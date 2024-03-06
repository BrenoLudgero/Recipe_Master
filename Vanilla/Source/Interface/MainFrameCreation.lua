function createRMFrame()
    local mainFrame = CreateFrame("Frame", nil, nil, templates.mainFrame)
    mainFrame:SetBackdrop(backdrops.mainFrame)
    mainFrame:SetBackdropColor(unpack(colors.mainBackground))
    mainFrame:SetFrameLevel(7)
    mainFrame:SetClampedToScreen(true)
    mainFrame:EnableMouse(true)
    mainFrame:SetWidth(sizes.mainWidth)
    mainFrame:Hide()
    return mainFrame
end

function createRMBorder(parent)
    local border = CreateFrame("Frame", nil, parent, templates.mainFrameBorder)
    local button = border.CloseButton
    local buttonWidth = button:GetWidth()
    local buttonHeight = button:GetHeight()
    border:SetPoint("TOPLEFT", parent, 2.5, 0)
    border:SetPoint("BOTTOMRIGHT", parent, 0, 2)
    setUpRMButtonWithTooltip(button, buttonWidth, buttonHeight, strings.hideWindowTooltip, function(button, button, down)
        autoOpenRecipeMaster = false
        restoreButton:Show()
        mainFrame:Hide()
    end)
    return border
end

function createRMHeader(parent)
    local header = CreateFrame("Frame", nil, parent)
    local frameLevel = parent:GetFrameLevel() - 1
    header:SetPoint("LEFT", parent, "LEFT")
    header:SetPoint("TOP", parent, "TOP", offsets.headerX, offsets.headerY)
    header:SetHeight(sizes.headerTextureHeight)
    header:SetFrameLevel(frameLevel)
    local texture = header:CreateTexture(nil)
    texture:SetTexture(textures.header, "REPEAT", "REPEAT")
    texture:SetHorizTile(true)
    texture:SetAllPoints(header)
    return header
end

function createRMHeaderText(parent)
    local text = parent:CreateFontString(nil, "OVERLAY", fonts.header)
    text:SetText(RecipeMasterName)
    text:SetTextColor(unpack(colors.yellow))
    text:SetPoint("CENTER", 0, offsets.headerTextY)
    return text
end

function createRMInnerBorder(parent)
    local innerBorder = CreateFrame("Frame", nil, parent, templates.innerBorder)
    local frameLevel = parent:GetFrameLevel() + 2
    innerBorder:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 1, 0)
    innerBorder:SetPoint("BOTTOMRIGHT", mainFrameBorder, "BOTTOMRIGHT", -3.2, 2)
    innerBorder:SetFrameLevel(frameLevel)
    matchParentHeight(innerBorder)
    return innerBorder
end

function createRMProgressContainer(parent)
    local progressContainer = CreateFrame("Frame", nil, parent, templates.innerBorder)
    local frameStrata = parent:GetFrameStrata()
    local frameLevel = parent:GetFrameLevel() + 1
    progressContainer:SetSize(parent:GetWidth(), sizes.progressContainerHeight)
    progressContainer:SetPoint("BOTTOM", parent, "BOTTOM", 0, 4)
    progressContainer:SetPoint("LEFT", mainFrameBorder, 1.8, 0)
    progressContainer:SetPoint("RIGHT", mainFrameBorder, -4.3, 0)
    progressContainer:SetFrameStrata(frameStrata)
    progressContainer:SetFrameLevel(frameLevel)
    return progressContainer
end

function createRMDivider(parent)
    local divider = CreateFrame("Frame", nil, parent, templates.divider)
    local frameLevel = parent:GetFrameLevel() + 2
    divider:SetSize(parent:GetWidth(), sizes.dividerHeight)
    divider:SetFrameLevel(frameLevel)
    divider:SetPoint("BOTTOM", parent, "BOTTOM", 0, offsets.dividerY)
    divider:SetPoint("LEFT", parent, "LEFT", -0.1, 0)
    divider:SetPoint("RIGHT", parent, "RIGHT", 0.2, 0)
    return divider
end

