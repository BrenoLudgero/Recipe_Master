local _, rm = ...
local L = rm.L

-- Some offsets and sizes change if Skillet is turned on (FrameHandler.updateSizesAndOffsetsBasedOnParent())
L.offsets.brightnessDropdownX = 15
L.offsets.brightnessDropdownY = -300
L.offsets.fishingTabX = -55.1
L.offsets.generalTextY = -85
L.offsets.headerX = -10
L.offsets.headerY = -1.5
L.offsets.headerTextY = -0.6
L.offsets.mainX = -34
L.offsets.mainY = -12
L.offsets.opacitySliderY = -128
L.offsets.optionsDropdownLabelY = 12
L.offsets.progressBarTextY = -255
L.offsets.recipeIconX = 20
L.offsets.recipesTabX = 55
L.offsets.recipeTextX = 6
L.offsets.recipesWindowTextY = -170
L.offsets.resetDefaultsX = 500
L.offsets.resetDefaultsY = -25
L.offsets.restoreButtonX = -22
L.offsets.restoreButtonY = -25
L.offsets.searchX = 80
L.offsets.searchY = -0.4
L.offsets.showLearnedButtonX = 267
L.offsets.showLearnedButtonY = -209
L.offsets.showLearnedTextX = 5
L.offsets.sliderX = 32
L.offsets.sliderDescriptionY = 12
L.offsets.sortTextX = 14
L.offsets.sortTextY = 2
L.offsets.sortBarX = -18
L.offsets.sortBarY = -3
L.offsets.sortOrderX = 2.2
L.offsets.sortOrderY = 2.5
L.offsets.spacingSliderY = -213
L.offsets.subtitleY = -35
L.offsets.tabTextX = 2
L.offsets.tabTextY = 6.8
L.offsets.tabTextureX = -2.5
L.offsets.tabTextureY = -6
L.offsets.titleY = -15
L.offsets.titlesTextX = 15
L.offsets.updateIconDropdownX = L.offsets.sliderX + 220
L.offsets.updateIconDropdownY = L.offsets.opacitySliderY

L.sizes.detailsBackgroundTile = 250
L.sizes.dividerHeight = 25
L.sizes.headerTextureHeight = 20
L.sizes.mainBackgroundTile = 300
L.sizes.mainWidth = 314 -- Minimum width!
L.sizes.optionsDropdownWidth = 132
L.sizes.progressContainerHeight = 22
L.sizes.progressHeight = 17
L.sizes.recipeIcon = 24.8 -- Width and height
L.sizes.restoreButton = 30 -- Width and height
L.sizes.searchWidth = 140
L.sizes.searchHeight = 18 -- The clickable height
L.sizes.sliderWidth = 150
L.sizes.sliderHeight = 18
L.sizes.sortBarWidth = 100
L.sizes.sortOrderButton = 32 -- Width and height
L.sizes.tabWidth = 90
L.sizes.tabHeight = 25
L.sizes.tabTextureWidth = 120
L.sizes.tabTextureHeight = 75

L.offsets.dividerY = L.sizes.progressContainerHeight + 1

L.colors.green = {0.1, 1, 0.1, 1} -- GameFontGreen color
L.colors.progressComplete = {1, 0.8431, 0, 1} -- Gold
L.colors.progressText = {1, 1, 1, 1} -- White
L.colors.yellow = {1, 0.81960791349411, 0, 1} -- GameFontNormal color

L.fonts.bottomTab = "Fonts\\FRIZQT__.TTF"
L.fonts.header = "SystemFont_Outline_Small"
L.fonts.optionDescription = "GameFontHighlight"
L.fonts.optionSection = "GameFontNormalMed1"
L.fonts.recipeText = "GameFontHighlightSmallOutline"
L.fonts.subtitle = "GameFontHighlight"
L.fonts.title = "GameFontNormalLarge"

L.fontSizes.centeredText = 13
L.fontSizes.search = 10
L.fontSizes.sortBar = 10
L.fontSizes.bottomTab = 9

L.strings.backgroundOpacity = "Background Opacity"
L.strings.blue = "Blue"
L.strings.bright = "Bright"
L.strings.brightness = OPTIONS_BRIGHTNESS
L.strings.color = COLOR
L.strings.comingSoon = SPLASH_OPENS_SOON
L.strings.common = ITEM_QUALITY1_DESC
L.strings.dark = "Dark"
L.strings.epic = ITEM_QUALITY4_DESC
L.strings.fishingNotLearned = SPELL_FAILED_NOT_KNOWN -- "Spell not learned"
L.strings.fishingTab = PROFESSIONS_FISHING
L.strings.general = GENERAL
L.strings.gray = "Gray"
L.strings.green = "Green"
L.strings.hideWindowTooltip = HIDE
L.strings.orange = "Orange"
L.strings.progressBar = "Progress Bar"
L.strings.purple = "Purple"
L.strings.rare = ITEM_QUALITY3_DESC
L.strings.recipeDetailsTab = LFG_LIST_DETAILS -- "Details"
L.strings.recipeIconSpacing = "Icon Spacing"
L.strings.recipesTab = TRADESKILL_SERVICE_LEARN -- "Recipes"
L.strings.recipesWindow = "Recipes Window"
L.strings.resetDefaults = RESET_TO_DEFAULT
L.strings.showLearned = "Show Learned Recipes"
L.strings.sortBy = select(1, strsplit(" ", RAID_FRAME_SORT_LABEL))..":" -- The first word of "Sort By" + ":"
L.strings.subtitle = string.format(PETITION_CREATOR, rm.author).."\n"..GAME_VERSION_LABEL.." "..rm.version -- "Created by Breno Ludgero \n Version x.x.x"
L.strings.uncommon = ITEM_QUALITY2_DESC
L.strings.updateIconDropdown = "Recipe Master's Button Icon"

L.templates.button = "UIPanelButtonTemplate"
L.templates.checkButton = "InterfaceOptionsCheckButtonTemplate"
L.templates.divider = "HorizontalBarTemplate"
L.templates.dropdown = "UIDropDownMenuTemplate"
L.templates.innerBorder = "InsetFrameTemplate4"
L.templates.mainFrame = "BackdropTemplate"
L.templates.mainFrameBorder = "BaseBasicFrameTemplate"
L.templates.search = "SearchBoxTemplate"
L.templates.scrollFrame = "UIPanelScrollFrameTemplate"
L.templates.slider = "OptionsSliderTemplate"

L.textures.bottomTab = "Interface/SPELLBOOK/UI-SpellBook-Tab1-Selected"
L.textures.header = "Interface/BankFrame/Bank-Background"
L.textures.mainBackground = "Interface/FrameGeneral/UI-Background-Marble"
L.textures.detailsBackground = "Interface/AdventureMap/AdventureMapParchmentTile"
L.textures.sortBar = "Interface/COMMON/Common-Input-Border"
L.textures.sortOrderArrow = "Interface/TradeSkillFrame/UI-TradeSkill-Multiskill"
L.textures.sortOrderButton = "Interface/Buttons/LockButton-Border"

L.backdrops.mainFrame = {
    bgFile = L.textures.mainBackground,
    tile = true,
    tileSize = L.sizes.mainBackgroundTile,
    insets = {left = 4, right = 3, top = 4, bottom = 4}
}
L.backdrops.details = {
    bgFile = L.textures.detailsBackground,
    tile = true,
    tileSize = L.sizes.detailsBackgroundTile,
    insets = {left = 4, right = 3, top = 4, bottom = 4}
}
