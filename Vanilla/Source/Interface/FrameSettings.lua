local _, rm = ...
local L = rm.L
local F = rm.F

F.offsets.bottomTabTextX = 2
F.offsets.bottomTabTextY = 6.8
F.offsets.bottomTabTextureX = -2.5
F.offsets.bottomTabTextureY = -6
F.offsets.brightnessDropdownX = 15
F.offsets.brightnessDropdownY = -350
F.offsets.checkButtonTextX = 5
F.offsets.fishingTabX = -55.1
F.offsets.generalTextY = -85
F.offsets.headerX = 6
F.offsets.headerY = 5
F.offsets.opacitySliderY = -128
F.offsets.optionsDropdownLabelY = 12
F.offsets.progressBarTextY = -305
F.offsets.recipeIconX = 20
F.offsets.recipeInfoY = -3
F.offsets.recipeTextX = 6
F.offsets.recipesScrollX = -31.3
F.offsets.recipesScrollTopY = -6
F.offsets.recipesScrollBottomY = 4.5
F.offsets.recipesTabX = 55
F.offsets.recipesWindowTextY = -170
F.offsets.resetDefaultsX = 500
F.offsets.resetDefaultsY = -25
F.offsets.searchBarX = 8
F.offsets.showLearnedButtonX = 278
F.offsets.showRecipesInfoButtonX = 32
F.offsets.showRecipesInfoButtonY = -260
F.offsets.sliderX = 32
F.offsets.sliderDescriptionY = 12
F.offsets.sliderMinMaxTextY = -3
F.offsets.sliderValueY = 2
F.offsets.sortBarX = -18
F.offsets.sortBarY = -3
F.offsets.sortByTextX = 14
F.offsets.sortByTextY = 3
F.offsets.sourcesColumnsContainerX = 4
F.offsets.sourcesColumnsContainerY = 3.5
F.offsets.sourcesHeaderY = -34
F.offsets.sourcesInstructionsCursorX = -14
F.offsets.sourcesInstructionsCursorY = 14
F.offsets.sourcesInstructionsClickTextureX = 18
F.offsets.sourcesInstructionsClickTextureY = -16
F.offsets.sourcesInstructionsRecipeX = -22
F.offsets.sourcesInstructionsRecipeY = 10
F.offsets.sourcesListX = 8.5
F.offsets.sourcesListY = -82
F.offsets.sourcesListCellY = 3.5
F.offsets.sourcesListColumnsX = {
-- [Tab label] = {column 1 offset, column 2 offset, ...} 
    [L.vendor] = {3, 165, 235, 319},
    [L.drop] = {3, 180, 235, 319},
    [L.pickpocket] = {3, 180, 235, 319},
    [L.quest] = {3, 245, 319},
    [L.unique] = {3, 242, 319},
    [L.object] = {3, 230, 319},
    [L.trainer] = {3, 319},
    [L.fishing] = {3, 330},
    [L.item] = {3, 330}
}
F.offsets.sourcesListRowX = -3
F.offsets.sourcesListScrollX = -33
F.offsets.sourcesListTabX = 4
F.offsets.sourcesListTabY = -1.5
F.offsets.sourcesListTabTextX = 1
F.offsets.spacingSliderY = -213
F.offsets.subtitleY = -35
F.offsets.titleY = -15
F.offsets.titleTextX = 15
F.offsets.uniqueSourceTextY = 15
F.offsets.updateIconDropdownX = F.offsets.sliderX + 233
F.offsets.updateIconDropdownY = F.offsets.opacitySliderY

if rm.locale == "esES" or rm.locale == "esMX" then
    F.offsets.sourcesListColumnsX[L.drop] = {3, 165, 213, 319}
    F.offsets.sourcesListColumnsX[L.pickpocket] = {3, 165, 213, 319}
    F.offsets.sourcesListColumnsX[L.object] = {3, 214, 319}
    F.offsets.sourcesListColumnsX[L.trainer] = {3, 302}
    F.offsets.sourcesListColumnsX[L.fishing] = {3, 302}
    F.offsets.sourcesListColumnsX[L.item] = {3, 302}
elseif rm.locale == "ptBR" then
    F.offsets.sourcesListColumnsX[L.drop] = {3, 180, 238, 319}
    F.offsets.sourcesListColumnsX[L.quest] = {3, 255, 329}
elseif rm.locale == "deDE" then
    F.offsets.sourcesListTabX = 3
    F.offsets.sourcesListColumnsX[L.vendor] = {3, 162, 235, 319}
