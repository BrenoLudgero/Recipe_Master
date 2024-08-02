local _, rm = ...
local L = rm.L
local F = rm.F

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
function rm.createAllFrameElements()
    F.colors.mainBackground = {1, 1, 1, rm.getPreference("backgroundOpacity")}
    F.colors.sourcesBackground = {0.55, 0.55, 0.55, rm.getPreference("backgroundOpacity")}

    ---------------------------- Main frame ------------------------------
    rm.mainFrame = rm.createFrame()
    rm.mainFrameBorder = rm.createBorder(rm.mainFrame)
    rm.header = rm.createHeader(rm.mainFrameBorder)
    rm.createHeaderText(rm.header)
    rm.createInnerBorder(rm.mainFrame)
    rm.restoreButton = rm.createRestoreButton() -- Displayed after clicking the "X" button to restore the mainFrame
    rm.centeredText = rm.createCenteredText(rm.mainFrame)
    rm.sourcesInstructions = rm.createSourcesInstructions(rm.mainFrame)

    ---------------------------- Bottom tabs -----------------------------
    rm.bottomTabs = {}
    rm.recipesTab = rm.createBottomTab(L.recipes, "BOTTOMLEFT", F.offsets.recipesTabX, true)
    rm.recipeSourcesTab = rm.createBottomTab(L.sources, "BOTTOM", 0, false)
    rm.fishingTab = rm.createBottomTab(L.fishing, "BOTTOMRIGHT", F.offsets.fishingTabX, false)

    ----------------------- Recipes / Fishing frame ----------------------
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

    --------------------------- Options frame ----------------------------
    rm.optionsFrame = rm.createOptionsFrame()
    -------------------- Texts ------------------
    rm.createOptionsText(F.fonts.title, L.title, F.offsets.titleTextX, F.offsets.titleY)
    rm.createOptionsText(F.fonts.subtitle, L.subtitle, F.offsets.titleTextX, F.offsets.subtitleY)
    rm.createOptionsText(F.fonts.optionSection, L.general, F.offsets.titleTextX, F.offsets.generalTextY)
    rm.createOptionsText(F.fonts.optionSection, L.recipesWindow, F.offsets.titleTextX, F.offsets.recipesWindowTextY)
    rm.createOptionsText(F.fonts.optionSection, L.progressBar, F.offsets.titleTextX, F.offsets.progressBarTextY)
    local options = {
        ---------------- Sliders ----------------
        opacitySlider = rm.createOpacitySlider(),
        spacingSlider = rm.createSpacingSlider(),
        --------------- Dropdowns ---------------
        progressBrightness = rm.createProgressBrightnessDropdown(),
        progressColor = rm.createProgressColorDropdown(),
        restoreButton = rm.createRestoreIconDropdown(),
        ---------------- Buttons ----------------
        showRecipesInfo = rm.createShowRecipesInfoCheckButton(),
        showLearnedButton = rm.createShowLearnedCheckButton()
    }
    rm.createResetDefaultsButton(options)
end
