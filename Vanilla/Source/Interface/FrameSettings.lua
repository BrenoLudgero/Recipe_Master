local _, rm = ...
local F = rm.F

--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--                              Offsets
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

local function setLocaleSpecificOffsets()
    if rm.locale == "esES" or rm.locale == "esMX" then
        F.offsets.dividerCheckButtonLabelY = 1
        F.offsets.iconDropdownX = F.offsets.thirdColumnX + 19
        F.offsets.showSourceTooltipCheckX = F.offsets.secondColumnX + 20
        F.offsets.showOppositeFactionAltsTooltipCheckX = F.offsets.secondColumnX + 20
    elseif rm.locale == "ptBR" then
        F.offsets.dividerCheckButtonLabelY = 1
        F.offsets.iconDropdownX = F.offsets.thirdColumnX + 14
        F.offsets.showSourceTooltipCheckX = F.offsets.secondColumnX + 35
        F.offsets.showOppositeFactionAltsTooltipCheckX = F.offsets.secondColumnX + 35
        F.offsets.sourcesListTabX = 2
    elseif rm.locale == "deDE" then
        F.offsets.dividerCheckButtonLabelY = 1
        F.offsets.iconDropdownX = F.offsets.thirdColumnX + 13
        F.offsets.showSourceTooltipCheckX = F.offsets.secondColumnX + 18
        F.offsets.showOppositeFactionAltsTooltipCheckX = F.offsets.secondColumnX + 18
        F.offsets.sourcesListTabX = 0
    elseif rm.locale == "frFR" then
        F.offsets.iconDropdownX = F.offsets.thirdColumnX + 13
        F.offsets.showSourceTooltipCheckX = F.offsets.secondColumnX + 25
        F.offsets.showOppositeFactionAltsTooltipCheckX = F.offsets.secondColumnX + 25
    elseif rm.locale == "ruRU" then
        F.offsets.showSourceTooltipCheckX = F.offsets.secondColumnX + 25
        F.offsets.showOppositeFactionAltsTooltipCheckX = F.offsets.secondColumnX + 25
        F.offsets.bottomTabTextY = 6.2
        F.offsets.sourcesListTabX = 0
        F.offsets.sourcesListTabTextX = 2
    elseif rm.locale == "koKR" then
        F.offsets.bottomTabTextY = 5.5
    elseif rm.locale == "zhTW" then
        F.offsets.recipeInfoY = 2
    elseif rm.locale == "zhCN" then
        F.offsets.recipeInfoY = 2
        F.offsets.bottomTabTextY = 6.2
    end
end

------------------------- Main frame -------------------------
F.offsets.mainHeaderX = 6
F.offsets.mainHeaderY = 5

------------------------- Bottom tabs -------------------------
F.offsets.bottomTabTextX = 2
F.offsets.bottomTabTextY = 6.8
F.offsets.bottomTabTextureX = -2.5
F.offsets.bottomTabTextureY = -6
F.offsets.fishingTabX = -55.1
F.offsets.recipesTabX = 55

------------------------- Recipes / Fishing frame -------------------------
F.offsets.dividerCheckButtonLabelY = 0
F.offsets.recipeIconX = 20
F.offsets.recipeInfoY = -3
F.offsets.recipeTextX = 6
F.offsets.recipesListScrollX = -31
F.offsets.recipesListScrollTopY = -6
F.offsets.recipesListScrollBottomY = 4.5
F.offsets.searchBarX = 8
F.offsets.searchBarY = -4
F.offsets.sortByDropdownX = -32
F.offsets.sortByDropdownY = -7
F.offsets.sortOrderDropdownX = -8
F.offsets.sortOrderDropdownY = -4
F.offsets.sourceFilterDropdownX = F.offsets.sortOrderDropdownX - 1
F.offsets.sourceFilterDropdownY = -2.5

