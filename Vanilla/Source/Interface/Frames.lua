local _, rm = ...
local L = rm.L

local function deleteFrameCreationFunctions()
    rm.createFrame = nil
    rm.createHeader = nil
    rm.createBorder = nil
    rm.createSortBar = nil
    rm.createDivider = nil
    rm.createSearchBar = nil
    rm.createBottomTab = nil
    rm.createHeaderText = nil
    rm.createSortByText = nil
    rm.createOptionsText = nil
    rm.createProgressBar = nil
    rm.createScrollFrame = nil
    rm.createInnerBorder = nil
    rm.createIconDropdown = nil
    rm.createCenteredText = nil
    rm.createOptionsFrame = nil
    rm.createSpacingSlider = nil
    rm.createOpacitySlider = nil
    rm.createRestoreButton = nil
    rm.createSortOrderButton = nil
    rm.createProgressBarText = nil
    rm.setUpButtonWithTooltip = nil
    rm.createProgressContainer = nil
    rm.createResetDefaultsButton = nil
    rm.createRecipeContainerFrame = nil
    rm.createProgressColorDropdown = nil
    rm.createShowLearnedCheckButton = nil
    rm.createProgressBrightnessDropdown = nil
end

-- Called in EventHandler.handleAddonLoaded, after SavedVariables are created or loaded
function rm.createAllFrames()
    L.colors.mainBackground = {1, 1, 1, rm.getPreference("backgroundOpacity")}
    L.colors.detailsBackground = {0.7, 0.7, 0.7, rm.getPreference("backgroundOpacity")}
    ---------- Main window ----------
    rm.mainFrame = rm.createFrame()
    rm.mainFrameBorder = rm.createBorder(rm.mainFrame)
    rm.header = rm.createHeader(rm.mainFrameBorder)
    local headerTitle = rm.createHeaderText(rm.header)
    local mainFrameInnerBorder = rm.createInnerBorder(rm.mainFrame)
    rm.progressContainer = rm.createProgressContainer(rm.mainFrame)
    rm.divider = rm.createDivider(rm.progressContainer) -- The frame containing searchBar and sortBar
    rm.scrollFrame = rm.createScrollFrame(rm.mainFrame)
    rm.recipeContainer = rm.createRecipeContainerFrame(rm.scrollFrame)
    rm.scrollFrame:SetScrollChild(rm.recipeContainer)
    rm.searchBar = rm.createSearchBar(rm.divider)
    rm.sortBar = rm.createSortBar(rm.divider)
    local sortByText = rm.createSortByText(rm.sortBar)
    local sortOrderButton = rm.createSortOrderButton(rm.sortBar)
    rm.progressBar = rm.createProgressBar(rm.progressContainer)
    rm.progressBarText = rm.createProgressBarText(rm.progressBar)
    rm.restoreButton = rm.createRestoreButton()
    rm.centeredText = rm.createCenteredText(mainFrameInnerBorder)
    ---------- Bottom tabs ----------
    rm.bottomTabs = {}
    rm.recipesTab = rm.createBottomTab(L.strings.recipesTab, "BOTTOMLEFT", L.offsets.recipesTabX, true)
    rm.recipeDetailsTab = rm.createBottomTab(L.strings.recipeDetailsTab, "BOTTOM", 0, false)
    rm.fishingTab = rm.createBottomTab(L.strings.fishingTab, "BOTTOMRIGHT", L.offsets.fishingTabX, false)
    ---------- Options window ----------
    rm.optionsFrame = rm.createOptionsFrame()
    ----- Texts -----
    rm.createOptionsText(L.fonts.title, L.title, L.offsets.titlesTextX, L.offsets.titleY)
    rm.createOptionsText(L.fonts.subtitle, L.strings.subtitle, L.offsets.titlesTextX, L.offsets.subtitleY)
    rm.createOptionsText(L.fonts.optionSection, L.strings.general, L.offsets.titlesTextX, L.offsets.generalTextY)
    rm.createOptionsText(L.fonts.optionSection, L.strings.recipesWindow, L.offsets.titlesTextX, L.offsets.recipesWindowTextY)
    rm.createOptionsText(L.fonts.optionSection, L.strings.progressBar, L.offsets.titlesTextX, L.offsets.progressBarTextY)
    ----- Sliders -----
    local opacitySlider = rm.createOpacitySlider()
    local spacingSlider = rm.createSpacingSlider()
    ----- Dropdowns -----
    local updateRMIcon = rm.createIconDropdown()
    local updateBarBrightness = rm.createProgressBrightnessDropdown()
    local updateBarColor = rm.createProgressColorDropdown()
    ----- Buttons -----
    local showLearned = rm.createShowLearnedCheckButton()
    local resetDefaults = rm.createResetDefaultsButton(opacitySlider, spacingSlider, updateRMIcon, updateBarBrightness, updateBarColor, showLearned)
    ----------------------------------------
    deleteFrameCreationFunctions()
    deleteFrameCreationFunctions = nil
end
