local function deleteFrameCreationFunctions()
    createRMFrame = nil
    createRMHeader = nil
    createRMBorder = nil
    createRMSortBar = nil
    createRMDivider = nil
    createRMSearchBar = nil
    createRMBottomTab = nil
    createRMHeaderText = nil
    createRMSortByText = nil
    createRMOptionsText = nil
    createRMProgressBar = nil
    createRMScrollFrame = nil
    createRMInnerBorder = nil
    createRMCenteredText = nil
    createRMOptionsFrame = nil
    createRMSpacingSlider = nil
    createRMOpacitySlider = nil
    createRMProgressBarText = nil
    createRMIconDropdown = nil
    setUpRMButtonWithTooltip = nil
    createRMProgressContainer = nil
    createRMResetDefaultsButton = nil
    createRMRecipeContainerFrame = nil
    createRMProgressColorDropdown = nil
    createRMShowLearnedCheckButton = nil
    createRMProgressBrightnessDropdown = nil
end

-- Called in EventHandler.handleRecipeMasterLoaded, after SavedVariables are created or loaded
function createAllFrames()
    colors.mainBackground = {1, 1, 1, RecipeMasterPreferences["backgroundOpacity"]}
    colors.detailsBackground = {0.7, 0.7, 0.7, RecipeMasterPreferences["backgroundOpacity"]}
    ---------- Main window ----------
    mainFrame = createRMFrame()
    mainFrameBorder = createRMBorder(mainFrame)
    header = createRMHeader(mainFrameBorder)
    local headerTitle = createRMHeaderText(header)
    local mainFrameInnerBorder = createRMInnerBorder(mainFrame)
    progressContainer = createRMProgressContainer(mainFrame)
    divider = createRMDivider(progressContainer) -- The frame containing searchBar and sortBar
    scrollFrame = createRMScrollFrame(mainFrame)
    recipeContainer = createRMRecipeContainerFrame(scrollFrame)
    scrollFrame:SetScrollChild(recipeContainer)
    searchBar = createRMSearchBar(divider)
    sortBar = createRMSortBar(divider)
    local sortByText = createRMSortByText(sortBar)
    local sortOrderButton = createRMSortOrderButton(sortBar)
    progressBar = createRMProgressBar(progressContainer)
    progressBarText = createRMProgressBarText(progressBar)
    restoreButton = createRMRestoreButton()
    centeredText = createRMCenteredText(mainFrameInnerBorder)
    ---------- Bottom tabs ----------
    bottomTabs = {}
    recipesTab = createRMBottomTab(strings.recipesTab, "BOTTOMLEFT", offsets.recipesTabX, true)
    recipeDetailsTab = createRMBottomTab(strings.recipeDetailsTab, "BOTTOM", 0, false)
    fishingTab = createRMBottomTab(strings.fishingTab, "BOTTOMRIGHT", offsets.fishingTabX, false)
    ---------- Options window ----------
    optionsFrame = createRMOptionsFrame()
    ----- Texts -----
    createRMOptionsText(fonts.title, RecipeMasterName, offsets.titlesTextX, offsets.titleY)
    createRMOptionsText(fonts.subtitle, strings.subtitle, offsets.titlesTextX, offsets.subtitleY)
    createRMOptionsText(fonts.optionSection, strings.general, offsets.titlesTextX, offsets.generalTextY)
    createRMOptionsText(fonts.optionSection, strings.recipesWindow, offsets.titlesTextX, offsets.recipesWindowTextY)
    createRMOptionsText(fonts.optionSection, strings.progressBar, offsets.titlesTextX, offsets.progressBarTextY)
    ----- Sliders -----
    local opacitySlider = createRMOpacitySlider()
    local spacingSlider = createRMSpacingSlider()
    ----- Dropdowns -----
    local updateRMIcon = createRMIconDropdown()
    local updateBarBrightness = createRMProgressBrightnessDropdown()
    local updateBarColor = createRMProgressColorDropdown()
    ----- Other -----
    local showLearned = createRMShowLearnedCheckButton()
    local resetDefaults = createRMResetDefaultsButton(opacitySlider, spacingSlider, updateRMIcon, updateBarBrightness, updateBarColor, showLearned)
    ----------------------------------------
    deleteFrameCreationFunctions()
end