------------------------- Sources frame -------------------------
F.offsets.instructionsY = -10
F.offsets.instructionsCursorX = -14
F.offsets.instructionsCursorY = 14
F.offsets.instructionsClickTextureX = 18
F.offsets.instructionsClickTextureY = -16
F.offsets.instructionsRecipeX = -22
F.offsets.instructionsRecipeY = 10
F.offsets.sourcesHeaderY = -34
F.offsets.uniqueSourceTextY = -7
--------------- Table ---------------
F.offsets.sourcesTableX = 8.5
F.offsets.sourcesTableY = -78
F.offsets.sourcesTableBottomY = 10
F.offsets.sourcesTableInset = 3 -- Space between the table's border and its content
F.offsets.sourcesTableCellIconX = -3 -- Space between a cell's icon and the border
F.offsets.sourcesTableCellIconSpacing = 2 -- Space between a cell's icon and its text
F.offsets.sourcesTableMapButtonY = -1
F.offsets.sourcesTableSeparatorSpacingX = 4 -- Space around the line separating columns
F.offsets.sourcesTableScrollBarX = 6
F.offsets.sourcesTableScrollBarY = 16
----- Tabs -----
F.offsets.sourcesListActiveTabY = -3
F.offsets.sourcesListInactiveTabY = -5.4
F.offsets.sourcesListTabX = 4
F.offsets.sourcesListTabY = -1.5
F.offsets.sourcesListTabTextX = 1

------------------------- Options frame -------------------------
F.offsets.firstColumnX = 28
F.offsets.secondColumnX = F.offsets.firstColumnX + 210
F.offsets.thirdColumnX = F.offsets.secondColumnX + 205
F.offsets.firstRowY = -128
F.offsets.secondRowY = F.offsets.firstRowY - 105
F.offsets.thirdRowY = F.offsets.firstRowY - 217
F.offsets.fourthRowY = F.offsets.firstRowY - 317
F.offsets.fifthRowY = F.offsets.firstRowY - 360
F.offsets.resetDefaultsX = 500
F.offsets.resetDefaultsY = -25
--------------- Texts ---------------
F.offsets.checkButtonTextX = 5
F.offsets.generalTextY = -85
F.offsets.dropdownLabelY = 12
F.offsets.progressBarTextY = -300
F.offsets.recipeTooltipTextY = -410
F.offsets.recipesWindowTextY = -190
F.offsets.sliderDescriptionY = 12
F.offsets.sliderMinMaxTextX = 18
F.offsets.sliderValueY = -2
F.offsets.subtitleY = -35
F.offsets.titleY = -15
F.offsets.titlesTextX = 13
--------------- Sliders ---------------
F.offsets.opacitySliderY = F.offsets.firstRowY
F.offsets.scaleSliderX = F.offsets.secondColumnX
F.offsets.scaleSliderY = F.offsets.firstRowY
F.offsets.spacingSliderY = F.offsets.secondRowY
--------------- Dropdowns ---------------
F.offsets.brightnessDropdownX = F.offsets.firstColumnX
F.offsets.brightnessDropdownY = F.offsets.thirdRowY
F.offsets.iconDropdownX = F.offsets.thirdColumnX
F.offsets.iconDropdownY = F.offsets.firstRowY
F.offsets.progressColorDropdownX = F.offsets.secondColumnX
--------------- Checkboxes ---------------
F.offsets.showDifficultyTooltipCheckX = F.offsets.firstColumnX - 4
F.offsets.showDifficultyTooltipCheckY = F.offsets.fourthRowY
F.offsets.showSourceTooltipCheckX = F.offsets.secondColumnX - 4
F.offsets.showSourceTooltipCheckY = F.offsets.fourthRowY
F.offsets.showAltsTooltipCheckX = F.offsets.firstColumnX - 4
F.offsets.showAltsTooltipCheckY = F.offsets.fifthRowY
F.offsets.showOppositeFactionAltsTooltipCheckX = F.offsets.secondColumnX - 4
F.offsets.showOppositeFactionAltsTooltipCheckY = F.offsets.fifthRowY

setLocaleSpecificOffsets()



--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--                              Sizes
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

local function setLocaleSpecificSizes()
    if rm.locale == "ruRU" then
        F.sizes.sourcesListTabPaddingX = 19
    end
end

------------------------- Main frame -------------------------
F.sizes.dividerHeight = 45
F.sizes.mainBackgroundTile = 300
F.sizes.restoreButton = 30 -- Width and height

