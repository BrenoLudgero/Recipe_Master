local _, rm = ...
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

local function showFullNameOnTooltip(tooltip, cell, data)
    if isCellUnderFirstColumn(cell) then
        tooltip:SetText(data["fullName"])
    else
        tooltip:SetText(data["fullZoneName"][cell:GetText()] or data["fullZoneName"])
    end
end

local function showFullNameIfShortened(tooltip, cell, data)
    if cell:GetText():sub(-3) == "..." then -- Cell text ends with "..."
        showFullNameOnTooltip(tooltip, cell, data)
        tooltip:Show()
    end
end

-- Only cells under the Level column have a defined color
local function showClassificationIfColored(tooltip, cell, data)
    local cellColor = string.match(cell:GetText(), "|c(%x%x%x%x%x%x%x%x)")
    if cellColor and cellColor ~= F.colors.whiteHex then
        tooltip:SetText(data["classification"])
        tooltip:Show()
    end
end

function rm.showTooltipOnMouseover(cell, data)
        cell:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            showFullNameIfShortened(GameTooltip, cell, data)
            showClassificationIfColored(GameTooltip, cell, data)
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
                    rm.showSourceColumns(columnList)
                    rm.createAllRowsForSourceType(sources, columnList)
                    rm.updateListHeight()
                    if sourceType == "unique" then
                        rm.showUniqueSourceText(sources[sourceType][1]["instructions"])
                    end
                    rm.activateSourcesTabAndDeactivateOthers(sourceType)
                else
                    hideSourceColumns(columnList)
                end
            end
        end
    end)
end
