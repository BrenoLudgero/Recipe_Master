local _, rm = ...
local F = rm.F

local tradeSkillMasterFrame = nil

function rm.registerTradeSkillMasterFrame(frame)
    tradeSkillMasterFrame = frame
end

local function isSkilletEnabledAndVisible()
    return SkilletFrame and SkilletFrame:IsVisible()
end

local function isTradeSkillFrameVisible()
    return TradeSkillFrame and TradeSkillFrame:IsVisible()
end

local function isTradeSkillMasterFrameVisible()
    return tradeSkillMasterFrame ~= nil
end

local function isCloudyTradeSkillEnabled()
    local isLoadedOrLoading = C_AddOns.IsAddOnLoaded("CloudyTradeSkill")
    return isLoadedOrLoading
end

function rm.getProfessionFrame()
    if isSkilletEnabledAndVisible() then
        return SkilletFrame
    elseif isTradeSkillMasterFrameVisible() then
        return tradeSkillMasterFrame
    elseif isTradeSkillFrameVisible() then
        return TradeSkillFrame
    end
    return false
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

local function setFramePointsRelativeToParent(professionFrame)
    rm.restoreButton:ClearAllPoints()
    if professionFrame == SkilletFrame then
        rm.restoreButton:SetPoint("TOPLEFT", professionFrame, "TOPRIGHT", 0, -1)
        rm.mainFrame:SetPoint("TOPLEFT", professionFrame, "TOPRIGHT", 0, -1)
        rm.mainFrame:SetPoint("BOTTOM", professionFrame)
    elseif professionFrame == tradeSkillMasterFrame then
        rm.restoreButton:SetPoint("TOPLEFT", professionFrame, "TOPRIGHT", 3, -1)
        rm.mainFrame:SetPoint("TOPLEFT", professionFrame, "TOPRIGHT", 3, -1)
        rm.mainFrame:SetPoint("BOTTOM", professionFrame.resizeBtn, 0, -1)
    elseif professionFrame == TradeSkillFrame then
        local restoreButtonOffsets = isCloudyTradeSkillEnabled() and {8, -2} or {-2, -4}
        local mainFrameTopOffsets = isCloudyTradeSkillEnabled() and {30, -4} or {-2, -4}
        if isCloudyTradeSkillEnabled() then
            rm.restoreButton:SetPoint("BOTTOMLEFT", TradeSkillCancelButton, "BOTTOMRIGHT", unpack(restoreButtonOffsets))
        else
            rm.restoreButton:SetPoint("TOPLEFT", TradeSkillFrameCloseButton, "TOPRIGHT", unpack(restoreButtonOffsets))
        end
        rm.mainFrame:SetPoint("TOPLEFT", TradeSkillFrameCloseButton, "TOPRIGHT", unpack(mainFrameTopOffsets))
        rm.mainFrame:SetPoint("BOTTOMLEFT", TradeSkillCancelButton, "BOTTOMRIGHT", 0, -6)
    end
end

function rm.setParentDependentFramesPosition()
    local professionFrame = rm.getProfessionFrame()
    if professionFrame then
        setFramePointsRelativeToParent(professionFrame)
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
