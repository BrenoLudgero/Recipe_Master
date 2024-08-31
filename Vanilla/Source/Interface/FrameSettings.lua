local _, rm = ...
local L = rm.L
local F = rm.F

--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--                              Offsets
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

local function setLocaleSpecificOffsets()
    if rm.locale == "esES" or rm.locale == "esMX" then
        F.offsets.showDetailsCheckX = F.offsets.thirdColumnX + 10
        F.offsets.showLearnedCheckX = F.offsets.secondColumnX - 30
    elseif rm.locale == "ptBR" then
        F.offsets.showDetailsCheckX = F.offsets.thirdColumnX + 10
        F.offsets.showLearnedCheckX = F.offsets.secondColumnX - 30
        F.offsets.sourcesListTabX = 2
    elseif rm.locale == "deDE" then
        F.offsets.showLearnedCheckX = F.offsets.secondColumnX - 22
        F.offsets.sourcesListTabX = 0
        F.offsets.sourcesListColumnsX[L.vendor] = {3, 162, 234, 314}
    elseif rm.locale == "frFR" then
        F.offsets.showDetailsCheckX = F.offsets.thirdColumnX - 4
        F.offsets.showLearnedCheckX = F.offsets.secondColumnX - 45
        F.offsets.sourcesListColumnsX[L.drop] = {3, 177, 230, 314}
        F.offsets.sourcesListColumnsX[L.pickpocket] = {3, 177, 230, 314}
    elseif rm.locale == "ruRU" then
        F.offsets.showDetailsCheckX = F.offsets.thirdColumnX + 5
        F.offsets.showLearnedCheckX = F.offsets.secondColumnX - 45
        F.offsets.bottomTabTextY = 6.2
        F.offsets.sourcesListTabX = 0
        F.offsets.sourcesListTabTextX = 2
        F.offsets.sourcesListColumnsX[L.vendor] = {3, 180, 249, 296}
        F.offsets.sourcesListColumnsX[L.drop] = {3, 180, 249, 296}
        F.offsets.sourcesListColumnsX[L.pickpocket] = {3, 180, 249, 296}
        F.offsets.sourcesListColumnsX[L.quest] = {3, 249, 320}
        F.offsets.sourcesListColumnsX[L.unique] = {3, 230, 296}
        F.offsets.sourcesListColumnsX[L.object] = {3, 249, 296}
        F.offsets.sourcesListColumnsX[L.trainer] = {3, 296}
        F.offsets.sourcesListColumnsX[L.fishing] = {3, 343}
        F.offsets.sourcesListColumnsX[L.item] = {3, 343}
    elseif rm.locale == "koKR" then
        F.offsets.bottomTabTextY = 5.5
        F.offsets.sourcesListColumnsX[L.vendor] = {3, 180, 260, 330}
        F.offsets.sourcesListColumnsX[L.drop] = {3, 196, 252, 330}
        F.offsets.sourcesListColumnsX[L.pickpocket] = {3, 196, 252, 330}
        F.offsets.sourcesListColumnsX[L.quest] = {3, 252, 330}
        F.offsets.sourcesListColumnsX[L.unique] = {3, 252, 330}
        F.offsets.sourcesListColumnsX[L.object] = {3, 252, 330}
    elseif rm.locale == "zhTW" then
        F.offsets.recipeInfoY = 2
        F.offsets.sourcesListCellY = 2
        F.offsets.sourcesListColumnsX[L.vendor] = {3, 177, 260, 327}
        F.offsets.sourcesListColumnsX[L.drop] = {3, 193, 249, 327}
        F.offsets.sourcesListColumnsX[L.pickpocket] = {3, 196, 249, 327}
        F.offsets.sourcesListColumnsX[L.quest] = {3, 249, 327}
        F.offsets.sourcesListColumnsX[L.unique] = {3, 249, 327}
        F.offsets.sourcesListColumnsX[L.object] = {3, 249, 327}
    elseif rm.locale == "zhCN" then
        F.offsets.recipeInfoY = 2
        F.offsets.bottomTabTextY = 6.2
        F.offsets.sourcesListCellY = 2
        F.offsets.sourcesListColumnsX[L.vendor] = {3, 177, 260, 327}
        F.offsets.sourcesListColumnsX[L.drop] = {3, 193, 254, 327}
        F.offsets.sourcesListColumnsX[L.pickpocket] = {3, 196, 254, 327}
        F.offsets.sourcesListColumnsX[L.quest] = {3, 254, 327}
        F.offsets.sourcesListColumnsX[L.unique] = {3, 254, 327}
        F.offsets.sourcesListColumnsX[L.object] = {3, 254, 327}
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
F.offsets.recipeIconX = 20
F.offsets.recipeInfoY = -3
F.offsets.recipeTextX = 6
F.offsets.recipesListScrollX = -31.3
F.offsets.recipesListScrollTopY = -6
F.offsets.recipesListScrollBottomY = 4.5
F.offsets.searchBarX = 8
F.offsets.sortBarX = -18
F.offsets.sortBarY = -3
F.offsets.sortByTextX = 14
F.offsets.sortByTextY = 3

