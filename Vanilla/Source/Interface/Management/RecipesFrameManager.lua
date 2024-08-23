local _, rm = ...
local F = rm.F

function rm.updateRecipesFrameElementsPosition()
    local yOffset = 0
    for _, rowIcon in ipairs(rm.recipesList.children) do
        if rowIcon:IsShown() then
            rowIcon:SetPoint("TOP", rm.recipesList, "BOTTOMLEFT", F.offsets.recipeIconX, yOffset)
            yOffset = yOffset - (F.sizes.recipeIcon + rm.getPreference("iconSpacing"))
        end
    end
end

function rm.clearRecipesFrameContent()
    for _, row in pairs(rm.recipesList.children) do
        row:Hide()
    end
    wipe(rm.recipesList.children)
end

function rm.showRecipesFrameElements()
    rm.hideSourcesFrameElements()
    rm.recipesScrollFrame:Show()
    rm.progressContainer:Show()
    rm.mainFrame:SetBackdrop(F.backdrops.recipesFrame)
    rm.mainFrame:SetBackdropColor(unpack(F.colors.mainBackground))
end

-- Ensures that no recipe text will be cropped
local function updateMainWidthBasedOnWidestRecipeName()
    local newMainFrameWidth = math.floor(rm.widestRecipeTextWidth + 75)
    if newMainFrameWidth > F.sizes.recipesFrameWidth then
        rm.mainFrame:SetWidth(newMainFrameWidth)
    else
        rm.mainFrame:SetWidth(F.sizes.recipesFrameWidth)
    end
end

local function getSpecializationDisplayName()
    local specialization = rm.getSavedSpecializationByName(rm.displayedProfession)
    if specialization then
        return GetSpellInfo(specialization)
    end
    return ""
end

local function updateProgressBarColor()
    if rm.progressBar:GetValue() < 100 then
        rm.progressBar:SetStatusBarColor(unpack(rm.getPreference("progressColor")))
        return
    end
    rm.progressBar:SetStatusBarColor(unpack(F.colors.gold))
end

local function updateProgressBar()
    -- If Skillet is enabled, avoids an error when switching from a 
    -- trade skill window to a craft window (enchanting) and vice versa
    -- or when using the default UI and the mentioned windows are closed in quick succession
    if rm.learnedPercentage > 100 then
        return
    end
    local progress = rm.learnedRecipesCount.."/"..rm.totalRecipesCount
    local specialization = getSpecializationDisplayName()
    rm.progressBar:SetValue(rm.learnedPercentage)
    rm.progressBarText:SetText(progress.." ("..rm.learnedPercentage.."%) "..specialization)
    updateProgressBarColor()
end

function rm.updateRecipeDisplay(getSkillInfo)
    rm.clearFrameContent()
    rm.showProfessionRecipes(getSkillInfo)
    updateMainWidthBasedOnWidestRecipeName()
    updateProgressBar()
end

function rm.showRecipesFrame(getSkillInfo)
    rm.centeredText:Hide()
    rm.showRecipesFrameElements()
    rm.setParentDependentFramesPosition()
    rm.activateBottomTabAndDesaturateOthers(rm.recipesTab)
    rm.updateRecipeDisplay(getSkillInfo)
    if not rm.autoOpenRecipesFrame then
        rm.restoreButton:Show()
        return
    elseif rm.mainFrame:IsShown() then
        return
    else
        rm.restoreButton:Hide()
        rm.mainFrame:Show()
    end
end
