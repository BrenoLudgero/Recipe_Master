local addonName, rm = ...

rm.frame:RegisterEvent("ADDON_LOADED")
rm.frame:RegisterEvent("SKILL_LINES_CHANGED")
rm.frame:RegisterEvent("TRADE_SKILL_SHOW")
rm.frame:RegisterEvent("TRADE_SKILL_CLOSE")
rm.frame:RegisterEvent("CRAFT_SHOW")
rm.frame:RegisterEvent("CRAFT_CLOSE")

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

local function waitForProfessionFrame()
    while not rm.getProfessionFrame() do
        do end
    end
end

-- Happens on the first time opening Recipe Master after login
local function noRecipesDisplayed()
    return #rm.recipeContainer.children == 0
end

local function showRecipeMasterFrame(getNumSkills, getSkillInfo)
    rm.showRecipesFrame(getNumSkills, getSkillInfo) 
    if noRecipesDisplayed() then
        C_Timer.After(0.1, function() 
            rm.updateRecipeDisplay(getNumSkills, getSkillInfo) 
        end)
    end
end

local function handleProfessionFrameOpened(getNumSkills, getSkillInfo, getItemLink, getDisplayedSkill)
    rm.displayedProfession = getDisplayedSkill() -- e.g. Engineering
    rm.lastDisplayedProfession = rm.displayedProfession -- Last profession displayed before opening the fishing frame
    if rm.getProfessionID(rm.displayedProfession) then
        rm.saveNewTradeSkills(getNumSkills, getSkillInfo, getItemLink)
        waitForProfessionFrame()
        RunNextFrame(function() 
            showRecipeMasterFrame(getNumSkills, getSkillInfo) 
        end)
    end
end

local function handleProfessionFrameClosed(getNumSkills, getSkillInfo, getItemLink, getDisplayedSkill)
    -- Delayed for one frame in case TradeSkillMaster is enabled, its frame is not considered closed immediately
    RunNextFrame(function()
        if not rm.getProfessionFrame() then
            rm.hideRecipeMasterFrame()
            return
        end
    end)
    -- The tradeskill frame is still open after closing the craft frame, show recipes for it (default interface)
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
