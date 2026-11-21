local _, rm = ...
local L = rm.L
local F = rm.F

-- Some clients hide tooltip values behind secret values (e.g. in combat), which add-ons can't compare, test or index
local function isSecret(value)
    return issecretvalue ~= nil and issecretvalue(value)
end

-- Fallback for characters saved before the maximum skill level started being stored
local professionRankCaps = {
    ["Apprentice"] = 75,
    ["Journeyman"] = 150,
    ["Expert"] = 225,
    ["Artisan"] = 300,
}

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

-- Green when the character has reached the cap of their current rank (e.g. 300 / 300 for Artisan)
local function getColoredProfessionSkill(characterProfessionData)
    local maxLevel = characterProfessionData["maxLevel"] or professionRankCaps[characterProfessionData["rank"]] or 0
    return getColoredSkill(characterProfessionData, maxLevel)
end

local function getColoredSpecialization(characterProfessionData, recipeSpecialization)
    local specialization = ""
    local specializationName = rm.getSpecializationName(recipeSpecialization)
    local characterSpecializations = rm.getSpecializationsList(characterProfessionData["specialization"])
    if not rm.tableContains(characterSpecializations, recipeSpecialization) then
        specialization = WrapTextInColorCode(specializationName, F.colors.lightPinkHex)
    else
        specialization = WrapTextInColorCode(specializationName, F.colors.lightGreenHex)
    end
    return specialization
end

local function getSortedCharacterNames(characters)
    local characterNames = {}
    for characterName in pairs(characters) do
        table.insert(characterNames, characterName)
    end
    table.sort(characterNames)
    return characterNames
end

-- Each line is {left, right}; lines with a right side are displayed in two columns
local function addLine(lines, left, right)
    table.insert(lines, {left = left, right = right})
end

local function addCharacterLines(lines, characters, getRightText)
    for _, characterName in ipairs(getSortedCharacterNames(characters)) do
        local left = "  "..rm.getClassColoredCharacterName(characterName)
        addLine(lines, left, getRightText(characters[characterName]))
    end
end

local function getRecipeSkillText(professionData, recipe)
    local skillText = getColoredSkill(professionData, recipe.requiredSkill)
    if recipe.specialization then
        skillText = skillText..", "..getColoredSpecialization(professionData, recipe.specialization)
    end
    return skillText
end

local function getRecipeTooltipLines(recipe, professionID, isCraftedItem)
    local lines = {}
    if isCraftedItem then
        local professionName = L.professions[professionID]
        addLine(lines, L.craftedItem..' - '..professionName)
    end
    if rm.getPreference("showDifficultyTooltipInfo") and recipe and recipe.difficulty then
        addLine(lines, WrapTextInColorCode(L.difficulty, F.colors.lightGrayHex))
        local difficultyLine = " "
        for index, diffLevel in ipairs(recipe.difficulty) do
            if diffLevel ~= 0 then
                difficultyLine = difficultyLine.." "..WrapTextInColorCode(diffLevel, rm.difficultyLevels[index].color)
            end
        end
        addLine(lines, difficultyLine)
    end
    if rm.getPreference("showSourcesTooltipInfo") and recipe and recipe.sources then
        addLine(lines, WrapTextInColorCode(L.sources, F.colors.lightBlueHex))
        for _, sourceType in ipairs(rm.sourcesOrder) do
            if recipe.sources[sourceType] then
                addLine(lines, "  "..(rm.getLocalizedSourceType(sourceType)))
            end
        end
    end
    if rm.getPreference("showAltsTooltipInfo") and recipe then
        local charactersMissingRecipe, charactersWhoCraftRecipe = rm.getAllCharactersRecipeStatus(recipe, professionID)
        local function getSkillText(professionData)
            return getRecipeSkillText(professionData, recipe)
        end
        if next(charactersWhoCraftRecipe) ~= nil then
            addLine(lines, WrapTextInColorCode(L.crafters, F.colors.lightGreenHex))
            addCharacterLines(lines, charactersWhoCraftRecipe, getSkillText)
        end
        if next(charactersMissingRecipe) ~= nil then
            addLine(lines, WrapTextInColorCode(L.unlearned, F.colors.lightPinkHex))
            addCharacterLines(lines, charactersMissingRecipe, getSkillText)
        end
    end
    return lines
end

