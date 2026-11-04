local _, rm = ...
local L = rm.L
local F = rm.F

local function isSwitchingList(tab)
    if tab == rm.recipesTab then
        return rm.isFishingDisplayed()
    elseif tab == rm.fishingTab then
        return not rm.isFishingDisplayed()
    end
    return false
end

function rm.activateBottomTabAndDesaturateOthers(tab)
    if isSwitchingList(tab) then
        rm.clearSearchBar()
    end
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

local function isFishingLearned()
    return rm.getSavedProfessionByID(356)
end

function rm.handleFishingTabClick()
    rm.showRecipesFrameElements()
    if not isFishingLearned() then
        rm.hideRecipesFrameElements()
        rm.showCenteredText(L.fishingNotLearned, F.colors.yellow)
        return
    end
    rm.showRecipesForSpecificProfession(L.professions[356])
end
