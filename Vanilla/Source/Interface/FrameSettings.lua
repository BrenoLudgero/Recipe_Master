local _, rm = ...
local L = rm.L
local F = rm.F

L.brightness = OPTIONS_BRIGHTNESS
L.color = COLOR
L.comingSoon = SPLASH_OPENS_SOON
L.common = ITEM_QUALITY1_DESC
L.epic = ITEM_QUALITY4_DESC
L.fishingNotLearned = SPELL_FAILED_NOT_KNOWN -- "Spell not learned"
L.fishingTab = PROFESSIONS_FISHING
L.general = GENERAL
L.hideWindowTooltip = HIDE
L.rare = ITEM_QUALITY3_DESC
L.recipeDetailsTab = LFG_LIST_DETAILS -- "Details"
L.recipesTab = TRADESKILL_SERVICE_LEARN -- "Recipes"
L.resetDefaults = RESET_TO_DEFAULT
L.sortBy = select(1, strsplit(" ", RAID_FRAME_SORT_LABEL))..":" -- The first word of "Sort By" + ":"
L.subtitle = string.format(PETITION_CREATOR, rm.author).."\n"..GAME_VERSION_LABEL.." "..rm.version -- "Created by Breno Ludgero \n Version x.x.x"
L.uncommon = ITEM_QUALITY2_DESC

-- Some offsets and sizes change if Skillet is turned on (FrameHandler.updateSizesAndOffsetsBasedOnParent())
F.offsets.brightnessDropdownX = 15
F.offsets.brightnessDropdownY = -300
F.offsets.fishingTabX = -55.1
F.offsets.generalTextY = -85
F.offsets.headerX = -10
F.offsets.headerY = -1.5
F.offsets.headerTextY = -0.6
F.offsets.mainX = -34
F.offsets.mainY = -12
F.offsets.opacitySliderY = -128
F.offsets.optionsDropdownLabelY = 12
F.offsets.progressBarTextY = -255
F.offsets.recipeIconX = 20
F.offsets.recipesTabX = 55
F.offsets.recipeTextX = 6
F.offsets.recipesWindowTextY = -170
F.offsets.resetDefaultsX = 500
F.offsets.resetDefaultsY = -25
F.offsets.restoreButtonX = -22
F.offsets.restoreButtonY = -25
F.offsets.searchX = 80
F.offsets.searchY = -0.4
F.offsets.showLearnedButtonX = 267
F.offsets.showLearnedButtonY = -209
F.offsets.showLearnedTextX = 5
F.offsets.sliderX = 32
F.offsets.sliderDescriptionY = 12
F.offsets.sortTextX = 14
F.offsets.sortTextY = 2
F.offsets.sortBarX = -18
F.offsets.sortBarY = -3
F.offsets.sortOrderX = 2.2
F.offsets.sortOrderY = 2.5
F.offsets.spacingSliderY = -213
F.offsets.subtitleY = -35
F.offsets.tabTextX = 2
F.offsets.tabTextY = 6.8
F.offsets.tabTextureX = -2.5
F.offsets.tabTextureY = -6
F.offsets.titleY = -15
F.offsets.titlesTextX = 15
F.offsets.updateIconDropdownX = F.offsets.sliderX + 220
F.offsets.updateIconDropdownY = F.offsets.opacitySliderY

F.sizes.detailsBackgroundTile = 250
F.sizes.dividerHeight = 25
F.sizes.headerTextureHeight = 20
F.sizes.mainBackgroundTile = 300
F.sizes.mainWidth = 314 -- Minimum width!
F.sizes.optionsDropdownWidth = 132
F.sizes.progressContainerHeight = 22
F.sizes.progressHeight = 17
F.sizes.recipeIcon = 24.8 -- Width and height
F.sizes.restoreButton = 30 -- Width and height
F.sizes.searchWidth = 140
F.sizes.searchHeight = 18 -- The clickable height
F.sizes.sliderWidth = 150
F.sizes.sliderHeight = 18
F.sizes.sortBarWidth = 100
F.sizes.sortOrderButton = 32 -- Width and height
F.sizes.tabWidth = 90
F.sizes.tabHeight = 25
F.sizes.tabTextureWidth = 120
F.sizes.tabTextureHeight = 75

F.offsets.dividerY = F.sizes.progressContainerHeight + 1

F.colors.green = {0.1, 1, 0.1, 1} -- GameFontGreen color
F.colors.progressComplete = {1, 0.8431, 0, 1} -- Gold
F.colors.progressText = {1, 1, 1, 1} -- White
F.colors.yellow = {1, 0.81960791349411, 0, 1} -- GameFontNormal color

F.fonts.bottomTab = "Fonts\\FRIZQT__.TTF"
F.fonts.header = "SystemFont_Outline_Small"
F.fonts.optionDescription = "GameFontHighlight"
F.fonts.optionSection = "GameFontNormalMed1"
F.fonts.recipeText = "GameFontHighlightSmallOutline"
F.fonts.subtitle = "GameFontHighlight"
F.fonts.title = "GameFontNormalLarge"

F.fontSizes.centeredText = 13
F.fontSizes.search = 10
F.fontSizes.sortBar = 10
F.fontSizes.bottomTab = 9

F.templates.button = "UIPanelButtonTemplate"
F.templates.checkButton = "InterfaceOptionsCheckButtonTemplate"
F.templates.divider = "HorizontalBarTemplate"
F.templates.dropdown = "UIDropDownMenuTemplate"
F.templates.innerBorder = "InsetFrameTemplate4"
F.templates.mainFrame = "BackdropTemplate"
F.templates.mainFrameBorder = "BaseBasicFrameTemplate"
F.templates.search = "SearchBoxTemplate"
F.templates.scrollFrame = "UIPanelScrollFrameTemplate"
F.templates.slider = "OptionsSliderTemplate"

F.textures.bottomTab = "Interface/SPELLBOOK/UI-SpellBook-Tab1-Selected"
F.textures.header = "Interface/BankFrame/Bank-Background"
F.textures.mainBackground = "Interface/FrameGeneral/UI-Background-Marble"
F.textures.detailsBackground = "Interface/AdventureMap/AdventureMapParchmentTile"
F.textures.sortBar = "Interface/COMMON/Common-Input-Border"
F.textures.sortOrderArrow = "Interface/TradeSkillFrame/UI-TradeSkill-Multiskill"
F.textures.sortOrderButton = "Interface/Buttons/LockButton-Border"

F.backdrops.mainFrame = {
    bgFile = F.textures.mainBackground,
    tile = true,
    tileSize = F.sizes.mainBackgroundTile,
    insets = {left = 4, right = 3, top = 4, bottom = 4}
}
F.backdrops.details = {
    bgFile = F.textures.detailsBackground,
    tile = true,
    tileSize = F.sizes.detailsBackgroundTile,
    insets = {left = 4, right = 3, top = 4, bottom = 4}
}
