local addonName, rm = ...

rm.frame:RegisterEvent("ADDON_LOADED")
rm.frame:RegisterEvent("UI_SCALE_CHANGED")
rm.frame:RegisterEvent("SKILL_LINES_CHANGED")
rm.frame:RegisterEvent("PLAYER_LEVEL_CHANGED")
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

function rm.handlePlayerLevelUp(event, _, newLevel)
    if event == "PLAYER_LEVEL_CHANGED" then
        rm.currentLevel = newLevel
        rm.refreshRecipesListIfOpen()
    end
end

function rm.handleRecipeLearned(event, spellID)
    if event == "NEW_RECIPE_LEARNED" then
        rm.saveNewlyLearnedSkill(spellID)
        rm.refreshRecipesListIfOpen()
    end
end

local function handleProfessionFrameOpened(getDisplayedProfessionFunction)
    rm.displayedProfession = getDisplayedProfessionFunction() -- e.g. Engineering (Localized)
    if rm.getProfessionID(rm.displayedProfession) then
        rm.saveNewTradeSkills(getItemLink)
        rm.showRecipesFrame()  
        rm.lastDisplayedProfession = rm.displayedProfession -- Used for switching to the recipes tab from another tab
    end
end

local function handleProfessionFrameClosed(getDisplayedProfessionFunction)
    if not rm.getProfessionFrame() then
        rm.hideMainFrame()
        return
    end
    -- A profession frame is still open after closing the Enchanting frame, show recipes for it
    -- Only applies for the default crafting UI
    handleProfessionFrameOpened(getDisplayedProfessionFunction)
end

function rm.handleProfessionFrame(event)
    local delayInSeconds = 0.05
    -- Delayed for a bit to ensure that RM will be displayed / closed reliably and ASAP
    if event == "TRADE_SKILL_SHOW" then
        C_Timer.After(delayInSeconds, function() 
            handleProfessionFrameOpened(GetTradeSkillLine)
        end)
    elseif event == "CRAFT_SHOW" then
        C_Timer.After(delayInSeconds, function() 
            handleProfessionFrameOpened(GetCraftDisplaySkillLine)
        end)
    elseif event == "TRADE_SKILL_CLOSE" or event == "CRAFT_CLOSE" then
        RunNextFrame(function() 
            handleProfessionFrameClosed(GetTradeSkillLine)
        end)
    end
end
