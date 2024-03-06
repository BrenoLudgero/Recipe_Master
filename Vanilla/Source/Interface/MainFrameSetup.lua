function setUpRMButtonWithTooltip(button, width, height, tooltipText, scriptOnClick)
    button:SetSize(width, height)
    button:EnableMouse(true)
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(tooltipText)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    button:SetScript("OnClick", scriptOnClick)
    return button
end

local function isMouseInsideScrollFrame()
    local mouseX, mouseY = GetCursorPosition()
    local frameX, frameY = scrollFrame:GetCenter()
    local frameWidth = scrollFrame:GetWidth()
    local frameHeight = scrollFrame:GetHeight()
    return mouseX >= (frameX - frameWidth / 2) and mouseX <= (frameX + frameWidth / 2) and mouseY >= (frameY - frameHeight / 2) and mouseY <= (frameY + frameHeight / 2)
end

function displayTooltipOnMouseover(icon, recipe)
    icon:SetScript("OnEnter", function(self)
        if isMouseInsideScrollFrame() then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0)
            GameTooltip:SetHyperlink(recipe.link)
            GameTooltip:Show()
        end
    end)
    icon:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
end

function chatLinkOnShiftClick(icon, recipe)
    icon:SetScript("OnMouseDown", function(self, button)
        if IsShiftKeyDown() and button == "LeftButton" then
            local editBox = ChatEdit_ChooseBoxForSend()
            ChatEdit_ActivateChat(editBox)
            editBox:Insert(recipe.link)
        end
    end)
end

function matchParentHeight(innerBorder)
    innerBorder:SetScript("OnUpdate", function(self, elapsed)
        self:SetHeight(innerBorder:GetParent():GetHeight())
    end)
end

function displayPlaceholderTextBasedOnFocus(searchBar)
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

function showMatchingRecipesOnTop(searchBar)
    searchBar:SetScript("OnTextChanged", function(self)
        local searchText = self:GetText():lower()
        local matchedRecipes = {}
        for _, rowText in ipairs(recipeContainer.children) do
            local recipeText = rowText:GetText():lower()
            if string.find(recipeText, searchText, 1, true) then
                rowText:Show()
                rowText.associatedIcon:Show()
            else
                rowText:Hide()
                rowText.associatedIcon:Hide()
            end
        end
        updateRecipesPosition()
    end)
end

local function isSortedBySelectedValue(dropdown)
    return sortBar.values[dropdown:GetID()].value == RecipeMasterPreferences["sortRecipesBy"]
end

local function updateSortBy(dropdown)
    if not isSortedBySelectedValue(dropdown) then
        local selectedValue = sortBar.values[dropdown:GetID()].value
        RecipeMasterPreferences["sortRecipesBy"] = selectedValue
    end
end

local function sortRecipesByValue(dropdown)
    UIDropDownMenu_SetSelectedID(sortBar, dropdown:GetID())
    updateSortBy(dropdown)
    showSortedRecipes()
end

function handleSortingOptions(sortBar)
    UIDropDownMenu_Initialize(sortBar, function(self)
        for _, option in ipairs(sortBar.values) do
            local info = UIDropDownMenu_CreateInfo()
            info.minWidth = sizes.sortBarWidth + 15
            info.text = option.text
            info.value = option.value
            info.func = sortRecipesByValue
            UIDropDownMenu_AddButton(info)
        end
    end)
end

local function isValueAColor(value, savedValue)
    return type(value) == "table" and (unpack(value) == unpack(savedValue))
end

function setInitialDropdownValue(dropdown, savedVariable)
    local savedValue = RecipeMasterPreferences[savedVariable]
    for _, option in pairs(dropdown.values) do
        if option.value == savedValue or isValueAColor(option.value, savedValue) then
            UIDropDownMenu_SetSelectedValue(dropdown, option.value)
        end
    end
end

local function updateSortOrder()
    local sortAscending = RecipeMasterPreferences["sortAscending"]
    if not sortAscending then
        RecipeMasterPreferences["sortAscending"] = true
    else
        RecipeMasterPreferences["sortAscending"] = false
    end
end

function updateArrowOrientation(texture)
    local sortAscending = RecipeMasterPreferences["sortAscending"]
    if sortAscending then
        texture:SetRotation(0)
        texture:SetPoint("CENTER", texture:GetParent(), 1.7, -1.3)
    else
        texture:SetRotation(math.pi)
        texture:SetPoint("CENTER", texture:GetParent(), -2.5, 1.7)
    end
end

local function toggleSortOrder(texture)
    updateSortOrder()
    updateArrowOrientation(texture)
    showSortedRecipes()
end

function updateSortOrderOnClick(button, texture)
    button:SetScript("OnClick", function(self)
        toggleSortOrder(texture)
    end)
end

local function handleRecipesTab(tab)
    if tab.label == TRADESKILL_SERVICE_LEARN then
        showRecipeFrameElements()
        showRecipesForProfession(lastDisplayedProfession)
    end
end

local function handleDetailsTab(tab)
    if tab.label == LFG_LIST_DETAILS then
        showDetailsTabElements()
        showCenteredText(strings.comingSoon, colors.green)
    end
end

local function handleFishingTab(tab)
    if tab.label == PROFESSIONS_FISHING then
        showRecipeFrameElements()
        if not getSavedProfessionByID(356) then
            hideRecipeFrameElements()
            showCenteredText(strings.fishingNotLearned, colors.yellow)
            return
        end
        showRecipesForProfession(professionNames[356])
    end
end

function handleTabSwitching(tab)
    tab:SetScript("OnClick", function(self)
        if not tab.active then
            centeredText:Hide()
            activateTabAndDesaturateOthers(tab)
            handleRecipesTab(tab)
            handleDetailsTab(tab)
            handleFishingTab(tab)
        end   
    end)
end
