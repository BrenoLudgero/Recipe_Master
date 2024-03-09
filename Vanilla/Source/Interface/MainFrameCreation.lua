local _, rm = ...
local L = rm.L

function rm.createFrame()
    local mainFrame = CreateFrame("Frame", nil, nil, L.templates.mainFrame)
    mainFrame:SetBackdrop(L.backdrops.mainFrame)
    mainFrame:SetBackdropColor(unpack(L.colors.mainBackground))
    mainFrame:SetFrameLevel(7)
    mainFrame:SetClampedToScreen(true)
    mainFrame:EnableMouse(true)
    mainFrame:SetWidth(L.sizes.mainWidth)
    mainFrame:Hide()
    return mainFrame
end

function rm.createBorder(parent)
    local border = CreateFrame("Frame", nil, parent, L.templates.mainFrameBorder)
    local button = border.CloseButton
    local buttonWidth = button:GetWidth()
    local buttonHeight = button:GetHeight()
    border:SetPoint("TOPLEFT", parent, 2.5, 0)
    border:SetPoint("BOTTOMRIGHT", parent, 0, 2)
    rm.setUpButtonWithTooltip(button, buttonWidth, buttonHeight, L.strings.hideWindowTooltip, function(button, button, down)
        rm.autoOpenRecipesFrame = false
        rm.restoreButton:Show()
        rm.mainFrame:Hide()
    end)
    return border
end

function rm.createHeader(parent)
    local header = CreateFrame("Frame", nil, parent)
    local frameLevel = parent:GetFrameLevel() - 1
    header:SetPoint("LEFT", parent, "LEFT")
    header:SetPoint("TOP", parent, "TOP", L.offsets.headerX, L.offsets.headerY)
    header:SetHeight(L.sizes.headerTextureHeight)
    header:SetFrameLevel(frameLevel)
    local texture = header:CreateTexture(nil)
    texture:SetTexture(L.textures.header, "REPEAT", "REPEAT")
    texture:SetHorizTile(true)
    texture:SetAllPoints(header)
    return header
end

function rm.createHeaderText(parent)
    local text = parent:CreateFontString(nil, "OVERLAY", L.fonts.header)
    text:SetText(L.title)
    text:SetTextColor(unpack(L.colors.yellow))
    text:SetPoint("CENTER", 0, L.offsets.headerTextY)
    return text
end

function rm.createInnerBorder(parent)
    local innerBorder = CreateFrame("Frame", nil, parent, L.templates.innerBorder)
    local frameLevel = parent:GetFrameLevel() + 2
    innerBorder:SetPoint("TOPLEFT", rm.header, "BOTTOMLEFT", 1, 0)
    innerBorder:SetPoint("BOTTOMRIGHT", rm.mainFrameBorder, "BOTTOMRIGHT", -3.2, 2)
    innerBorder:SetFrameLevel(frameLevel)
    rm.matchParentHeight(innerBorder)
    return innerBorder
end

function rm.createProgressContainer(parent)
    local progressContainer = CreateFrame("Frame", nil, parent, L.templates.innerBorder)
    local frameStrata = parent:GetFrameStrata()
    local frameLevel = parent:GetFrameLevel() + 1
    progressContainer:SetSize(parent:GetWidth(), L.sizes.progressContainerHeight)
    progressContainer:SetPoint("BOTTOM", parent, "BOTTOM", 0, 4)
    progressContainer:SetPoint("LEFT", rm.mainFrameBorder, 1.8, 0)
    progressContainer:SetPoint("RIGHT", rm.mainFrameBorder, -4.3, 0)
    progressContainer:SetFrameStrata(frameStrata)
    progressContainer:SetFrameLevel(frameLevel)
    return progressContainer
end

function rm.createDivider(parent)
    local divider = CreateFrame("Frame", nil, parent, L.templates.divider)
    local frameLevel = parent:GetFrameLevel() + 2
    divider:SetSize(parent:GetWidth(), L.sizes.dividerHeight)
    divider:SetFrameLevel(frameLevel)
    divider:SetPoint("BOTTOM", parent, "BOTTOM", 0, L.offsets.dividerY)
    divider:SetPoint("LEFT", parent, "LEFT", -0.1, 0)
    divider:SetPoint("RIGHT", parent, "RIGHT", 0.2, 0)
    return divider
end

