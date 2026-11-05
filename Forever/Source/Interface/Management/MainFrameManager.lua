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

-- The default profession frame's first tab is the professions book, which shows no profession
local function isProfessionsBookShown()
    return ProfessionsFrame.BookPage and ProfessionsFrame.BookPage:IsShown()
end

local function isProfessionsFrameVisible()
    return ProfessionsFrame and ProfessionsFrame:IsVisible() and not isProfessionsBookShown()
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
    elseif isProfessionsFrameVisible() then
        return ProfessionsFrame
    end
    return false
end

local function setFramePointsRelativeToParent(professionFrame)
    rm.mainFrame:ClearAllPoints()
    rm.restoreButton:ClearAllPoints()
    if professionFrame == ProfessionsFrame then
        rm.restoreButton:SetPoint("TOPLEFT", professionFrame, "TOPRIGHT", 4, 2)
        rm.mainFrame:SetPoint("TOPLEFT", professionFrame, "TOPRIGHT", 48, 0)
        rm.mainFrame:SetPoint("BOTTOM", professionFrame)
    elseif professionFrame == DragonflightUIProfessionFrame then
        rm.restoreButton:SetPoint("TOPLEFT", professionFrame, "TOPRIGHT", 2, -1)
        rm.mainFrame:SetPoint("TOPLEFT", professionFrame, "TOPRIGHT", 2, -1)
        rm.mainFrame:SetPoint("BOTTOM", professionFrame)
    elseif professionFrame == SkilletFrame then
        rm.restoreButton:SetPoint("TOPLEFT", professionFrame, "TOPRIGHT", 0, -1)
        rm.mainFrame:SetPoint("TOPLEFT", professionFrame, "TOPRIGHT", 0, -1)
        rm.mainFrame:SetPoint("BOTTOM", professionFrame)
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
