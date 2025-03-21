local _, rm = ...
local L = rm.L
local F = rm.F

local function showTooltipOnMouseover(icon, recipe)
    GameTooltip:SetOwner(icon, "ANCHOR_RIGHT", 0, 0)
    GameTooltip:SetHyperlink(recipe.link)
    GameTooltip:Show()
end

function rm.displayInspectIconAndTooltipOnMouseover(icon, recipe)
    icon:HookScript("OnEnter", function(self)
        showTooltipOnMouseover(self, recipe)
        if recipe.sources then
            ShowInspectCursor()
        end
    end)
    icon:HookScript("OnLeave", function()
        ResetCursor()
        GameTooltip:Hide()
    end)
end

local function createChatLink(recipe)
    local chatBox = ChatEdit_ChooseBoxForSend()
    ChatEdit_ActivateChat(chatBox)
    chatBox:Insert(recipe.link)
end

local function showSourcesForRecipe(recipe)
    rm.showSourcesFrameElements()
    rm.activateBottomTabAndDesaturateOthers(rm.recipeSourcesTab)
    rm.showAllSources(recipe)
end

function rm.createChatLinkOrDisplaySourcesOnClick(icon, recipe)
    icon:HookScript("OnMouseDown", function(self, button)
        if IsShiftKeyDown() and button == "LeftButton" then
            createChatLink(recipe)
        elseif not IsShiftKeyDown() and recipe.sources then
            rm.clearFrameContent()
            rm.mainFrame:SetWidth(F.sizes.sourcesFrameWidth)
            showSourcesForRecipe(recipe)
        end
    end)
end

local function getMissingRequirementsText(recipe)
    local missingRequirements = ""
    if recipe.skill > rm.getSavedProfessionLevelByName(rm.displayedProfession) then
        local skillInfo = L.skill..": "..recipe.skill.."  "
        missingRequirements = missingRequirements..skillInfo
    end
    if recipe.specialization then
        local savedSpecialization = rm.getSavedSpecializationByName(rm.displayedProfession)
        if rm.currentSeason == "SoD" and savedSpecialization and type(savedSpecialization) == "table" then
            if not rm.tableContains(savedSpecialization, recipe.specialization) then
                local specializationInfo = rm.getSpecializationName(recipe.specialization).."  "
                missingRequirements = missingRequirements..specializationInfo
            end
        else
            if recipe.specialization ~= savedSpecialization then 
                local specializationInfo = rm.getSpecializationName(recipe.specialization).."  "
                missingRequirements = missingRequirements..specializationInfo
            end
        end
    end
    if recipe.repLevel and not rm.isReputationRequirementMet(recipe) then
        local reputationInfo = rm.getFactionName(recipe.repFaction).."  "
        missingRequirements = missingRequirements..reputationInfo
    end
    return missingRequirements
end

local function getDifficultyTextAndColor(recipe)
    local professionSkill = rm.getSavedProfessionLevelByName(rm.displayedProfession)
    for index, diffLevel in ipairs(recipe.difficulty) do
        if diffLevel ~= 0 and diffLevel >= professionSkill then
            return rm.difficultyLevels[index].name, rm.difficultyLevels[index].color
        end
    end
    return rm.difficultyLevels[4].name, rm.difficultyLevels[4].color -- Trivial
end

function rm.getRequirementsText(recipe, recipeInfo)
    local missingRequirements = getMissingRequirementsText(recipe)
    if missingRequirements == "" then
        if recipe.difficulty then
            local difficultyLevel, difficultyColor = getDifficultyTextAndColor(recipe)
            recipeInfo:SetText(
                WrapTextInColorCode(L.canLearn, F.colors.yellowHex)..
                WrapTextInColorCode(" | ", F.colors.whiteHex)..
                WrapTextInColorCode(difficultyLevel, difficultyColor)
            )
        else
            recipeInfo:SetText(WrapTextInColorCode(L.canLearn, F.colors.yellowHex))
        end
    else
        recipeInfo:SetText(missingRequirements:gsub("(%s%s)(%C)", ", %2")) -- Replaces all "  " with ", " when followed by a character
        recipeInfo:SetTextColor(unpack(F.colors.red))
    end
end

function rm.storeWidestRecipeTextWidth(recipeNameWidth, recipeInfoWidth)
    if recipeNameWidth > rm.widestRecipeTextWidth then
        rm.widestRecipeTextWidth = recipeNameWidth
    end
    if recipeInfoWidth and recipeInfoWidth > rm.widestRecipeTextWidth then
        rm.widestRecipeTextWidth = recipeInfoWidth
    end
end

function rm.displayPlaceholderTextBasedOnFocus(searchBar)
    searchBar:SetScript("OnEditFocusGained", function(self)
        self.Instructions:Hide()
        self.clearButton:Show()
    end)
    searchBar:SetScript("OnEditFocusLost", function(self)
        self.Instructions:Show()
        self.clearButton:Hide()
        searchBar:SetText("")
    end)
end

local function isSearchInRecipeName(row, searchText)
    local recipeName = row.recipeText:GetText():lower()
    return string.find(recipeName, searchText, 1, true)
end

function rm.showMatchingRecipesOnTop(searchBar)
    searchBar:SetScript("OnTextChanged", function(self)
        local searchText = self:GetText():lower()
        for _, row in ipairs(rm.recipesList.children) do
            if isSearchInRecipeName(row, searchText) then
                row:Show()
            else
                row:Hide()
            end
        end
        rm.updateRecipesFrameElementsPosition()
    end)
end

local function isSortedBySelectedValue(dropdown, value)
    return value == rm.getPreference("sortRecipesBy")
end

local function updateSortByPreference(dropdown, value)
    if not isSortedBySelectedValue(dropdown, value) then
        rm.setPreference("sortRecipesBy", value)
    end
end

local function sortRecipesByValue(dropdown, value)
    updateSortByPreference(dropdown, value)
    rm.showSortedRecipes()
end

function rm.handleSortingOptions(dropdown, options)
    dropdown:SetupMenu(function(self, rootDescription)
        for _, item in ipairs(options) do
            local name = item[1]
            local value = item[2]
            rootDescription:CreateButton(name, function()
                sortRecipesByValue(self, value)
                self:SetDefaultText(name)
            end)
        end
    end)
end

local function isValueAColor(value, savedValue)
    return type(value) == "table" and (unpack(value) == unpack(savedValue))
end

function rm.setInitialDropdownValue(dropdown, options, savedVariable)
    local savedValue = rm.getPreference(savedVariable)
    for _, item in ipairs(options) do
        local name = item[1]
        local value = item[2]
        if value == savedValue or isValueAColor(value, savedValue) then
            dropdown:SetDefaultText(name)
        end
    end
end

function rm.updateArrowOrientation(texture)
    if rm.getPreference("sortAscending") then
        texture:SetTexture(F.textures.sortOrderArrowUp)
        texture:SetPoint("CENTER", texture:GetParent(), 1.4, 2)
    else
        texture:SetTexture(F.textures.sortOrderArrowDown)
        texture:SetPoint("CENTER", texture:GetParent(), 1.4, -4.8)
    end
end

local function updateSortOrder(texture)
    rm.toggleBooleanPreference("sortAscending")
    rm.updateArrowOrientation(texture)
    rm.showSortedRecipes()
end

function rm.updateSortOrderOnClick(button, texture)
    button:SetScript("OnClick", function(self)
        updateSortOrder(texture)
    end)
end
