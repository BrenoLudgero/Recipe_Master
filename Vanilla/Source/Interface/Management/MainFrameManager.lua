local _, rm = ...
local F = rm.F

local function isDragonflightUiEnabledAndVisible()
    return DragonflightUIProfessionFrame and DragonflightUIProfessionFrame:IsVisible()
end

local function isSkilletEnabledAndVisible()
    return SkilletFrame and SkilletFrame:IsVisible()
end

local function isWiderProfessionsEnabledAndVisible()
    return CraftTradeSkillFrame and CraftTradeSkillFrame:IsVisible()
end

local function isCloudyTradeSkillEnabled()
    local isLoadedOrLoading = C_AddOns.IsAddOnLoaded("CloudyTradeSkill")
    return isLoadedOrLoading
end

local function isAlaTradeSkillEnabled()
    local isLoadedOrLoading = C_AddOns.IsAddOnLoaded("alaTradeSkill")
    return isLoadedOrLoading
end

local function isTradeSkillFrameVisible()
    return TradeSkillFrame and TradeSkillFrame:IsVisible()
end

local function isCraftFrameVisible()
    return CraftFrame and CraftFrame:IsVisible()
end

local function isTradeSkillMasterVisible()
    return rm.tradeSkillMasterFrame and rm.tradeSkillMasterFrame:IsVisible()
end

function rm.getProfessionFrame()
    if isDragonflightUiEnabledAndVisible() then
        return DragonflightUIProfessionFrame
    elseif isSkilletEnabledAndVisible() then
        return SkilletFrame
    elseif isWiderProfessionsEnabledAndVisible() then
        return CraftTradeSkillFrame
    elseif isTradeSkillMasterVisible() then
        return rm.tradeSkillMasterFrame
    elseif isTradeSkillFrameVisible() and not isCraftFrameVisible() then
        return TradeSkillFrame
    elseif isCraftFrameVisible() then
        return CraftFrame
    end
    return false
end

local function getDefaultFramesOffsets()
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

local function setDefaultFramesRestoreButtonAnchor(closeButton, exitButton, restoreButtonOffsets)
    if isCloudyTradeSkillEnabled() then
        rm.restoreButton:SetPoint("BOTTOMLEFT", exitButton, "BOTTOMRIGHT", unpack(restoreButtonOffsets))
    else
        rm.restoreButton:SetPoint("TOPLEFT", closeButton, "TOPRIGHT", unpack(restoreButtonOffsets))
    end
end

local function setFramePointsRelativeToParent(professionFrame)
    rm.mainFrame:ClearAllPoints()
    rm.restoreButton:ClearAllPoints()
    if professionFrame == DragonflightUIProfessionFrame then
        rm.restoreButton:SetPoint("TOPLEFT", professionFrame, "TOPRIGHT", 2, -1)
        rm.mainFrame:SetPoint("TOPLEFT", professionFrame, "TOPRIGHT", 2, -1)
        rm.mainFrame:SetPoint("BOTTOM", professionFrame)
    elseif professionFrame == SkilletFrame then
        rm.restoreButton:SetPoint("TOPLEFT", professionFrame, "TOPRIGHT", 0, -1)
        rm.mainFrame:SetPoint("TOPLEFT", professionFrame, "TOPRIGHT", 0, -1)
        rm.mainFrame:SetPoint("BOTTOM", professionFrame)
    elseif professionFrame == TradeSkillFrame or professionFrame == CraftFrame then
        local closeButton = (professionFrame == TradeSkillFrame) and TradeSkillFrameCloseButton or CraftFrameCloseButton
        local exitButton = (professionFrame == TradeSkillFrame) and TradeSkillCancelButton or CraftCancelButton
        local mainFrameTopOffsets, mainFrameBottomOffsets, restoreButtonOffsets = getDefaultFramesOffsets()
        setDefaultFramesRestoreButtonAnchor(closeButton, exitButton, restoreButtonOffsets)
        rm.mainFrame:SetPoint("TOPLEFT", closeButton, "TOPRIGHT", unpack(mainFrameTopOffsets))
        rm.mainFrame:SetPoint("BOTTOMLEFT", exitButton, "BOTTOMRIGHT", unpack(mainFrameBottomOffsets))
    else
        rm.restoreButton:SetPoint("TOPLEFT", professionFrame, "TOPRIGHT", 2, -1)
        rm.mainFrame:SetPoint("TOPLEFT", professionFrame, "TOPRIGHT", 2, -1)
        rm.mainFrame:SetPoint("BOTTOM", professionFrame, 0, -1)
    end
end

function rm.setParentDependentFramesPosition()
    local professionFrame = rm.getProfessionFrame()
    if professionFrame then
        setFramePointsRelativeToParent(professionFrame)
        rm.mainFrame:SetFrameStrata(professionFrame:GetFrameStrata())
        rm.restoreButton:SetFrameStrata(professionFrame:GetFrameStrata())
    end
end

-- TSM passes its crafting frame when it's shown, and nothing when it's hidden
local function onTradeSkillMasterVisibilityChanged(isVisible, frame)
    rm.tradeSkillMasterFrame = isVisible and frame or nil
    -- Waits for TSM to show the default frame when switching to it
    RunNextFrame(function()
        if rm.getProfessionFrame() then
            rm.setParentDependentFramesPosition()
        end
    end)
end

function rm.registerTradeSkillMasterCallback()
    if TSM_API then
        TSM_API.RegisterUICallback("CRAFTING", "RecipeMaster:MainFrame", onTradeSkillMasterVisibilityChanged)
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
    rm.sourcesBackButton:Hide()
    rm.sourcesTableArea:Hide()
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

local function anchorCenteredText()
    rm.centeredText:ClearAllPoints()
    if rm.recipesScrollFrame:IsShown() then
        rm.centeredText:SetPoint("TOPLEFT", rm.recipesScrollFrame)
        -- Extended over the scroll bar so that it's also centered horizontally
        rm.centeredText:SetPoint("BOTTOMRIGHT", rm.recipesScrollFrame, -F.offsets.recipesListScrollX, 0)
    else
        rm.centeredText:SetPoint("CENTER")
    end
end

function rm.showCenteredText(string, color)
    anchorCenteredText()
    rm.centeredText:SetText(string)
    rm.centeredText:SetTextColor(unpack(color))
    rm.centeredText:Show()
end
