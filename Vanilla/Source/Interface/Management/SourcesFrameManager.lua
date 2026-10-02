local _, rm = ...
local F = rm.F

local function updateHeaderIcon(recipe, xOffset)
    rm.sourcesHeader.recipeIcon:SetTexture(recipe.texture)
    rm.sourcesHeader.recipeIcon:SetPoint("TOP", rm.mainFrame, -xOffset, F.offsets.sourcesHeaderY)
end

local function updateHeaderText(recipe)
    rm.sourcesHeader.recipeName:SetText(recipe.name)
    local r, g, b = C_Item.GetItemQualityColor(recipe.quality)
    rm.sourcesHeader.recipeName:SetTextColor(unpack({r, g, b}))
end

function rm.showUpdatedSourcesHeader(recipe)
    rm.sourcesHeader.recipeIcon:Show()
    rm.sourcesHeader.recipeName:Show()
    updateHeaderText(recipe)
    local textWidth = rm.sourcesHeader.recipeName:GetWidth()
    local iconWidth = rm.sourcesHeader.recipeIcon:GetWidth()
    local iconXOffset = (iconWidth + textWidth - 14.8) / 2
    updateHeaderIcon(recipe, iconXOffset)
end

local function updateTabAppearance(tab)
    tab.text:ClearAllPoints()
    if tab.active then
        tab.texture:SetTexture(F.textures.sourcesListActiveTab)
        tab.texture:SetAlpha(1)
        tab.text:SetAlpha(1)
        tab.text:SetPoint("CENTER", tab.texture, F.offsets.sourcesListTabTextX, F.offsets.sourcesListActiveTabY)
    else
        tab.texture:SetTexture(F.textures.sourcesListInactiveTab)
        tab.texture:SetAlpha(0.8)
        tab.text:SetAlpha(0.8)
        tab.text:SetPoint("CENTER", tab.texture, F.offsets.sourcesListTabTextX, F.offsets.sourcesListInactiveTabY)
    end
end

function rm.activateSourcesTabAndDeactivateOthers(activeSourceType)
    for _, tab in ipairs(rm.sourcesTabs) do
        tab.active = (tab.sourceType == activeSourceType)
        updateTabAppearance(tab)
    end
end

local function clearSourcesTabs()
    for _, tab in ipairs(rm.sourcesTabs) do
        tab.active = false
        tab:Hide()
    end
end

function rm.showSourcesTabs(sourceTypes)
    clearSourcesTabs()
    local xOffset = 0
    for i, sourceType in ipairs(sourceTypes) do
        local tab = rm.getSourcesTab(i)
        tab.sourceType = sourceType
        tab.text:SetText(rm.getLocalizedSourceType(sourceType))
        tab:SetSize(tab.text:GetWidth() + F.sizes.sourcesListTabPaddingX, F.sizes.sourcesListTabHeight)
        tab:ClearAllPoints()
        tab:SetPoint("BOTTOMLEFT", rm.sourcesTable, "TOPLEFT", xOffset + 4, F.offsets.sourcesListTabY)
        tab:Show()
        xOffset = xOffset + tab:GetWidth() + F.offsets.sourcesListTabX
    end
end

----------------------------- Table -----------------------------
local function setCellIcon(cell, icon)
    local padding = F.sizes.sourcesTableCellPadding
    cell.text:ClearAllPoints()
    cell.text:SetPoint("RIGHT", -padding, 0)
    if icon then
        cell.icon:SetTexture(icon.texture)
        cell.icon:SetTexCoord(unpack(icon.textureCoords))
        cell.icon:Show()
        cell.text:SetPoint("LEFT", cell.icon, "RIGHT", F.offsets.sourcesTableCellIconSpacing, 0)
    else
        cell.icon:Hide()
        cell.text:SetPoint("LEFT", padding, 0)
    end
end

-- icon: Optional table with the icon's texture and textureCoords
local function setCellContent(cell, text, align, tooltip, icon)
    setCellIcon(cell, icon)
    cell.text:SetText(text)
    cell.text:SetJustifyH(align or "CENTER")
    cell.tooltip = tooltip
    cell:Show()
end

local function getCellContentWidth(cell)
    local width = cell.text:GetUnboundedStringWidth()
    if cell.icon:IsShown() then
        width = width + cell.icon:GetWidth() + F.offsets.sourcesTableCellIconSpacing
    end
    return width
end

-- Widest content in the column (header included), limited by the column's maxWidth
local function getFittedColumnWidth(lines, index, column)
    local contentWidth = 0
    for _, line in ipairs(lines) do
        contentWidth = math.max(contentWidth, getCellContentWidth(line.cells[index]))
    end
    local width = math.ceil(contentWidth) + (2 * F.sizes.sourcesTableCellPadding)
    return math.min(width, column.maxWidth or width)
end

-- Converts the separator's width from screen pixels into UI units at the table's current scale.
-- A width that isn't a whole number of pixels is rounded differently depending on the separator's position on screen
local function getSeparatorWidth()
    local pixelSize = PixelUtil.GetPixelToUIUnitFactor() / rm.sourcesTable:GetEffectiveScale()
    return F.sizes.sourcesTableSeparatorWidth * pixelSize
end

