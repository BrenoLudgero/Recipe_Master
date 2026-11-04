local _, rm = ...
local L = rm.L
local F = rm.F

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
    local characterSpecializations = rm.getSpecializationsList(characterProfessionData["specialization"])
    if not rm.tableContains(characterSpecializations, recipeSpecialization) then
        specialization = WrapTextInColorCode(specializationName, F.colors.lightPinkHex)
    else
        specialization = WrapTextInColorCode(specializationName, F.colors.lightGreenHex)
    end
    return specialization
end

local function getRecipeTooltipMessage(recipe, professionID, isCraftedItem)
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
    local coloredMessage = WrapTextInColorCode(message, F.colors.whiteHex)
    if isCraftedItem then
        local professionName = L.professions[professionID]
        local craftedByProffesion = WrapTextInColorCode(L.craftedItem..' - '..professionName, F.colors.whiteHex)
        return "Recipe Master"..newLine..craftedByProffesion..coloredMessage
    else
        return "Recipe Master"..coloredMessage
    end
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
    local message = getRecipeTooltipMessage(item, professionID, isCraftedItem)
    local messageLineCount = select(2, message:gsub("\n", "\n"))
    if messageLineCount > 0 then -- Not counting the "Recipe Master" header
        appendMessage(tooltip, message)
    end
end

local function isItemARecipe(itemID)
    local classID = select(6, C_Item.GetItemInfoInstant(itemID))
    return classID == Enum.ItemClass.Recipe
end

local function showMessageInRecipesOrCraftedItemsTooltip(tooltip)
    local _, _, itemID = TooltipUtil.GetDisplayedItem(tooltip)
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

-- Appends the message to a spell's tooltip
TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, function(tooltip)
    if tooltip ~= GameTooltip then
        return
    end
    if rm.getPreference("showAltsTooltipInfo") or rm.getPreference("showSourcesTooltipInfo") then
        local _, spellID = TooltipUtil.GetDisplayedSpell(tooltip)
        if spellID then
            local spell, professionID = getSpellInfo(spellID)
            showMessageInTooltip(tooltip, spell, professionID, false)
        end
    end
end)
