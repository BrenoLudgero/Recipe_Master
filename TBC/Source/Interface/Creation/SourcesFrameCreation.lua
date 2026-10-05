local _, rm = ...
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

local function createTabText(tab)
    local text = tab:CreateFontString(nil, "OVERLAY")
    text:SetFont(F.fonts.sourcesListTab, F.fontSizes.sourcesListTab, "OUTLINE")
    text:SetPoint("CENTER", tab.texture, F.offsets.sourcesListTabTextX, 0)
    return text
end

local function createSourcesTab()
    local tab = CreateFrame("Button", nil, rm.sourcesTableArea)
    tab.active = false
    tab.texture = createTabTexture(tab)
    tab.text = createTabText(tab)
    rm.showSourcesOnTabClick(tab)
    rm.highlightInactiveOnMouseover(tab)
    return tab
end

-- Tabs are reused between recipes
function rm.getSourcesTab(index)
    if not rm.sourcesTabs[index] then
        rm.sourcesTabs[index] = createSourcesTab()
    end
    return rm.sourcesTabs[index]
end

----------------------------- Table -----------------------------
function rm.createSourcesTableArea(parent)
    local area = CreateFrame("Frame", nil, parent)
    area:SetPoint("TOPLEFT", F.offsets.sourcesTableX, F.offsets.sourcesTableY)
    area:SetPoint("BOTTOMLEFT", F.offsets.sourcesTableX, F.offsets.sourcesTableBottomY)
    area:SetWidth(F.sizes.sourcesTableWidth)
    area:Hide()
    return area
end

local function createTableHeader(sourcesTable)
    local inset = F.offsets.sourcesTableInset
    local header = CreateFrame("Frame", nil, sourcesTable)
    header:SetPoint("TOPLEFT", inset, -inset)
    header:SetPoint("TOPRIGHT", -inset, -inset)
    header:SetHeight(F.sizes.sourcesTableHeaderHeight)
    header.texture = header:CreateTexture(nil, "BACKGROUND")
    header.texture:SetAllPoints()
    header.texture:SetColorTexture(unpack(F.colors.black))
    header.separatorColor = F.colors.sourcesTableHeaderSeparator
    header.cells = {}
    header.separators = {}
    return header
end

local function createTableScrollFrame(sourcesTable, area)
    local inset = F.offsets.sourcesTableInset
    local scrollFrame = CreateFrame("ScrollFrame", nil, sourcesTable, F.templates.scrollFrame)
    scrollFrame:SetPoint("TOPLEFT", sourcesTable.header, "BOTTOMLEFT")
    scrollFrame:SetPoint("BOTTOMRIGHT", -inset, inset)
    -- Spans the whole area instead of the table, which may be too short for it
    scrollFrame.ScrollBar:ClearAllPoints()
    scrollFrame.ScrollBar:SetPoint("TOPLEFT", area, "TOPRIGHT", F.offsets.sourcesTableScrollBarX, -F.offsets.sourcesTableScrollBarY)
    scrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", area, "BOTTOMRIGHT", F.offsets.sourcesTableScrollBarX, F.offsets.sourcesTableScrollBarY)
    return scrollFrame
end

local function createTableContent(scrollFrame)
    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetSize(F.sizes.sourcesTableContentWidth, 1) -- Height adjusted based on the number of rows
    scrollFrame:SetScrollChild(content)
    return content
end

-- Child frames are drawn above their parent's textures, so a border drawn by the table would be covered by its header and rows
local function createTableBorder(sourcesTable)
    local border = CreateFrame("Frame", nil, sourcesTable, F.templates.sourcesTable)
    border:SetAllPoints()
    border:SetFrameLevel(sourcesTable.content:GetFrameLevel() + 4) -- Above rows (+1), their cells (+2) and map buttons (+3)
    border:SetBackdrop(F.backdrops.sourcesTableBorder)
    return border
end

function rm.createSourcesTable(area)
    local sourcesTable = CreateFrame("Frame", nil, area, F.templates.sourcesTable)
    sourcesTable:SetPoint("TOPLEFT")
    sourcesTable:SetPoint("TOPRIGHT")
    sourcesTable:SetBackdrop(F.backdrops.sourcesTable)
    sourcesTable.header = createTableHeader(sourcesTable)
    sourcesTable.scrollFrame = createTableScrollFrame(sourcesTable, area)
    sourcesTable.content = createTableContent(sourcesTable.scrollFrame)
    sourcesTable.border = createTableBorder(sourcesTable)
    sourcesTable.rows = {}
    sourcesTable.rowCount = 0
    rm.updateTableHeightOnAreaResize(area)
    return sourcesTable
