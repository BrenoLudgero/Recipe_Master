local _, rm = ...
local L = rm.L
local F = rm.F

function rm.activateBottomTabAndDesaturateOthers(tab)
    for _, otherTab in pairs(rm.bottomTabs) do
        otherTab.active = false
        otherTab.texture:SetDesaturated(true)
    end
    tab.active = true
    tab.texture:SetDesaturated(false)
end

local function congratulateIfEmptyList()
    if rm.isRecipeListEmpty() then
        rm.showCenteredText(L.congratulations, F.colors.gold)
    end
end

function rm.handleRecipesTabClick()
    rm.showRecipesFrameElements()
    rm.showRecipesForSpecificProfession(rm.lastDisplayedProfession)
    congratulateIfEmptyList()
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
    congratulateIfEmptyList()
end
