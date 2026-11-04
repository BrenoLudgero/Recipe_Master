local _, rm = ...
local F = rm.F

-- Hooked to preserve the element's template scripts (e.g., the dropdown's highlight)
function rm.showTooltipTextOnMouseover(element, tooltipText, anchorPoint)
    element:HookScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, anchorPoint)
        GameTooltip:SetText(tooltipText)
        GameTooltip:Show()
    end)
    element:HookScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

function rm.minimizeMainFrameOnClick(button)
    button:SetScript("OnClick", function(self)
        rm.setPreference("maximizeMainFrame", false)
        rm.restoreButton:Show()
        rm.mainFrame:Hide()
    end)
end

function rm.restoreMainFrameOnClick(restoreButton)
    restoreButton:SetScript("OnClick", function(self)
        rm.setPreference("maximizeMainFrame", true)
        self:Hide()
        rm.mainFrame:Show()
    end)
end