end

local function createCellIcon(cell)
    local icon = cell:CreateTexture(nil, "ARTWORK")
    icon:SetSize(F.sizes.sourcesTableCellIcon, F.sizes.sourcesTableCellIcon)
    icon:Hide()
    return icon
end

-- The icon and text are anchored when the cell's content is set, depending on what is shown at the left of the text
local function createCell(parent)
    local cell = CreateFrame("Frame", nil, parent)
    cell.icon = createCellIcon(cell)
    cell.text = cell:CreateFontString(nil, "OVERLAY")
    cell.text:SetWordWrap(false) -- Text exceeding the cell is shortened with "..."
    if parent == rm.sourcesTable.header then
        cell.text:SetFontObject(F.fonts.sourcesTableHeader)
    else
        cell.text:SetFont(F.fonts.sourcesTableCell, F.fontSizes.sourcesTableCell)
    end
    rm.showCellTooltipOnMouseover(cell)
    return cell
end

-- Separators take the color of the adjacent rows
local function setRowColors(row, index)
    if index % 2 == 1 then
        row.texture:SetColorTexture(unpack(F.colors.sourcesTableOddRow))
        row.separatorColor = F.colors.sourcesTableEvenRow
    else
        row.texture:SetColorTexture(unpack(F.colors.sourcesTableEvenRow))
        row.separatorColor = F.colors.sourcesTableOddRow
    end
end

local function createRow(index)
    local yOffset = -(index - 1) * F.sizes.sourcesTableRowHeight
    local row = CreateFrame("Frame", nil, rm.sourcesTable.content)
    row:SetPoint("TOPLEFT", 0, yOffset)
    row:SetPoint("TOPRIGHT", 0, yOffset)
    row:SetHeight(F.sizes.sourcesTableRowHeight)
    row.texture = row:CreateTexture(nil, "BACKGROUND")
    row.texture:SetAllPoints()
    setRowColors(row, index)
    row.cells = {}
    row.separators = {}
    return row
end

-- Rows and cells are reused between tabs and recipes
function rm.getSourcesTableRow(index)
    local rows = rm.sourcesTable.rows
    if not rows[index] then
        rows[index] = createRow(index)
    end
    return rows[index]
end

-- Each line has its own segment of the separator, so it can have a different color
local function createSeparator(parent)
    local separator = parent:CreateTexture(nil, "BORDER") -- Above the line's background
    -- Snapping moves each edge to the nearest pixel, which can make the line a pixel wider or narrower
    separator:SetSnapToPixelGrid(false)
    separator:SetTexelSnappingBias(0)
    separator:SetColorTexture(unpack(parent.separatorColor))
    return separator
end

-- Parent is either the table's header or one of its rows.
-- Index 1 separates the first column from the second
function rm.getSourcesTableSeparator(parent, index)
    if not parent.separators[index] then
        parent.separators[index] = createSeparator(parent)
    end
    return parent.separators[index]
end

-- Parent is either the table's header or one of its rows
function rm.getSourcesTableCell(parent, index)
    if not parent.cells[index] then
        parent.cells[index] = createCell(parent)
    end
    return parent.cells[index]
end

-- Shows the source's location on the world map or sets TomTom waypoints to it
local function createMapButton(cell)
    local button = CreateFrame("Button", nil, cell)
    button:SetSize(F.sizes.sourcesTableMapButton, F.sizes.sourcesTableMapButton)
    button:SetNormalAtlas(F.atlases.mapButton)
    button:SetPushedAtlas(F.atlases.mapButtonPushed)
    button:SetHighlightAtlas(F.atlases.mapButton, "ADD")
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    rm.showMapButtonTooltipOnMouseover(button)
    rm.showSourceLocationOnMapButtonClick(button)
    button:Hide()
    return button
end

-- Only cells of sources with coordinates have a map button
function rm.getSourcesTableMapButton(cell)
    if not cell.mapButton then
        cell.mapButton = createMapButton(cell)
    end
    return cell.mapButton
end

----------------------------- Unique Source Instructions -----------------------------
function rm.createUniqueSourceText(parent)
    local instructions = parent:CreateFontString(nil, "OVERLAY")
    instructions:SetFont(F.fonts.uniqueInstructions, F.fontSizes.uniqueInstructions, "OUTLINE")
    instructions:SetPoint("TOP", rm.sourcesTable, "BOTTOM", 0, F.offsets.uniqueSourceTextY)
    instructions:Hide()
    return instructions
end
