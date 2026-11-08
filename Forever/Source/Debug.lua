local _, rm = ...
local L = rm.L

-- Development tool, kept out of packaged builds by the #@debug@ block in the TOC and the release .yaml ignore list
-- /rmdebug <profession> [skill level] [specialization, ...]
-- Shows Recipe Master for any profession as if the character had just learned it,
-- in a placeholder profession window. Nothing is saved in SavedVariables
-- /rmdebug learn <recipe>: Learns one of its recipes, through NEW_RECIPE_LEARNED when possible

local debugFrame
local debugProfession -- {ID, name, data} while the debug window is shown
local previousDisplayedProfession, previousLastDisplayedProfession
local isLearningDebugRecipe = false -- While Recipe Master handles a simulated NEW_RECIPE_LEARNED

local professionTextures = {
    [171] = "Interface/Icons/Trade_Alchemy",
    [164] = "Interface/Icons/Trade_BlackSmithing",
    [185] = "Interface/Icons/INV_Misc_Food_15",
    [333] = "Interface/Icons/Trade_Engraving",
    [202] = "Interface/Icons/Trade_Engineering",
    [129] = "Interface/Icons/Spell_Holy_SealOfSacrifice",
    [356] = "Interface/Icons/Trade_Fishing",
    [182] = "Interface/Icons/Spell_Nature_NatureTouchGrow",
    [165] = "Interface/Icons/Trade_LeatherWorking",
    [186] = "Interface/Icons/Trade_Mining",
    [40]  = "Interface/Icons/Trade_BrewPoison",
    [393] = "Interface/Icons/INV_Misc_Pelt_Wolf_01",
    [197] = "Interface/Icons/Trade_Tailoring",
}

local function printMessage(message)
    print(WrapTextInColorCode(L.title, "ff40C0FF")..": "..message)
end

