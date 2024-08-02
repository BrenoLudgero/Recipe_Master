local _, rm = ...
local F = rm.F

function rm.setUpButtonWithTooltip(button, width, height, tooltipText, scriptOnClick)
    button:SetSize(width, height)
    button:EnableMouse(true)
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(tooltipText)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    button:SetScript("OnClick", scriptOnClick)
    return button
end

function rm.matchParentHeight(innerBorder)
    innerBorder:SetScript("OnUpdate", function(self, elapsed)
        self:SetHeight(innerBorder:GetParent():GetHeight())
    end)
end
