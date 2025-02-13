local _, rm = ...
local L = rm.L
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

local function isCloudyTradeSkillEnabled()
    local isLoadedOrLoading = C_AddOns.IsAddOnLoaded("CloudyTradeSkill")
    return isLoadedOrLoading
end

local function isAlaTradeSkillEnabled()
    local isLoadedOrLoading = C_AddOns.IsAddOnLoaded("alaTradeSkill")
    return isLoadedOrLoading
end

local function isTradeSkillMasterEnabled()
    return (
        TSM_API and (
            TSM_API.IsUIVisible("CRAFTING") 
            or isTradeSkillFrameVisible() 
            or isCraftFrameVisible()
        )
    )
end

function rm.getProfessionFrame()
    if isSkilletEnabledAndVisible() then
        return SkilletFrame
    elseif isTradeSkillMasterEnabled() then
        return UIParent
    elseif isTradeSkillFrameVisible() and not isCraftFrameVisible() then
        return TradeSkillFrame
    elseif isCraftFrameVisible() then
        return CraftFrame
    end
    return false
end

local function onMainFrameDragStart(frame, button, mainFrameWidth)
    if button == "LeftButton" then
        frame:StartMoving()
    elseif button == "RightButton" then
        local isSourcesTabActive = (rm.activeTab == L.sources and #rm.sourcesList.children > 0)
        local minHeight, maxHeight = 296, 700
        local width = isSourcesTabActive and F.sizes.sourcesFrameWidth or mainFrameWidth
        rm.mainFrame:SetResizeBounds(width, minHeight, width, maxHeight)
        frame:StartSizing()
    end
end

local function onMainFrameDragStop(frame, preferenceKey)
    local _, _, _, xOffset, yOffset = frame:GetPoint()
    frame:StopMovingOrSizing()
    rm.setPreference(preferenceKey, {xOffset, yOffset})
    rm.setPreference("mainFrameHeight", rm.mainFrame:GetHeight())
end

local function onRestoreButtonDragStart(frame, button)
    if button == "LeftButton" then
        frame:StartMoving()
    end
end

local function onRestoreButtonDragStop(frame, preferenceKey)
    local _, _, _, xOffset, yOffset = frame:GetPoint()
    frame:StopMovingOrSizing()
    rm.setPreference(preferenceKey, {xOffset, yOffset})
end

local function registerMainFrameDragEvents(mainFrameWidth)
    rm.mainFrame:RegisterForDrag("LeftButton", "RightButton")
    rm.mainFrame:SetScript("OnDragStart", function(self, button)
        onMainFrameDragStart(self, button, mainFrameWidth)
    end)
    rm.mainFrame:SetScript("OnDragStop", function(self)
        onMainFrameDragStop(self, "mainFrameOffsets")
    end)
end

local function registerRestoreButtonDragEvents()
    rm.restoreButton:RegisterForDrag("LeftButton", "RightButton")
    rm.restoreButton:SetScript("OnDragStart", onRestoreButtonDragStart)
    rm.restoreButton:SetScript("OnDragStop", function(self)
        onRestoreButtonDragStop(self, "restoreButtonOffsets")
    end)
end

local function initializeMainFrame(professionFrame, mainFrameWidth)
    rm.mainFrame:SetSize(1, rm.getPreference("mainFrameHeight"))
    rm.mainFrame:ClearAllPoints()
    rm.mainFrame:SetPoint("TOPLEFT", professionFrame, unpack(rm.getPreference("mainFrameOffsets")))
    rm.mainFrame:SetMovable(true)
    rm.mainFrame:SetResizable(true)
end

local function initializeRestoreButton(professionFrame)
    rm.restoreButton:SetFrameStrata("DIALOG")
    rm.restoreButton:ClearAllPoints()
    rm.restoreButton:SetPoint("TOPLEFT", professionFrame, unpack(rm.getPreference("restoreButtonOffsets")))
    rm.restoreButton:SetMovable(true)
    rm.restoreButton:SetResizable(false)
end

local function setMainFrameMovableAndResizable(professionFrame, mainFrameWidth)
    initializeMainFrame(professionFrame, mainFrameWidth)
    registerMainFrameDragEvents(mainFrameWidth)
end

local function setRestoreButtonMovable(professionFrame)
    initializeRestoreButton(professionFrame)
    registerRestoreButtonDragEvents()
end

local function getFramesOffsets()
    local mainFrameTopOffsets = {-2, -4}
    local mainFrameBottomOffsets = {0, -6}
    local restoreButtonOffsets = {-2, -4}
    if isAlaTradeSkillEnabled() then
        mainFrameBottomOffsets = {0, -9}
        if alaTradeSkillSV.set.blz_style then -- "Blizzard style" option is enabled
            mainFrameTopOffsets = {7, -2}
            restoreButtonOffsets = {9, -2}
        else
            mainFrameTopOffsets = {12, 4}
            restoreButtonOffsets = {14, 4}
        end
    elseif isCloudyTradeSkillEnabled() then
        mainFrameTopOffsets = {30, -4}
        restoreButtonOffsets = {8, -2}
    end
    return mainFrameTopOffsets, mainFrameBottomOffsets, restoreButtonOffsets
end

local function setRestoreButtonAnchor(closeButton, exitButton, restoreButtonOffsets)
    if isCloudyTradeSkillEnabled() then
        rm.restoreButton:SetPoint("BOTTOMLEFT", exitButton, "BOTTOMRIGHT", unpack(restoreButtonOffsets))
    else
        rm.restoreButton:SetPoint("TOPLEFT", closeButton, "TOPRIGHT", unpack(restoreButtonOffsets))
    end
end

local function setFramePointsRelativeToParent(professionFrame)
    rm.restoreButton:ClearAllPoints()
    if professionFrame == SkilletFrame then
        rm.restoreButton:SetPoint("TOPLEFT", professionFrame, "TOPRIGHT", 0, -1)
        rm.mainFrame:SetPoint("TOPLEFT", professionFrame, "TOPRIGHT", 0, -1)
        rm.mainFrame:SetPoint("BOTTOM", professionFrame)
    elseif professionFrame == TradeSkillFrame or professionFrame == CraftFrame then
        local closeButton = (professionFrame == TradeSkillFrame) and TradeSkillFrameCloseButton or CraftFrameCloseButton
        local exitButton = (professionFrame == TradeSkillFrame) and TradeSkillCancelButton or CraftCancelButton
        local mainFrameTopOffsets, mainFrameBottomOffsets, restoreButtonOffsets = getFramesOffsets()
        setRestoreButtonAnchor(closeButton, exitButton, restoreButtonOffsets)
        rm.mainFrame:SetPoint("TOPLEFT", closeButton, "TOPRIGHT", unpack(mainFrameTopOffsets))
        rm.mainFrame:SetPoint("BOTTOMLEFT", exitButton, "BOTTOMRIGHT", unpack(mainFrameBottomOffsets))
    end
end

local function updatePositionBasedOnParent(professionFrame, mainFrameWidth)
    if professionFrame == UIParent then -- TSM is enabled
        setMainFrameMovableAndResizable(professionFrame, mainFrameWidth)
        setRestoreButtonMovable(professionFrame)
    else
        setFramePointsRelativeToParent(professionFrame)
    end
end

function rm.setParentDependentFramesPosition()
    local professionFrame = rm.getProfessionFrame()
    if professionFrame then
        local mainFrameWidth = rm.mainFrame:GetWidth()
        updatePositionBasedOnParent(professionFrame, mainFrameWidth)
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