elseif rm.locale == "frFR" then
    F.offsets.sourcesListColumnsX[L.vendor] = {3, 165, 230, 319}
    F.offsets.sourcesListColumnsX[L.drop] = {3, 175, 235, 319}
    F.offsets.sourcesListColumnsX[L.pickpocket] = {3, 175, 235, 319}
elseif rm.locale == "ruRU" then
    F.offsets.bottomTabTextY = 5.5
    F.offsets.sourcesListCellY = 4
    F.offsets.sourcesListColumnsX[L.vendor] = {3, 165, 240, 298}
    F.offsets.sourcesListColumnsX[L.drop] = {3, 180, 249, 298}
    F.offsets.sourcesListColumnsX[L.pickpocket] = {3, 180, 249, 298}
    F.offsets.sourcesListColumnsX[L.quest] = {3, 255, 320}
    F.offsets.sourcesListColumnsX[L.unique] = {3, 236, 298}
    F.offsets.sourcesListColumnsX[L.object] = {3, 249, 298}
    F.offsets.sourcesListColumnsX[L.trainer] = {3, 298}
    F.offsets.sourcesListColumnsX[L.fishing] = {3, 340}
    F.offsets.sourcesListColumnsX[L.item] = {3, 340}
elseif rm.locale == "koKR" then
    F.offsets.bottomTabTextY = 5.5
    F.offsets.sourcesListColumnsX[L.vendor] = {3, 192, 268, 335}
    F.offsets.sourcesListColumnsX[L.drop] = {3, 220, 270, 335}
    F.offsets.sourcesListColumnsX[L.pickpocket] = {3, 220, 270, 335}
    F.offsets.sourcesListColumnsX[L.quest] = {3, 295, 350}
    F.offsets.sourcesListColumnsX[L.object] = {3, 270, 335}
    F.offsets.sourcesListColumnsX[L.trainer] = {3, 319}
    F.offsets.sourcesListColumnsX[L.fishing] = {3, 344}
    F.offsets.sourcesListColumnsX[L.item] = {3, 344}
elseif rm.locale == "zhTW" then
    F.offsets.recipeInfoY = 2
    F.offsets.sourcesListCellY = 2
    F.offsets.sourcesListColumnsX[L.vendor] = {3, 179, 256, 326}
    F.offsets.sourcesListColumnsX[L.drop] = {3, 204, 256, 326}
    F.offsets.sourcesListColumnsX[L.pickpocket] = {3, 204, 256, 326}
    F.offsets.sourcesListColumnsX[L.object] = {3, 256, 326}
    F.offsets.sourcesListColumnsX[L.quest] = {3, 275, 335}
elseif rm.locale == "zhCN" then
    F.offsets.recipeInfoY = 2
    F.offsets.sourcesListCellY = 2
    F.offsets.sourcesListColumnsX[L.vendor] = {3, 179, 256, 326}
    F.offsets.sourcesListColumnsX[L.drop] = {3, 204, 262, 326}
    F.offsets.sourcesListColumnsX[L.pickpocket] = {3, 204, 262, 326}
    F.offsets.sourcesListColumnsX[L.object] = {3, 262, 326}
    F.offsets.sourcesListColumnsX[L.quest] = {3, 275, 335}
end

F.sizes.bottomTabWidth = 90
F.sizes.bottomTabHeight = 25
F.sizes.bottomTabTextureWidth = 120
F.sizes.bottomTabTextureHeight = 75
F.sizes.dividerHeight = 25
F.sizes.mainBackgroundTile = 300
F.sizes.optionsDropdownWidth = 132
F.sizes.progressContainerHeight = 22
F.sizes.recipeIcon = 26 -- Width and height
F.sizes.recipesFrameWidth = 314 -- Minimum width!
F.sizes.resetDefaultsButtonWidth = 140
F.sizes.resetDefaultsButtonHeight = 35
F.sizes.restoreButton = 30 -- Width and height
F.sizes.searchBarWidth = 128
F.sizes.searchBarHeight = 18 -- Clickable area height
F.sizes.sliderWidth = 150
F.sizes.sliderHeight = 18
F.sizes.sortBarWidth = 100
F.sizes.sortOrderButton = 32 -- Width and height
F.sizes.sourcesBackgroundTile = 220
F.sizes.sourcesCellTextLength = {
    ["firstOfTwoColumns"] = 52,
    ["npc"] = 24,
    ["object"] = 36,
    ["quest"] = 35,
    ["zone"] = 14
}
F.sizes.sourcesFrameWidth = 430
F.sizes.sourcesHeaderIcon = 20 -- Width and height
F.sizes.sourcesInstructions = 250 -- Width and height
F.sizes.sourcesInstructionsCursor = 60 -- Width and height
F.sizes.sourcesInstructionsClickTexture = 40 -- Width and height
F.sizes.sourcesInstructionsRecipe = 85 -- Width and height
F.sizes.sourcesListColumnHeight = 16
F.sizes.sourcesListExtraBorderHeight = 2.6
F.sizes.sourcesListRowHeight = 17
F.sizes.sourcesListTabHeight = 25
F.sizes.sourcesListWidth = 381

