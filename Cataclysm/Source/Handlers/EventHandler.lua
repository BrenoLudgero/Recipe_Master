local addonName, rm = ...

rm.frame:RegisterEvent("ADDON_LOADED")
rm.frame:RegisterEvent("PLAYER_LOGIN")
rm.frame:RegisterEvent("UI_SCALE_CHANGED")
rm.frame:RegisterEvent("SKILL_LINES_CHANGED")
rm.frame:RegisterEvent("NEW_RECIPE_LEARNED")
rm.frame:RegisterEvent("TRADE_SKILL_SHOW")
rm.frame:RegisterEvent("TRADE_SKILL_CLOSE")

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
    elseif event == "ADDON_LOADED" and addon == "TradeSkillMaster" then
        TSM_API.RegisterUICallback("CRAFTING", "nil", function(_, tsmFrame)
            rm.registerTradeSkillMasterFrame(tsmFrame)
        end)
    end
end

function rm.handlePlayerLogin(event)
    if event == "PLAYER_LOGIN" then
        rm.frame:UnregisterEvent("ADDON_LOADED")
        rm.frame:UnregisterEvent("PLAYER_LOGIN")
    end
end

-- Updates current professions in SavedVariables when the character's skills are updated
-- This event also fires after every login / reload
function rm.handleSkillChange(event)
    if event == "SKILL_LINES_CHANGED" then
        rm.updateCharacterProfessions()
    end
end

function rm.handleRecipeLearned(event, spellID)
    if event == "NEW_RECIPE_LEARNED" then
        rm.saveNewlyLearnedSkill(spellID)
    end
end

local function showMainFrame()
    rm.showRecipesFrame()
    if rm.isRecipeListEmpty() then -- Might happen when opening Recipe Master after login
        rm.updateRecipesList()
    end
end

local function handleProfessionFrameOpened()
    rm.displayedProfession = GetTradeSkillLine() -- e.g. Engineering
    if rm.getProfessionID(rm.displayedProfession) then
        rm.saveNewTradeSkills()
        RunNextFrame(function() 
            showMainFrame() 
            rm.lastDisplayedProfession = rm.displayedProfession -- Used for switching to the recipes tab from another tab
        end)
    end
end

function rm.handleProfessionFrame(event)
    -- Delayed for 0.03 seconds to ensure that RM will be displayed reliably and ASAP
    if event == "TRADE_SKILL_SHOW" then
        C_Timer.After(0.03, handleProfessionFrameOpened)
    elseif event == "TRADE_SKILL_CLOSE" then
        rm.hideMainFrame()
    end
end