-- The current character's skill level, followed by the other characters' in alphabetical order
local function getProfessionTooltipLines(professionID)
    local lines = {}
    local otherCharacters = rm.getProfessionDataForOtherCharacters(professionID)
    local currentCharacterProfession = rm.getSavedVariablesForCurrentCharacter()[professionID]
    if currentCharacterProfession then
        addCharacterLines(lines, {[rm.currentCharacter] = currentCharacterProfession}, getColoredProfessionSkill)
    end
    if next(otherCharacters) ~= nil then
        if #lines > 0 then
            addLine(lines, " ")
        end
        addCharacterLines(lines, otherCharacters, getColoredProfessionSkill)
    end
    return lines
end

-- Ensures that the message is not displayed twice
local function isTooltipMessageDisplayed(tooltip)
    for i = 1, tooltip:NumLines() do
        local currentLineText = _G[tooltip:GetName().."TextLeft"..i]:GetText()
        if isSecret(currentLineText) then
            -- Not one of RecipeMaster's lines
        elseif not currentLineText or currentLineText:gsub("^%s*(.-)%s*$", "%1") == "Recipe Master" then
            return true
        end
    end
    return false
end

local function appendLines(tooltip, lines)
    if isTooltipMessageDisplayed(tooltip) then
        return
    end
    tooltip:AddLine(" ")
    tooltip:AddLine("Recipe Master")
    for _, line in ipairs(lines) do
        if line.right then
            tooltip:AddDoubleLine(line.left, line.right, 1, 1, 1, 1, 1, 1)
        else
            tooltip:AddLine(line.left, 1, 1, 1)
        end
    end
    tooltip:AddLine(" ")
    tooltip:Show() -- Resizes the tooltip when the lines are added after it's displayed
end

local function isSpellData(data)
    return data.link and string.find(data.link, "|Hspell:", 1, true)
end

-- Recipe items aren't always of their profession's item subclass (e.g. Pattern: Polar Gloves), so they're found by ID
local function getRecipeInfo(itemID)
    for professionID in pairs(L.professions) do
        local recipe = rm.cachedRecipes[professionID][itemID]
        -- Ignores spells that share the recipe's ID
        if recipe and not isSpellData(recipe) then
            return recipe, professionID
        end
    end
    return false, false
end

-- Abilities granted by a profession whose name does not match the profession's name
local otherProfessionSpells = {
    [818] = 185,   -- Basic Campfire
    [13262] = 333, -- Disenchant
    [2366] = 182,  -- Herb Gathering (Apprentice)
    [2368] = 182,  -- Herb Gathering (Journeyman)
    [3570] = 182,  -- Herb Gathering (Expert)
    [11993] = 182, -- Herb Gathering (Artisan)
    [2383] = 182,  -- Find Herbs
    [2576] = 186,  -- Mining (Journeyman)
    [2656] = 186,  -- Smelting
    [3564] = 186,  -- Mining (Expert)
    [10248] = 186, -- Mining (Artisan)
    [2580] = 186,  -- Find Minerals
}

-- Debug: /run RecipeMasterDebugTooltips = true
local function debugPrint(...)
    if RecipeMasterDebugTooltips then
        print("|cff33ff99RecipeMaster|r", ...)
    end
end

-- Candidate names for a spell: the tooltip's own spell name, the spell APIs' names and the tooltip's header text
local function getSpellNameCandidates(tooltip, spellName, spellID)
    local names = {}
    local function add(name)
        if not isSecret(name) and type(name) == "string" and name ~= "" then
            table.insert(names, (name:gsub("^%s*(.-)%s*$", "%1")))
        end
    end
    add(spellName)
    if C_Spell and C_Spell.GetSpellName then
        add(C_Spell.GetSpellName(spellID))
    end
    if GetSpellInfo then
        add((GetSpellInfo(spellID)))
    end
    local header = tooltip:GetName() and _G[tooltip:GetName().."TextLeft1"]
    if header then
        add(header:GetText())
    end
    return names
end

-- Identifies a profession, its abilities or specializations (e.g. Cooking, Disenchant, Armorsmith)
local function getProfessionIDFromSpell(tooltip, spellName, spellID)
    for _, name in ipairs(getSpellNameCandidates(tooltip, spellName, spellID)) do
        local professionID = rm.getTrackedProfessionID(name)
        if professionID then
            return professionID
        end
    end
    return otherProfessionSpells[spellID] or rm.getProfessionIDBySpecialization(spellID)
