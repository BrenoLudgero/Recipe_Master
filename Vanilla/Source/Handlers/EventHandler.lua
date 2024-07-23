local addonName, rm = ...

rm.frame:RegisterEvent("ADDON_LOADED")
rm.frame:RegisterEvent("UI_SCALE_CHANGED")
rm.frame:RegisterEvent("SKILL_LINES_CHANGED")
rm.frame:RegisterEvent("TRADE_SKILL_SHOW")
rm.frame:RegisterEvent("TRADE_SKILL_CLOSE")
rm.frame:RegisterEvent("CRAFT_SHOW")
rm.frame:RegisterEvent("CRAFT_CLOSE")

local function scaleInterfaceElements()
    local uiScale = UIParent:GetScale()
    rm.mainFrame:SetScale(uiScale + 0.1)
    rm.restoreButton:SetScale(uiScale + 0.1)
end

-- Adjusts all interface elements based on the user's UI Scale setting
-- This fires when the setting is updated and after every login / reload
function rm.handleScaleChange(event)
    if event == "UI_SCALE_CHANGED" then
        scaleInterfaceElements()
    end
end

function rm.handleAddonLoaded(event, addon) 
    if event == "ADDON_LOADED" and addon == addonName then
        rm.cacheAllAssets()
        rm.cacheAllAssets = nil
        rm.createSavedVariables()
        rm.createSavedVariables = nil
        rm.updateSavedVariables()
        rm.updateSavedVariables = nil
        rm.updateSavedCharacters()
        rm.updateSavedCharacters = nil
        rm.createAllFrameElements()
        rm.createAllFrameElements = nil
        rm.frame:UnregisterEvent("ADDON_LOADED")
    end
end

-- Updates current professions in SavedVariables when the character's skills are updated
-- This event also fires after every login / reload
function rm.handleSkillChange(event)
    if event == "SKILL_LINES_CHANGED" then
        rm.updateCharacterProfessions()
    end
end

-- Happens on the first time opening Recipe Master after login
local function noRecipesDisplayed()
    return #rm.recipeContainer.children == 0
end

local function showRecipeMasterFrame(getSkillInfo)
    rm.showRecipesFrame(getSkillInfo) 
    if noRecipesDisplayed() then
        C_Timer.After(0.01, function() 
            rm.updateRecipeDisplay(getSkillInfo) 
        end)
    end
end

local function handleProfessionFrameOpened(getNumSkills, getSkillInfo, getItemLink, getDisplayedSkill)
    rm.displayedProfession = getDisplayedSkill() -- e.g. Engineering
    if rm.getProfessionID(rm.displayedProfession) then
        rm.saveNewTradeSkills(getNumSkills, getSkillInfo, getItemLink)
        RunNextFrame(function() 
            showRecipeMasterFrame(getSkillInfo) 
            rm.lastDisplayedProfession = rm.displayedProfession -- Used for switching to the recipes tab from another tab
        end)
    end
end

local function handleProfessionFrameClosed(getNumSkills, getSkillInfo, getItemLink, getDisplayedSkill)
    -- Delayed in case TradeSkillMaster or Skillet is enabled, their frames are not considered closed immediately
    C_Timer.After(0.01, function()
        if not rm.getProfessionFrame() then
            rm.hideRecipeMasterFrame()
            return
        end
    end)
    -- A profession frame is still open after closing the Enchanting frame, show recipes for it
    -- Does not apply if Skillet or TradeSkillMaster is enabled
    handleProfessionFrameOpened(getNumSkills, getSkillInfo, getItemLink, getDisplayedSkill)
end

function rm.handleProfessionFrame(event)
    if event == "TRADE_SKILL_SHOW" then
        handleProfessionFrameOpened(GetNumTradeSkills, GetTradeSkillInfo, GetTradeSkillItemLink, GetTradeSkillLine)
    elseif event == "CRAFT_SHOW" then
        handleProfessionFrameOpened(GetNumCrafts, GetCraftInfo, GetCraftItemLink, GetCraftDisplaySkillLine)
    elseif event == "TRADE_SKILL_CLOSE" or event == "CRAFT_CLOSE" then
        handleProfessionFrameClosed(GetNumTradeSkills, GetTradeSkillInfo, GetTradeSkillItemLink, GetTradeSkillLine)
    end
end
