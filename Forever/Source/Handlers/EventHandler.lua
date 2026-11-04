local addonName, rm = ...
local L = rm.L

rm.frame:RegisterEvent("ADDON_LOADED")
rm.frame:RegisterEvent("UI_SCALE_CHANGED")
rm.frame:RegisterEvent("SKILL_LINES_CHANGED")
rm.frame:RegisterEvent("PLAYER_LEVEL_CHANGED")
rm.frame:RegisterEvent("NEW_RECIPE_LEARNED")
rm.frame:RegisterEvent("TRADE_SKILL_SHOW")
rm.frame:RegisterEvent("TRADE_SKILL_LIST_UPDATE")
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
        rm.registerTradeSkillMasterCallback()
        rm.createChatCommand()
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

function rm.handleRecipeLearned(event, skillID)
    if event == "NEW_RECIPE_LEARNED" then
        rm.saveNewlyLearnedSkill(skillID)
        rm.refreshRecipesListIfOpen()
    end
end

-- Removes focus from the search bar when clicking anywhere else (except its clear button).
-- The event is only registered while the search bar has focus (RecipesFrameSetup.lua)
function rm.handleMouseDown(event)
    if event == "GLOBAL_MOUSE_DOWN" 
    and not (rm.searchBar:IsMouseOver() or rm.searchBar.clearButton:IsMouseOver()) then
        rm.searchBar:ClearFocus()
    end
end

local function getDisplayedProfession()
    local professionInfo = C_TradeSkillUI.GetBaseProfessionInfo()
    return L.professions[professionInfo.professionID] or professionInfo.professionName
end

local function handleProfessionFrameOpened(getDisplayedProfessionFunction)
    rm.displayedProfession = getDisplayedProfessionFunction() -- e.g. Engineering (Localized)
    if rm.getProfessionID(rm.displayedProfession) 
    -- Linked and guild professions can be of a profession the character hasn't learned
    and rm.getSavedProfessionByName(rm.displayedProfession) then
        rm.saveLearnedTradeSkills()
        rm.clearSearchBar()
        rm.showRecipesFrame()  
        rm.lastDisplayedProfession = rm.displayedProfession -- Used for switching to the recipes tab from another tab
    end
end

local function handleProfessionFrameClosed(getDisplayedProfessionFunction)
    if not rm.getProfessionFrame() then
        rm.hideMainFrame()
        return
    end
    -- A profession frame is still open after closing the profession, show recipes for it
    handleProfessionFrameOpened(getDisplayedProfessionFunction)
end

-- The default profession frame's first tab is the professions book, which hides the profession without closing it
local isProfessionsBookHooked = false
local function hookProfessionsBook()
    if isProfessionsBookHooked or not (ProfessionsFrame and ProfessionsFrame.BookPage) then
        return
    end
    ProfessionsFrame.BookPage:HookScript("OnShow", function()
        RunNextFrame(function()
            handleProfessionFrameClosed(getDisplayedProfession)
        end)
    end)
    ProfessionsFrame.BookPage:HookScript("OnHide", function()
        RunNextFrame(function()
            if rm.getProfessionFrame() then
                handleProfessionFrameOpened(getDisplayedProfession)
            end
        end)
    end)
    isProfessionsBookHooked = true
end

-- The profession's recipes can finish loading after it's shown
-- The list is only refreshed when new recipes are found, as it's also updated after every craft
local function handleProfessionListUpdated()
    if rm.getProfessionFrame() and not C_TradeSkillUI.IsDataSourceChanging() and rm.saveLearnedTradeSkills() then
        rm.refreshRecipesListIfOpen()
    end
end

function rm.handleProfessionFrame(event)
    local delayInSeconds = 0.05
    -- Delayed for a bit to ensure that RM will be displayed / closed reliably and ASAP
    if event == "TRADE_SKILL_SHOW" then
        C_Timer.After(delayInSeconds, function() 
            hookProfessionsBook()
            handleProfessionFrameOpened(getDisplayedProfession)
        end)
    elseif event == "TRADE_SKILL_LIST_UPDATE" then
        handleProfessionListUpdated()
    elseif event == "TRADE_SKILL_CLOSE" then
        RunNextFrame(function() 
            handleProfessionFrameClosed(getDisplayedProfession)
        end)
    end
end