function rm.createScrollFrame(parent)
    local scroll = CreateFrame("ScrollFrame", nil, parent, L.templates.scrollFrame)
    scroll:SetPoint("TOPLEFT", rm.header, "BOTTOMLEFT", -0.5, -5.7)
    scroll:SetPoint("BOTTOMRIGHT", rm.divider, "TOPRIGHT", 0, 4.5)
    scroll:SetPoint("RIGHT", rm.mainFrameBorder, "RIGHT", -31.5, 0)
    return scroll
end

function rm.createRecipeContainerFrame(parent)
    local recipeContainer = CreateFrame("Frame", nil, parent)
    recipeContainer:SetSize(1, 1) -- L.Sizes are adjusted dynamically
    recipeContainer.children = {}
    return recipeContainer
end

function rm.createSearchBar(parent)
    local searchBar = CreateFrame("EditBox", nil, parent, L.templates.search)
    local font = searchBar:GetFont()
    local frameLevel = parent:GetFrameLevel() + 1
    searchBar:SetSize(L.sizes.searchWidth, L.sizes.searchHeight)
    searchBar:SetFrameLevel(frameLevel)
    searchBar:SetPoint("CENTER", parent, "LEFT", L.offsets.searchX, L.offsets.searchY)
    searchBar:SetFont(font, L.fontSizes.search, "")
    rm.displayPlaceholderTextBasedOnFocus(searchBar)
    rm.showMatchingRecipesOnTop(searchBar)
    return searchBar
end

function rm.createSortBar(parent)
    local sortBar = CreateFrame("Button", nil, parent, L.templates.dropdown)
    local font = rm.searchBar:GetFont()
    local frameLevel = parent:GetFrameLevel() + 1
    sortBar:SetScale(0.73)
    sortBar:SetFrameLevel(frameLevel)
    sortBar:SetPoint("RIGHT", parent, "RIGHT", L.offsets.sortBarX, L.offsets.sortBarY)
    sortBar.Text:SetFont(font, L.fontSizes.sortBar, "")
    sortBar.Text:SetPoint("CENTER", 0, 2.5)
    sortBar.values = {
        {text = NAME, value = "Name"},
        {text = QUALITY, value = "Quality"},
        {text = SKILL, value = "Skill"}
    }
    UIDropDownMenu_SetWidth(sortBar, L.sizes.sortBarWidth)
    rm.handleSortingOptions(sortBar)
    rm.setInitialDropdownValue(sortBar, "sortRecipesBy")
    return sortBar
end

function rm.createSortByText(parent)
    local text = parent:CreateFontString(nil, "OVERLAY", L.fonts.header)
    text:SetText(L.strings.sortBy)
    text:SetTextColor(unpack(L.colors.yellow))
    text:SetPoint("RIGHT", parent, "LEFT", L.offsets.sortTextX, L.offsets.sortTextY)
    return text
end

function rm.createSortOrderButton(parent)
    local button = CreateFrame("Button", nil, parent)
    local frameLevel = parent:GetFrameLevel() + 1
    button:SetFrameLevel(frameLevel)
    button:SetSize(L.sizes.sortOrderButton, L.sizes.sortOrderButton)
    button:SetPoint("CENTER", parent, "RIGHT", L.offsets.sortOrderX, L.offsets.sortOrderY)
    button:SetNormalTexture(L.textures.sortOrderButton)
    local texture = button:CreateTexture()
    texture:SetTexture(L.textures.sortOrderArrow)
    texture:SetDrawLayer("OVERLAY")
    rm.updateArrowOrientation(texture)
    rm.updateSortOrderOnClick(button, texture)
    return button
end

function rm.createProgressBar(parent)
    local progressBar = CreateFrame("StatusBar", nil, parent)
    local frameLevel = parent:GetFrameLevel() - 1
    progressBar:SetSize(parent:GetWidth(), L.sizes.progressHeight)
    progressBar:SetStatusBarTexture(rm.getPreference("progressTexture"))
    progressBar:SetMinMaxValues(0, 100)
    progressBar:SetFrameLevel(frameLevel)
    progressBar:SetPoint("CENTER", parent, "CENTER", 0, 0)
    progressBar:SetPoint("LEFT", parent)
    progressBar:SetPoint("RIGHT", parent)
    local background = progressBar:CreateTexture(nil, "BACKGROUND")
    background:SetTexture(L.textures.mainBackground)
    background:SetAllPoints(progressBar)
    return progressBar
