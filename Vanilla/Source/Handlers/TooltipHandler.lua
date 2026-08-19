local _, rm = ...
local L = rm.L
local F = rm.F

local function isSpecialLeatherworkingRecipe(recipeID)
    return (
        recipeID == 22694 
        or recipeID == 22695 
        or recipeID == 22697 
        or recipeID == 22698
    )
end

-- Recipes that have a profession name different than the profession's display name for some languages
local function handleMismatchedProfessionNames(recipeID, itemLink)
    if isSpecialLeatherworkingRecipe(recipeID) then
        return L.professions[165]
    end
    local professionName = select(7, C_Item.GetItemInfo(itemLink))
    if professionName == "가죽세공" then
        return "가죽 세공"
    elseif professionName == "기계 공학" then
        return "기계공학"
    elseif professionName == "Зачаровывание" then
        return "Наложение чар"
    elseif professionName == "Peletería" and rm.locale == "esES" then
        return "Marroquinería"
    elseif professionName == "Sastrería" and rm.locale == "esES" then
        return "Costura"
    end
    return professionName
end

local function getColoredSkill(characterProfessionData, recipeSkill)
    local skill = ""
    local characterProfessionLevel = characterProfessionData["level"]
    if characterProfessionLevel < recipeSkill then
        skill = WrapTextInColorCode(characterProfessionLevel, F.colors.lightPinkHex)
    else
        skill = WrapTextInColorCode(characterProfessionLevel, F.colors.lightGreenHex)
    end
    return skill
end

local function getColoredSpecialization(characterProfessionData, recipeSpecialization)
    local specialization = ""
    local specializationName = rm.getSpecializationName(recipeSpecialization)
    local characterSpecialization = characterProfessionData["specialization"]
    if characterSpecialization ~= recipeSpecialization then
        specialization = WrapTextInColorCode(specializationName, F.colors.lightPinkHex)
    else
        specialization = WrapTextInColorCode(specializationName, F.colors.lightGreenHex)
    end
    return specialization
end

local function getRecipeTooltipMessage(recipe, professionID)
    local message = ""
    local newLine = "\n"
    local newLineInfo = "\n  "
    if rm.getPreference("showDifficultyTooltipInfo") and recipe and recipe.difficulty then
        message = message..newLine..WrapTextInColorCode(L.difficulty, F.colors.lightGrayHex)..newLineInfo
        for index, diffLevel in ipairs(recipe.difficulty) do
            if diffLevel ~= 0 then
                message = message..WrapTextInColorCode(diffLevel, rm.difficultyLevels[index].color).." "
            end
        end
    end
    if rm.getPreference("showSourcesTooltipInfo") and recipe and recipe.sources then
        message = message..newLine..WrapTextInColorCode(L.sources, F.colors.lightBlueHex)
        for _, sourceType in ipairs(rm.sourcesOrder) do
            if recipe.sources[sourceType] then
                message = message..newLineInfo..(rm.getLocalizedSourceType(sourceType))
            end
        end
    end
    if rm.getPreference("showAltsTooltipInfo") then
        local charactersMissingRecipe, charactersWhoCraftRecipe = rm.getAllCharactersRecipeStatus(recipe, professionID)
        if #charactersWhoCraftRecipe > 0 then
            -- Sort the charactersWhoCraftRecipe table alphabetically
            table.sort(charactersWhoCraftRecipe)
            message = message..newLine..WrapTextInColorCode(L.crafters, F.colors.lightGreenHex)
            for _, characterName in pairs(charactersWhoCraftRecipe) do
                message = message..newLineInfo..characterName
            end
        end
        if next(charactersMissingRecipe) ~= nil then
            -- Sort the charactersMissingRecipe table alphabetically
            table.sort(charactersMissingRecipe)
            message = message..newLine..WrapTextInColorCode(L.unlearned, F.colors.lightPinkHex)
            for characterName, professionData in pairs(charactersMissingRecipe) do
                local characterLine = newLineInfo..characterName.." ("
                characterLine = characterLine..L.skill.." "..getColoredSkill(professionData, recipe.requiredSkill)
                if recipe.specialization then
                    characterLine = characterLine..", "..getColoredSpecialization(professionData, recipe.specialization)
                end
                message = message..characterLine..")"
            end
        end
    end
    return "Recipe Master"..WrapTextInColorCode(message, F.colors.whiteHex)
end

-- Ensures that the message is not displayed twice
local function isTooltipMessageDisplayed(currentLineText, message)
    local lineText = currentLineText:gsub("^%s*(.-)%s*$", "%1") -- Removes blank spaces and new lines
    return lineText == message
