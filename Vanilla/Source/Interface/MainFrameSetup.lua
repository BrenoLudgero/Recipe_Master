local _, rm = ...
local L = rm.L
local F = rm.F

function rm.setUpButtonWithTooltip(button, width, height, tooltipText, scriptOnClick)
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
    local frameX, frameY = rm.scrollFrame:GetCenter()
    local frameWidth = rm.scrollFrame:GetWidth()
    local frameHeight = rm.scrollFrame:GetHeight()
    return (
        mouseX >= (frameX - frameWidth / 2) 
        and mouseX <= (frameX + frameWidth / 2) 
        and mouseY >= (frameY - frameHeight / 2) 
        and mouseY <= (frameY + frameHeight / 2)
    )
end

function rm.displayTooltipOnMouseover(icon, recipe)
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

function rm.chatLinkOnShiftClick(icon, recipe)
    icon:SetScript("OnMouseDown", function(self, button)
        if IsShiftKeyDown() and button == "LeftButton" then
            local chatBox = ChatEdit_ChooseBoxForSend()
            ChatEdit_ActivateChat(chatBox)
            chatBox:Insert(recipe.link)
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
    elseif recipeInfoWidth and recipeInfoWidth > rm.widestRecipeTextWidth then
        rm.widestRecipeTextWidth = recipeInfoWidth
    end
end

function rm.matchParentHeight(innerBorder)
    innerBorder:SetScript("OnUpdate", function(self, elapsed)
        self:SetHeight(innerBorder:GetParent():GetHeight())
    end)
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

function rm.showMatchingRecipesOnTop(searchBar)
    searchBar:SetScript("OnTextChanged", function(self)
        local searchText = self:GetText():lower()
        local matchedRecipes = {}
        for _, rowIcon in ipairs(rm.recipeContainer.children) do
            local recipeText = rowIcon.associatedText:GetText():lower()
            if string.find(recipeText, searchText, 1, true) then
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
        rm.updateRecipesPosition()
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

local function toggleSortOrder(sortAscending)
    if sortAscending then
        rm.setPreference("sortAscending", false)
    else
        rm.setPreference("sortAscending", true)
    end
end

function rm.updateArrowOrientation(texture, sortAscending)
    if sortAscending then
        texture:SetRotation(0)
        texture:SetPoint("CENTER", texture:GetParent(), 1.7, -1.3)
    else
        texture:SetRotation(math.pi)
        texture:SetPoint("CENTER", texture:GetParent(), -2.5, 1.7)
    end
end

local function updateSortOrder(texture)
    local sortAscending = rm.getPreference("sortAscending")
    toggleSortOrder(sortAscending)
    rm.updateArrowOrientation(texture, sortAscending)
    rm.showSortedRecipes()
end

function rm.updateSortOrderOnClick(button, texture)
    button:SetScript("OnClick", function(self)
        updateSortOrder(texture)
    end)
end

local function handleRecipesTab()
    rm.showRecipeFrameElements()
    rm.showRecipesForSpecificProfession(rm.lastDisplayedProfession)
end

local function handleSourcesTab()
    rm.showSourcesTabElements()
    rm.showCenteredText(L.comingSoon, F.colors.green)
end

local function handleFishingTab()
    rm.showRecipeFrameElements()
    if not rm.getSavedProfessionByID(356) then -- Fishing is not learned
        rm.hideRecipeFrameElements()
        rm.showCenteredText(L.fishingNotLearned, F.colors.yellow)
        return
    end
    rm.showRecipesForSpecificProfession(L.professions[356])
end

local function handleCurrentTab(tab)
    if tab.label == L.recipes then
        handleRecipesTab()
        return
    elseif tab.label == L.sources then
        handleSourcesTab()
        return
    elseif tab.label == L.fishing then
        handleFishingTab()
        return
    end
end

function rm.handleTabSwitching(tab)
    tab:SetScript("OnClick", function(self)
        if not tab.active then
            rm.centeredText:Hide()
            rm.activateTabAndDesaturateOthers(tab)
            handleCurrentTab(tab)
        end   
    end)
end
