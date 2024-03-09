local addonName, rm = ...
rm.frame:RegisterEvent("ADDON_LOADED")
rm.frame:RegisterEvent("SKILL_LINES_CHANGED")
rm.frame:RegisterEvent("TRADE_SKILL_SHOW")
rm.frame:RegisterEvent("TRADE_SKILL_CLOSE")
rm.frame:RegisterEvent("CRAFT_SHOW")
rm.frame:RegisterEvent("CRAFT_CLOSE")

function rm.handleAddonLoaded(event, addon) 
    if event == "ADDON_LOADED" and addon == addonName then
        rm.isEventFirstOpen = {TRADE_SKILL_SHOW = true, CRAFT_SHOW = true}
        rm.createSavedVariables()
        rm.createSavedVariables = nil
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
        C_Timer.After(0.02, rm.updateCharacterProfessions)
    end
end

-- Trade skills may not be available immediately after opening the profession window, hence the delays
local function handleWindowOpened(getNumSkillsFunction, getSkillInfoFunction, getItemLinkFunction, getDisplaySkillLineFunction, event)
    rm.displayedProfession = getDisplaySkillLineFunction() -- e.g. Engineering
    rm.lastDisplayedProfession = rm.displayedProfession -- Last profession displayed before opening the fishing tab
    if rm.getProfessionID(rm.displayedProfession) then
        if not rm.isEventFirstOpen[event] then
            C_Timer.After(0.04, function() rm.saveNewTradeSkills(getNumSkillsFunction, getSkillInfoFunction, getItemLinkFunction) end)
            C_Timer.After(0.1, function() rm.showRecipesFrame(getNumSkillsFunction, getSkillInfoFunction) end)
            return
        end
        -- This ensures that the trade skills are loaded, saved and displayed on the first time opening a profession window
        rm.isEventFirstOpen[event] = false
        C_Timer.After(0.04, function() rm.saveNewTradeSkills(getNumSkillsFunction, getSkillInfoFunction, getItemLinkFunction) end)
        C_Timer.After(0.1, function() rm.showRecipesFrame(getNumSkillsFunction, getSkillInfoFunction) end)
        C_Timer.After(0.11, rm.clearWindowContent)
        C_Timer.After(0.19, function () rm.showProfessionRecipes(getNumSkillsFunction, getSkillInfoFunction) end)
        C_Timer.After(0.2, rm.updateProgressBar)
    end
end

function rm.handleProfessionWindowOpened(event)
    if event == "TRADE_SKILL_SHOW" then
        handleWindowOpened(GetNumTradeSkills, GetTradeSkillInfo, GetTradeSkillItemLink, GetTradeSkillLine, event)
    elseif event == "CRAFT_SHOW" then
        handleWindowOpened(GetNumCrafts, GetCraftInfo, GetCraftItemLink, GetCraftDisplaySkillLine, event)
    elseif event == "TRADE_SKILL_CLOSE" or event == "CRAFT_CLOSE" then
        -- A trade skill window is still opened after closing the craft window, show recipes for it
        if rm.getProfessionFrame() then
            handleWindowOpened(GetNumTradeSkills, GetTradeSkillInfo, GetTradeSkillItemLink, GetTradeSkillLine)
        else
            rm.hideRecipeMasterFrame()
        end
    end
end