end

local function appendMessage(tooltip, message)
    for i = 1, tooltip:NumLines() do
        local currentLineText = _G[tooltip:GetName().."TextLeft"..i]:GetText()
        if not currentLineText or isTooltipMessageDisplayed(currentLineText, message) then
            return
        end
    end
    tooltip:AddLine("\n"..message.."\n")
end

local function getRecipeInfo(itemLink)
    local recipeID = rm.getIDFromLink(itemLink)
    local professionName = handleMismatchedProfessionNames(recipeID, itemLink)
    local professionID = rm.getProfessionID(professionName)
    if professionID then
        local recipe = rm.cachedRecipes[professionID][recipeID]
        return recipe, professionID
    end
    return false, false
end

local function getSpellInfo(spellID)
    local possibleProfessionIDs = {
        186,  -- Mining
        2842, -- Poisons
        202,  -- Engineering
        333   -- Enchanting
    }
    for _, professionID in ipairs(possibleProfessionIDs) do
        local spell = rm.cachedRecipes[professionID][spellID]
        if spell then
            return spell, professionID
        end
    end
    return false, false
end

local indentation = "  " -- Groups the skill levels under the "Recipe Master" header
local _, currentCharacterClass = UnitClass("player") -- Always in English and upper case

-- Fallback for characters saved before the maximum skill level started being stored
local maxSkillByRank = {
    ["Apprentice"] = 75,
    ["Journeyman"] = 150,
    ["Expert"] = 225,
    ["Artisan"] = 300
}

-- Profession spells whose name does not match the profession's name
local otherProfessionSpells = {
    [2575] = 186,  -- Mining
    [2576] = 186,  -- Smelting (Journeyman)
    [2656] = 186,  -- Smelting
    [3564] = 186,  -- Smelting (Expert)
    [10248] = 186  -- Smelting (Artisan)
}

-- Identifies a profession, profession rank or specialization spell (e.g. Cooking, Goblin Engineer)
local function getProfessionIDFromSpell(spellID)
    local specializationProfessionID = rm.getProfessionIDBySpecializationSpell(spellID)
    if specializationProfessionID then
        return specializationProfessionID
    end
    if otherProfessionSpells[spellID] then
        return otherProfessionSpells[spellID]
    end
    local spellName = GetSpellInfo(spellID)
    if spellName then
        return rm.getProfessionID(spellName)
    end
    return false
end

local function getMaxSkill(characterProfessionData)
    return (
        characterProfessionData["maxLevel"]
        or maxSkillByRank[characterProfessionData["rank"]]
        or 300
    )
end

-- Supports class color addons. Falls back to white for characters saved before 2.14.2
local function getClassColorHex(class)
    local classColors
    if class then
        classColors = (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class]) or RAID_CLASS_COLORS[class]
    end
    if not classColors then
        return F.colors.whiteHex
    end
    return string.format(
        "ff%02X%02X%02X",
        math.floor(classColors.r * 255),
        math.floor(classColors.g * 255),
        math.floor(classColors.b * 255)
    )
end

local function getColoredSkillLevel(skillLevel, maxSkillLevel)
    local levelColor = F.colors.lightGreenHex
    if skillLevel < maxSkillLevel then
        levelColor = F.colors.lightPinkHex
    end
    return WrapTextInColorCode(skillLevel, levelColor)
            ..WrapTextInColorCode(" / "..maxSkillLevel, F.colors.whiteHex)
end

-- Read from the skill lines to stay accurate even before the profession is saved again
local function getCurrentCharacterSkill(professionID)
    local professionName = L.professions[professionID]
    for i = 1, GetNumSkillLines() do
        local skillName, _, _, skillRank, _, _, maxSkillRank = GetSkillLineInfo(i)
        if skillName == professionName then
            return skillRank, maxSkillRank
        end
    end
    local savedProfession = rm.getSavedProfessionByID(professionID)
    if savedProfession then
        return savedProfession["level"], getMaxSkill(savedProfession)
    end
    return false, false
end

local function getSortedCharacterNames(charactersProfessionData)
    local characterNames = {}
    for characterName in pairs(charactersProfessionData) do
        table.insert(characterNames, characterName)
    end
    table.sort(characterNames)
    return characterNames
end

local function getOtherCharactersProfessionData(professionID)
    if not rm.getPreference("showAltsTooltipInfo") then
        return {}
    end
    return rm.getProfessionDataForOtherCharacters(professionID)