------------------------- Sources frame -------------------------
F.offsets.instructionsCursorX = -14
F.offsets.instructionsCursorY = 14
F.offsets.instructionsClickTextureX = 18
F.offsets.instructionsClickTextureY = -16
F.offsets.instructionsRecipeX = -22
F.offsets.instructionsRecipeY = 10
F.offsets.sourcesHeaderY = -34
F.offsets.uniqueSourceTextY = 15
--------------- List ---------------
F.offsets.sourcesListX = 8.5
F.offsets.sourcesListY = -82
F.offsets.sourcesListScrollX = -33
F.offsets.sourcesListScrollY = 10
----- Columns -----
F.offsets.columnsContainerX = 4
F.offsets.columnsContainerY = 3.5
F.offsets.sourcesListColumnsX = {
-- [Tab label] = {columns' xOffset}
    [L.vendor] = {3, 162, 230, 314},
    [L.drop] = {3, 180, 230, 314},
    [L.pickpocket] = {3, 180, 230, 314},
    [L.quest] = {3, 230, 314},
    [L.unique] = {3, 230, 314},
    [L.object] = {3, 230, 314},
    [L.trainer] = {3, 314},
    [L.fishing] = {3, 330},
    [L.item] = {3, 330}
}
----- Rows -----
F.offsets.sourcesListRowX = -3
----- Cells -----
F.offsets.sourcesListCellY = 3.5
----- Tabs -----
F.offsets.sourcesListActiveTabY = -3
F.offsets.sourcesListInactiveTabY = -5.4
F.offsets.sourcesListTabX = 4
F.offsets.sourcesListTabY = -1.5
F.offsets.sourcesListTabTextX = 1

------------------------- Options frame -------------------------
F.offsets.firstColumnX = 28
F.offsets.secondColumnX = F.offsets.firstColumnX + 210
F.offsets.thirdColumnX = F.offsets.secondColumnX + 190
F.offsets.firstRowY = -128
F.offsets.secondRowY = F.offsets.firstRowY - 103
F.offsets.thirdRowY = F.offsets.firstRowY - 217
F.offsets.resetDefaultsX = 500
F.offsets.resetDefaultsY = -25
--------------- Texts ---------------
F.offsets.checkButtonTextX = 5
F.offsets.generalTextY = -85
F.offsets.dropdownLabelY = 12
F.offsets.progressBarTextY = -300
F.offsets.recipesWindowTextY = -188
F.offsets.sliderDescriptionY = 12
F.offsets.sliderMinMaxTextY = -3
F.offsets.sliderValueY = 0
F.offsets.subtitleY = -35
F.offsets.titleY = -15
F.offsets.titlesTextX = 13
--------------- Sliders ---------------
F.offsets.opacitySliderY = F.offsets.firstRowY
F.offsets.scaleSliderX = F.offsets.secondColumnX
F.offsets.scaleSliderY = F.offsets.firstRowY
F.offsets.spacingSliderY = F.offsets.secondRowY
--------------- Dropdowns ---------------
F.offsets.brightnessDropdownX = F.offsets.firstColumnX - 19
F.offsets.brightnessDropdownY = F.offsets.thirdRowY
F.offsets.iconDropdownX = F.offsets.thirdColumnX
F.offsets.iconDropdownY = F.offsets.firstRowY
F.offsets.progressColorDropdownX = F.offsets.secondColumnX - 19
--------------- Checkboxes ---------------
F.offsets.showDetailsCheckX = F.offsets.thirdColumnX + 15
F.offsets.showDetailsCheckY = F.offsets.secondRowY
F.offsets.showLearnedCheckX = F.offsets.secondColumnX - 6
F.offsets.showLearnedCheckY = F.offsets.secondRowY

setLocaleSpecificOffsets()



--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--                              Sizes
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

local function setLocaleSpecificSizes()
    if rm.locale == "ptBR" then
        F.sizes.sourcesListExtraTabWidth = 19
    elseif rm.locale == "deDE" then
        F.sizes.sourcesListExtraTabWidth = 18
    elseif rm.locale == "ruRU" then
        F.sizes.sourcesListExtraTabWidth = 16
        F.sizes.sourcesCellTextLength["firstOfTwoColumns"] = 94
        F.sizes.sourcesCellTextLength["npc"] = 40
        F.sizes.sourcesCellTextLength["object"] = 70
        F.sizes.sourcesCellTextLength["quest"] = 70
        F.sizes.sourcesCellTextLength["zone"] = 25
    elseif rm.locale == "koKR" then
        F.sizes.sourcesCellTextLength["firstOfTwoColumns"] = 90
        F.sizes.sourcesCellTextLength["npc"] = 38
        F.sizes.sourcesCellTextLength["object"] = 70
        F.sizes.sourcesCellTextLength["quest"] = 66
        F.sizes.sourcesCellTextLength["zone"] = 18
    elseif rm.locale == "zhTW" or rm.locale == "zhCN" then
        F.sizes.sourcesListExtraBorderHeight = 4.4
        F.sizes.sourcesCellTextLength["firstOfTwoColumns"] = 66
        F.sizes.sourcesCellTextLength["npc"] = 27
        F.sizes.sourcesCellTextLength["object"] = 50
        F.sizes.sourcesCellTextLength["quest"] = 47
    end
end

------------------------- Main frame -------------------------
F.sizes.dividerHeight = 25
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
F.sizes.searchBarWidth = 128
F.sizes.searchBarHeight = 18 -- Clickable area height
F.sizes.sortBarWidth = 100
F.sizes.sortOrderButton = 32 -- Width and height

------------------------- Sources frame -------------------------
F.sizes.sourcesBackgroundTile = 220
F.sizes.sourcesCellTextLength = {
    ["firstOfTwoColumns"] = 53,
    ["npc"] = 19,
    ["object"] = 36,
    ["quest"] = 33,
    ["zone"] = 14
}
F.sizes.sourcesFrameWidth = 430
F.sizes.sourcesHeaderIcon = 20 -- Width and height
F.sizes.sourcesInstructions = 250 -- Width and height
F.sizes.sourcesInstructionsCursor = 60 -- Width and height
F.sizes.sourcesInstructionsClickTexture = 40 -- Width and height
F.sizes.sourcesInstructionsRecipe = 85 -- Width and height
F.sizes.sourcesListColumnHeight = 16
F.sizes.sourcesListExtraTabWidth = 20
F.sizes.sourcesListExtraBorderHeight = 2.6
F.sizes.sourcesListRowHeight = 17
F.sizes.sourcesListTabHeight = 25
F.sizes.sourcesListWidth = 381

------------------------- Options frame -------------------------
F.sizes.optionsDropdownWidth = 132
F.sizes.resetDefaultsButtonWidth = 140
F.sizes.resetDefaultsButtonHeight = 35
F.sizes.sliderWidth = 150
F.sizes.sliderHeight = 18

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
F.fonts.sortByText = "SystemFont_Outline"

------------------------- Sources frame -------------------------
F.fonts.sourcesColumns = "GameFontHighlight"
F.fonts.sourcesFrameHeader = specificFont
F.fonts.sourcesListCell = specificFont
F.fonts.sourcesListTab = specificFont
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
    if rm.locale == "ruRU" then
        F.fontSizes.bottomTab = 10
    elseif rm.locale == "koKR" then
        F.fontSizes.bottomTab = 11
        F.fontSizes.sourcesFrameHeader = 16
        F.fontSizes.sourcesListCell = 10.5
    elseif rm.locale == "zhTW" or rm.locale == "zhCN"then
        F.fontSizes.bottomTab = 14
        F.fontSizes.sourcesFrameHeader = 17
        F.fontSizes.sourcesListCell = 13
        F.fontSizes.sourcesListTab = 13
        F.fontSizes.uniqueInstructions = 15
    end
end

------------------------- Main frame -------------------------
F.fontSizes.centeredText = 18

------------------------- Bottom tabs -------------------------
F.fontSizes.bottomTab = 9

------------------------- Sources frame -------------------------
F.fontSizes.sourcesFrameHeader = 15
F.fontSizes.sourcesListCell = 9.5
F.fontSizes.sourcesListTab = 10
F.fontSizes.uniqueInstructions = 13

------------------------- Recipes / Fishing frame -------------------------
F.fontSizes.searchBar = 10
F.fontSizes.sortBar = 11

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
F.colors.lightGreenHex = "ff90EE90"
F.colors.lightPinkHex = "ffFFB6C1"
F.colors.lightPurpleHex = "ff956DD1"
F.colors.orange = {1, 0.6, 0}
F.colors.orangeHex = "ffFF9900"
F.colors.purple = {0.482, 0.192, 0.824}
F.colors.red = {1, 0.125, 0.125}
F.colors.redHex = "ffFF2020"
F.colors.skyBlueHex = "ff57C8EA"
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
F.templates.dropdown = "UIDropDownMenuTemplate"
F.templates.innerBorder = "InsetFrameTemplate4"
F.templates.mainFrame = "BackdropTemplate"
F.templates.mainFrameBorder = "BaseBasicFrameTemplate"
F.templates.search = "SearchBoxTemplate"
F.templates.sourcesList = "BackdropTemplate"
F.templates.scrollFrame = "UIPanelScrollFrameTemplate"
F.templates.slider = "OptionsSliderTemplate"



--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--                            Textures
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

F.textures.bottomTab = "Interface/SPELLBOOK/UI-SpellBook-Tab1-Selected"
F.textures.copperIcon = "|TInterface/MoneyFrame/UI-CopperIcon:11:10:2:0.5:64:64:4:60:4:60|t"
F.textures.commonRecipe = "Interface/Icons/INV_Scroll_03"
F.textures.cursor = "Interface/CURSOR/Point"
F.textures.cursorClick = "Interface/Buttons/GLOWSTAR"
F.textures.exchangeTicket = "|TInterface/Icons/Inv_inscription_parchment:11:10:2:0.5:64:64:4:60:4:60|t"
F.textures.factionIcons = {
    ["Alliance"] = "Interface/WorldStateFrame/AllianceIcon",
    ["Horde"] = "Interface/WorldStateFrame/HordeIcon"
}
F.textures.goldIcon = "|TInterface/MoneyFrame/UI-GoldIcon:11:10:2:0.5:64:64:4:60:4:60|t"
F.textures.header = "Interface/BankFrame/Bank-Background"
F.textures.mainBackground = "Interface/FrameGeneral/UI-Background-Marble"
F.textures.silverIcon = "|TInterface/MoneyFrame/UI-SilverIcon:11:10:2:0.5:64:64:4:60:4:60|t"
F.textures.sourcesBackground = "Interface/AdventureMap/AdventureMapParchmentTile"
F.textures.sourcesListBackground = "Interface/TutorialFrame/TutorialFrameBackground"
F.textures.sourcesListEdge = "Interface/Tooltips/UI-Tooltip-Border"
F.textures.sortBar = "Interface/COMMON/Common-Input-Border"
F.textures.sortOrderArrow = "Interface/TradeSkillFrame/UI-TradeSkill-Multiskill"
F.textures.sortOrderButton = "Interface/Buttons/LockButton-Border"
F.textures.sortOrderButtonHighlight = "Interface/Buttons/UI-CheckBox-Highlight"
F.textures.sourcesInstructionsMask = "Interface/Masks/CircleMaskScalable"
F.textures.sourcesListColumn = "Interface/Glues/CharacterSelect/Glues-CharacterSelect-Tab"
F.textures.sourcesListRow = "Interface/Tooltips/UI-Tooltip-Background"
F.textures.sourcesListActiveTab = "Interface/HELPFRAME/HelpFrameTab-Active"
F.textures.sourcesListInactiveTab = "Interface/HELPFRAME/HelpFrameTab-Inactive"
F.textures.tarnishedUndermineReal = "|TInterface/Icons/INV_Misc_Coin_16:11:10:2:0.5:64:64:4:60:4:60|t"



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
F.backdrops.sourcesList = {
    bgFile = F.textures.sourcesListBackground,
    edgeFile = F.textures.sourcesListEdge,
    tile = true,
    tileEdge = true,
    tileSize = 16,
    edgeSize = 14,
    insets = {left = 4, right = 4, top = 4, bottom = 4},
}