-- The lowest rank that allows the skill level (same thresholds as ProfessionHandler's getRankName)
local function getRankName(skillLevel)
    if skillLevel > 225 then
        return "Artisan"
    elseif skillLevel > 150 then
        return "Expert"
    elseif skillLevel > 75 then
        return "Journeyman"
    end
    return "Apprentice"
end

local function isDebugProfessionName(professionName)
    return debugProfession ~= nil and debugProfession.name == professionName
end

local function isDebugProfessionID(professionID)
    return debugProfession ~= nil and debugProfession.ID == professionID
end

------------------------- Overrides -------------------------
-- Every read of the displayed profession goes through these, so the debug profession is never written to SavedVariables

local getSavedProfessionByName = rm.getSavedProfessionByName
function rm.getSavedProfessionByName(profession)
    if isDebugProfessionName(profession) then
        return debugProfession.data
    end
    return getSavedProfessionByName(profession)
end

-- Mostly used by the handlers that save new data, so it's only redirected during a simulated NEW_RECIPE_LEARNED,
-- which then only finds the debug profession and can't save anything in SavedVariables
local getSavedProfessionByID = rm.getSavedProfessionByID
function rm.getSavedProfessionByID(professionID)
    if isLearningDebugRecipe then
        return isDebugProfessionID(professionID) and debugProfession.data or nil
    end
    return getSavedProfessionByID(professionID)
end

local getSavedSpecializationByProfessionName = rm.getSavedSpecializationByProfessionName
function rm.getSavedSpecializationByProfessionName(professionName)
    if isDebugProfessionName(professionName) then
        return debugProfession.data["specialization"]
    end
    return getSavedSpecializationByProfessionName(professionName)
end

local getSavedSpecializationByProfessionID = rm.getSavedSpecializationByProfessionID
function rm.getSavedSpecializationByProfessionID(professionID)
    if isDebugProfessionID(professionID) then
        return debugProfession.data["specialization"]
    end
    return getSavedSpecializationByProfessionID(professionID)
end

-- The debug window takes the place of a profession window, so Recipe Master anchors to it
local getProfessionFrame = rm.getProfessionFrame
function rm.getProfessionFrame()
    local professionFrame = getProfessionFrame()
    if not professionFrame and debugFrame and debugFrame:IsVisible() then
        return debugFrame
    end
    return professionFrame
end

------------------------- Specializations -------------------------

local function getSpecializationName(specializationID)
    return rm.getSpecializationName(specializationID) or tostring(specializationID)
end

-- The profession's specializations are the spells marked as such in its database
local function getSpecializationNames(professionID)
    local specializationNames = {}
    for recipeID, recipeData in pairs(rm.recipeDB[professionID]) do
        if recipeData.isSpecialization then
            specializationNames[recipeID] = getSpecializationName(recipeID)
        end
    end
    return specializationNames
end

local function getSpecializationsText(specialization)
    local names = {}
    for _, specializationID in ipairs(rm.getSpecializationsList(specialization)) do
        table.insert(names, getSpecializationName(specializationID))
    end
    if #names == 0 then
        return "none"
    end
    return table.concat(names, ", ")
end

------------------------- Debug window -------------------------

local function stopDebugging()
    if not debugProfession then
        return
    end
    debugProfession = nil
    rm.displayedProfession = previousDisplayedProfession
    rm.lastDisplayedProfession = previousLastDisplayedProfession
    rm.hideMainFrame()
end

local function createDebugFrame()
    local frame = CreateFrame("Frame", "RecipeMasterDebugFrame", UIParent, "ButtonFrameTemplate")
    frame:Hide() -- Before setting OnHide, as new frames are shown
    ButtonFrameTemplate_HideButtonBar(frame)
    frame:SetSize(384, 512)
    frame:SetPoint("TOPLEFT", 16, -116) -- Where the game opens its panels
    frame:SetToplevel(true)
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame.text = frame.Inset:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.text:SetPoint("LEFT", 16, 0)
    frame.text:SetPoint("RIGHT", -16, 0)
    -- Makes room for an actual profession window
    frame:RegisterEvent("TRADE_SKILL_SHOW")
    frame:SetScript("OnEvent", frame.Hide)
    frame:SetScript("OnHide", stopDebugging)
    table.insert(UISpecialFrames, frame:GetName()) -- Closed with Escape
    return frame
end

local function updateDebugFrame()
    local data = debugProfession.data
    local learnedCount = #data["skills"]
    debugFrame:SetTitle(debugProfession.name.." (Debug)")
    debugFrame:SetPortraitToAsset(professionTextures[debugProfession.ID] or "Interface/Icons/INV_Scroll_03")
    debugFrame.text:SetText(
        "Debugging "..debugProfession.name.." (ID "..debugProfession.ID..")\n\n"..
        "Skill: "..data["level"].."\n"..
        "Rank: "..L[data["rank"]:lower()].."\n"..
        "Specializations: "..getSpecializationsText(data["specialization"]).."\n"..
        "Learned recipes: "..(learnedCount > 0 and learnedCount or "none")
    )
end

-- specializationIDs: A list of spell IDs, saved like Blacksmithing's to allow any combination
local function startDebugging(professionID, skillLevel, specializationIDs)
    if not debugProfession then
        previousDisplayedProfession = rm.displayedProfession
        previousLastDisplayedProfession = rm.lastDisplayedProfession
    end
    debugProfession = {
        ID = professionID,
        name = L.professions[professionID],
        data = {
            ["level"] = skillLevel,
            ["rank"] = getRankName(skillLevel),
            ["skills"] = {},
            ["specialization"] = #specializationIDs > 0 and specializationIDs,
        },
    }
    debugFrame = debugFrame or createDebugFrame()
    updateDebugFrame()
    debugFrame:Show()
    -- Same steps as opening a profession (EventHandler's handleProfessionFrameOpened)
    rm.displayedProfession = debugProfession.name
    rm.clearSearchBar()
    rm.showRecipesFrame()
    rm.lastDisplayedProfession = debugProfession.name
end

------------------------- Arguments -------------------------

local function getIDsSortedByName(namesByID)
    local IDs = {}
    for ID in pairs(namesByID) do
        table.insert(IDs, ID)
    end
    table.sort(IDs, function(a, b)
        return namesByID[a] < namesByID[b]
    end)
    return IDs
end

local function printNames(namesByID)
    for _, ID in ipairs(getIDsSortedByName(namesByID)) do
        print("    "..ID..": "..namesByID[ID])
    end
end

-- The example uses the game's names, so it works as typed in any language
local function printUsage()
    local exampleSpecializations = getSpecializationName(9787)..", "..getSpecializationName(17041) -- Weaponsmith, Master Swordsmith
    printMessage("/rmdebug <profession> [skill level] [specialization, ...]")
    print("    e.g. /rmdebug "..L.professions[164].." 300 "..exampleSpecializations)
    print("/rmdebug learn <recipe name or ID, or the learned spell's ID>")
    print("Profession IDs (can be typed instead of names):")
    printNames(L.professions)
end

local function printSpecializations(professionID)
    local specializationNames = getSpecializationNames(professionID)
    if not next(specializationNames) then
        printMessage(L.professions[professionID].." has no specializations.")
        return
    end
    printMessage(L.professions[professionID].." specializations:")
    for _, specializationID in ipairs(getIDsSortedByName(specializationNames)) do
        local requiredSpecialization = rm.recipeDB[professionID][specializationID].specialization
        local requirement = requiredSpecialization and " (requires "..getSpecializationName(requiredSpecialization)..")" or ""
        print("    "..specializationID..": "..specializationNames[specializationID]..requirement)
    end
end

-- Accepts an ID, a name in the game's language or the start of one (e.g. "eng" for Engineering)
-- namesByID: The names to search, by ID. Returns nil and the IDs matched if none or more than one matches
local function findID(text, namesByID)
    local ID = tonumber(text)
    if ID then
        return namesByID[ID] and ID
    end
    local searchedName = text:lower()
    local matchedIDs = {}
    for nameID, name in pairs(namesByID) do
        local lowerName = name:lower()
        if lowerName == searchedName then
            return nameID
        elseif lowerName:sub(1, #searchedName) == searchedName then
            table.insert(matchedIDs, nameID)
        end
    end
    if #matchedIDs == 1 then
        return matchedIDs[1]
    end
    return nil, matchedIDs
end

-- The profession is the longest run of leading words that matches one (some names have several words)
-- Returns its ID and the text after it
local function findProfession(arguments)
    local words = {strsplit(" ", arguments)}
    for wordCount = #words, 1, -1 do
        local professionText = table.concat(words, " ", 1, wordCount)
        local professionID = findID(professionText, L.professions)
        if professionID then
            return professionID, strtrim(table.concat(words, " ", wordCount + 1))
        end
    end
end

-- specializationsText: Comma-separated specializations. Returns nil if any of them doesn't match
local function findSpecializations(professionID, specializationsText)
    local specializationIDs = {}
    local specializationNames = getSpecializationNames(professionID)
    for _, specializationText in ipairs({strsplit(",", specializationsText)}) do
        specializationText = strtrim(specializationText)
        if specializationText ~= "" then
            local specializationID = findID(specializationText, specializationNames)
            if not specializationID then
                printMessage("No single specialization matches \""..specializationText.."\".")
                return
            end
            if not rm.tableContains(specializationIDs, specializationID) then
                table.insert(specializationIDs, specializationID)
            end
        end
    end
    return specializationIDs
end

------------------------- Learning recipes -------------------------

-- The spell the game sends in NEW_RECIPE_LEARNED when the recipe is learned. nil if unknown
-- Recipes store the spell they teach, or are keyed by it
local function getLearnedSpell(recipe)
    if type(recipe.teaches) == "number" then
        return recipe.teaches
    end
end

local function getSpellName(spellID)
    return C_Spell.GetSpellName(spellID)
end

local function getDebugRecipes()
    return rm.cachedRecipes[debugProfession.ID]
end

local function getDebugRecipeNames()
    local recipeNames = {}
    for recipeID, recipe in pairs(getDebugRecipes()) do
        if recipe.name then
            recipeNames[recipeID] = recipe.name
        end
    end
    return recipeNames
end

-- skill: A saved skill, which recipes store under teaches
local function getRecipeNameBySkill(skill)
    for _, recipe in pairs(getDebugRecipes()) do
        if recipe.teaches == skill then
            return recipe.name
        end
    end
    return tostring(skill)
end

local function printMatchingRecipes(recipeIDs)
    local maximumListed = 10
    local recipeNames = getDebugRecipeNames()
    local matchingNames = {}
    for _, recipeID in ipairs(recipeIDs) do
        matchingNames[recipeID] = recipeNames[recipeID]
    end
    for index, recipeID in ipairs(getIDsSortedByName(matchingNames)) do
        if index > maximumListed then
            print("    ...and "..(#recipeIDs - maximumListed).." more")
            return
        end
        print("    "..recipeID..": "..matchingNames[recipeID])
    end
end

-- Runs Recipe Master's event handler as the game would. Returns the skills it saved
local function sendRecipeLearnedEvent(spellID)
    local skills = debugProfession.data["skills"]
    local previousSkillsCount = #skills
    isLearningDebugRecipe = true
    local isSuccessful, errorMessage = pcall(rm.frame:GetScript("OnEvent"), rm.frame, "NEW_RECIPE_LEARNED", spellID)
    isLearningDebugRecipe = false
    if not isSuccessful then
        geterrorhandler()(errorMessage)
    end
    return {unpack(skills, previousSkillsCount + 1)}
end

-- Ranks and specializations aren't learned as recipes, so they're set when opening the profession
local function isLearnableDebugRecipe(recipe)
    local professionCommand = "/rmdebug "..debugProfession.ID
    if rm.isRankupRecipe(recipe) then
        printMessage("Ranks follow the skill level: "..professionCommand.." <skill level>")
        return false
    elseif recipe.isSpecialization then
        printMessage("Specializations are set when opening the profession: "..professionCommand.." <skill level> <specialization>")
        return false
    elseif rm.tableContains(debugProfession.data["skills"], recipe.teaches) then
        printMessage(recipe.name.." is already learned.")
        return false
    end
    return true
end

-- recipeText: A recipe's ID or name (or the start of it), or the ID of the spell the game sends when learning one
-- Returns the recipe (nil if a spell ID was given) and the spell to send (nil if unknown). Returns nothing if neither
local function findRecipeAndSpell(recipeText)
    local number = tonumber(recipeText)
    if number and not getDebugRecipes()[number] then
        if not getSpellName(number) then
            printMessage("No "..debugProfession.name.." recipe or spell has the ID "..number..".")
            return
        end
        return nil, number
    end
    local recipeID, matchedIDs = findID(recipeText, getDebugRecipeNames())
    if not recipeID then
        printMessage("No single "..debugProfession.name.." recipe matches \""..recipeText.."\".")
        printMatchingRecipes(matchedIDs)
        return
    end
    local recipe = getDebugRecipes()[recipeID]
    return recipe, getLearnedSpell(recipe)
end

local function learnDebugRecipe(recipeText)
    if not debugProfession then
        printMessage("Open a profession first: /rmdebug <profession>")
        return
    elseif recipeText == "" then
        printMessage("/rmdebug learn <recipe name or ID, or the learned spell's ID>")
        return
    end
    local recipe, spellID = findRecipeAndSpell(recipeText)
    if (not recipe and not spellID) or (recipe and not isLearnableDebugRecipe(recipe)) then
        return
    end
    if spellID then
        local savedSkills = sendRecipeLearnedEvent(spellID)
        for _, skill in ipairs(savedSkills) do
            printMessage("NEW_RECIPE_LEARNED ("..spellID..") saved "..getRecipeNameBySkill(skill)..".")
        end
        if #savedSkills == 0 then
            printMessage("NEW_RECIPE_LEARNED ("..spellID..") saved no "..debugProfession.name.." recipe.")
        end
    end
    -- Recipe Master missed it, so it's learned anyway to show the result
    if recipe and not rm.tableContains(debugProfession.data["skills"], recipe.teaches) then
        table.insert(debugProfession.data["skills"], recipe.teaches)
        rm.refreshRecipesListIfOpen()
        local reason = spellID and "" or " (no spell known to send NEW_RECIPE_LEARNED with)"
        printMessage("Learned "..recipe.name.." directly"..reason..".")
    end
    updateDebugFrame()
end

------------------------- Chat command -------------------------

local function handleDebugCommand(message)
    local arguments = strtrim(message):gsub("%s+", " ")
    if arguments == "" then
        printUsage()
        return
    end
    local firstWord, otherWords = arguments:match("^(%S+) ?(.*)$")
    if firstWord:lower() == "learn" then
        learnDebugRecipe(otherWords)
        return
    end
    local professionID, remainingText = findProfession(arguments)
    if not professionID then
        printMessage("No single profession matches \""..arguments.."\".")
        printUsage()
        return
    end
    -- A leading number is the skill level, unless it's a specialization's ID
    local skillText, specializationsText = remainingText:match("^(%d+)%s*(.*)$")
    if not skillText or getSpecializationNames(professionID)[tonumber(skillText)] then
        skillText, specializationsText = nil, remainingText
    end
    local specializationIDs = findSpecializations(professionID, specializationsText)
    if not specializationIDs then
        printSpecializations(professionID)
        return
    end
    -- Recipe Master would show the debug profession inside the open one
    if getProfessionFrame() then
        printMessage("Close the profession window first.")
        return
    end
    startDebugging(professionID, math.max(tonumber(skillText) or 1, 1), specializationIDs)
end

SLASH_RECIPEMASTERDEBUG1 = "/rmdebug"
SlashCmdList["RECIPEMASTERDEBUG"] = handleDebugCommand
