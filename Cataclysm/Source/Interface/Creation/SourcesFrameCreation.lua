local _, rm = ...
local L = rm.L
local F = rm.F

----------------------------- Instructions -----------------------------
function rm.createSourcesInstructions(parent)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetPoint("CENTER")
    frame:SetSize(F.sizes.sourcesInstructions, F.sizes.sourcesInstructions)
    frame.texture = frame:CreateTexture(nil, "ARTWORK")
    frame.texture:SetAllPoints(frame)
    frame.texture:AdjustPointsOffset(0, F.offsets.instructionsY)
    frame.texture:SetTexture(F.textures.mainBackground)
    frame.texture:SetColorTexture(0, 0, 0, 0.55)
    frame.mask = frame:CreateMaskTexture()
    frame.mask:SetAllPoints(frame.texture)
    frame.mask:SetTexture(F.textures.sourcesInstructionsMask, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    frame.texture:AddMaskTexture(frame.mask)
    local recipe = CreateFrame("Frame", nil, frame)
    recipe:SetPoint("CENTER", F.offsets.instructionsRecipeX, F.offsets.instructionsRecipeY)
    recipe:SetSize(F.sizes.sourcesInstructionsRecipe, F.sizes.sourcesInstructionsRecipe)
    recipe.texture = recipe:CreateTexture(nil, "ARTWORK")
    recipe.texture:SetAllPoints(recipe)
    recipe.texture:SetTexture(F.textures.commonRecipe)
    local cursor = CreateFrame("Frame", nil, frame)
    cursor:SetFrameLevel(recipe:GetFrameLevel() + 1)
    cursor:SetPoint("TOPLEFT", recipe, "BOTTOMRIGHT", F.offsets.instructionsCursorX, F.offsets.instructionsCursorY)
    cursor:SetSize(F.sizes.sourcesInstructionsCursor, F.sizes.sourcesInstructionsCursor)
    cursor.texture = cursor:CreateTexture(nil, "ARTWORK")
    cursor.texture:SetAllPoints(cursor)
    cursor.texture:SetTexture(F.textures.cursor)
    cursor.clickTexture = cursor:CreateTexture(nil, "ARTWORK")
    cursor.clickTexture:SetSize(F.sizes.sourcesInstructionsClickTexture, F.sizes.sourcesInstructionsClickTexture)
    cursor.clickTexture:SetPoint("BOTTOMRIGHT", cursor, "TOPLEFT", F.offsets.instructionsClickTextureX, F.offsets.instructionsClickTextureY)
    cursor.clickTexture:SetTexture(F.textures.cursorClick)
    frame:Hide()
    return frame
end

----------------------------- Header -----------------------------
local function createSourcesRecipeIcon(parent)
    local recipeIcon = parent:CreateTexture(nil)
    recipeIcon:SetSize(F.sizes.sourcesHeaderIcon, F.sizes.sourcesHeaderIcon)
    return recipeIcon
end

local function createSourcesRecipeName(parent)
    local recipeName = parent:CreateFontString(nil, "OVERLAY")
    recipeName:SetFont(F.fonts.sourcesFrameHeader, F.fontSizes.sourcesFrameHeader, "OUTLINE")
    return recipeName
end

function rm.createSourcesHeader(parent)
    local sourceHeader = {}
    sourceHeader.recipeIcon = createSourcesRecipeIcon(parent)
    sourceHeader.recipeName = createSourcesRecipeName(parent)
    sourceHeader.recipeName:SetPoint("LEFT", sourceHeader.recipeIcon, "RIGHT", F.offsets.recipeTextX, 0)
    return sourceHeader
end

----------------------------- Tabs -----------------------------
local function createTabTexture(tab)
    local texture = tab:CreateTexture()
    texture:SetAllPoints(tab)
    texture:SetTexture(F.textures.sourcesListTab)
    return texture
end

local function createTabText(tab, string)
    local text = tab:CreateFontString(nil, "OVERLAY")
    text:SetFont(F.fonts.sourcesListTab, F.fontSizes.sourcesListTab, "OUTLINE")
    text:SetText(string)
    text:SetPoint("CENTER", tab.texture, F.offsets.sourcesListTabTextX, 0)
    return text
end

function rm.createSourceTypeTab(string, label, xOffset, sources)
    local tab = CreateFrame("Button", nil, rm.sourcesScrollFame)
    tab:SetFrameLevel(rm.sourcesList:GetFrameLevel() - 1)
    tab:SetPoint("BOTTOMLEFT", rm.sourcesScrollFame, "TOPLEFT", xOffset + 4, F.offsets.sourcesListTabY)
    tab:SetFrameStrata("MEDIUM")
    tab.active = false
    tab.label = label -- Source type (drop, quest, etc...)
    tab.texture = createTabTexture(tab)
    tab.text = createTabText(tab, string)
    tab:SetSize(tab.text:GetWidth() + F.sizes.sourcesListExtraTabWidth, F.sizes.sourcesListTabHeight)
    rm.showSourcesOnTabClick(tab, sources)
    rm.highlightInactiveOnMouseover(tab)
    rm.sourcesListTabs[label] = tab
    return tab
end

----------------------------- List -----------------------------
function rm.createSourcesScrollFrame(parent)
    local scrollFrame = CreateFrame("ScrollFrame", nil, parent, F.templates.scrollFrame)
    scrollFrame:SetPoint("TOPLEFT", F.offsets.sourcesListX, F.offsets.sourcesListY)
    scrollFrame:SetPoint("BOTTOMRIGHT", F.offsets.sourcesListScrollX, F.offsets.sourcesListScrollY)
    scrollFrame:Hide()
    return scrollFrame
end

function rm.createSourcesList(parent)
    local container = CreateFrame("Frame", nil, parent, F.templates.sourcesList)
    container:SetSize(F.sizes.sourcesListWidth + 8, 1) -- Height adjusted based on the number of items in the list
    container:SetBackdrop(F.backdrops.sourcesList)
    container.children = {}
    return container
end

function rm.createColumnsContainer(parent)
    local container = CreateFrame("Frame", nil, parent)
    container:SetSize(F.sizes.sourcesListWidth, F.sizes.sourcesListColumnHeight)
    container:SetPoint("TOPLEFT", F.offsets.columnsContainerX, -F.offsets.columnsContainerY)
    container.texture = container:CreateTexture()
    container.texture:SetAllPoints()
    container.texture:SetColorTexture(unpack(F.colors.black))
    return container
end

local function createListColumn(columnName, xOffset)
    local column = rm.sourcesColumnsContainer:CreateFontString(nil, "OVERLAY", F.fonts.sourcesColumns)
    column:SetPoint("LEFT", xOffset, 0)
    column:SetText(columnName)
    return column
end

function rm.createSourcesListColumns(columnList, tabLabel)
    local columns = {}
    for i, column in ipairs(columnList) do
        local column = createListColumn(column, F.offsets.sourcesListColumnsX[tabLabel][i])
        column:Hide()
        table.insert(columns, column)
    end
    return columns
end

local function setRowColor(row)
    if #rm.sourcesList.children % 2 == 0 then
        row.texture:SetColorTexture(0.27, 0.27, 0.27)
    else
        row.texture:SetColorTexture(0.2, 0.2, 0.2)
    end
end

local function createListRow(columns, yOffset)
    local row = CreateFrame("Frame", nil, rm.sourcesList)
    row:SetSize(F.sizes.sourcesListWidth, F.sizes.sourcesListRowHeight)
    row:SetPoint("TOPLEFT", columns[1], "BOTTOMLEFT", F.offsets.sourcesListRowX, yOffset)
    row.texture = row:CreateTexture()
    row.texture:SetAllPoints()
    row.texture:SetTexture(F.textures.sourcesListRow)
    setRowColor(row)
    table.insert(rm.sourcesList.children, row)
    return row
end

local function setCellText(cell, text, data)
    if data[L.chance] and type(text) == "number" then
        cell:SetText(text.." %")
    else
        cell:SetText(text)
    end
end

local function createListCell(row, data, text)
    local cell = row:CreateFontString(nil, "OVERLAY")
    cell:SetFont(F.fonts.sourcesListCell, F.fontSizes.sourcesListCell)
    setCellText(cell, text, data)
    rm.showTooltipOnMouseover(cell, data)
    return cell
end

local function isFirstColumn(column, columns)
    return column == columns[1]
end

local function setCellPosition(cell, column, columnName, columns, yOffset)
    if isFirstColumn(column, columns) then
        cell:SetPoint("TOPLEFT", column, "BOTTOMLEFT", 0, yOffset - F.offsets.sourcesListCellY)
    else
        cell:SetPoint("TOPLEFT", column, "BOTTOM", -(cell:GetWidth() / 2), yOffset - F.offsets.sourcesListCellY)
    end
end

local function createSourceRow(columns, data)
    local yOffset = (#rm.sourcesList.children * -F.sizes.sourcesListRowHeight) - 1
    local row = createListRow(columns, yOffset)
    local cells = {}
    for _, column in ipairs(columns) do
        local columnName = column:GetText()
        local dataValue = data[columnName]
        if type(dataValue) ~= "table" then
            local cell = createListCell(row, data, dataValue)
            setCellPosition(cell, column, columnName, columns, yOffset)
            table.insert(cells, cell)
        else -- Source present in multiple zones
            row:Hide()
            table.remove(rm.sourcesList.children, nil)
            yOffset = yOffset + F.sizes.sourcesListRowHeight
            local newCellYOffset = 0
            for i = 1, #dataValue do
                yOffset = yOffset - F.sizes.sourcesListRowHeight
                local newRow = createListRow(columns, yOffset)
                for _, cell in pairs(cells) do
                    local newCell = createListCell(newRow, data, cell:GetText())
                    newCell:SetPoint(cell:GetPoint())
                    newCell:AdjustPointsOffset(0, newCellYOffset)
                end
                newCellYOffset = newCellYOffset - F.sizes.sourcesListRowHeight
                local mapCell = createListCell(newRow, data, dataValue[i])
                setCellPosition(mapCell, column, columnName, columns, yOffset)
            end
        end
    end
end

function rm.createAllRowsForSourceType(sources, columns)
    for _, source in pairs(sources) do
        createSourceRow(columns, source)
    end
end

----------------------------- Unique Source Instructions -----------------------------
function rm.createUniqueSourceText(parent)
    local instructions = parent:CreateFontString(nil, "OVERLAY")
    instructions:SetFont(F.fonts.uniqueInstructions, F.fontSizes.uniqueInstructions, "OUTLINE")
    instructions:SetPoint("TOP", rm.sourcesColumnsContainer, "CENTER", 0, -(F.sizes.sourcesListRowHeight + F.offsets.uniqueSourceTextY))
    instructions:Hide()
    return instructions
end
