local _, rm = ...
local L = rm.L
local F = rm.F

function rm.highlightTabOnMouseover(tab)
    tab:SetScript("OnEnter", function(self)
        if not self.active then
            self.texture:SetDesaturation(0.6)
        end
    end)
    tab:SetScript("OnLeave", function(self)
        if not self.active then
            self.texture:SetDesaturated(true)
        end
    end)
end

local function handleActiveTab(tab)
    if tab.label == L.recipes then
        rm.handleRecipesTabClick()
    elseif tab.label == L.sources then
        rm.handleSourcesTabClick()
    elseif tab.label == L.fishing then
        rm.handleFishingTabClick()
    end
end

function rm.handleTabSwitching(tab)
    tab:SetScript("OnClick", function(self)
        if not self.active then
            rm.centeredText:Hide()
            rm.mainFrame:SetWidth(F.sizes.recipesFrameWidth)
            rm.activateBottomTabAndDesaturateOthers(self)
            handleActiveTab(self)
        end   
    end)
end
