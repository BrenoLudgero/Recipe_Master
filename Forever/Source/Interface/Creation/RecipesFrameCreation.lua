local _, rm = ...
local L = rm.L
local F = rm.F

function rm.createProgressContainer(parent)
    local progressContainer = CreateFrame("Frame", nil, parent, F.templates.innerBorder)
    local frameStrata = parent:GetFrameStrata()
    local frameLevel = rm.mainFrameBorder:GetFrameLevel() - 2
    progressContainer:SetSize(parent:GetWidth(), F.sizes.progressContainerHeight)
    progressContainer:SetPoint("BOTTOM", 0, 5.5)
    progressContainer:SetPoint("LEFT", rm.mainFrameBorder, 1.8, 0)
    progressContainer:SetPoint("RIGHT", rm.mainFrameBorder, -4.3, 0)
    progressContainer:SetFrameStrata(frameStrata)
    progressContainer:SetFrameLevel(frameLevel)
    return progressContainer
end

function rm.createDivider(parent)
    local divider = CreateFrame("Frame", nil, parent, F.templates.divider)
    local frameLevel = rm.mainFrameBorder:GetFrameLevel() + 1
    divider:SetHeight(F.sizes.dividerHeight)
    divider:SetFrameLevel(frameLevel)
    divider:SetPoint("BOTTOM", parent, "TOP")
    divider:SetPoint("LEFT")
    divider:SetPoint("RIGHT")
    return divider
end

local function createDividerCheckButton(parent, preference, labelText)
    local button = CreateFrame("CheckButton", nil, parent, F.templates.checkButton)
    local frameLevel = parent:GetFrameLevel() + 1
    button:SetSize(F.sizes.dividerCheckButton, F.sizes.dividerCheckButton)
    button:SetFrameLevel(frameLevel)
    button:SetChecked(rm.getPreference(preference))
    button.label = button:CreateFontString(nil, "OVERLAY", F.fonts.dividerCheckButtonText)
    button.label:SetText(labelText)
    button.label:SetFontHeight(F.fontSizes.dividerCheckButton)
    button.label:SetPoint("LEFT", button, "RIGHT", 0, F.offsets.dividerCheckButtonLabelY)
    rm.toggleRecipesListPreferenceOnClick(button, preference)
    return button
end

function rm.createShowLearnedCheckButton(parent)
    local button = createDividerCheckButton(parent, "showLearnedRecipes", L.showLearned)
    button:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT")
    return button
end

function rm.createShowDetailsCheckButton(parent)
    local button = createDividerCheckButton(parent, "showRecipesInfo", L.showDetails)
    local showLearnedWidth = rm.showLearnedCheckButton:GetWidth() + rm.showLearnedCheckButton.label:GetStringWidth()
    button:SetPoint("LEFT", rm.showLearnedCheckButton, "LEFT", showLearnedWidth + 1, 0)
    return button
end

function rm.createRecipesScrollFrame(parent)
    local scroll = CreateFrame("ScrollFrame", nil, parent, F.templates.scrollFrame)
    scroll:SetPoint("TOPLEFT", rm.header, "BOTTOMLEFT", 0, F.offsets.recipesListScrollTopY)
    scroll:SetPoint("BOTTOMRIGHT", rm.divider, "TOPRIGHT", 0, F.offsets.recipesListScrollBottomY)
    scroll:SetPoint("RIGHT", rm.mainFrameBorder, F.offsets.recipesListScrollX, 0)
    return scroll
end

function rm.createRecipesList(parent)
    local container = CreateFrame("Frame", nil, parent)
    container:SetSize(1, 1) -- Sizes are adjusted automatically
    container.children = {}
    return container
end

function rm.createSearchBar(parent)
    local searchBar = CreateFrame("EditBox", nil, parent, F.templates.search)
    local font = searchBar:GetFont()
    local frameLevel = parent:GetFrameLevel() + 1
    searchBar:SetHeight(F.sizes.searchBarHeight)
    searchBar:SetFrameLevel(frameLevel)
    searchBar:SetPoint("TOPLEFT", F.offsets.searchBarX, F.offsets.searchBarY)
    searchBar:SetFont(font, F.fontSizes.searchBar, "")
    rm.displayPlaceholderTextBasedOnFocus(searchBar)
    rm.showMatchingRecipesOnTop(searchBar)
    return searchBar
end

function rm.createSortByDropdown(parent)
    local font = rm.searchBar:GetFont()
    local frameLevel = parent:GetFrameLevel() + 1
    local sortDropdown = CreateFrame("DropdownButton", nil, parent, F.templates.dropdown)
    sortDropdown:SetWidth(F.sizes.sortDropdownWidth)
    sortDropdown:SetScale(0.73)
    sortDropdown:SetFrameLevel(frameLevel)
    sortDropdown:SetPoint("TOPRIGHT", parent, F.offsets.sortByDropdownX, F.offsets.sortByDropdownY)
    sortDropdown.Text:SetFont(font, F.fontSizes.sortDropdown, "")
    rm.showTooltipTextOnMouseover(sortDropdown, L.sortBy, "ANCHOR_TOP")
    local options = {
        {L.name, "Name"},
        {L.quality, "Quality"},
        {L.skill, "Skill"}
    }
    rm.handleSortingOptions(sortDropdown, options)
    rm.setInitialDropdownValue(sortDropdown, options, "sortRecipesBy")
    return sortDropdown
end