if rm.locale == "ruRU" then
    F.sizes.sourcesCellTextLength["firstOfTwoColumns"] = 86
    F.sizes.sourcesCellTextLength["npc"] = 54
    F.sizes.sourcesCellTextLength["object"] = 54
    F.sizes.sourcesCellTextLength["quest"] = 60
    F.sizes.sourcesCellTextLength["zone"] = 25
elseif rm.locale == "koKR" then
    F.sizes.sourcesCellTextLength["firstOfTwoColumns"] = 64
    F.sizes.sourcesCellTextLength["npc"] = 32
    F.sizes.sourcesCellTextLength["object"] = 46
    F.sizes.sourcesCellTextLength["quest"] = 56
    F.sizes.sourcesCellTextLength["zone"] = 18
elseif rm.locale == "zhTW" or rm.locale == "zhCN" then
    F.sizes.sourcesListExtraBorderHeight = 4.4
end

F.colors.black = {0, 0, 0}
F.colors.blue = {0.00, 0.44, 0.87}
F.colors.gray = {0.62, 0.62, 0.62}
F.colors.grayishBlueHex = "ff73A7BC"
F.colors.gold = {1, 0.8431, 0}
F.colors.green = {0.098, 1, 0.098} -- GameFontGreen color
F.colors.lightBlueHex = "ff82C5FF"
F.colors.lightBrownHex = "ffB78F6A"
F.colors.lightGreenHex = "ff90EE90"
F.colors.lightPurpleHex = "ff956DD1"
F.colors.lightRedHex = "ffFFB6C1"
F.colors.orange = {1, 0.6, 0}
F.colors.orangeHex = "ffFF9900"
F.colors.purple = {0.482, 0.192, 0.824}
F.colors.red = {1, 0.125, 0.125}
F.colors.redHex = "ffFF2020"
F.colors.white = {1, 1, 1}
F.colors.whiteHex = "ffFFFFFF"
F.colors.yellow = {1, 0.824, 0} -- GameFontNormal color

if rm.locale == "ruRU" then
    F.fonts.bottomTab = "Fonts\\FRIZQT___CYR.TTF"
    F.fonts.recipeText = "GameFontHighlightSmallOutline"
    F.fontSizes.bottomTab = 9
    F.fontSizes.sourcesFrameHeader = 15
    F.fontSizes.sourcesListCell = 9.5
    F.fontSizes.sourcesListTab = 10
    F.fontSizes.uniqueInstructions = 13
elseif rm.locale == "koKR" then
    F.fonts.bottomTab = "Fonts\\2002.TTF"
    F.fonts.recipeText = "GameFontHighlightSmallOutline"
    F.fontSizes.bottomTab = 11
    F.fontSizes.sourcesFrameHeader = 16
    F.fontSizes.sourcesListCell = 10.5
    F.fontSizes.sourcesListTab = 10
    F.fontSizes.uniqueInstructions = 13
elseif rm.locale == "zhTW" then
    F.fonts.bottomTab = "Fonts\\blei00d.TTF"
    F.fonts.recipeText = "GameFontHighlightSmall"
    F.fontSizes.bottomTab = 13
    F.fontSizes.sourcesFrameHeader = 17
    F.fontSizes.sourcesListCell = 13
    F.fontSizes.sourcesListTab = 13
    F.fontSizes.uniqueInstructions = 15
elseif rm.locale == "zhCN" then
    F.fonts.bottomTab = "Fonts\\ARKai_T.ttf"
    F.fonts.recipeText = "GameFontHighlightSmall"
    F.fontSizes.bottomTab = 13
    F.fontSizes.sourcesFrameHeader = 17
    F.fontSizes.sourcesListCell = 13
    F.fontSizes.sourcesListTab = 13
    F.fontSizes.uniqueInstructions = 15
else
    F.fonts.bottomTab = "Fonts\\FRIZQT__.TTF"
    F.fonts.recipeText = "GameFontHighlightSmallOutline"
    F.fontSizes.bottomTab = 9
    F.fontSizes.sourcesFrameHeader = 15
    F.fontSizes.sourcesListCell = 9.5
    F.fontSizes.sourcesListTab = 10
    F.fontSizes.uniqueInstructions = 13