end

-- The recipes list keeps displaying the details of a profession rank / specialization
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

local function getSpellInfo(spellID)
    for professionID in pairs(L.professions) do
        local spell = rm.cachedRecipes[professionID][spellID]
        -- Ignores recipe items that share the spell's ID
        -- e.g. "Formula: Brilliant Mana Oil" and spell "Create Soulstone (Major)"
        if spell and isSpellData(spell) and not rm.isRankupRecipe(spell) then
            return spell, professionID
        end
    end
    return false, false
end

-- Items crafted by the recipes (e.g. Silk Bandage, Greater Magic Wand)
local function getCraftedItemInfo(itemID)
    local craftedItem = rm.craftedItems[itemID]
    if craftedItem then
        return craftedItem.recipe, craftedItem.professionID
    end
    return false, false
end

local function showMessageInTooltip(tooltip, item, professionID, isCraftedItem)
    local lines = getRecipeTooltipLines(item, professionID, isCraftedItem)
    if #lines > 0 then
        appendLines(tooltip, lines)
    end
end

local function showMessageInProfessionTooltip(tooltip, professionID)
    local lines = getProfessionTooltipLines(professionID)
    if #lines > 0 then
        appendLines(tooltip, lines)
    end
end

local function isItemARecipe(itemID)
    local classID = select(6, C_Item.GetItemInfoInstant(itemID))
    return classID == Enum.ItemClass.Recipe
end

local function showMessageInRecipesOrCraftedItemsTooltip(tooltip, itemID)
    if not itemID then
        itemID = select(3, TooltipUtil.GetDisplayedItem(tooltip))
    end
    if itemID and isItemARecipe(itemID) then
        local recipe, professionID = getRecipeInfo(itemID)
        showMessageInTooltip(tooltip, recipe, professionID, false)
    elseif itemID then
        local recipe, professionID = getCraftedItemInfo(itemID)
        if recipe then
            showMessageInTooltip(tooltip, recipe, professionID, true)
        end
    end
end

-- Appends the message to a recipe's or crafted item's tooltip, and to a chat link tooltip (ItemRefTooltip)
TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip)
    if tooltip ~= GameTooltip and tooltip ~= ItemRefTooltip then
        return
    end
    if rm.getPreference("showAltsTooltipInfo") or rm.getPreference("showSourcesTooltipInfo") then
        showMessageInRecipesOrCraftedItemsTooltip(tooltip)
    end
end)

local function showMessageInSpellTooltip(tooltip, spellName, spellID)
    if isSecret(spellID) then
        return
    end
    if isSecret(spellName) then
        spellName = nil
    end
    if not spellID then
        debugPrint("spell tooltip without a spell ID", tostring(spellName))
        return
    end
    if not (rm.getPreference("showAltsTooltipInfo") or rm.getPreference("showSourcesTooltipInfo")) then
        return
    end
    -- Profession spells (e.g. "Cooking") and their specializations (e.g. "Armorsmith") share one list
    local baseProfessionID = getProfessionIDFromSpell(tooltip, spellName, spellID)
    debugPrint("spell", spellID, tostring(spellName), "->", tostring(baseProfessionID),
        "names:", table.concat(getSpellNameCandidates(tooltip, spellName, spellID), " | "))
    if baseProfessionID and rm.getPreference("showAltsTooltipInfo") and not isTooltipOwnedByRecipeMaster(tooltip) then
        showMessageInProfessionTooltip(tooltip, baseProfessionID)
    else
        local spell, professionID = getSpellInfo(spellID)
        showMessageInTooltip(tooltip, spell, professionID, false)
    end
end

-- Appends the message to a spell's tooltip
-- Spellbook tooltips can be shown by another tooltip than GameTooltip (e.g. ElvUI's ElvUI_SpellBookTooltip)
local function isSupportedSpellTooltip(tooltip)
    if tooltip == GameTooltip then
        return true
    end
    local tooltipName = tooltip.GetName and tooltip:GetName()
    return tooltipName and tooltipName:find("SpellBookTooltip", 1, true) ~= nil
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, function(tooltip, data)
    if not isSupportedSpellTooltip(tooltip) then
        debugPrint("ignored spell tooltip", tostring(tooltip.GetName and tooltip:GetName()))
        return
    end
    local spellName, spellID = TooltipUtil.GetDisplayedSpell(tooltip)
    if isSecret(spellID) then
        return
    end
    showMessageInSpellTooltip(tooltip, spellName, spellID or (data and data.id))
end)