function rm.createSortOrderButton(parent)
    local button = CreateFrame("Button", nil, parent)
    local frameLevel = parent:GetFrameLevel() + 1
    button:SetFrameLevel(frameLevel)
    button:SetSize(F.sizes.sortOrderButton, F.sizes.sortOrderButton)
    -- Aligned to the right side of the sortBy dropdown's background texture
    button:SetPoint("TOPLEFT", parent.Background, "TOPRIGHT", F.offsets.sortOrderDropdownX, F.offsets.sortOrderDropdownY)
    button:SetNormalTexture(F.textures.sortOrderButton)
    button:SetHighlightTexture(F.textures.sortOrderButtonHighlight)
    local texture = button:CreateTexture()
    texture:SetDrawLayer("OVERLAY")
    rm.updateArrowOrientation(texture)
    rm.updateSortOrderOnClick(button, texture)
    return button
end

function rm.createSourceFilterDropdown(parent)
    local font = rm.searchBar:GetFont()
    local frameLevel = parent:GetFrameLevel() + 1
    local sourceDropdown = CreateFrame("DropdownButton", nil, parent, F.templates.dropdown)
    sourceDropdown:SetWidth(F.sizes.sortDropdownWidth)
    sourceDropdown:SetScale(0.73)
    sourceDropdown:SetFrameLevel(frameLevel)
    sourceDropdown:SetPoint("TOPLEFT", rm.sortByDropdown, "BOTTOMLEFT", 0, F.offsets.sourceFilterDropdownY)
    sourceDropdown:SetPoint("RIGHT", rm.mainFrameBorder, "RIGHT", F.offsets.sourceFilterDropdownX, 0)
    sourceDropdown.Text:SetFont(font, F.fontSizes.sortDropdown, "")
    rm.showTooltipTextOnMouseover(sourceDropdown, L.sources, "ANCHOR_TOP")
    rm.handleSourceFilterOptions(sourceDropdown)
    return sourceDropdown
end

function rm.createProgressBar(parent)
    local progressBar = CreateFrame("StatusBar", nil, parent)
    local frameLevel = parent:GetFrameLevel()
    progressBar:SetStatusBarTexture(rm.getPreference("progressTexture"))
    progressBar:SetMinMaxValues(0, 100)
    progressBar:SetFrameLevel(frameLevel)
    progressBar:SetPoint("TOP", 0, -3.5)
    progressBar:SetPoint("LEFT", 3, 0)
    progressBar:SetPoint("RIGHT", -3, 0)
    progressBar:SetPoint("BOTTOM", 0, 3)
    local background = progressBar:CreateTexture(nil, "BACKGROUND")
    background:SetTexture(F.textures.mainBackground)
    background:SetAllPoints(progressBar)
    return progressBar
end

function rm.createProgressBarText(parent)
    local text = parent:CreateFontString(nil, "OVERLAY", F.fonts.progressBar)
    text:SetAllPoints(parent)
    text:SetTextColor(unpack(F.colors.white))
    return text
end

local function createRowIcon(recipe, yOffset)
    local recipeIcon = CreateFrame("Button", nil, rm.recipesList)
    local texture = recipeIcon:CreateTexture(nil)
    texture:SetTexture(recipe.texture)
    texture:SetAllPoints(recipeIcon)
    recipeIcon:SetSize(F.sizes.recipeIcon, F.sizes.recipeIcon)
    recipeIcon:SetPoint("TOP", rm.recipesList, "BOTTOMLEFT", F.offsets.recipeIconX, yOffset)
    recipeIcon.texture = texture
    rm.displayInspectIconAndTooltipOnMouseover(recipeIcon, recipe)
    rm.createChatLinkOrDisplaySourcesOnClick(recipeIcon, recipe)
    return recipeIcon
end

local function createAdditionalInfoText(recipe, recipeName, recipeInfo, color)
    if rm.isLearnedRecipe(recipe) then
        recipeInfo:SetText(L.learned)
        recipeInfo:SetTextColor(unpack(color)) -- Gray
    else
        rm.getRequirementsText(recipe, recipeInfo)
    end
    recipeName.additionalInfo = recipeInfo
end

local function createRowText(recipe, rowIcon, color)
    local recipeName = rm.recipesList:CreateFontString(nil, "OVERLAY", F.fonts.recipeText)
    recipeName:SetParent(rowIcon)
    recipeName:SetText(recipe.name)
    recipeName:SetTextColor(unpack(color))
    if rm.getPreference("showRecipesInfo") then
        local recipeInfo = rm.recipesList:CreateFontString(nil, "OVERLAY", F.fonts.recipeText)
        recipeInfo:SetParent(rowIcon)
        recipeName:SetPoint("LEFT", rowIcon, "TOPRIGHT", F.offsets.recipeTextX, -6)
        recipeInfo:SetPoint("TOPLEFT", recipeName, "BOTTOMLEFT", 0, F.offsets.recipeInfoY)
        createAdditionalInfoText(recipe, recipeName, recipeInfo, color)
    else
        recipeName:SetPoint("LEFT", rowIcon, "RIGHT", F.offsets.recipeTextX, 0)
    end
    return recipeName
end

function rm.createRecipeRow(recipe, color, desaturateIcon)
    local yOffset = -(#rm.recipesList.children * (F.sizes.recipeIcon + rm.getPreference("iconSpacing")))
    local rowIcon = createRowIcon(recipe, yOffset)
    rowIcon.texture:SetDesaturated(desaturateIcon)
    local recipeNameText = createRowText(recipe, rowIcon, color)
    local recipeNameWidth = recipeNameText:GetWidth()
    local recipeInfoWidth = 0
    if recipeNameText.additionalInfo then
        recipeInfoText = recipeNameText.additionalInfo
        recipeInfoWidth = recipeInfoText:GetWidth()
    end
    rm.storeWidestRecipeTextWidth(recipeNameWidth, recipeInfoWidth)
    rowIcon.recipeText = recipeNameText
    table.insert(rm.recipesList.children, rowIcon)
end
