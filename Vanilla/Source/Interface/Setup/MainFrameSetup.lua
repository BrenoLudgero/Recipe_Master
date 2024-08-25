local _, rm = ...
local F = rm.F

function rm.showTooltipTextOnMouseover(element, tooltipText, anchorPoint)
    element:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, anchorPoint)
        GameTooltip:SetText(tooltipText)
        GameTooltip:Show()
    end)
    element:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

function rm.minimizeMainFrameOnClick(button)
    button:SetScript("OnClick", function(self)
        rm.isMainFrameMaximized = false
        rm.restoreButton:Show()
        rm.mainFrame:Hide()
    end)
end

function rm.restoreMainFrameOnClick(restoreButton)
    restoreButton:SetScript("OnClick", function(self)
        rm.isMainFrameMaximized = true
        self:Hide()
        rm.mainFrame:Show()
    end)
end

function rm.matchParentHeight(innerBorder)
    innerBorder:SetScript("OnUpdate", function(self, elapsed)
        self:SetHeight(innerBorder:GetParent():GetHeight())
    end)
end
