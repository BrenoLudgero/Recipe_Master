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
    elseif professionName == "Sastrería" and rm.locale == "esES" then
        return "Costura"
    end
    return professionName
end

local function getColoredSkill(character, recipeSkill, professionID)
    local skill = ""
    local characterProfessionLevel = rm.getSavedProfessionLevelForCharacter(character, professionID)
    if characterProfessionLevel < recipeSkill then
        skill = WrapTextInColorCode(characterProfessionLevel, F.colors.lightPinkHex)
    else
        skill = WrapTextInColorCode(characterProfessionLevel, F.colors.lightGreenHex)
    end
    return skill
end

local function getColoredSpecialization(character, recipeSpecialization, professionID)
    local specialization = ""
    local specializationName = rm.getSpecializationName(recipeSpecialization)
    local characterSpecialization = rm.getSavedProfessionSpecializationForCharacter(character, professionID)
    if characterSpecialization ~= recipeSpecialization then
        specialization = WrapTextInColorCode(specializationName, F.colors.lightPinkHex)
    else
        specialization = WrapTextInColorCode(specializationName, F.colors.lightGreenHex)
    end
    return specialization
end

local function getRecipeTooltipMessage(recipe, professionID)
    local charactersMissingRecipe, charactersWhoCraftRecipe = rm.getAllCharactersRecipeStatus(recipe, professionID)
    local message = ""
    local newLine = "\n"
    local newLineInfo = "\n  "
    if rm.getPreference("showSourcesTooltipInfo") and recipe and recipe.sources then
        message = message..newLine..WrapTextInColorCode(L.sources, F.colors.lightBlueHex)
        for _, sourceType in ipairs(rm.sourcesOrder) do
            if recipe.sources[sourceType] then
                message = message..newLineInfo..(rm.getLocalizedSourceType(sourceType))
            end
        end
    end
    if rm.getPreference("showAltsTooltipInfo") then
        if #charactersWhoCraftRecipe > 0 then
            -- Sort the charactersWhoCraftRecipe table alphabetically
            table.sort(charactersWhoCraftRecipe)
            message = message..newLine..WrapTextInColorCode(L.crafters, F.colors.lightGreenHex)
            for _, character in pairs(charactersWhoCraftRecipe) do
                message = message..newLineInfo..character
            end
        end
        if #charactersMissingRecipe > 0 then
            -- Sort the charactersMissingRecipe table alphabetically
            table.sort(charactersMissingRecipe)
            message = message..newLine..WrapTextInColorCode(L.unlearned, F.colors.lightPinkHex)
            for _, character in pairs(charactersMissingRecipe) do
                local characterLine = newLineInfo..character.." ("
                characterLine = characterLine..L.skill.." "..getColoredSkill(character, recipe.skill, professionID)
                if recipe.specialization then
                    characterLine = characterLine..", "..getColoredSpecialization(character, recipe.specialization, professionID)
                end
                message = message..characterLine..")"
            end
        end
    end
    return rm.L.title..WrapTextInColorCode(message, F.colors.whiteHex)
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

local function getRecipeInfo(itemName, itemLink)
    local recipeID = rm.getIDFromLink(itemLink)
    local professionName = handleMismatchedProfessionNames(recipeID, itemLink)
    local professionID = rm.getProfessionID(professionName)
    local recipe = rm.cachedRecipes[professionID][recipeID]
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
            showMessageInTooltip(tooltip, itemName, itemLink)
        end
    end
end)

-- Appends the message to a chat link tooltip
ItemRefTooltip:HookScript("OnTooltipSetItem", function(tooltip, ...)
    if rm.getPreference("showAltsTooltipInfo") or rm.getPreference("showSourcesTooltipInfo") then
        local itemName, itemLink = tooltip:GetItem()
        if itemName and isItemARecipe(itemName) then
            showMessageInTooltip(tooltip, itemName, itemLink)
        end
    end
end)
