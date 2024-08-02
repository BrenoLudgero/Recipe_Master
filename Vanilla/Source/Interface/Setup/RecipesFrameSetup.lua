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
        ShowInspectCursor()
        showTooltipOnMouseover(self, recipe)
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
        elseif not IsShiftKeyDown() then
            rm.clearFrameContent()
            rm.mainFrame:SetWidth(F.sizes.sourcesFrameWidth)
            showSourcesForRecipe(recipe)
        end
    end)
end

function rm.getRequirementsText(recipe, recipeInfo)
    local missingRequirements = ""
    if recipe.skill > rm.getSavedProfessionLevelByName(rm.displayedProfession) then
        local skillInfo = L.skill..": "..recipe.skill.."  "
        missingRequirements = missingRequirements..skillInfo
    end
    if recipe.specialization then 
        local specializationInfo = rm.getSpecializationName(recipe.specialization).."  "
        missingRequirements = missingRequirements..specializationInfo
    end
    if recipe.repLevel and not rm.isReputationRequirementMet(recipe) then
        local reputationInfo = rm.getFactionName(recipe.repFaction).."  "
        missingRequirements = missingRequirements..reputationInfo
    end
    if missingRequirements ~= "" then
        recipeInfo:SetText(missingRequirements:gsub("(%s%s)(%C)", ", %2")) -- Replaces all "  " with ", " when followed by a character
        recipeInfo:SetTextColor(unpack(F.colors.red))
    else
        recipeInfo:SetText(L.canLearn)
        recipeInfo:SetTextColor(unpack(F.colors.yellow))
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

local function isSearchInRecipeName(rowIcon, searchText)
    local recipeName = rowIcon.associatedText:GetText():lower()
    return string.find(recipeName, searchText, 1, true)
end

function rm.showMatchingRecipesOnTop(searchBar)
    searchBar:SetScript("OnTextChanged", function(self)
        local searchText = self:GetText():lower()
        for _, rowIcon in ipairs(rm.recipesList.children) do
            if isSearchInRecipeName(rowIcon, searchText) then
                rowIcon:Show()
                rowIcon.associatedText:Show()
                if rowIcon.associatedText.additionalInfo then
                    rowIcon.associatedText.additionalInfo:Show()
                end
            else
                rowIcon:Hide()
                rowIcon.associatedText:Hide()
                if rowIcon.associatedText.additionalInfo then
                    rowIcon.associatedText.additionalInfo:Hide()
                end
            end
        end
        rm.updateRecipesFrameElementsPosition()
    end)
end

local function isSortedBySelectedValue(dropdown, sortBar)
    return sortBar.values[dropdown:GetID()].value == rm.getPreference("sortRecipesBy")
end

local function updateSortByPreference(dropdown, sortBar)
    if not isSortedBySelectedValue(dropdown, sortBar) then
        local selectedValue = sortBar.values[dropdown:GetID()].value
        rm.setPreference("sortRecipesBy", selectedValue)
    end
end

local function sortRecipesByValue(dropdown, sortBar)
    UIDropDownMenu_SetSelectedID(sortBar, dropdown:GetID())
    updateSortByPreference(dropdown, sortBar)
    rm.showSortedRecipes()
end

function rm.handleSortingOptions(sortBar)
    UIDropDownMenu_Initialize(sortBar, function(self)
        for _, option in ipairs(sortBar.values) do
            local info = UIDropDownMenu_CreateInfo()
            info.minWidth = F.sizes.sortBarWidth + 15
            info.text = option.text
            info.value = option.value
            info.func = function(self)
                sortRecipesByValue(self, sortBar)
            end
            UIDropDownMenu_AddButton(info)
        end
    end)
end

local function isValueAColor(value, savedValue)
    return type(value) == "table" and (unpack(value) == unpack(savedValue))
end

function rm.setInitialDropdownValue(dropdown, savedVariable)
    local savedValue = rm.getPreference(savedVariable)
    for _, option in pairs(dropdown.values) do
        if option.value == savedValue or isValueAColor(option.value, savedValue) then
            UIDropDownMenu_SetSelectedValue(dropdown, option.value)
        end
    end
end

local function toggleSortOrder()
    if rm.getPreference("sortAscending") then
        rm.setPreference("sortAscending", false)
    else
        rm.setPreference("sortAscending", true)
    end
end

function rm.updateArrowOrientation(texture)
    if rm.getPreference("sortAscending") then
        texture:SetRotation(0)
        texture:SetPoint("CENTER", texture:GetParent(), 1.2, -1.5)
    else
        texture:SetRotation(math.pi)
        texture:SetPoint("CENTER", texture:GetParent(), -2.5, 1.8)
    end
end

local function updateSortOrder(texture)
    toggleSortOrder()
    rm.updateArrowOrientation(texture)
    rm.showSortedRecipes()
end

function rm.updateSortOrderOnClick(button, texture)
    button:SetScript("OnClick", function(self)
        updateSortOrder(texture)
    end)
end