------------------------- Bottom tabs -------------------------
F.sizes.bottomTabWidth = 90
F.sizes.bottomTabHeight = 25
F.sizes.bottomTabTextureWidth = 120
F.sizes.bottomTabTextureHeight = 75

------------------------- Recipes / Fishing frame -------------------------
F.sizes.progressContainerHeight = 22
F.sizes.recipeIcon = 26 -- Width and height
F.sizes.recipesFrameWidth = 314 -- Minimum width!
F.sizes.searchBarHeight = 18 -- Clickable area height
F.sizes.dividerCheckButton = 22 -- Width and height
F.sizes.sortDropdownWidth = 110
F.sizes.sortOrderButton = 34 -- Width and height

------------------------- Sources frame -------------------------
--        Headers' width defined at SourcesDisplay.lua
F.sizes.sourcesBackgroundTile = 220
F.sizes.sourcesFrameWidth = 430
F.sizes.sourcesHeaderIcon = 20 -- Width and height
F.sizes.sourcesInstructions = 250 -- Width and height
F.sizes.sourcesInstructionsCursor = 60 -- Width and height
F.sizes.sourcesInstructionsClickTexture = 40 -- Width and height
F.sizes.sourcesInstructionsRecipe = 85 -- Width and height
F.sizes.sourcesListTabHeight = 25
F.sizes.sourcesListTabPaddingX = 20 -- Space around the inside of a tab and its text
F.sizes.sourcesTableHeaderHeight = 18
F.sizes.sourcesTableCellPadding = 4 -- Space between the inside of a cell and its text
F.sizes.sourcesTableCellIcon = 14 -- Width and height of icons beside a cell's text (e.g., faction icons)
F.sizes.sourcesTableMapButton = 14 -- Width and height
F.sizes.sourcesTableQuestieButton = 13 -- Width and height
F.sizes.sourcesTableMouseIconWidth = 12 -- Shown in the map button's tooltip
F.sizes.sourcesTableMouseIconHeight = 16
F.sizes.sourcesTableRowHeight = 17
F.sizes.sourcesTableSeparatorWidth = 1
F.sizes.sourcesTableWidth = 389
F.sizes.sourcesTableContentWidth = F.sizes.sourcesTableWidth - (2 * F.offsets.sourcesTableInset)

------------------------- Options frame -------------------------
F.sizes.optionsDropdownWidth = 145
F.sizes.resetDefaultsButtonWidth = 140
F.sizes.resetDefaultsButtonHeight = 35
F.sizes.sliderWidth = 150
F.sizes.sliderHeight = 18

------------------------- World map -------------------------
F.sizes.mapAreaBorder = 2
F.sizes.mapPin = 12 -- Width and height
F.sizes.mapPinBorder = 2

setLocaleSpecificSizes()



--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--                              Fonts
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

local function getLocaleSpecificFont()
    if rm.locale == "ruRU" then
        return "Fonts/FRIZQT___CYR.TTF"
    elseif rm.locale == "koKR" then
        return "Fonts/2002.TTF"
    elseif rm.locale == "zhTW" then
        return "Fonts/blei00d.TTF"
    elseif rm.locale == "zhCN" then
        return "Fonts/ARKai_T.ttf"
    end
    return "Fonts/FRIZQT__.TTF"
end

local specificFont = getLocaleSpecificFont()

------------------------- Main frame -------------------------
F.fonts.centeredText = specificFont
F.fonts.header = "SystemFont_Outline_Small"

------------------------- Bottom tabs -------------------------
F.fonts.bottomTab = specificFont

------------------------- Recipes / Fishing frame -------------------------
F.fonts.progressBar = "SystemFont_Outline_Small"
F.fonts.recipeText = "GameFontHighlightSmallOutline"
F.fonts.dividerCheckButtonText = "SystemFont_Outline_Small"

------------------------- Sources frame -------------------------
F.fonts.sourcesFrameHeader = specificFont
F.fonts.sourcesListTab = specificFont
F.fonts.sourcesTableCell = specificFont
F.fonts.sourcesTableHeader = "GameFontHighlight"
F.fonts.uniqueInstructions = specificFont

