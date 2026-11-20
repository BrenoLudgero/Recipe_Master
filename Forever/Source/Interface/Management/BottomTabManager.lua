local _, rm = ...

function rm.activateBottomTabAndDesaturateOthers(tab)
    for _, bottomTab in pairs(rm.bottomTabs) do
        if bottomTab == tab then
            bottomTab.active = true
            bottomTab.texture:SetDesaturated(false)
            rm.activeTab = tab.label
        else
            bottomTab.active = false
            bottomTab.texture:SetDesaturated(true)
        end
    end
end

function rm.handleRecipesTabClick()
    rm.showRecipesFrameElements()
    rm.showRecipesForSpecificProfession(rm.lastDisplayedProfession)
end

function rm.handleSourcesTabClick()
    rm.showSourcesFrameElements()
    rm.sourcesInstructions:Show()
end