end

F.fonts.centeredText = F.fonts.bottomTab
F.fonts.header = "SystemFont_Outline_Small"
F.fonts.optionDescription = "GameFontHighlight"
F.fonts.optionSection = "GameFontNormalMed1"
F.fonts.progressBar = "SystemFont_Outline_Small"
F.fonts.sortByText = "SystemFont_Outline"
F.fonts.sourcesColumns = "GameFontHighlight"
F.fonts.sourcesFrameHeader = F.fonts.bottomTab
F.fonts.sourcesListCell = F.fonts.bottomTab
F.fonts.sourcesListTab = F.fonts.bottomTab
F.fonts.subtitle = "GameFontHighlight"
F.fonts.title = "GameFontNormalLarge"
F.fonts.uniqueInstructions = F.fonts.bottomTab

F.fontSizes.centeredText = 18
F.fontSizes.search = 10
F.fontSizes.sortBar = 11
F.fontSizes.sourceName = 14

F.templates.button = "UIPanelButtonTemplate"
F.templates.checkButton = "InterfaceOptionsCheckButtonTemplate"
F.templates.divider = "HorizontalBarTemplate"
F.templates.dropdown = "UIDropDownMenuTemplate"
F.templates.innerBorder = "InsetFrameTemplate4"
F.templates.mainFrame = "BackdropTemplate"
F.templates.mainFrameBorder = "BaseBasicFrameTemplate"
F.templates.search = "SearchBoxTemplate"
F.templates.sourcesList = "BackdropTemplate"
F.templates.scrollFrame = "UIPanelScrollFrameTemplate"
F.templates.slider = "OptionsSliderTemplate"

F.textures.bottomTab = "Interface/SPELLBOOK/UI-SpellBook-Tab1-Selected"
F.textures.copperIcon = "Interface/MoneyFrame/UI-CopperIcon"
F.textures.commonRecipe = "Interface/Icons/INV_Scroll_03"
F.textures.cursor = "Interface/CURSOR/Point"
F.textures.cursorClick = "Interface/Buttons/GLOWSTAR"
F.textures.exchangeTicket = "Interface/Icons/Inv_inscription_parchment"
F.textures.factionIcons = {
    ["Alliance"] = "Interface/WorldStateFrame/AllianceIcon",
    ["Horde"] = "Interface/WorldStateFrame/HordeIcon"
}
F.textures.goldIcon = "Interface/MoneyFrame/UI-GoldIcon"
F.textures.header = "Interface/BankFrame/Bank-Background"
F.textures.mainBackground = "Interface/FrameGeneral/UI-Background-Marble"
F.textures.silverIcon = "Interface/MoneyFrame/UI-SilverIcon"
F.textures.sourcesBackground = "Interface/AdventureMap/AdventureMapParchmentTile"
F.textures.sortBar = "Interface/COMMON/Common-Input-Border"
F.textures.sortOrderArrow = "Interface/TradeSkillFrame/UI-TradeSkill-Multiskill"
F.textures.sortOrderButton = "Interface/Buttons/LockButton-Border"
F.textures.sortOrderButtonHighlight = "Interface/Buttons/UI-CheckBox-Highlight"
F.textures.sourcesInstructionsMask = "Interface/Masks/CircleMaskScalable"
F.textures.sourcesListColumn = "Interface/Glues/CharacterSelect/Glues-CharacterSelect-Tab"
F.textures.sourcesListRow = "Interface/Tooltips/UI-Tooltip-Background"
F.textures.sourcesListTabActive = "Interface/HELPFRAME/HelpFrameTab-Active"
F.textures.sourcesListTabInactive = "Interface/HELPFRAME/HelpFrameTab-Inactive"

F.backdrops.recipesFrame = {
    bgFile = F.textures.mainBackground,
    tile = true,
    tileSize = F.sizes.mainBackgroundTile,
    insets = {left = 4, right = 4, top = 4, bottom = 4}
}
F.backdrops.sourcesFrame = {
    bgFile = F.textures.sourcesBackground,
    tile = true,
    tileSize = F.sizes.sourcesBackgroundTile,
    insets = {left = 4, right = 4, top = 4, bottom = 4}
}
F.backdrops.sourcesList = {
    bgFile = "Interface/TutorialFrame/TutorialFrameBackground",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true,
    tileEdge = true,
    tileSize = 16,
    edgeSize = 14,
    insets = {left = 4, right = 4, top = 4, bottom = 4},
}
