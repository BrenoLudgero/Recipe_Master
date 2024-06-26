local _, rm = ...
local L = rm.L
local F = rm.F

local function isTradeSkillFrameVisible()
    return TradeSkillFrame and TradeSkillFrame:IsVisible()
end

local function isCraftFrameVisible()
    return CraftFrame and CraftFrame:IsVisible()
end

function rm.getProfessionFrame()
    local frame = false
    if SkilletFrame and SkilletFrame:IsVisible() then
        return SkilletFrame
    elseif TSM_API and (TSM_API.IsUIVisible("CRAFTING") or isTradeSkillFrameVisible() or isCraftFrameVisible()) then
        return UIParent
    elseif isTradeSkillFrameVisible() and not isCraftFrameVisible() then
        frame = TradeSkillFrame
    elseif isCraftFrameVisible() then
        frame = CraftFrame
    end
    return frame
end

local function keepMainFrameHeightSameAsProfessionFrame(professionFrame, uiScale)
    xOffset = -(F.offsets.mainX * uiScale)
    rm.mainFrame:SetScript("OnUpdate", function(self, elapsed)
        self:ClearAllPoints()
        self:SetPoint("TOPLEFT", professionFrame, "TOPRIGHT", xOffset, F.offsets.mainTop)
        self:SetPoint("BOTTOM", professionFrame, "BOTTOM", 0, F.offsets.mainBottom)
    end)
end

local function anchorFrameToProfessionFrame(professionFrame)
    local uiScale = UIParent:GetScale()
    local xOffset = -(F.offsets.restoreButtonX * uiScale)
    rm.restoreButton:ClearAllPoints()
    rm.restoreButton:SetPoint("TOPLEFT", professionFrame, "TOPRIGHT", xOffset, F.offsets.restoreButtonY)
    keepMainFrameHeightSameAsProfessionFrame(professionFrame, uiScale)
end

local function replaceHideFrameButtonWithScrollTexture()
    local hideButton = rm.mainFrameBorder.CloseButton
    hideButton:Disable(true)
    hideButton:Hide()
    local newTexture = rm.mainFrame:CreateTexture()
    newTexture:SetPoint("CENTER", hideButton, -0.4, 0)
    newTexture:SetSize(18, 18)
    newTexture:SetTexture("Interface/Icons/INV_Scroll_11")
end

local function updateFramePositionAndHeightOnDrag(professionFrame, mainFrameWidth)
    rm.mainFrame:RegisterForDrag("LeftButton", "RightButton")
    rm.mainFrame:SetResizeBounds(mainFrameWidth, 296, mainFrameWidth, 700)
    rm.mainFrame:SetScript("OnDragStart", function(self, button)
        if button == "LeftButton" then
            self:StartMoving()
        elseif button == "RightButton" then
            self:StartSizing()
        end
    end)
end

local function saveFramePositionOnDragStop(professionFrame)
    rm.mainFrame:SetScript("OnDragStop", function(self)
        local _, _, _, xOffset, yOffset = self:GetPoint()
        self:StopMovingOrSizing()
        rm.setPreference("mainFrameOffsets", {xOffset, yOffset})
        rm.setPreference("mainFrameHeight", rm.mainFrame:GetHeight())
    end)
end

local function setFrameMovableAndResizable(professionFrame, mainFrameWidth)
    rm.mainFrame:SetSize(1, rm.getPreference("mainFrameHeight"))
    rm.mainFrame:ClearAllPoints()
    rm.mainFrame:SetPoint("TOPLEFT", professionFrame, unpack(rm.getPreference("mainFrameOffsets")))
    rm.mainFrame:SetMovable(true)
    rm.mainFrame:SetResizable(true)
    updateFramePositionAndHeightOnDrag(professionFrame, mainFrameWidth)
    saveFramePositionOnDragStop(professionFrame)
end

local function updateSizesAndOffsetsBasedOnParent(professionFrame, mainFrameWidth)
    if professionFrame == SkilletFrame then
        yOffset = 0
        F.offsets.mainX = 0
        F.offsets.mainTop = 0
        F.offsets.mainBottom = 0
        F.offsets.headerY = -33
        F.offsets.restoreButtonX = 0
        F.offsets.restoreButtonY = 1.5
        F.sizes.headerTextureHeight = 40
    end
    if professionFrame == UIParent then -- TSM is enabled
        replaceHideFrameButtonWithScrollTexture()
        setFrameMovableAndResizable(professionFrame, mainFrameWidth)
    else
        anchorFrameToProfessionFrame(professionFrame)
    end
end

local function setParentDependentFramesPosition()
    local professionFrame = rm.getProfessionFrame()
    if professionFrame then
        local mainFrameWidth = rm.mainFrame:GetWidth()
        updateSizesAndOffsetsBasedOnParent(professionFrame, mainFrameWidth)
        rm.mainFrame:SetFrameStrata(professionFrame:GetFrameStrata())
    end
end

