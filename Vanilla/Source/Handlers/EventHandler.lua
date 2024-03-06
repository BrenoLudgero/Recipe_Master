frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("SKILL_LINES_CHANGED")
frame:RegisterEvent("TRADE_SKILL_SHOW")
frame:RegisterEvent("TRADE_SKILL_CLOSE")
frame:RegisterEvent("CRAFT_SHOW")
frame:RegisterEvent("CRAFT_CLOSE")

function handleRecipeMasterLoaded(event, addOnName) 
    if event == "ADDON_LOADED" and addOnName == "RecipeMaster" then
        isEventFirstOpen = {TRADE_SKILL_SHOW = true, CRAFT_SHOW = true}
        createRecipeMasterSavedVariables()
        createRecipeMasterSavedVariables = nil
        updateRecipeMasterSavedCharacters()
        updateRecipeMasterSavedCharacters = nil
        createAllFrames()
        createAllFrames = nil
        frame:UnregisterEvent("ADDON_LOADED")
    end
end

-- Updates current professions in SavedVariables when the character's skills are updated
-- This event also fires after every login / reload
function handleSkillChange(event)
    if event == "SKILL_LINES_CHANGED" then
        C_Timer.After(0.02, updateCharacterProfessions)
    end
end

-- Trade skills may not be available immediately after opening the profession window, hence the delays
local function handleWindowOpened(getNumSkillsFunction, getSkillInfoFunction, getItemLinkFunction, getDisplaySkillLineFunction, event)
    displayedProfession = getDisplaySkillLineFunction() -- e.g. Engineering
    lastDisplayedProfession = displayedProfession -- Last profession displayed before opening the fhisingTab
    if getProfessionID(displayedProfession) then
        if not isEventFirstOpen[event] then
            C_Timer.After(0.04, function() saveNewTradeSkills(getNumSkillsFunction, getSkillInfoFunction, getItemLinkFunction) end)
            C_Timer.After(0.1, function() showRecipesFrame(getNumSkillsFunction, getSkillInfoFunction) end)
            return
        end
        -- This ensures that the trade skills are loaded, saved and displayed on the first time opening a profession window
        isEventFirstOpen[event] = false
        C_Timer.After(0.04, function() saveNewTradeSkills(getNumSkillsFunction, getSkillInfoFunction, getItemLinkFunction) end)
        C_Timer.After(0.1, function() showRecipesFrame(getNumSkillsFunction, getSkillInfoFunction) end)
        C_Timer.After(0.11, clearWindowContent)
        C_Timer.After(0.19, function () showProfessionRecipes(getNumSkillsFunction, getSkillInfoFunction) end)
        C_Timer.After(0.2, updateProgressBar)
    end
end

function handleProfessionWindowOpened(event)
    if event == "TRADE_SKILL_SHOW" then
        handleWindowOpened(GetNumTradeSkills, GetTradeSkillInfo, GetTradeSkillItemLink, GetTradeSkillLine, event)
    elseif event == "CRAFT_SHOW" then
        handleWindowOpened(GetNumCrafts, GetCraftInfo, GetCraftItemLink, GetCraftDisplaySkillLine, event)
    elseif event == "TRADE_SKILL_CLOSE" or event == "CRAFT_CLOSE" then
        -- A trade skill window is still opened after closing the craft window, show recipes for it
        if getProfessionFrame() then
            handleWindowOpened(GetNumTradeSkills, GetTradeSkillInfo, GetTradeSkillItemLink, GetTradeSkillLine)
        else
            hideRecipeMasterFrame()
        end
    end
end
