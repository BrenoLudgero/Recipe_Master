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
    local message = getRecipeTooltipMessage(item, professionID, isCraftedItem)
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
        local _, spellID = tooltip:GetSpell()
        if spellID then
            local spell, professionID = getSpellInfo(spellID)
            showMessageInTooltip(tooltip, spell, professionID, false)
        end
    end
end)

-- Appends the message to a chat link tooltip
ItemRefTooltip:HookScript("OnTooltipSetItem", function(tooltip)
    if rm.getPreference("showAltsTooltipInfo") or rm.getPreference("showSourcesTooltipInfo") then
        showMessageInRecipesOrCraftedItemsTooltip(tooltip)
    end
end)
