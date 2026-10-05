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

local function getMouseButtonIcon(atlas)
    return CreateAtlasMarkup(atlas, F.sizes.sourcesTableMouseIconWidth, F.sizes.sourcesTableMouseIconHeight)
end

local function getMapButtonTooltipText()
    local lines = {getMouseButtonIcon(F.atlases.leftMouseButton).." "..L.showOnMap}
    if rm.isTomTomLoaded() then
        table.insert(lines, getMouseButtonIcon(F.atlases.rightMouseButton).." "..L.setTomTomWaypoint)
    end
    return table.concat(lines, "\n")
end

function rm.showMapButtonTooltipOnMouseover(button)
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText(getMapButtonTooltipText())
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

-- Without TomTom, both clicks show the map
function rm.showSourceLocationOnMapButtonClick(button)
    button:SetScript("OnClick", function(self, mouseButton)
        if mouseButton == "RightButton" and rm.isTomTomLoaded() then
            rm.setTomTomWaypoints(self.source)
        else
            rm.showSourceOnWorldMap(self.source)
        end
    end)
end

function rm.updateTableHeightOnAreaResize(area)
    area:SetScript("OnSizeChanged", function()
        rm.updateSourcesTableHeight()
    end)
end
