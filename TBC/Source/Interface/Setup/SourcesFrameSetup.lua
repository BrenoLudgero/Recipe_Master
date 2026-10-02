local _, rm = ...

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

function rm.showSourcesOnTabClick(tab)
    tab:SetScript("OnClick", function(self)
        if not self.active then
            rm.showSourcesTab(self.sourceType)
        end
    end)
end

local function getCellTooltipText(cell)
    local lines = {}
    if cell.text:IsTruncated() then
        table.insert(lines, cell.text:GetText())
    end
    if cell.tooltip then
        table.insert(lines, cell.tooltip)
    end
    return table.concat(lines, "\n\n")
end

function rm.showCellTooltipOnMouseover(cell)
    cell:SetScript("OnEnter", function(self)
        local tooltipText = getCellTooltipText(self)
        if tooltipText ~= "" then
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            GameTooltip:SetText(tooltipText)
            GameTooltip:Show()
        end
    end)
    cell:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    -- Clicks go through to the main frame so it can still be dragged from the table
    cell:EnableMouseMotion(true)
    cell:SetMouseClickEnabled(false)
end

function rm.updateTableHeightOnAreaResize(area)
    area:SetScript("OnSizeChanged", function()
        rm.updateSourcesTableHeight()
    end)
end
