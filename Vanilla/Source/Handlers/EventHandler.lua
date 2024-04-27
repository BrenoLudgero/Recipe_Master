local addonName, rm = ...
rm.frame:RegisterEvent("ADDON_LOADED")
rm.frame:RegisterEvent("SKILL_LINES_CHANGED")
rm.frame:RegisterEvent("TRADE_SKILL_SHOW")
rm.frame:RegisterEvent("TRADE_SKILL_CLOSE")
rm.frame:RegisterEvent("CRAFT_SHOW")
rm.frame:RegisterEvent("CRAFT_CLOSE")

function rm.handleAddonLoaded(event, addon) 
    if event == "ADDON_LOADED" and addon == addonName then
        rm.cacheAllRecipes()
        rm.cacheAllRecipes = nil
        rm.cacheAllTradeSkills()
        rm.cacheAllTradeSkills = nil
        rm.createSavedVariables()
        rm.createSavedVariables = nil
        rm.updateSavedVariables()
        rm.updateSavedVariables = nil
        rm.updateSavedCharacters()
        rm.updateSavedCharacters = nil
        rm.createAllFrames()
        rm.createAllFrames = nil
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

local function handleWindowOpened(getNumSkills, getSkillInfo, getItemLink, getDisplayedSkill)
    rm.displayedProfession = getDisplayedSkill() -- e.g. Engineering
    rm.lastDisplayedProfession = rm.displayedProfession -- Last profession displayed before opening the fishing tab
    if rm.getProfessionID(rm.displayedProfession) then
        rm.saveNewTradeSkills(getNumSkills, getSkillInfo, getItemLink)
        while not rm.getProfessionFrame() do -- Wait for a skill window to be available
            do end
        end
        RunNextFrame(function() rm.showRecipesFrame(getNumSkills, getSkillInfo) end)
    end
end

function rm.handleProfessionWindowOpened(event)
    if event == "TRADE_SKILL_SHOW" then
        handleWindowOpened(GetNumTradeSkills, GetTradeSkillInfo, GetTradeSkillItemLink, GetTradeSkillLine)
    elseif event == "CRAFT_SHOW" then
        handleWindowOpened(GetNumCrafts, GetCraftInfo, GetCraftItemLink, GetCraftDisplaySkillLine)
    elseif event == "TRADE_SKILL_CLOSE" or event == "CRAFT_CLOSE" then
        -- A trade skill window is still opened after closing the craft window, show recipes for it
        -- Delayed for one frame in case TradeSkillMaster is enabled, its frame is not considered closed immediately
        RunNextFrame(function()
            if not rm.getProfessionFrame() then
                rm.hideRecipeMasterFrame()
                return
            end
        end)
        handleWindowOpened(GetNumTradeSkills, GetTradeSkillInfo, GetTradeSkillItemLink, GetTradeSkillLine)
    end
end
