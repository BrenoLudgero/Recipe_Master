local _, rm = ...
local L = rm.L
local F = rm.F

-- Called in EventHandler.handleAddonLoaded, after SavedVariables are created or loaded
function rm.createAllFrameElements()
    F.colors.mainBackground = {1, 1, 1, rm.getPreference("backgroundOpacity")}
    F.colors.sourcesBackground = {0.6, 0.6, 0.6, rm.getPreference("backgroundOpacity")}

    ------------------------- Main frame -------------------------
    rm.mainFrame = rm.createMainFrame()
    rm.mainFrameBorder = rm.createBorder(rm.mainFrame)
    rm.header = rm.createMainHeader(rm.mainFrameBorder)
    rm.createMainHeaderText(rm.header)
    rm.createInnerBorder(rm.mainFrame)
    rm.restoreButton = rm.createRestoreButton() -- Displayed after clicking the "X" button to restore the mainFrame
    rm.centeredText = rm.createCenteredText(rm.mainFrame)

    ------------------------- Bottom tabs -------------------------
    rm.bottomTabs = {}
    rm.recipesTab = rm.createBottomTab(L.recipes, "BOTTOMLEFT", F.offsets.recipesTabX, true)
    rm.recipeSourcesTab = rm.createBottomTab(L.sources, "BOTTOM", 0, false)
    rm.fishingTab = rm.createBottomTab(L.fishing, "BOTTOMRIGHT", F.offsets.fishingTabX, false)

    ------------------------- Recipes / Fishing frame -------------------------
    rm.progressContainer = rm.createProgressContainer(rm.mainFrame)
    rm.divider = rm.createDivider(rm.progressContainer) -- The background frame containing searchBar and sortBar
    rm.recipesScrollFrame = rm.createRecipesScrollFrame(rm.mainFrame)
    rm.recipesList = rm.createRecipesList(rm.recipesScrollFrame)
    rm.recipesScrollFrame:SetScrollChild(rm.recipesList)
    rm.searchBar = rm.createSearchBar(rm.divider)
    rm.sortBar = rm.createSortBar(rm.divider)
    rm.createSortByText(rm.sortBar)
    rm.createSortOrderButton(rm.sortBar)
    rm.progressBar = rm.createProgressBar(rm.progressContainer)
    rm.progressBarText = rm.createProgressBarText(rm.progressBar)

    ------------------------- Sources frame -------------------------
    rm.sourcesInstructions = rm.createSourcesInstructions(rm.mainFrame)
    rm.sourcesHeader = rm.createSourcesHeader(rm.mainFrame) -- Recipe icon and name
    rm.sourcesListTabs = {}
    rm.sourcesScrollFame = rm.createSourcesScrollFrame(rm.mainFrame)
    rm.sourcesList = rm.createSourcesList(rm.mainFrame)
    rm.sourcesScrollFame:SetScrollChild(rm.sourcesList)
    rm.sourcesColumnsContainer = rm.createColumnsContainer(rm.sourcesList)
    rm.sourcesListColumns = {}
    rm.uniqueSourceText = rm.createUniqueSourceText(rm.sourcesList)

    ------------------------- Options frame -------------------------
    rm.optionsFrame = rm.createOptionsFrame()
    ---------- Texts ----------
    rm.createOptionsText(F.fonts.title, L.title, F.offsets.titlesTextX, F.offsets.titleY)
    rm.createOptionsText(F.fonts.subtitle, L.subtitle, F.offsets.titlesTextX, F.offsets.subtitleY)
    rm.createOptionsText(F.fonts.optionSection, L.general, F.offsets.titlesTextX, F.offsets.generalTextY)
    rm.createOptionsText(F.fonts.optionSection, L.recipesWindow, F.offsets.titlesTextX, F.offsets.recipesWindowTextY)
    rm.createOptionsText(F.fonts.optionSection, L.progressBar, F.offsets.titlesTextX, F.offsets.progressBarTextY)
    rm.createOptionsText(F.fonts.optionSection, L.recipeTooltip, F.offsets.titlesTextX, F.offsets.recipeTooltipTextY)
    rm.optionsFrameElements = {
        ---------- Sliders ----------
        opacitySlider = rm.createOpacitySlider(),
        scaleSlider = rm.createScaleSlider(),
        spacingSlider = rm.createSpacingSlider(),
        ---------- Dropdowns ----------
        progressBrightness = rm.createProgressBrightnessDropdown(),
        progressColor = rm.createProgressColorDropdown(),
        restoreButton = rm.createRestoreIconDropdown(),
        ---------- Checkboxes ----------
        showRecipesInfo = rm.createShowRecipesInfoCheckButton(),
        showLearnedButton = rm.createShowLearnedCheckButton(),        
        showSourcesTooltipInfo = rm.createSourcesTooltipInfoCheckButton(),
        showAltsTooltipInfo = rm.createAltsTooltipInfoCheckButton()
    }
    rm.createResetDefaultsButton()
end
