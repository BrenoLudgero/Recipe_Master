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

local function keepFrameHeightSameAsProfessionWindow(professionFrame, yOffset)
    rm.mainFrame:SetScript("OnUpdate", function(self, elapsed)
        local parentScale = professionFrame:GetEffectiveScale()
        self:SetPoint("TOPLEFT", professionFrame, "TOPRIGHT", F.offsets.mainX * parentScale, F.offsets.mainY * parentScale)
        self:SetPoint("BOTTOM", professionFrame, "BOTTOM", 0, yOffset * parentScale)
    end)
end

local function anchorFrameToProfessionWindow(professionFrame, yOffset)
    rm.mainFrame:SetPoint("TOPLEFT", professionFrame, "TOPRIGHT", F.offsets.restoreButtonX, F.offsets.restoreButtonY)
    rm.restoreButton:SetPoint("LEFT", professionFrame, "TOPRIGHT", F.offsets.restoreButtonX, F.offsets.restoreButtonY)
    keepFrameHeightSameAsProfessionWindow(professionFrame, yOffset)
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
    end)
end

local function setFrameMovableAndResizable(professionFrame, mainFrameWidth)
    rm.mainFrameBorder.CloseButton:Disable(true)
    rm.mainFrame:SetSize(1, 413)
    rm.mainFrame:SetPoint("TOPLEFT", professionFrame, "TOPLEFT", unpack(rm.getPreference("mainFrameOffsets")))
    rm.mainFrame:SetMovable(true)
    rm.mainFrame:EnableMouse(true)
    rm.mainFrame:SetResizable(true)
    updateFramePositionAndHeightOnDrag(professionFrame, mainFrameWidth)
    saveFramePositionOnDragStop(professionFrame)
end

local function updateSizesAndOffsetsBasedOnParent(professionFrame, mainFrameWidth)
    local yOffset = 73
    if professionFrame == SkilletFrame then
        yOffset = 0
        F.offsets.mainX = 0
        F.offsets.mainY = 0
        F.offsets.headerY = -33
        F.offsets.restoreButtonX = 0.5
        F.offsets.restoreButtonY = -16
        F.sizes.headerTextureHeight = 40
    end
    if professionFrame == UIParent then -- TSM is enabled
        setFrameMovableAndResizable(professionFrame, mainFrameWidth)
    else
        anchorFrameToProfessionWindow(professionFrame, yOffset)
    end
    rm.mainFrame:SetFrameStrata(professionFrame:GetFrameStrata())
end

local function setParentDependentFramesPosition()
    local professionFrame = rm.getProfessionFrame()
    local mainFrameWidth = rm.mainFrame:GetWidth()
    updateSizesAndOffsetsBasedOnParent(professionFrame, mainFrameWidth)
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
    if rm.learnedPercentage > 100 then -- Happens on the first time opening a profession frame, causing an error
        return
    end
    local progress = rm.learnedRecipesCount.."/"..rm.totalRecipesCount
    local specialization = getSpecializationDisplayName()
    rm.progressBar:SetValue(rm.learnedPercentage)
    updateProgressBarColor()
    rm.progressBarText:SetText(progress.." ("..rm.learnedPercentage.."%)"..specialization)
end

function rm.updateRecipesPosition()
    local yOffset = 0
    local recipeSection = rm.recipeContainer.children
    for _, rowIcon in ipairs(recipeSection) do
        if rowIcon:IsShown() then
            rowIcon:SetPoint("TOP", rm.recipeContainer, "BOTTOMLEFT", F.offsets.recipeIconX, yOffset)
            yOffset = yOffset - (F.sizes.recipeIcon + rm.getPreference("rowSpacing"))
        end
    end
end

local function resetRecipeCounts()
    rm.displayedRecipesCount = 0
    rm.learnedRecipesCount = 0
    rm.missingRecipesCount = 0
    rm.widestRecipeTextWidth = 0
end

function rm.clearWindowContent()
    local recipeSection = rm.recipeContainer.children
    for _, rowIcon in pairs(recipeSection) do
        rowIcon:Hide()
        rowIcon.associatedText:Hide()
        rowIcon.associatedText.aditionalInfo:Hide()
    end
    wipe(recipeSection)
    resetRecipeCounts()
end

function rm.hideRecipeFrameElements()
    rm.scrollFrame:Hide()
    rm.progressContainer:Hide()
end

function rm.showDetailsTabElements()
    rm.hideRecipeFrameElements()
    rm.mainFrame:SetBackdrop(F.backdrops.details)
    rm.mainFrame:SetBackdropColor(unpack(F.colors.detailsBackground))
end

function rm.showRecipeFrameElements()
    rm.scrollFrame:Show()
    rm.progressContainer:Show()
    rm.mainFrame:SetBackdrop(F.backdrops.mainFrame)
    rm.mainFrame:SetBackdropColor(unpack(F.colors.mainBackground))
end

-- Ensures that no recipe text will be cropped
local function updateMainWidthBasedOnWidestRecipeName()
    local newMainFrameWidth = math.floor(rm.widestRecipeTextWidth + 73)
    if newMainFrameWidth >= F.sizes.mainWidth then
        rm.mainFrame:SetWidth(newMainFrameWidth)
    else
        rm.mainFrame:SetWidth(F.sizes.mainWidth)
    end
end

function rm.updateRecipeDisplay(getNumSkillsFunction, getSkillInfoFunction)
    rm.clearWindowContent()
    rm.showProfessionRecipes(getNumSkillsFunction, getSkillInfoFunction)
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

function rm.showRecipesFrame(getNumSkillsFunction, getSkillInfoFunction)
    if not rm.getProfessionFrame() then
        return
    end
    rm.centeredText:Hide()
    rm.showRecipeFrameElements()
    setParentDependentFramesPosition()
    rm.activateTabAndDesaturateOthers(rm.recipesTab)
    rm.updateRecipeDisplay(getNumSkillsFunction, getSkillInfoFunction)
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
    elseif rm.getProfessionFrame() then
        setParentDependentFramesPosition()
        return
    end
    rm.clearWindowContent()
    rm.mainFrame:Hide()
end

function rm.showCenteredText(string, color)
    rm.centeredText:SetText(string)
    rm.centeredText:SetTextColor(unpack(color))
    rm.centeredText:Show()
end
