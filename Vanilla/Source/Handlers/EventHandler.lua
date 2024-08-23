local addonName, rm = ...

rm.frame:RegisterEvent("ADDON_LOADED")
rm.frame:RegisterEvent("PLAYER_LOGIN")
rm.frame:RegisterEvent("UI_SCALE_CHANGED")
rm.frame:RegisterEvent("SKILL_LINES_CHANGED")
rm.frame:RegisterEvent("TRADE_SKILL_SHOW")
rm.frame:RegisterEvent("TRADE_SKILL_CLOSE")
rm.frame:RegisterEvent("CRAFT_SHOW")
rm.frame:RegisterEvent("CRAFT_CLOSE")

-- Scales the interface elements based on the UI Scale setting + scale preference
-- This fires when the setting is updated and after every login / reload
function rm.handleScaleChange(event)
    if event == "UI_SCALE_CHANGED" then
        local interfaceScale = UIParent:GetEffectiveScale() + rm.getPreference("interfaceScale")
        rm.mainFrame:SetScale(interfaceScale)
        rm.restoreButton:SetScale(interfaceScale)
    end
end

function rm.handlePlayerLogin(event)
    if event == "PLAYER_LOGIN" then
        rm.frame:UnregisterEvent("ADDON_LOADED")
        rm.frame:UnregisterEvent("PLAYER_LOGIN")
    end
end

function rm.handleAddonLoaded(event, addon) 
    if event == "ADDON_LOADED" and addon == addonName then
        rm.cacheAllAssets()
        rm.createSavedVariables()
        rm.updateSavedVariables()
        rm.updateSavedCharacters()
        rm.createAllFrameElements()
    elseif event == "ADDON_LOADED" and addon == "TradeSkillMaster" then
        rm.optionsFrameElements["restoreButton"]:Hide()
    end
end

-- Updates current professions in SavedVariables when the character's skills are updated
-- This event also fires after every login / reload
function rm.handleSkillChange(event)
    if event == "SKILL_LINES_CHANGED" then
        rm.updateCharacterProfessions()
    end
end

local function showMainFrame(getSkillInfo)
    rm.showRecipesFrame(getSkillInfo) 
    C_Timer.After(0.01, function() 
        if rm.isRecipeListEmpty() then -- Might happen when opening Recipe Master after login
            rm.updateRecipeDisplay(getSkillInfo)
        end
    end)
end

local function handleProfessionFrameOpened(getNumSkills, getSkillInfo, getItemLink, getDisplayedSkill)
    rm.displayedProfession = getDisplayedSkill() -- e.g. Engineering
    if rm.getProfessionID(rm.displayedProfession) then
        rm.saveNewTradeSkills(getNumSkills, getSkillInfo, getItemLink)
        RunNextFrame(function() 
            showMainFrame(getSkillInfo) 
            rm.lastDisplayedProfession = rm.displayedProfession -- Used for switching to the recipes tab from another tab
        end)
    end
end

local function handleProfessionFrameClosed(getNumSkills, getSkillInfo, getItemLink, getDisplayedSkill)
    -- Delayed in case TradeSkillMaster or Skillet is enabled, their frames are not considered closed immediately
    C_Timer.After(0.01, function()
        if not rm.getProfessionFrame() then
            rm.hideMainFrame()
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
