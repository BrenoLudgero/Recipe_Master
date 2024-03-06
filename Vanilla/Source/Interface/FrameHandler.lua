function getProfessionFrame()
    local frame = false
    if SkilletFrame and SkilletFrame:IsVisible() then
        frame = SkilletFrame
    elseif (TradeSkillFrame and TradeSkillFrame:IsVisible()) and not (CraftFrame and CraftFrame:IsVisible()) then
        frame = TradeSkillFrame
    elseif CraftFrame and CraftFrame:IsVisible() then
        frame = CraftFrame
    end
    return frame
end

local function updateSizesAndOffsetsBasedOnParent(professionFrame)
    local yOffset = 73
    if professionFrame == SkilletFrame then
        yOffset = 0
        offsets.mainX = 0
        offsets.mainY = 0
        offsets.headerY = -33
        offsets.restoreButtonX = 0.5
        offsets.restoreButtonY = -16
        sizes.headerTextureHeight = 40
    end
    mainFrame:SetScript("OnUpdate", function(self, elapsed)
        local parentScale = professionFrame:GetEffectiveScale()
        self:SetPoint("TOPLEFT", professionFrame, "TOPRIGHT", offsets.mainX * parentScale, offsets.mainY * parentScale)
        self:SetPoint("BOTTOM", professionFrame, "BOTTOM", 0, yOffset * parentScale)
    end)
end

local function setParentDependentFramesPosition()
    local professionFrame = getProfessionFrame()
    updateSizesAndOffsetsBasedOnParent(professionFrame)
    mainFrame:SetFrameStrata(professionFrame:GetFrameStrata())
    restoreButton:SetPoint("LEFT", professionFrame, "TOPRIGHT", offsets.restoreButtonX, offsets.restoreButtonY)
end

local function updateProgressBarColor()
    if progressBar:GetValue() < 100 then
        progressBar:SetStatusBarColor(unpack(RecipeMasterPreferences["progressColor"]))
        return
    end
    progressBar:SetStatusBarColor(unpack(colors.progressComplete))
end

local function getSpecializationDisplayName()
    local specialization = getSavedSpecializationByName(displayedProfession)
    local specializationName = ""
    if specialization then
        specializationName = " - "..GetSpellInfo(specialization)
    end
    return specializationName
end

function updateProgressBar()
    if learnedPercentage > 100 then -- Happens on the first time opening a profession frame, causing an error
        return
    end
    local progress = learnedRecipesCount.."/"..totalRecipesCount
    local specialization = getSpecializationDisplayName()
    progressBar:SetValue(learnedPercentage)
    updateProgressBarColor()
    progressBarText:SetText(progress.." ("..learnedPercentage.."%)"..specialization)
end

function updateRecipesPosition()
    local yOffset = 0
    for _, element in ipairs(recipeContainer.children) do
        if element:IsShown() then
            element.associatedIcon:SetPoint("TOP", recipeContainer, "BOTTOMLEFT", offsets.recipeIconX, yOffset)
            yOffset = yOffset - (sizes.recipeIcon + RecipeMasterPreferences["rowSpacing"])
        end
    end
end

local function resetRecipeCounts()
    displayedRecipesCount = 0
    learnedRecipesCount = 0
    missingRecipesCount = 0
    widestRecipeTextWidth = 0
end

function clearWindowContent()
    local recipeSection = recipeContainer.children
    for _, recipeText in pairs(recipeSection) do
        recipeText:Hide()
        recipeText.associatedIcon:Hide()
    end
    wipe(recipeSection)
    resetRecipeCounts()
end

function hideRecipeFrameElements()
    scrollFrame:Hide()
    progressContainer:Hide()
end

function showDetailsTabElements()
    hideRecipeFrameElements()
    mainFrame:SetBackdrop(backdrops.details)
    mainFrame:SetBackdropColor(unpack(colors.detailsBackground))
end

function showRecipeFrameElements()
    scrollFrame:Show()
    progressContainer:Show()
    mainFrame:SetBackdrop(backdrops.mainFrame)
    mainFrame:SetBackdropColor(unpack(colors.mainBackground))
end

-- Ensures that no recipe text will be cropped
local function updateMainWidthBasedOnWidestRecipeName()
    local newMainFrameWidth = math.floor(widestRecipeTextWidth + 73)
    if newMainFrameWidth >= sizes.mainWidth then
        mainFrame:SetWidth(newMainFrameWidth)
    else
        mainFrame:SetWidth(sizes.mainWidth)
    end
end

function updateRecipeDisplay(getNumSkillsFunction, getSkillInfoFunction)
    clearWindowContent()
    showProfessionRecipes(getNumSkillsFunction, getSkillInfoFunction)
    updateMainWidthBasedOnWidestRecipeName()
    updateProgressBar()
end

function showRecipesFrame(getNumSkillsFunction, getSkillInfoFunction)
    if not getProfessionFrame() then
        return
    end
    centeredText:Hide()
    showRecipeFrameElements()
    setParentDependentFramesPosition()
    activateTabAndDesaturateOthers(recipesTab)
    updateRecipeDisplay(getNumSkillsFunction, getSkillInfoFunction)
    if not autoOpenRecipeMaster then
        restoreButton:Show()
        return
    elseif mainFrame:IsShown() then
        return
    else
        restoreButton:Hide()
        mainFrame:Show()
    end
end

function hideRecipeMasterFrame()
    if not mainFrame:IsShown() and not getProfessionFrame() then
        restoreButton:Hide()
        return
    elseif getProfessionFrame() then
        setParentDependentFramesPosition()
        return
    end
    clearWindowContent()
    mainFrame:Hide()
end

function activateTabAndDesaturateOthers(tab)
    for _, otherTab in pairs(bottomTabs) do
        otherTab.active = false
        otherTab.texture:SetDesaturated(true)
    end
    tab.active = true
    tab.texture:SetDesaturated(false)
end

function showCenteredText(string, color)
    centeredText:SetText(string)
    centeredText:SetTextColor(unpack(color))
    centeredText:Show()
end