------------------------- Options frame -------------------------
F.fonts.optionDescription = "GameFontHighlight"
F.fonts.optionSection = "GameFontNormalMed1"
F.fonts.subtitle = "GameFontHighlight"
F.fonts.title = "GameFontNormalLarge"



--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--                            Font Sizes
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

local function setLocaleSpecificFontSizes()
    if rm.locale == "esES" 
    or rm.locale == "esMX"
    or rm.locale == "ptBR"
    or rm.locale == "deDE" then
        F.fontSizes.dividerCheckButton = 8
    elseif rm.locale == "frFR" then
        F.fontSizes.dividerCheckButton = 7
    elseif rm.locale == "ruRU" then
        F.fontSizes.bottomTab = 10
    elseif rm.locale == "koKR" then
        F.fontSizes.bottomTab = 11
    elseif rm.locale == "zhTW" or rm.locale == "zhCN"then
        F.fontSizes.bottomTab = 14
        F.fontSizes.sourcesFrameHeader = 17
        F.fontSizes.sourcesTableCell = 13
        F.fontSizes.sourcesListTab = 13
        F.fontSizes.uniqueInstructions = 15
    end
end

------------------------- Main frame -------------------------
F.fontSizes.centeredText = 18

------------------------- Bottom tabs -------------------------
F.fontSizes.bottomTab = 9

------------------------- Recipes / Fishing frame -------------------------
F.fontSizes.dividerCheckButton = 10

------------------------- Sources frame -------------------------
F.fontSizes.sourcesFrameHeader = 15
F.fontSizes.sourcesListTab = 10
F.fontSizes.sourcesTableCell = 9.5
F.fontSizes.uniqueInstructions = 13

------------------------- Recipes / Fishing frame -------------------------
F.fontSizes.searchBar = 10
F.fontSizes.sortDropdown = 12

setLocaleSpecificFontSizes()



--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--                              Colors
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

F.colors.black = {0, 0, 0}
F.colors.blue = {0.00, 0.44, 0.87}
F.colors.cadetBlueHex = "ff73A7BC"
F.colors.emeraldHex = "ff0BBE76"
F.colors.gray = {0.659, 0.659, 0.659}
F.colors.grayHex = "ffA8A8A8"
F.colors.gold = {1, 0.8431, 0}
F.colors.green = {0.098, 1, 0.098} -- GameFontGreen color
F.colors.lightBlueHex = "ff82C5FF"
F.colors.lightGrayHex = "ffCCCCCC"
F.colors.lightGreenHex = "ff90EE90"
F.colors.lightPinkHex = "ffFFB6C1"
F.colors.lightPurpleHex = "ff956DD1"
F.colors.mapArea = {0.8, 0.1, 0.05, 0.4}
F.colors.mapAreaBorder = {0, 0, 0}
F.colors.mapPinBorder = {0, 0, 0}
F.colors.mapPinFill = {0.9, 0.15, 0.1}
F.colors.orange = {1, 0.6, 0}
F.colors.orangeHex = "ffFF9900"
F.colors.purple = {0.482, 0.192, 0.824}
F.colors.red = {1, 0.125, 0.125}
F.colors.redHex = "ffFF2020"
F.colors.skyBlueHex = "ff57C8EA"
F.colors.sourcesTableHeaderSeparator = {1, 1, 1, 0.4}
F.colors.sourcesTableEvenRow = {0.2, 0.2, 0.2}
F.colors.sourcesTableOddRow = {0.27, 0.27, 0.27}
F.colors.tanHex = "ffAC885D"
F.colors.white = {1, 1, 1}
F.colors.whiteHex = "ffFFFFFF"
F.colors.yellow = {1, 0.824, 0} -- GameFontNormal color
F.colors.yellowHex = "ffFFD100" -- GameFontNormal color



--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--                            Templates
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

