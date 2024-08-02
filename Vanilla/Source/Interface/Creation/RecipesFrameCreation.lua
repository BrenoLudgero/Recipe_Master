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
    local frameLevel = parent:GetFrameLevel() + 2
    divider:SetSize(parent:GetWidth(), F.sizes.dividerHeight)
    divider:SetFrameLevel(frameLevel)
    divider:SetPoint("BOTTOM", parent, "TOP")
    divider:SetPoint("LEFT")
    divider:SetPoint("RIGHT")
    return divider
end

function rm.createRecipesScrollFrame(parent)
    local scroll = CreateFrame("ScrollFrame", nil, parent, F.templates.scrollFrame)
    scroll:SetPoint("TOPLEFT", rm.header, "BOTTOMLEFT", 0, F.offsets.recipesScrollTopY)
    scroll:SetPoint("BOTTOMRIGHT", rm.divider, "TOPRIGHT", 0, F.offsets.recipesScrollBottomY)
    scroll:SetPoint("RIGHT", rm.mainFrameBorder, F.offsets.recipesScrollX, 0)
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
    searchBar:SetSize(F.sizes.searchBarWidth, F.sizes.searchBarHeight)
    searchBar:SetFrameLevel(frameLevel)
    searchBar:SetPoint("TOPLEFT", F.offsets.searchBarX, 0)
    searchBar:SetPoint("BOTTOMLEFT")
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
    sortBar:SetPoint("RIGHT", F.offsets.sortBarX, F.offsets.sortBarY)
    sortBar.Text:SetFont(font, F.fontSizes.sortBar, "")
    sortBar.Text:SetPoint("CENTER", 0, 2.5)
    sortBar.values = {
        {text = L.name, value = "Name"},
        {text = L.quality, value = "Quality"},
        {text = L.skill, value = "Skill"}
    }
    UIDropDownMenu_SetWidth(sortBar, F.sizes.sortBarWidth)
    rm.handleSortingOptions(sortBar)
    rm.setInitialDropdownValue(sortBar, "sortRecipesBy")
    return sortBar
end

function rm.createSortByText(parent)
    local text = parent:CreateFontString(nil, "OVERLAY", F.fonts.sortByText)
    text:SetText(L.sortBy)
    text:SetTextColor(unpack(F.colors.yellow))
    text:SetPoint("RIGHT", parent, "LEFT", F.offsets.sortByTextX, F.offsets.sortByTextY)
    return text
end

function rm.createSortOrderButton(parent)
    local button = CreateFrame("Button", nil, parent)
    local frameLevel = parent:GetFrameLevel() + 1
    button:SetFrameLevel(frameLevel)
    button:SetSize(F.sizes.sortOrderButton, F.sizes.sortOrderButton)
    button:SetPoint("TOPRIGHT", rm.divider, 0, 0)
    button:SetPoint("BOTTOMRIGHT", rm.divider, 0, 0)
    button:SetNormalTexture(F.textures.sortOrderButton)
    button:SetHighlightTexture(F.textures.sortOrderButtonHighlight)
    local texture = button:CreateTexture()
    texture:SetTexture(F.textures.sortOrderArrow)
    texture:SetDrawLayer("OVERLAY")
    rm.updateArrowOrientation(texture)
    rm.updateSortOrderOnClick(button, texture)
    return button
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
    recipeName:SetText(recipe.name)
    recipeName:SetTextColor(unpack(color))
    if rm.getPreference("showRecipesInfo") then
        local recipeInfo = rm.recipesList:CreateFontString(nil, "OVERLAY", F.fonts.recipeText)
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
    rowIcon.associatedText = recipeNameText
    table.insert(rm.recipesList.children, rowIcon)
end
