local _, rm = ...
local L = rm.L
local F = rm.F

function rm.highlightInactiveOnMouseover(tab)
    tab:SetScript("OnEnter", function(self)
        if not self.active then
            self.texture:SetAlpha(1)
            self.text:SetAlpha(1)
        end
    end)
    tab:SetScript("OnLeave", function(self)
        if not self.active then
            self.texture:SetAlpha(0.8)
            self.text:SetAlpha(0.8)
        end
    end)
end

local function isCellUnderFirstColumn(cell)
    local cellParent = select(2, cell:GetPoint())
    local cellParentXOffset = select(4, cellParent:GetPoint())
    return cellParentXOffset < 4
end

local function showUnshortenedName(tooltip, cell, data)
    if string.find(cell:GetText(), "...", 0, true) then -- Cell text contains "..."
        if isCellUnderFirstColumn(cell) then
            tooltip:SetText(data["fullName"])
        else
            tooltip:SetText(data["fullZoneName"][cell:GetText()] or data["fullZoneName"])
        end
        tooltip:Show()
    end
end

local function getColoredCellInfo(cell, cellColor, data)
    local cellParentColumnText = select(2, cell:GetPoint()):GetText()
    if cellParentColumnText == L.name and cellColor ~= F.colors.grayHex then
        return data["classAndRace"]
    elseif cellColor == F.colors.grayHex then
        return L.questCompleted
    else
        return data["classification"]
    end
end

-- Only cells under the Level or Quest Name column have a defined color
local function showColoredCellInfo(tooltip, cell, data)
    local cellColor = string.match(cell:GetText(), "|c(%x%x%x%x%x%x%x%x)")
    if cellColor and cellColor ~= F.colors.whiteHex then
        local info = getColoredCellInfo(cell, cellColor, data)
        local tooltipText = _G[tooltip:GetName().."TextLeft"..1]:GetText()
        if tooltipText then -- Tooltip already has an unshortened name
            tooltip:SetText(tooltipText.."\n\n"..info)
        else
            tooltip:SetText(info)
        end
        tooltip:Show()
    end
end

function rm.showTooltipOnMouseover(cell, data)
    cell:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        showUnshortenedName(GameTooltip, cell, data)
        showColoredCellInfo(GameTooltip, cell, data)
    end)
    cell:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

local function hideSourceColumns(columnList)
    for _, column in pairs(columnList) do
        column:Hide()
    end
end

function rm.showSourcesOnTabClick(tab, sources)
    tab:SetScript("OnClick", function(self)
        if not self.active then
            rm.clearSourcesList()
            for sourceType, columnList in pairs(rm.sourcesListColumns) do
                if sourceType == self.label then
                    rm.showTabRows(sources, sourceType, columnList)
                else
                    hideSourceColumns(columnList)
                end
            end
        end
    end)
end
