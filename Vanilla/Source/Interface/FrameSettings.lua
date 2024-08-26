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
        F.offsets.sourcesListColumnsX[L.drop] = {3, 165, 213, 319}
        F.offsets.sourcesListColumnsX[L.pickpocket] = {3, 165, 213, 319}
        F.offsets.sourcesListColumnsX[L.object] = {3, 214, 319}
        F.offsets.sourcesListColumnsX[L.trainer] = {3, 302}
        F.offsets.sourcesListColumnsX[L.fishing] = {3, 302}
        F.offsets.sourcesListColumnsX[L.item] = {3, 302}
    elseif rm.locale == "ptBR" then
        F.offsets.showDetailsCheckX = F.offsets.thirdColumnX + 10
        F.offsets.showLearnedCheckX = F.offsets.secondColumnX - 30
        F.offsets.sourcesListColumnsX[L.drop] = {3, 180, 238, 319}
        F.offsets.sourcesListColumnsX[L.quest] = {3, 255, 329}
    elseif rm.locale == "deDE" then
        F.offsets.showLearnedCheckX = F.offsets.secondColumnX - 22
        F.offsets.sourcesListTabX = 3
        F.offsets.sourcesListColumnsX[L.vendor] = {3, 162, 235, 319}
    elseif rm.locale == "frFR" then
        F.offsets.showDetailsCheckX = F.offsets.thirdColumnX - 4
        F.offsets.showLearnedCheckX = F.offsets.secondColumnX - 45
        F.offsets.sourcesListColumnsX[L.vendor] = {3, 165, 230, 319}
        F.offsets.sourcesListColumnsX[L.drop] = {3, 175, 235, 319}
        F.offsets.sourcesListColumnsX[L.pickpocket] = {3, 175, 235, 319}
    elseif rm.locale == "ruRU" then
        F.offsets.bottomTabTextY = 5.5
        F.offsets.showDetailsCheckX = F.offsets.thirdColumnX + 5
        F.offsets.showLearnedCheckX = F.offsets.secondColumnX - 45
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
    if rm.locale == "ruRU" then
        F.sizes.sourcesCellTextLength["firstOfTwoColumns"] = 94
        F.sizes.sourcesCellTextLength["npc"] = 39
        F.sizes.sourcesCellTextLength["object"] = 70
        F.sizes.sourcesCellTextLength["quest"] = 70
        F.sizes.sourcesCellTextLength["zone"] = 25
    elseif rm.locale == "koKR" then
        F.sizes.sourcesCellTextLength["firstOfTwoColumns"] = 90
        F.sizes.sourcesCellTextLength["npc"] = 38
        F.sizes.sourcesCellTextLength["object"] = 70
        F.sizes.sourcesCellTextLength["quest"] = 70
        F.sizes.sourcesCellTextLength["zone"] = 18
    elseif rm.locale == "zhTW" or rm.locale == "zhCN" then
        F.sizes.sourcesListExtraBorderHeight = 4.4
        F.sizes.sourcesCellTextLength["firstOfTwoColumns"] = 68
        F.sizes.sourcesCellTextLength["npc"] = 27
        F.sizes.sourcesCellTextLength["object"] = 45
        F.sizes.sourcesCellTextLength["quest"] = 50
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
    ["firstOfTwoColumns"] = 56,
    ["npc"] = 21,
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
        F.fontSizes.bottomTab = 9
        F.fontSizes.sourcesFrameHeader = 15
        F.fontSizes.sourcesListCell = 9.5
        F.fontSizes.sourcesListTab = 10
        F.fontSizes.uniqueInstructions = 13
    elseif rm.locale == "koKR" then
        F.fontSizes.bottomTab = 11
        F.fontSizes.sourcesFrameHeader = 16
        F.fontSizes.sourcesListCell = 10.5
        F.fontSizes.sourcesListTab = 10
        F.fontSizes.uniqueInstructions = 13
    elseif rm.locale == "zhTW" then
        F.fontSizes.bottomTab = 13
        F.fontSizes.sourcesFrameHeader = 17
        F.fontSizes.sourcesListCell = 13
        F.fontSizes.sourcesListTab = 13
        F.fontSizes.uniqueInstructions = 15
    elseif rm.locale == "zhCN" then
        F.fontSizes.bottomTab = 13
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
