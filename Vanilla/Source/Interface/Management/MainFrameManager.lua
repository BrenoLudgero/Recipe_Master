local _, rm = ...
local F = rm.F

local function isSkilletEnabledAndVisible()
    return SkilletFrame and SkilletFrame:IsVisible()
end

local function isTradeSkillFrameVisible()
    return TradeSkillFrame and TradeSkillFrame:IsVisible()
end

local function isCraftFrameVisible()
    return CraftFrame and CraftFrame:IsVisible()
end

local function isTradeSkillMasterEnabled()
    return TSM_API and (TSM_API.IsUIVisible("CRAFTING") or isTradeSkillFrameVisible() or isCraftFrameVisible())
end

function rm.getProfessionFrame()
    local frame = false
    if isSkilletEnabledAndVisible() then
        return SkilletFrame
    elseif isTradeSkillMasterEnabled() then
        return UIParent
    elseif isTradeSkillFrameVisible() and not isCraftFrameVisible() then
        frame = TradeSkillFrame
    elseif isCraftFrameVisible() then
        frame = CraftFrame
    end
    return frame
end

local function replaceHideFrameButtonWithScrollTexture()
    local closeButton = rm.mainFrameBorder.CloseButton
    closeButton:Disable(true)
    closeButton:Hide()
    local newTexture = rm.mainFrame:CreateTexture()
    newTexture:SetPoint("CENTER", closeButton, -0.4, 0)
    newTexture:SetSize(18, 18)
    newTexture:SetTexture("Interface/Icons/INV_Scroll_11")
end

local function updateFramePositionOrHeightOnDrag(professionFrame, mainFrameWidth)
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
    updateFramePositionOrHeightOnDrag(professionFrame, mainFrameWidth)
    saveFramePositionOnDragStop(professionFrame)
end

local function keepMainFrameHeightSameAsProfessionFrame(professionFrame, uiScale)
    xOffset = -(F.offsets.mainX * uiScale)
    rm.mainFrame:SetScript("OnUpdate", function(self, elapsed)
        self:ClearAllPoints()
        self:SetPoint("TOPLEFT", professionFrame, "TOPRIGHT", xOffset, F.offsets.mainTopY)
        self:SetPoint("BOTTOM", professionFrame, 0, F.offsets.mainBottomY)
    end)
end

local function anchorToProfessionFrame(professionFrame)
    local uiScale = UIParent:GetScale()
    local xOffset = -(F.offsets.restoreButtonX * uiScale)
    rm.restoreButton:ClearAllPoints()
    rm.restoreButton:SetPoint("TOPLEFT", professionFrame, "TOPRIGHT", xOffset, F.offsets.restoreButtonY)
    keepMainFrameHeightSameAsProfessionFrame(professionFrame, uiScale)
end

local function updateSizesAndOffsetsBasedOnParent(professionFrame, mainFrameWidth)
    if professionFrame == UIParent then -- TSM is enabled
        replaceHideFrameButtonWithScrollTexture()
        setFrameMovableAndResizable(professionFrame, mainFrameWidth)
        return
    elseif professionFrame == SkilletFrame then -- Skillet is enabled
        yOffset = 0
        F.offsets.mainX = 0
        F.offsets.mainTopY = -1.5
        F.offsets.mainBottomY = 0
        F.offsets.headerY = -33
        F.offsets.restoreButtonX = 0
        F.offsets.restoreButtonY = -1.5
        F.sizes.headerTextureHeight = 40
    end
    anchorToProfessionFrame(professionFrame)
end

function rm.setParentDependentFramesPosition()
    local professionFrame = rm.getProfessionFrame()
    if professionFrame then
        local mainFrameWidth = rm.mainFrame:GetWidth()
        updateSizesAndOffsetsBasedOnParent(professionFrame, mainFrameWidth)
        rm.mainFrame:SetFrameStrata(professionFrame:GetFrameStrata())
    end
end

local function resetRecipeCounts()
    rm.learnedRecipesCount = 0
    rm.missingRecipesCount = 0
    rm.widestRecipeTextWidth = 0
end

function rm.clearFrameContent()
    rm.clearRecipesFrameContent()
    rm.clearSourcesFrameContent()
    resetRecipeCounts()
end

function rm.hideRecipesFrameElements()
    rm.recipesScrollFrame:Hide()
    rm.progressContainer:Hide()
end

function rm.hideSourcesFrameElements()
    rm.sourcesHeader.recipeIcon:Hide()
    rm.sourcesHeader.recipeName:Hide()
    rm.sourcesScrollFame:Hide()
    rm.uniqueSourceText:Hide()
    rm.sourcesInstructions:Hide()
end

function rm.hideMainFrame()
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