F.templates.button = "UIPanelButtonTemplate"
F.templates.checkButton = "InterfaceOptionsCheckButtonTemplate"
F.templates.divider = "HorizontalBarTemplate"
F.templates.dropdown = "WowStyle1DropdownTemplate"
F.templates.innerBorder = "InsetFrameTemplate4"
F.templates.mainFrame = "BackdropTemplate"
F.templates.mainFrameBorder = "BaseBasicFrameTemplate"
F.templates.search = "SearchBoxTemplate"
F.templates.scrollFrame = "UIPanelScrollFrameTemplate"
F.templates.slider = "HorizontalSliderTemplate"
F.templates.sourcesTable = "BackdropTemplate"



--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--                            Textures
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

F.textures.bottomTab = "Interface/SPELLBOOK/UI-SpellBook-Tab1-Selected"
F.textures.circleMask = "Interface/Masks/CircleMaskScalable"
F.textures.copperCoin = "Interface/MoneyFrame/UI-CopperIcon"
F.textures.commonRecipe = "Interface/Icons/INV_Scroll_03"
F.textures.cursor = "Interface/CURSOR/Point"
F.textures.cursorClick = "Interface/Buttons/GLOWSTAR"
F.textures.exchangeTicket = "Interface/Icons/Inv_inscription_parchment"
F.textures.factionIcons = {
    ["Alliance"] = "Interface/WorldStateFrame/AllianceIcon",
    ["Horde"] = "Interface/WorldStateFrame/HordeIcon"
}
F.textures.goldCoin = "Interface/MoneyFrame/UI-GoldIcon"
F.textures.header = "Interface/BankFrame/Bank-Background"
F.textures.mainBackground = "Interface/FrameGeneral/UI-Background-Marble"
F.textures.questieButton = "Interface/AddOns/Questie/Icons/questie.png" -- Questie's logo
F.textures.silverCoin = "Interface/MoneyFrame/UI-SilverIcon"
F.textures.sourcesBackButton = "Interface/Buttons/UI-SpellbookIcon-PrevPage-Up"
F.textures.sourcesBackButtonHighlight = "Interface/Buttons/UI-Common-MouseHilight"
F.textures.sourcesBackButtonPushed = "Interface/Buttons/UI-SpellbookIcon-PrevPage-Down"
F.textures.sourcesBackground = "Interface/AdventureMap/AdventureMapParchmentTile"
F.textures.sortOrderArrowUp = "Interface/Buttons/Arrow-Up-Up"
F.textures.sortOrderArrowDown = "Interface/Buttons/Arrow-Down-Up"
F.textures.sortOrderButton = "Interface/Buttons/LockButton-Border"
F.textures.sortOrderButtonHighlight = "Interface/Buttons/UI-CheckBox-Highlight"
F.textures.sourcesInstructionsMask = "Interface/Masks/CircleMaskScalable"
F.textures.sourcesListActiveTab = "Interface/HELPFRAME/HelpFrameTab-Active"
F.textures.sourcesListInactiveTab = "Interface/HELPFRAME/HelpFrameTab-Inactive"
F.textures.sourcesTableBackground = "Interface/TutorialFrame/TutorialFrameBackground"
F.textures.sourcesTableEdge = "Interface/Tooltips/UI-Tooltip-Border"
F.textures.squareMask = "Interface/Buttons/WHITE8X8"
F.textures.tarnishedUndermineReal = "Interface/Icons/INV_Misc_Coin_16"



--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--                              Atlases
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

F.atlases.leftMouseButton = "newplayertutorial-icon-mouse-leftbutton"
F.atlases.mapButton = "orderhall-commandbar-mapbutton-up"
F.atlases.mapButtonPushed = "orderhall-commandbar-mapbutton-down"
F.atlases.rightMouseButton = "newplayertutorial-icon-mouse-rightbutton"



--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--                            Backdrops
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

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
F.backdrops.sourcesTable = {
    bgFile = F.textures.sourcesTableBackground,
    tile = true,
    tileSize = 16,
    insets = {left = 4, right = 4, top = 4, bottom = 4},
}
F.backdrops.sourcesTableBorder = { -- Separate from the background so it's displayed above the header and rows
    edgeFile = F.textures.sourcesTableEdge,
    tileEdge = true,
    edgeSize = 14,
}