end

function rm.createProgressBarText(parent)
    local text = parent:CreateFontString(nil, "OVERLAY", L.fonts.header)
    text:SetPoint("CENTER", 0, 0)
    text:SetTextColor(unpack(L.colors.progressText))
    return text
end

function rm.createBottomTab(label, anchor, xOffset, active)
    local tab = CreateFrame("Button", nil, rm.mainFrame)
    local frameLevel = rm.mainFrame:GetFrameLevel() - 1
    tab:SetSize(L.sizes.tabWidth, L.sizes.tabHeight)
    tab:SetFrameLevel(frameLevel)
    tab:SetPoint("TOP", rm.mainFrameBorder, anchor, xOffset, 0)
    tab.active = active
    local texture = tab:CreateTexture()
    texture:SetPoint("CENTER", tab, L.offsets.tabTextureX, L.offsets.tabTextureY)
    texture:SetSize(L.sizes.tabTextureWidth, L.sizes.tabTextureHeight)
    texture:SetTexture(L.textures.bottomTab)
    if not tab.active then
        texture:SetDesaturated(true)
    end
    tab.texture = texture
    local text = tab:CreateFontString(nil, "OVERLAY")
    text:SetFont(L.fonts.bottomTab, L.fontSizes.bottomTab, "OUTLINE")
    text:SetText(label)
    text:SetPoint("CENTER", texture, L.offsets.tabTextX, L.offsets.tabTextY)
    tab.label = text:GetText()
    table.insert(rm.bottomTabs, tab)
    rm.handleTabSwitching(tab)
    return tab
end

function rm.createRestoreButton()
    local button = CreateFrame("Button", nil)
    rm.setUpButtonWithTooltip(button, L.sizes.restoreButton, L.sizes.restoreButton, L.title, function(self, button, down)
        rm.autoOpenRecipesFrame = true
        self:Hide()
        rm.mainFrame:Show()
    end)
    button.texture = button:CreateTexture()
    button.texture:SetTexture(rm.getPreference("restoreButtonIconTexture"))
    button.texture:SetAllPoints(button)
    return button
end

local function createRowIcon(recipe, yOffset)
    local icon = rm.recipeContainer:CreateTexture(nil)
    icon:SetTexture(recipe.texture)
    icon:SetSize(L.sizes.recipeIcon, L.sizes.recipeIcon)
    icon:SetPoint("TOP", rm.recipeContainer, "BOTTOMLEFT", L.offsets.recipeIconX, yOffset)
    rm.displayTooltipOnMouseover(icon, recipe)
    rm.chatLinkOnShiftClick(icon, recipe)
    return icon
end

local function createRowText(recipe, rowIcon, red, green, blue)
    local text = rm.recipeContainer:CreateFontString(nil, "OVERLAY", L.fonts.recipeText)
    text:SetText(recipe.name)
    text:SetTextColor(red, green, blue)
    text:SetPoint("LEFT", rowIcon, "RIGHT", L.offsets.recipeTextX, 0)
    text.associatedIcon = rowIcon
    return text
end

local function storeWidestRecipeTextWidth(recipeTextWidth)
    if recipeTextWidth > rm.widestRecipeTextWidth then
        rm.widestRecipeTextWidth = recipeTextWidth
    end
end

function rm.createRecipeRow(recipe, red, green, blue, desaturateIcon)
    local yOffset = -(rm.displayedRecipesCount * (L.sizes.recipeIcon + rm.getPreference("rowSpacing")))
    local rowIcon = createRowIcon(recipe, yOffset)
    rowIcon:SetDesaturated(desaturateIcon)
    local rowText = createRowText(recipe, rowIcon, red, green, blue)
    local recipeTextWidth = rowText:GetWidth()
    storeWidestRecipeTextWidth(recipeTextWidth)
    table.insert(rm.recipeContainer.children, rowText)
    rm.displayedRecipesCount = rm.displayedRecipesCount + 1
end

function rm.createCenteredText(parent)
    local text = parent:CreateFontString(nil, "OVERLAY")
    text:SetFont(L.fonts.bottomTab, L.fontSizes.centeredText, "OUTLINE")
    text:SetPoint("CENTER", parent)
    text:Hide()
    return text
end