function createRMScrollFrame(parent)
    local scroll = CreateFrame("ScrollFrame", nil, parent, templates.scrollFrame)
    scroll:SetPoint("TOPLEFT", header, "BOTTOMLEFT", -0.5, -5.7)
    scroll:SetPoint("BOTTOMRIGHT", divider, "TOPRIGHT", 0, 4.5)
    scroll:SetPoint("RIGHT", mainFrameBorder, "RIGHT", -31.5, 0)
    return scroll
end

function createRMRecipeContainerFrame(parent)
    local recipeContainer = CreateFrame("Frame", nil, parent)
    recipeContainer:SetSize(1, 1) -- Sizes are adjusted dynamically
    recipeContainer.children = {}
    return recipeContainer
end

function createRMSearchBar(parent)
    local searchBar = CreateFrame("EditBox", nil, parent, templates.search)
    local font = searchBar:GetFont()
    local frameLevel = parent:GetFrameLevel() + 1
    searchBar:SetSize(sizes.searchWidth, sizes.searchHeight)
    searchBar:SetFrameLevel(frameLevel)
    searchBar:SetPoint("CENTER", parent, "LEFT", offsets.searchX, offsets.searchY)
    searchBar:SetFont(font, fontSizes.search, "")
    displayPlaceholderTextBasedOnFocus(searchBar)
    showMatchingRecipesOnTop(searchBar)
    return searchBar
end

function createRMSortBar(parent)
    local sortBar = CreateFrame("Button", nil, parent, templates.dropdown)
    local font = searchBar:GetFont()
    local frameLevel = parent:GetFrameLevel() + 1
    sortBar:SetScale(0.73)
    sortBar:SetFrameLevel(frameLevel)
    sortBar:SetPoint("RIGHT", parent, "RIGHT", offsets.sortBarX, offsets.sortBarY)
    sortBar.Text:SetFont(font, fontSizes.sortBar, "")
    sortBar.Text:SetPoint("CENTER", 0, 2.5)
    sortBar.values = {
        {text = NAME, value = "Name"},
        {text = QUALITY, value = "Quality"},
        {text = SKILL, value = "Skill"}
    }
    UIDropDownMenu_SetWidth(sortBar, sizes.sortBarWidth)
    handleSortingOptions(sortBar)
    setInitialDropdownValue(sortBar, "sortRecipesBy")
    return sortBar
end

function createRMSortByText(parent)
    local text = parent:CreateFontString(nil, "OVERLAY", fonts.header)
    text:SetText(strings.sortBy)
    text:SetTextColor(unpack(colors.yellow))
    text:SetPoint("RIGHT", parent, "LEFT", offsets.sortTextX, offsets.sortTextY)
    return text
end

function createRMSortOrderButton(parent)
    local button = CreateFrame("Button", nil, parent)
    local frameLevel = parent:GetFrameLevel() + 1
    button:SetFrameLevel(frameLevel)
    button:SetSize(sizes.sortOrderButton, sizes.sortOrderButton)
    button:SetPoint("CENTER", parent, "RIGHT", offsets.sortOrderX, offsets.sortOrderY)
    button:SetNormalTexture(textures.sortOrderButton)
    local texture = button:CreateTexture()
    texture:SetTexture(textures.sortOrderArrow)
    texture:SetDrawLayer("OVERLAY")
    updateArrowOrientation(texture)
    updateSortOrderOnClick(button, texture)
    return button
end

function createRMProgressBar(parent)
    local progressBar = CreateFrame("StatusBar", nil, parent)
    local frameLevel = parent:GetFrameLevel() - 1
    progressBar:SetSize(parent:GetWidth(), sizes.progressHeight)
    progressBar:SetStatusBarTexture(RecipeMasterPreferences["progressTexture"])
    progressBar:SetMinMaxValues(0, 100)
    progressBar:SetFrameLevel(frameLevel)
    progressBar:SetPoint("CENTER", parent, "CENTER", 0, 0)
    progressBar:SetPoint("LEFT", parent)
    progressBar:SetPoint("RIGHT", parent)
    local background = progressBar:CreateTexture(nil, "BACKGROUND")
    background:SetTexture(textures.mainBackground)
    background:SetAllPoints(progressBar)
    return progressBar