end

-- Ensures that the information is not displayed twice
local function isProfessionInfoDisplayed(tooltip)
    for i = 1, tooltip:NumLines() do
        local currentLineText = _G[tooltip:GetName().."TextLeft"..i]:GetText()
        if currentLineText and currentLineText:find("Recipe Master", 1, true) then
            return true
        end
    end
    return false
end

-- Recipe Master's tooltips are already detailed inside the recipes list
local function isTooltipOwnedByRecipeMaster(tooltip)
    local owner = tooltip:GetOwner()
    while owner do
        if owner == rm.mainFrame then
            return true
        end
        owner = owner:GetParent()
    end
    return false
end

-- Appends the character's and its alts' skill levels to a profession's tooltip
local function showProfessionInfoInTooltip(tooltip, professionID)
    if isProfessionInfoDisplayed(tooltip) then
        return
    end
    local skillLevel, maxSkillLevel = getCurrentCharacterSkill(professionID)
    local otherCharacters = getOtherCharactersProfessionData(professionID)
    local characterNames = getSortedCharacterNames(otherCharacters)
    if not skillLevel and #characterNames == 0 then
        return
    end
    tooltip:AddLine(" ")
    tooltip:AddLine("Recipe Master", unpack(F.colors.yellow))
    if skillLevel then
        tooltip:AddDoubleLine(
            indentation..WrapTextInColorCode(L.yourSkill, getClassColorHex(currentCharacterClass)),
            getColoredSkillLevel(skillLevel, maxSkillLevel)
        )
    end
    if #characterNames > 0 then
        tooltip:AddLine(" ")
        for _, characterName in ipairs(characterNames) do
            local characterProfessionData = otherCharacters[characterName]
            tooltip:AddDoubleLine(
                indentation..WrapTextInColorCode(
                    characterName.."-"..rm.currentServer,
                    getClassColorHex(characterProfessionData["class"])
                ),
                getColoredSkillLevel(
                    characterProfessionData["level"],
                    getMaxSkill(characterProfessionData)
                )
            )
        end
    end
    tooltip:AddLine(" ") -- Keeps the last line from touching whatever is appended below
    tooltip:Show()
end

local function showMessageInTooltip(tooltip, item, professionID)
    local message = getRecipeTooltipMessage(item, professionID)
    local messageLineCount = select(2, message:gsub("\n", "\n"))
    if messageLineCount > 0 then -- Not counting the "Recipe Master" header
        appendMessage(tooltip, message)
    end
end

local function isItemARecipe(itemName)
    for _, prefix in pairs(L.recipePrefixes) do
        if itemName:sub(1, #prefix) == prefix then
            return true
        end
    end
    return false
end

-- Appends the message to a recipe's tooltip
GameTooltip:HookScript("OnTooltipSetItem", function(tooltip, ...)
    if rm.getPreference("showAltsTooltipInfo") or rm.getPreference("showSourcesTooltipInfo") then
        local itemName, itemLink = tooltip:GetItem()
        if itemName and isItemARecipe(itemName) then
            local recipe, professionID = getRecipeInfo(itemLink)
            showMessageInTooltip(tooltip, recipe, professionID)
        end
    end
end)

-- Appends the message to a spell's tooltip
GameTooltip:HookScript("OnTooltipSetSpell", function(tooltip)
    if rm.getPreference("showAltsTooltipInfo") or rm.getPreference("showSourcesTooltipInfo") then
        local _, spellID = tooltip:GetSpell()
        if spellID then
            -- Professions display the characters' skill levels instead of recipe information
            -- The recipes list keeps displaying the details of a profession rank / specialization
            local professionID = getProfessionIDFromSpell(spellID)
            if professionID and not isTooltipOwnedByRecipeMaster(tooltip) then
                showProfessionInfoInTooltip(tooltip, professionID)
                return
            end
            local spell, recipeProfessionID = getSpellInfo(spellID)
            showMessageInTooltip(tooltip, spell, recipeProfessionID)
        end
    end
end)

-- Appends the message to a chat link tooltip
ItemRefTooltip:HookScript("OnTooltipSetItem", function(tooltip, ...)
    if rm.getPreference("showAltsTooltipInfo") or rm.getPreference("showSourcesTooltipInfo") then
        local itemName, itemLink = tooltip:GetItem()
        if itemName and isItemARecipe(itemName) then
            local recipe, professionID = getRecipeInfo(itemLink)
            showMessageInTooltip(tooltip, recipe, professionID)
        end
    end
end)
