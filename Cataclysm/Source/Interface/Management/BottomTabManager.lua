local _, rm = ...
local L = rm.L
local F = rm.F

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

local function isRecipeListEmpty()
    return rm.mainFrame:IsShown() and #rm.recipesList.children == 0
end

local function congratulateIfEmptyList()
    if isRecipeListEmpty() then
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
