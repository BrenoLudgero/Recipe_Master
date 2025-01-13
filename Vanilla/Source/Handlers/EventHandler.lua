local addonName, rm = ...

rm.frame:RegisterEvent("ADDON_LOADED")
rm.frame:RegisterEvent("UI_SCALE_CHANGED")
rm.frame:RegisterEvent("SKILL_LINES_CHANGED")
rm.frame:RegisterEvent("NEW_RECIPE_LEARNED")
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

function rm.handleAddonLoaded(event, addon) 
    if event == "ADDON_LOADED" and addon == addonName then
        rm.cacheAllAssets()
        rm.createSavedVariables()
        rm.updateSavedVariables()
        rm.updateSavedCharacters()
        rm.createAllFrameElements()
        rm.frame:UnregisterEvent("ADDON_LOADED")
    end
end

-- Updates current professions in SavedVariables when the character's skills are updated
-- This event also fires after every login / reload
function rm.handleSkillChange(event)
    if event == "SKILL_LINES_CHANGED" then
        rm.updateCharacterProfessions()
        rm.refreshRecipesListIfOpen()
    end
end

function rm.handleRecipeLearned(event, spellID)
    if event == "NEW_RECIPE_LEARNED" then
        rm.saveNewlyLearnedSkill(spellID)
        rm.refreshRecipesListIfOpen()
    end
end

local function showMainFrame(getSkillInfo)
    rm.showRecipesFrame(getSkillInfo) 
    if rm.isRecipeListEmpty() then -- Might happen when opening Recipe Master after login
        rm.updateRecipesList(getSkillInfo)
    end
end

local function handleProfessionFrameOpened(getNumSkills, getSkillInfo, getItemLink, getDisplayedSkill)
    rm.displayedProfession = getDisplayedSkill() -- e.g. Engineering (Localized)
    if rm.getProfessionID(rm.displayedProfession) then
        rm.saveNewTradeSkills(getNumSkills, getSkillInfo, getItemLink)
        showMainFrame(getSkillInfo) 
        rm.lastDisplayedProfession = rm.displayedProfession -- Used for switching to the recipes tab from another tab
    end
end

local function handleProfessionFrameClosed(getNumSkills, getSkillInfo, getItemLink, getDisplayedSkill)
    if not rm.getProfessionFrame() then
        rm.hideMainFrame()
        return
    end
    -- A profession frame is still open after closing the Enchanting frame, show recipes for it
    -- Does not apply if Skillet or TradeSkillMaster is enabled
    handleProfessionFrameOpened(getNumSkills, getSkillInfo, getItemLink, getDisplayedSkill)
end

function rm.handleProfessionFrame(event)
    local delayInSeconds = 0.05
    -- Delayed for a bit to ensure that RM will be displayed / hidden reliably and ASAP
    if event == "TRADE_SKILL_SHOW" then
        C_Timer.After(delayInSeconds, function() 
            handleProfessionFrameOpened(GetNumTradeSkills, GetTradeSkillInfo, GetTradeSkillItemLink, GetTradeSkillLine)
        end)
    elseif event == "CRAFT_SHOW" then
        C_Timer.After(delayInSeconds, function() 
            handleProfessionFrameOpened(GetNumCrafts, GetCraftInfo, GetCraftItemLink, GetCraftDisplaySkillLine)
        end)
    elseif event == "TRADE_SKILL_CLOSE" or event == "CRAFT_CLOSE" then
        RunNextFrame(function() 
            handleProfessionFrameClosed(GetNumTradeSkills, GetTradeSkillInfo, GetTradeSkillItemLink, GetTradeSkillLine)
        end)
    end
end