-- The action slot behind a hovered action button (Blizzard bars and the common bar add-ons)
local function getOwnerActionSlot(tooltip)
    local owner = tooltip.GetOwner and tooltip:GetOwner()
    if not owner then
        return nil
    end
    local slot = owner.action or owner._state_action
    if not slot and owner.CalculateAction then
        slot = owner:CalculateAction()
    end
    return type(slot) == "number" and slot or nil
end

-- What a macro shows: a spell ID or an item ID, read from the tooltip data first, then from the action slot
local function getMacroSpellOrItem(tooltip, data)
    if data and data.lines then
        for _, line in ipairs(data.lines) do
            if isSecret(line.tooltipID) or isSecret(line.tooltipType) then
                -- Hidden by the client
            elseif line.tooltipID and line.tooltipType == Enum.TooltipDataType.Spell then
                return line.tooltipID, nil
            elseif line.tooltipID and line.tooltipType == Enum.TooltipDataType.Item then
                return nil, line.tooltipID
            end
        end
    end
    local slot = getOwnerActionSlot(tooltip)
    if slot and GetActionInfo then
        local actionType, id, subType = GetActionInfo(slot)
        if isSecret(actionType) or isSecret(id) or isSecret(subType) then
            return nil, nil
        end
        if actionType == "macro" then
            if subType == "spell" then
                return id, nil
            elseif subType == "item" then
                return nil, id
            end
            local macroSpellID = GetMacroSpell and GetMacroSpell(id)
            if macroSpellID then
                return macroSpellID, nil
            end
            local _, itemLink = GetMacroItem and GetMacroItem(id)
            if itemLink then
                return nil, tonumber(itemLink:match("item:(%d+)"))
            end
        end
    end
    -- Last resort: the spell named in the tooltip's header, when the character knows it
    local header = tooltip.GetName and tooltip:GetName() and _G[tooltip:GetName().."TextLeft1"]
    local headerText = header and header:GetText()
    if headerText and not isSecret(headerText) then
        local spellInfo = C_Spell and C_Spell.GetSpellInfo and C_Spell.GetSpellInfo(headerText)
        if spellInfo and spellInfo.spellID then
            return spellInfo.spellID, nil
        end
        if GetSpellInfo then
            local spellID = select(7, GetSpellInfo(headerText))
            if spellID then
                return spellID, nil
            end
        end
    end
    return nil, nil
end

-- Appends the message to a macro's tooltip (e.g. a macro on an action bar showing First Aid)
if Enum.TooltipDataType.Macro then
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Macro, function(tooltip, data)
        if tooltip ~= GameTooltip then
            return
        end
        if not (rm.getPreference("showAltsTooltipInfo") or rm.getPreference("showSourcesTooltipInfo")) then
            return
        end
        local spellID, itemID = getMacroSpellOrItem(tooltip, data)
        debugPrint("macro tooltip ->", "spell", tostring(spellID), "item", tostring(itemID))
        if spellID then
            showMessageInSpellTooltip(tooltip, nil, spellID)
        elseif itemID then
            showMessageInRecipesOrCraftedItemsTooltip(tooltip, itemID)
        end
    end)
end

-- Fallback for clients that still fire the legacy script; the message is never added twice
if GameTooltip:HasScript("OnTooltipSetSpell") then
    GameTooltip:HookScript("OnTooltipSetSpell", function(tooltip)
        local spellName, spellID = tooltip:GetSpell()
        showMessageInSpellTooltip(tooltip, spellName, spellID)
    end)
end

-- ElvUI's spellbook tooltip on clients without TooltipDataProcessor support for it
local elvUISpellBookTooltip = _G["ElvUI_SpellBookTooltip"]
if elvUISpellBookTooltip and elvUISpellBookTooltip:HasScript("OnTooltipSetSpell") then
    elvUISpellBookTooltip:HookScript("OnTooltipSetSpell", function(tooltip)
        local spellName, spellID = tooltip:GetSpell()
        showMessageInSpellTooltip(tooltip, spellName, spellID)
    end)
end
