local _, rm = ...
local L = rm.L
local F = rm.F

local function isSpecificLeatherworkingRecipe(recipeID)
    return (
        recipeID == 22694    -- Pattern: Polar Gloves
        or recipeID == 22695 -- Pattern: Polar Bracers
        or recipeID == 22697 -- Pattern: Icy Scale Gauntlets
        or recipeID == 22698 -- Pattern: Icy Scale Bracers
    )
end

-- Recipes that have a profession name different than the profession's display name for some languages
local function handleMismatchedProfessionNames(recipeID, itemLink)
    if isSpecificLeatherworkingRecipe(recipeID) then
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
    if rm.getPreference("showAltsTooltipInfo") then
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
        if not currentLineText or currentLineText:gsub("^%s*(.-)%s*$", "%1") == "Recipe Master" then
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

-- Identifies a profession, its abilities or specializations (e.g. Cooking, Disenchant, Armorsmith)
local function getProfessionIDFromSpell(spellName, spellID)
    return (
        rm.getTrackedProfessionID(spellName)
        or otherProfessionSpells[spellID]
        or rm.getProfessionIDBySpecialization(spellID)
    )
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

local function isSpellData(data)
    return data.link and string.find(data.link, "|Hspell:", 1, true)
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
local function getCraftedItemInfo(itemName, itemLink)
    local itemID = rm.getIDFromLink(itemLink)
    local craftedItem = rm.craftedItems[itemID] or rm.craftedEnchantingItems[itemName]
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

local function isItemARecipe(itemName)
    for _, prefix in pairs(L.recipePrefixes) do
        if itemName:sub(1, #prefix) == prefix then
            return true
        end
    end
    return false
end

local function showMessageInRecipesOrCraftedItemsTooltip(tooltip)
    local itemName, itemLink = tooltip:GetItem()
    if itemName and isItemARecipe(itemName) then
        local recipe, professionID = getRecipeInfo(itemLink)
        showMessageInTooltip(tooltip, recipe, professionID, false)
    elseif itemLink then
        local recipe, professionID = getCraftedItemInfo(itemName, itemLink)
        if recipe then
            showMessageInTooltip(tooltip, recipe, professionID, true)
        end
    end
end

-- Appends the message to a recipe's or crafted item's tooltip
GameTooltip:HookScript("OnTooltipSetItem", function(tooltip)
    if rm.getPreference("showAltsTooltipInfo") or rm.getPreference("showSourcesTooltipInfo") then
        showMessageInRecipesOrCraftedItemsTooltip(tooltip)
    end
end)

-- Appends the message to a spell's tooltip
GameTooltip:HookScript("OnTooltipSetSpell", function(tooltip)
    if rm.getPreference("showAltsTooltipInfo") or rm.getPreference("showSourcesTooltipInfo") then
        local spellName, spellID = tooltip:GetSpell()
        if spellID then
            -- Profession spells (e.g. "Cooking") and their specializations (e.g. "Armorsmith") share one list
            local baseProfessionID = getProfessionIDFromSpell(spellName, spellID)
            if baseProfessionID and rm.getPreference("showAltsTooltipInfo") and not isTooltipOwnedByRecipeMaster(tooltip) then
                showMessageInProfessionTooltip(tooltip, baseProfessionID)
            else
                local spell, professionID = getSpellInfo(spellID)
                showMessageInTooltip(tooltip, spell, professionID, false)
            end
        end
    end
end)

-- Appends the message to a chat link tooltip
ItemRefTooltip:HookScript("OnTooltipSetItem", function(tooltip)
    if rm.getPreference("showAltsTooltipInfo") or rm.getPreference("showSourcesTooltipInfo") then
        showMessageInRecipesOrCraftedItemsTooltip(tooltip)
    end
end)