end

function createRMProgressBarText(parent)
    local text = parent:CreateFontString(nil, "OVERLAY", fonts.header)
    text:SetPoint("CENTER", 0, 0)
    text:SetTextColor(unpack(colors.progressText))
    return text
end

function createRMBottomTab(label, anchor, xOffset, active)
    local tab = CreateFrame("Button", nil, mainFrame)
    local frameLevel = mainFrame:GetFrameLevel() - 1
    tab:SetSize(sizes.tabWidth, sizes.tabHeight)
    tab:SetFrameLevel(frameLevel)
    tab:SetPoint("TOP", mainFrameBorder, anchor, xOffset, 0)
    tab.active = active
    local texture = tab:CreateTexture()
    texture:SetPoint("CENTER", tab, offsets.tabTextureX, offsets.tabTextureY)
    texture:SetSize(sizes.tabTextureWidth, sizes.tabTextureHeight)
    texture:SetTexture(textures.bottomTab)
    tab.texture = texture
    if not tab.active then
        texture:SetDesaturated(true)
    end
    local text = tab:CreateFontString(nil, "OVERLAY")
    text:SetFont(fonts.bottomTab, fontSizes.bottomTab, "OUTLINE")
    text:SetText(label)
    text:SetPoint("CENTER", texture, offsets.tabTextX, offsets.tabTextY)
    tab.label = text:GetText()
    table.insert(bottomTabs, tab)
    handleTabSwitching(tab)
    return tab
end

function createRMRestoreButton()
    local button = CreateFrame("Button", nil)
    button.texture = button:CreateTexture()
    button.texture:SetTexture(RecipeMasterPreferences["restoreButtonIconTexture"])
    button.texture:SetAllPoints(button)
    setUpRMButtonWithTooltip(button, sizes.restoreButton, sizes.restoreButton, RecipeMasterName, function(self, button, down)
        autoOpenRecipeMaster = true
        self:Hide()
        mainFrame:Show()
    end)
    return button
end

local function createRowIcon(recipe, yOffset)
    local icon = recipeContainer:CreateTexture(nil)
    icon:SetTexture(recipe.texture)
    icon:SetSize(sizes.recipeIcon, sizes.recipeIcon)
    icon:SetPoint("TOP", recipeContainer, "BOTTOMLEFT", offsets.recipeIconX, yOffset)
    displayTooltipOnMouseover(icon, recipe)
    chatLinkOnShiftClick(icon, recipe)
    return icon
end

local function createRowText(recipe, rowIcon, red, green, blue)
    local text = recipeContainer:CreateFontString(nil, "OVERLAY", fonts.recipeText)
    text:SetText(recipe.name)
    text:SetTextColor(red, green, blue)
    text:SetPoint("LEFT", rowIcon, "RIGHT", offsets.recipeTextX, 0)
    text.associatedIcon = rowIcon
    return text
end

local function storeWidestRecipeTextWidth(recipeTextWidth)
    if recipeTextWidth > widestRecipeTextWidth then
        widestRecipeTextWidth = recipeTextWidth
    end
end

function createRecipeRow(recipe, red, green, blue, desaturateIcon)
    local yOffset = -(displayedRecipesCount * (sizes.recipeIcon + RecipeMasterPreferences["rowSpacing"]))
    local rowIcon = createRowIcon(recipe, yOffset)
    rowIcon:SetDesaturated(desaturateIcon)
    local rowText = createRowText(recipe, rowIcon, red, green, blue)
    local recipeTextWidth = rowText:GetWidth()
    storeWidestRecipeTextWidth(recipeTextWidth)
    table.insert(recipeContainer.children, rowText)
    displayedRecipesCount = displayedRecipesCount + 1
end

function createRMCenteredText(parent)
    local text = parent:CreateFontString(nil, "OVERLAY")
    text:SetFont(fonts.bottomTab, fontSizes.centeredText, "OUTLINE")
    text:SetPoint("CENTER", parent)
    text:Hide()
    return text
end
