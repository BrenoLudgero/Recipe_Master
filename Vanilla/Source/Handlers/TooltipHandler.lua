local _, rm = ...
local L = rm.L

local function isItemRecipe(itemName)
    for _, prefix in pairs(L.recipePrefixes) do
        if itemName:sub(1, #prefix) == prefix then
            return true
        end
    end
    return false
end

local function getRecipeTooltipMessage(recipe, profession)
    local charactersMissingRecipe, charactersWhoCraftRecipe = rm.getAllCharactersRecipeStatus(recipe, profession)
    local message = ""
    local newLine = "\n"
    local newLineInfo = "\n    "
    if #charactersWhoCraftRecipe > 0 then
        message = message..newLine..WrapTextInColorCode(L.crafters, "FF90EE90") -- Light green
        for _, character in pairs(charactersWhoCraftRecipe) do
            message = message..newLineInfo..character
        end
    end
    if #charactersMissingRecipe > 0 then
        message = message..newLine..WrapTextInColorCode(L.unlearned, "FFFFB6C1") -- Light red
        for _, character in pairs(charactersMissingRecipe) do
            local characterProfessionLevel = rm.getSavedProfessionLeveForCharacter(character, profession)
            message = message..newLineInfo..character.." ("..characterProfessionLevel..")"
        end
    end
    return rm.L.title..WrapTextInColorCode(message, "FFFFFFFF") -- White
end

-- Ensures that the message is not displayed twice
local function isTooltipMessageDisplayed(i, tooltip, message)
    local lineText = _G[tooltip:GetName().."TextLeft"..i]:GetText()
    lineText = lineText:gsub("^%s*(.-)%s*$", "%1") -- Removes blank spaces and new lines
    return lineText == message
end

local function showTooltipMessage(tooltip, message)
    for i = 1, tooltip:NumLines() do
        if isTooltipMessageDisplayed(i, tooltip, message) then
            return
        end
    end
    tooltip:AddLine("\n"..message.."\n")
end

-- Appends the message to a recipe's tooltip
GameTooltip:HookScript("OnTooltipSetItem", function(tooltip, ...)
    local itemName, itemLink = tooltip:GetItem()
    if itemName and isItemRecipe(itemName) then
        local recipeID = rm.getIDFromLink(itemLink)
        local professionName = select(7, C_Item.GetItemInfo(itemLink))
        professionName = rm.handleMismatchedProfessionNames(professionName)
        local professionID = rm.getProfessionID(professionName)
        local recipe = rm.recipes[professionID][recipeID]
        local message = getRecipeTooltipMessage(recipe, professionID)
        local messageLineCount = select(2, message:gsub("\n", "\n"))
        if messageLineCount > 0 then -- Not counting the "Recipe Master" header
            showTooltipMessage(tooltip, message)
        end
    end
end)