-- The last separator has no spacing at its right, which would misalign the last column
local function getSeparatorTakenSpace(separatorWidth, isLastSeparator)
    local spacing = F.offsets.sourcesTableSeparatorSpacingX
    if isLastSeparator then
        return separatorWidth + spacing
    end
    return separatorWidth + (2 * spacing)
end

local function getAllSeparatorsTakenSpace(columnCount, separatorWidth)
    local takenSpace = 0
    for i = 1, columnCount - 1 do
        takenSpace = takenSpace + getSeparatorTakenSpace(separatorWidth, i == columnCount - 1)
    end
    return takenSpace
end

local function getColumnWidths(columns, lines, separatorWidth)
    local widths = {}
    local remainingWidth = F.sizes.sourcesTableContentWidth - getAllSeparatorsTakenSpace(#columns, separatorWidth)
    local fillColumn
    for i, column in ipairs(columns) do
        if column.fill then
            fillColumn = i
        else
            widths[i] = column.width or getFittedColumnWidth(lines, i, column)
            remainingWidth = remainingWidth - widths[i]
        end
    end
    if fillColumn then
        widths[fillColumn] = remainingWidth
    end
    return widths
end

-- Anchored by its center so that scale changes only require updating its width
local function positionSeparator(line, index, centerX, separatorWidth)
    local separator = rm.getSourcesTableSeparator(line, index)
    separator:ClearAllPoints()
    separator:SetPoint("TOP", line, "TOPLEFT", centerX, 0)
    separator:SetPoint("BOTTOM", line, "BOTTOMLEFT", centerX, 0)
    separator:SetWidth(separatorWidth)
    separator:Show()
end

local function positionCellsAndSeparators(line, widths, separatorWidth)
    local xOffset = 0
    for i, width in ipairs(widths) do
        local cell = line.cells[i]
        cell:ClearAllPoints()
        cell:SetPoint("TOPLEFT", xOffset, 0)
        cell:SetPoint("BOTTOMLEFT", xOffset, 0)
        cell:SetWidth(width)
        if i < #widths then
            local centerX = xOffset + width + F.offsets.sourcesTableSeparatorSpacingX + (separatorWidth / 2)
            positionSeparator(line, i, centerX, separatorWidth)
        end
        xOffset = xOffset + width + getSeparatorTakenSpace(separatorWidth, i == #widths - 1)
    end
end

function rm.updateSourcesTableHeight()
    local rowsHeight = rm.sourcesTable.rowCount * F.sizes.sourcesTableRowHeight
    local tableHeight = F.sizes.sourcesTableHeaderHeight + rowsHeight + (2 * F.offsets.sourcesTableInset)
    local areaHeight = rm.sourcesTableArea:GetHeight()
    if areaHeight > 0 then
        tableHeight = math.min(tableHeight, areaHeight)
    end
    rm.sourcesTable:SetHeight(tableHeight)
end

local function clearLine(line)
    for _, cell in ipairs(line.cells) do
        cell:Hide()
    end
    for _, separator in ipairs(line.separators) do
        separator:Hide()
    end
end

local function clearSourcesTable()
    clearLine(rm.sourcesTable.header)
    for _, row in ipairs(rm.sourcesTable.rows) do
        clearLine(row)
        row:Hide()
    end
    rm.sourcesTable.rowCount = 0
end

function rm.populateSourcesTable(columns, rows)
    clearSourcesTable()
    local header = rm.sourcesTable.header
    local lines = {header}
    for i, column in ipairs(columns) do
        setCellContent(rm.getSourcesTableCell(header, i), column.header, column.align)
    end
    for i, data in ipairs(rows) do
        local row = rm.getSourcesTableRow(i)
        for j, column in ipairs(columns) do
            local value = data[column.field]
            if column.format then
                value = column.format(value)
            end
            local tooltip = data.tooltips and data.tooltips[column.field]
            local icon = (column.field == "name") and data.icon or nil
            setCellContent(rm.getSourcesTableCell(row, j), value, column.align, tooltip, icon)
        end
        row:Show()
        table.insert(lines, row)
    end
    local separatorWidth = getSeparatorWidth()
    local widths = getColumnWidths(columns, lines, separatorWidth)
    for _, line in ipairs(lines) do
        positionCellsAndSeparators(line, widths, separatorWidth)
    end
    rm.sourcesTable.rowCount = #rows
    rm.sourcesTable.content:SetHeight(math.max(#rows * F.sizes.sourcesTableRowHeight, 1))
    rm.sourcesTable.scrollFrame:SetVerticalScroll(0)
    rm.updateSourcesTableHeight()
end

function rm.clearSourcesFrameContent()
    clearSourcesTable()
    clearSourcesTabs()
    rm.sourcesTableArea:Hide()
end

function rm.showSourcesFrameElements()
    rm.hideRecipesFrameElements()
    rm.mainFrame:SetBackdrop(F.backdrops.sourcesFrame)
    rm.mainFrame:SetBackdropColor(unpack(F.colors.sourcesBackground))
end

function rm.showUniqueSourceText(string)
    rm.uniqueSourceText:SetText(string)
    rm.uniqueSourceText:SetTextColor(unpack(F.colors.white))
    rm.uniqueSourceText:Show()
end
