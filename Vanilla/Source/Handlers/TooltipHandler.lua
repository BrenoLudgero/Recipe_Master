local _, rm = ...
local L = rm.L
local F = rm.F

local function isItemRecipe(itemName)
    for _, prefix in pairs(L.recipePrefixes) do
        if itemName:sub(1, #prefix) == prefix then
            return true
        end
    end
    return false
end

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
    elseif professionName == "Sastrería" and rm.locale == "esES" then
        return "Costura"
    end
    return professionName
end

local function getRecipeTooltipMessage(recipe, profession)
    local charactersMissingRecipe, charactersWhoCraftRecipe = rm.getAllCharactersRecipeStatus(recipe, profession)
    local message = ""
    local newLine = "\n"
    local newLineInfo = "\n  "
    if recipe.purchasable then
        message = message..newLine..WrapTextInColorCode(L.purchasableRecipe, F.colors.lightBlueHex)
    end
    if #charactersWhoCraftRecipe > 0 then
        message = message..newLine..WrapTextInColorCode(L.crafters, F.colors.lightGreenHex)
        for _, character in pairs(charactersWhoCraftRecipe) do
            message = message..newLineInfo..character
        end
    end
    if #charactersMissingRecipe > 0 then
        message = message..newLine..WrapTextInColorCode(L.unlearned, F.colors.lightRedHex)
        for _, character in pairs(charactersMissingRecipe) do
            local characterProfessionLevel = rm.getSavedProfessionLeveForCharacter(character, profession)
            message = message..newLineInfo..character.." ("..characterProfessionLevel..")"
        end
    end
    return rm.L.title..WrapTextInColorCode(message, F.colors.whiteHex)
end

-- Ensures that the message is not displayed twice
local function isTooltipMessageDisplayed(i, tooltip, message)
    local lineText = _G[tooltip:GetName().."TextLeft"..i]:GetText()
    lineText = lineText:gsub("^%s*(.-)%s*$", "%1") -- Removes blank spaces and new lines
    return lineText == message
end

local function appendMessage(tooltip, message)
    for i = 1, tooltip:NumLines() do
        if isTooltipMessageDisplayed(i, tooltip, message) then
            return
        end
    end
    tooltip:AddLine("\n"..message.."\n")
end

local function getRecipeInfo(itemName, itemLink)
    local recipeID = rm.getIDFromLink(itemLink)
    local professionName = handleMismatchedProfessionNames(recipeID, itemLink)
    local professionID = rm.getProfessionID(professionName)
    local recipe = rm.recipeDB[professionID][recipeID]
    recipe.purchasable = rm.sourceDB[professionID][recipeID] and rm.sourceDB[professionID][recipeID]["vendor"] ~= nil
    return recipe, professionID
end

local function showMessageInTooltip(tooltip, itemName, itemLink)
    local recipe, professionID = getRecipeInfo(itemName, itemLink)
    local message = getRecipeTooltipMessage(recipe, professionID)
    local messageLineCount = select(2, message:gsub("\n", "\n"))
    if messageLineCount > 0 then -- Not counting the "Recipe Master" header
        appendMessage(tooltip, message)
    end
end

-- Appends the message to a recipe's tooltip
GameTooltip:HookScript("OnTooltipSetItem", function(tooltip, ...)
    local itemName, itemLink = tooltip:GetItem()
    if itemName and isItemRecipe(itemName) then
        showMessageInTooltip(tooltip, itemName, itemLink)
    end
end)

-- Appends the message to a chat link tooltip
ItemRefTooltip:HookScript("OnTooltipSetItem", function(tooltip, ...)
    local itemName, itemLink = tooltip:GetItem()
    if itemName and isItemRecipe(itemName) then
        showMessageInTooltip(tooltip, itemName, itemLink)
    end
end)
