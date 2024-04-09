local _, rm = ...
local L = rm.L
local F = rm.F

function rm.createFrame()
    local mainFrame = CreateFrame("Frame", nil, nil, F.templates.mainFrame)
    mainFrame:SetBackdrop(F.backdrops.mainFrame)
    mainFrame:SetBackdropColor(unpack(F.colors.mainBackground))
    mainFrame:SetFrameLevel(7)
    mainFrame:SetClampedToScreen(true)
    mainFrame:EnableMouse(true)
    mainFrame:SetWidth(F.sizes.mainWidth)
    mainFrame:Hide()
    return mainFrame
end

function rm.createBorder(parent)
    local border = CreateFrame("Frame", nil, parent, F.templates.mainFrameBorder)
    local button = border.CloseButton
    local buttonWidth = button:GetWidth()
    local buttonHeight = button:GetHeight()
    border:SetPoint("TOPLEFT", parent, 2.5, 0)
    border:SetPoint("BOTTOMRIGHT", parent, 0, 2)
    rm.setUpButtonWithTooltip(button, buttonWidth, buttonHeight, L.hideWindowTooltip, function(button, button, down)
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
    header:SetPoint("TOP", parent, "TOP", F.offsets.headerX, F.offsets.headerY)
    header:SetHeight(F.sizes.headerTextureHeight)
    header:SetFrameLevel(frameLevel)
    local texture = header:CreateTexture(nil)
    texture:SetTexture(F.textures.header, "REPEAT", "REPEAT")
    texture:SetHorizTile(true)
    texture:SetAllPoints(header)
    return header
end

function rm.createHeaderText(parent)
    local text = parent:CreateFontString(nil, "OVERLAY", F.fonts.header)
    text:SetText(L.title)
    text:SetTextColor(unpack(F.colors.yellow))
    text:SetPoint("CENTER", 0, F.offsets.headerTextY)
    return text
end

function rm.createInnerBorder(parent)
    local innerBorder = CreateFrame("Frame", nil, parent, F.templates.innerBorder)
    local frameLevel = parent:GetFrameLevel() + 2
    innerBorder:SetPoint("TOPLEFT", rm.header, "BOTTOMLEFT", 1, 0)
    innerBorder:SetPoint("BOTTOMRIGHT", rm.mainFrameBorder, "BOTTOMRIGHT", -3.2, 2)
    innerBorder:SetFrameLevel(frameLevel)
    rm.matchParentHeight(innerBorder)
    return innerBorder
end

function rm.createProgressContainer(parent)
    local progressContainer = CreateFrame("Frame", nil, parent, F.templates.innerBorder)
    local frameStrata = parent:GetFrameStrata()
    local frameLevel = parent:GetFrameLevel() + 1
    progressContainer:SetSize(parent:GetWidth(), F.sizes.progressContainerHeight)
    progressContainer:SetPoint("BOTTOM", parent, "BOTTOM", 0, 4)
    progressContainer:SetPoint("LEFT", rm.mainFrameBorder, 1.8, 0)
    progressContainer:SetPoint("RIGHT", rm.mainFrameBorder, -4.3, 0)
    progressContainer:SetFrameStrata(frameStrata)
    progressContainer:SetFrameLevel(frameLevel)
    return progressContainer
end

function rm.createDivider(parent)
    local divider = CreateFrame("Frame", nil, parent, F.templates.divider)
    local frameLevel = parent:GetFrameLevel() + 2
    divider:SetSize(parent:GetWidth(), F.sizes.dividerHeight)
    divider:SetFrameLevel(frameLevel)
    divider:SetPoint("BOTTOM", parent, "BOTTOM", 0, F.offsets.dividerY)
    divider:SetPoint("LEFT", parent, "LEFT", -0.1, 0)
    divider:SetPoint("RIGHT", parent, "RIGHT", 0.2, 0)
    return divider
end

function rm.createScrollFrame(parent)
    local scroll = CreateFrame("ScrollFrame", nil, parent, F.templates.scrollFrame)
    scroll:SetPoint("TOPLEFT", rm.header, "BOTTOMLEFT", -0.5, -5.7)
    scroll:SetPoint("BOTTOMRIGHT", rm.divider, "TOPRIGHT", 0, 4.5)
    scroll:SetPoint("RIGHT", rm.mainFrameBorder, "RIGHT", -31.5, 0)
    return scroll
end

function rm.createRecipeContainerFrame(parent)
    local recipeContainer = CreateFrame("Frame", nil, parent)
    recipeContainer:SetSize(1, 1) -- Sizes are adjusted dynamically
    recipeContainer.children = {}
    return recipeContainer
end

function rm.createSearchBar(parent)
    local searchBar = CreateFrame("EditBox", nil, parent, F.templates.search)
    local font = searchBar:GetFont()
    local frameLevel = parent:GetFrameLevel() + 1
    searchBar:SetSize(F.sizes.searchWidth, F.sizes.searchHeight)
    searchBar:SetFrameLevel(frameLevel)
    searchBar:SetPoint("CENTER", parent, "LEFT", F.offsets.searchX, F.offsets.searchY)
    searchBar:SetFont(font, F.fontSizes.search, "")
    rm.displayPlaceholderTextBasedOnFocus(searchBar)
    rm.showMatchingRecipesOnTop(searchBar)
    return searchBar
end

function rm.createSortBar(parent)
    local sortBar = CreateFrame("Button", nil, parent, F.templates.dropdown)
    local font = rm.searchBar:GetFont()
    local frameLevel = parent:GetFrameLevel() + 1
    sortBar:SetScale(0.73)
    sortBar:SetFrameLevel(frameLevel)
    sortBar:SetPoint("RIGHT", parent, "RIGHT", F.offsets.sortBarX, F.offsets.sortBarY)
    sortBar.Text:SetFont(font, F.fontSizes.sortBar, "")
    sortBar.Text:SetPoint("CENTER", 0, 2.5)
    sortBar.values = {
        {text = NAME, value = "Name"},
        {text = QUALITY, value = "Quality"},
        {text = SKILL, value = "Skill"}
    }
    UIDropDownMenu_SetWidth(sortBar, F.sizes.sortBarWidth)
    rm.handleSortingOptions(sortBar)
    rm.setInitialDropdownValue(sortBar, "sortRecipesBy")
    return sortBar
end

function rm.createSortByText(parent)
    local text = parent:CreateFontString(nil, "OVERLAY", F.fonts.header)
    text:SetText(L.sortBy)
    text:SetTextColor(unpack(F.colors.yellow))
    text:SetPoint("RIGHT", parent, "LEFT", F.offsets.sortTextX, F.offsets.sortTextY)
    return text
end

function rm.createSortOrderButton(parent)
    local button = CreateFrame("Button", nil, parent)
    local frameLevel = parent:GetFrameLevel() + 1
    button:SetFrameLevel(frameLevel)
    button:SetSize(F.sizes.sortOrderButton, F.sizes.sortOrderButton)
    button:SetPoint("CENTER", parent, "RIGHT", F.offsets.sortOrderX, F.offsets.sortOrderY)
    button:SetNormalTexture(F.textures.sortOrderButton)
    local texture = button:CreateTexture()
    texture:SetTexture(F.textures.sortOrderArrow)
    texture:SetDrawLayer("OVERLAY")
    rm.updateArrowOrientation(texture)
    rm.updateSortOrderOnClick(button, texture)
    return button
end

function rm.createProgressBar(parent)
    local progressBar = CreateFrame("StatusBar", nil, parent)
    local frameLevel = parent:GetFrameLevel() - 1
    progressBar:SetSize(parent:GetWidth(), F.sizes.progressHeight)
    progressBar:SetStatusBarTexture(rm.getPreference("progressTexture"))
    progressBar:SetMinMaxValues(0, 100)
    progressBar:SetFrameLevel(frameLevel)
    progressBar:SetPoint("CENTER", parent, "CENTER", 0, 0)
    progressBar:SetPoint("LEFT", parent)
    progressBar:SetPoint("RIGHT", parent)
    local background = progressBar:CreateTexture(nil, "BACKGROUND")
    background:SetTexture(F.textures.mainBackground)
    background:SetAllPoints(progressBar)
    return progressBar
end

function rm.createProgressBarText(parent)
    local text = parent:CreateFontString(nil, "OVERLAY", F.fonts.header)
    text:SetPoint("CENTER", 0, 0)
    text:SetTextColor(unpack(F.colors.white))
    return text
end

function rm.createBottomTab(label, anchor, xOffset, active)
    local tab = CreateFrame("Button", nil, rm.mainFrame)
    local frameLevel = rm.mainFrame:GetFrameLevel() - 1
    tab:SetSize(F.sizes.tabWidth, F.sizes.tabHeight)
    tab:SetFrameLevel(frameLevel)
    tab:SetPoint("TOP", rm.mainFrameBorder, anchor, xOffset, 0)
    tab.active = active
    local texture = tab:CreateTexture()
    texture:SetPoint("CENTER", tab, F.offsets.tabTextureX, F.offsets.tabTextureY)
    texture:SetSize(F.sizes.tabTextureWidth, F.sizes.tabTextureHeight)
    texture:SetTexture(F.textures.bottomTab)
    if not tab.active then
        texture:SetDesaturated(true)
    end
    tab.texture = texture
    local text = tab:CreateFontString(nil, "OVERLAY")
    text:SetFont(F.fonts.bottomTab, F.fontSizes.bottomTab, "OUTLINE")
    text:SetText(label)
    text:SetPoint("CENTER", texture, F.offsets.tabTextX, F.offsets.tabTextY)
    tab.label = text:GetText()
    table.insert(rm.bottomTabs, tab)
    rm.handleTabSwitching(tab)
    return tab
end

function rm.createRestoreButton()
    local button = CreateFrame("Button", nil)
    rm.setUpButtonWithTooltip(button, F.sizes.restoreButton, F.sizes.restoreButton, L.title, function(self, button, down)
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
    icon:SetSize(F.sizes.recipeIcon, F.sizes.recipeIcon)
    icon:SetPoint("TOP", rm.recipeContainer, "BOTTOMLEFT", F.offsets.recipeIconX, yOffset)
    rm.displayTooltipOnMouseover(icon, recipe)
    rm.chatLinkOnShiftClick(icon, recipe)
    return icon
end

local function createAditionalInfoText(recipe, recipeName, recipeInfo, color)
    if rm.isLearnedRecipe(recipe) then
        recipeInfo:SetText(L.learned)
        recipeInfo:SetTextColor(unpack(color)) -- Gray
    else
        rm.getRequirementsText(recipe, recipeInfo)
    end
    recipeName.aditionalInfo = recipeInfo
end

local function createRowText(recipe, rowIcon, color)
    local recipeName = rm.recipeContainer:CreateFontString(nil, "OVERLAY", F.fonts.recipeText)
    recipeName:SetText(recipe.name)
    recipeName:SetTextColor(unpack(color))
    local showRecipesInfo = rm.getPreference("showRecipesInfo")
    if showRecipesInfo then
        local recipeInfo = rm.recipeContainer:CreateFontString(nil, "OVERLAY", F.fonts.recipeText)
        recipeName:SetPoint("LEFT", rowIcon, "TOPRIGHT", F.offsets.recipeTextX, -6)
        recipeInfo:SetPoint("TOPLEFT", recipeName, "BOTTOMLEFT", 0, F.offsets.recipeInfoY)
        createAditionalInfoText(recipe, recipeName, recipeInfo, color)
    else
        recipeName:SetPoint("LEFT", rowIcon, "RIGHT", F.offsets.recipeTextX, 0)
    end
    return recipeName
end

function rm.createRecipeRow(recipe, color, desaturateIcon)
    local yOffset = -(rm.displayedRecipesCount * (F.sizes.recipeIcon + rm.getPreference("iconSpacing")))
    local rowIcon = createRowIcon(recipe, yOffset)
    rowIcon:SetDesaturated(desaturateIcon)
    local recipeNameText = createRowText(recipe, rowIcon, color)
    local recipeTextWidth = recipeNameText:GetWidth()
    local recipeInfoWidth
    if recipeNameText.aditionalInfo then
        recipeInfoText = recipeNameText.aditionalInfo
        recipeInfoWidth = recipeInfoText:GetWidth()
    end
    rm.storeWidestRecipeTextWidth(recipeTextWidth, recipeInfoWidth)
    rowIcon.associatedText = recipeNameText
    table.insert(rm.recipeContainer.children, rowIcon)
    rm.displayedRecipesCount = rm.displayedRecipesCount + 1
end

function rm.createCenteredText(parent)
    local text = parent:CreateFontString(nil, "OVERLAY")
    text:SetFont(F.fonts.bottomTab, F.fontSizes.centeredText, "OUTLINE")
    text:SetPoint("CENTER", parent)
    text:Hide()
    return text
end