local function updateProgressBarColor()
    if rm.progressBar:GetValue() < 100 then
        rm.progressBar:SetStatusBarColor(unpack(rm.getPreference("progressColor")))
        return
    end
    rm.progressBar:SetStatusBarColor(unpack(F.colors.progressComplete))
end

local function getSpecializationDisplayName()
    local specialization = rm.getSavedSpecializationByName(rm.displayedProfession)
    if specialization then
        return " - "..GetSpellInfo(specialization)
    end
    return ""
end

function rm.updateProgressBar()
    if rm.learnedPercentage > 100 then -- Avoids an error when using the add-on for the first time
        return
    end
    local progress = rm.learnedRecipesCount.."/"..rm.totalRecipesCount
    local specialization = getSpecializationDisplayName()
    rm.progressBar:SetValue(rm.learnedPercentage)
    updateProgressBarColor()
    rm.progressBarText:SetText(progress.." ("..rm.learnedPercentage.."%)"..specialization)
end

function rm.updateRecipesFrameElementsPosition()
    local yOffset = 0
    local recipeSection = rm.recipeContainer.children
    for _, rowIcon in ipairs(recipeSection) do
        if rowIcon:IsShown() then
            rowIcon:SetPoint("TOP", rm.recipeContainer, "BOTTOMLEFT", F.offsets.recipeIconX, yOffset)
            yOffset = yOffset - (F.sizes.recipeIcon + rm.getPreference("iconSpacing"))
        end
    end
end

local function resetRecipeCounts()
    rm.learnedRecipesCount = 0
    rm.missingRecipesCount = 0
    rm.widestRecipeTextWidth = 0
end

local function clearRecipesFrameContent()
    local recipeSection = rm.recipeContainer.children
    for _, rowIcon in pairs(recipeSection) do
        rowIcon:Hide()
        rowIcon.associatedText:Hide()
        if rowIcon.associatedText.additionalInfo then
            rowIcon.associatedText.additionalInfo:Hide()
        end
    end
    wipe(recipeSection)
end

function rm.clearFrameContent()
    clearRecipesFrameContent()
    resetRecipeCounts()
end

function rm.showSourcesFrameElements()
    rm.hideRecipesFrameElements()
    rm.mainFrame:SetBackdrop(F.backdrops.sources)
    rm.mainFrame:SetBackdropColor(unpack(F.colors.sourcesBackground))
end

function rm.showRecipesFrameElements()
    rm.scrollFrame:Show()
    rm.progressContainer:Show()
    rm.mainFrame:SetBackdrop(F.backdrops.mainFrame)
    rm.mainFrame:SetBackdropColor(unpack(F.colors.mainBackground))
end

function rm.hideRecipesFrameElements()
    rm.scrollFrame:Hide()
    rm.progressContainer:Hide()
end

-- Ensures that no recipe text will be cropped
local function updateMainWidthBasedOnWidestRecipeName()
    local newMainFrameWidth = math.floor(rm.widestRecipeTextWidth + 68)
    if newMainFrameWidth > F.sizes.mainWidth then
        rm.mainFrame:SetWidth(newMainFrameWidth)
    else
        rm.mainFrame:SetWidth(F.sizes.mainWidth)
    end
end

function rm.updateRecipeDisplay(getSkillInfo)
    rm.clearFrameContent()
    rm.showProfessionRecipes(getSkillInfo)
    updateMainWidthBasedOnWidestRecipeName()
    rm.updateProgressBar()
end

function rm.activateTabAndDesaturateOthers(tab)
    for _, otherTab in pairs(rm.bottomTabs) do
        otherTab.active = false
        otherTab.texture:SetDesaturated(true)
    end
    tab.active = true
    tab.texture:SetDesaturated(false)
end

function rm.showRecipesFrame(getSkillInfo)
    rm.centeredText:Hide()
    rm.showRecipesFrameElements()
    setParentDependentFramesPosition()
    rm.activateTabAndDesaturateOthers(rm.recipesTab)
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

function rm.hideRecipeMasterFrame()
    if not rm.mainFrame:IsShown() and not rm.getProfessionFrame() then
        rm.restoreButton:Hide()
        return
    end
    rm.clearFrameContent()
    rm.mainFrame:Hide()
end

function rm.showCenteredText(string, color)
    rm.centeredText:SetText(string)
    rm.centeredText:SetTextColor(unpack(color))
    rm.centeredText:Show()
end

function rm.handleRecipesTabClick()
    rm.showRecipesFrameElements()
    rm.showRecipesForSpecificProfession(rm.lastDisplayedProfession)
end

function rm.handleSourcesTabClick()
    rm.showSourcesFrameElements()
    rm.showCenteredText(L.comingSoon, F.colors.green)
end

function rm.handleFishingTabClick()
    rm.showRecipesFrameElements()
    if not rm.getSavedProfessionByID(356) then -- Fishing is not learned
        rm.hideRecipesFrameElements()
        rm.showCenteredText(L.fishingNotLearned, F.colors.yellow)
        return
    end
    rm.showRecipesForSpecificProfession(L.professions[356])
end
