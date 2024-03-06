-- Some offsets and sizes change if Skillet is turned on (FrameHandler.updateSizesAndOffsetsBasedOnParent())
offsets = {
    brightnessDropdownX = 15,
    brightnessDropdownY = -300,
    fishingTabX = -55.1,
    generalTextY = -85,
    headerX = -10,
    headerY = -1.5,
    headerTextY = -0.6,
    mainX = -34,
    mainY = -12,
    opacitySliderY = -128,
    optionsDropdownLabelY = 12,
    progressBarTextY = -255,
    recipeIconX = 20,
    recipesTabX = 55,
    recipeTextX = 6,
    recipesWindowTextY = -170,
    resetDefaultsX = 500,
    resetDefaultsY = -25,
    restoreButtonX = -22,
    restoreButtonY = -25,
    searchX = 80,
    searchY = -0.4,
    showLearnedButtonX = 267,
    showLearnedButtonY = -209,
    showLearnedTextX = 5,
    sliderX = 32,
    sliderDescriptionY = 12,
    sortTextX = 14,
    sortTextY = 2,
    sortBarX = -18,
    sortBarY = -3,
    sortOrderX = 2.2,
    sortOrderY = 2.5,
    spacingSliderY = -213,
    subtitleY = -35,
    tabTextX = 2,
    tabTextY = 6.8,
    tabTextureX = -2.5,
    tabTextureY = -6,
    titleY = -15,
    titlesTextX = 15
}

offsets.updateIconDropdownX = offsets.sliderX + 220
offsets.updateIconDropdownY = offsets.opacitySliderY

sizes = {
    detailsBackgroundTile = 250,
    dividerHeight = 25,
    headerTextureHeight = 20,
    mainBackgroundTile = 300,
    mainWidth = 314, -- Minimum width!
    optionsDropdownWidth = 132,
    progressContainerHeight = 22,
    progressHeight = 17,
    recipeIcon = 24.8, -- Width and height
    restoreButton = 30, -- Width and height
    searchWidth = 140,
    searchHeight = 18, -- The clickable height
    sliderWidth = 150,
    sliderHeight = 18,
    sortBarWidth = 100,
    sortOrderButton = 32, -- Width and height
    tabWidth = 90,
    tabHeight = 25,
    tabTextureWidth = 120,
    tabTextureHeight = 75,
}

offsets.dividerY = sizes.progressContainerHeight + 1

colors = {
    -- detailsBackground and mainBackground in Frames.CreateAllFrames()
    green = {0.1, 1, 0.1, 1}, -- GameFontGreen color
    progressComplete = {1, 0.8431, 0, 1}, -- Gold
    progressText = {1, 1, 1, 1}, -- White
    yellow = {1, 0.81960791349411, 0, 1} -- GameFontNormal color
}

fonts = {
    bottomTab = "Fonts\\FRIZQT__.TTF",
    header = "SystemFont_Outline_Small",
    optionDescription = "GameFontHighlight",
    optionSection = "GameFontNormalMed1",
    recipeText = "GameFontHighlightSmallOutline",
    subtitle = "GameFontHighlight",
    title = "GameFontNormalLarge"
}

fontSizes = {
    centeredText = 13,
    search = 10,
    sortBar = 10,
    bottomTab = 9
}

strings = {
    backgroundOpacity = "Background Opacity",
    blue = "Blue",
    bright = "Bright",
    brightness = OPTIONS_BRIGHTNESS,
    color = COLOR,
    comingSoon = SPLASH_OPENS_SOON,
    common = ITEM_QUALITY1_DESC,
    dark = "Dark",
    epic = ITEM_QUALITY4_DESC,
    fishingNotLearned = SPELL_FAILED_NOT_KNOWN, -- "Spell not learned"
    fishingTab = PROFESSIONS_FISHING,
    general = GENERAL,
    gray = "Gray",
    green = "Green",
    hideWindowTooltip = HIDE,
    orange = "Orange",
    progressBar = "Progress Bar",
    purple = "Purple",
    rare = ITEM_QUALITY3_DESC,
    recipeDetailsTab = LFG_LIST_DETAILS, -- "Details"
    recipeIconSpacing = "Icon Spacing",
    recipesTab = TRADESKILL_SERVICE_LEARN, -- "Recipes"
    recipesWindow = "Recipes Window",
    resetDefaults = RESET_TO_DEFAULT,
    showLearned = "Show Learned Recipes",
    sortBy = select(1, strsplit(" ", RAID_FRAME_SORT_LABEL))..":", -- The first word of "Sort By" + ":"
    subtitle = string.format(PETITION_CREATOR, RecipeMasterAuthor).."\n"..GAME_VERSION_LABEL.." "..RecipeMasterVersion, -- "Created by Breno Ludgero \n Version x.x.x"
    uncommon = ITEM_QUALITY2_DESC,
    updateIconDropdown = "Recipe Master's Button Icon",
}

templates = {
    button = "UIPanelButtonTemplate",
    checkButton = "InterfaceOptionsCheckButtonTemplate",
    divider = "HorizontalBarTemplate",
    dropdown = "UIDropDownMenuTemplate",
    innerBorder = "InsetFrameTemplate4",
    mainFrame = "BackdropTemplate",
    mainFrameBorder = "BaseBasicFrameTemplate",
    search = "SearchBoxTemplate",
    scrollFrame = "UIPanelScrollFrameTemplate",
    slider = "OptionsSliderTemplate"
}

textures = {
    bottomTab = "Interface/SPELLBOOK/UI-SpellBook-Tab1-Selected",
    header = "Interface/BankFrame/Bank-Background",
    mainBackground = "Interface/FrameGeneral/UI-Background-Marble",
    detailsBackground = "Interface/AdventureMap/AdventureMapParchmentTile",
    sortBar = "Interface/COMMON/Common-Input-Border",
    sortOrderArrow = "Interface/TradeSkillFrame/UI-TradeSkill-Multiskill",
    sortOrderButton = "Interface/Buttons/LockButton-Border"
}

backdrops = {
    mainFrame = {
        bgFile = textures.mainBackground,
        tile = true,
        tileSize = sizes.mainBackgroundTile,
        insets = {left = 4, right = 3, top = 4, bottom = 4}
    },
    details = {
        bgFile = textures.detailsBackground,
        tile = true,
        tileSize = sizes.detailsBackgroundTile,
        insets = {left = 4, right = 3, top = 4, bottom = 4}
    }
}
