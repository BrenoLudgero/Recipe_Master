local _, rm = ...

-- Nothing in Recipe Master runs in combat. Its code running there puts it in the call chain of
-- Blizzard UI that reads secret values (e.g. the professions book's cooldowns), which then errors
-- Each callback has an optional key: queuing the same key again replaces the earlier one,
-- so events that fire often in combat (e.g. SKILL_LINES_CHANGED) are only handled once afterwards
local queuedCallbacks = {}
local queuedCallbacksByKey = {}

function rm.runOutOfCombat(callback, key)
    if not InCombatLockdown() then
        callback()
        return
    end
    if key and queuedCallbacksByKey[key] then
        queuedCallbacksByKey[key].callback = nil
    end
    local queuedCallback = {callback = callback}
    table.insert(queuedCallbacks, queuedCallback)
    if key then
        queuedCallbacksByKey[key] = queuedCallback
    end
end

-- Wraps a callback (e.g. for C_Timer.After) so that it waits for combat to end when called in combat
function rm.outOfCombat(callback)
    return function()
        rm.runOutOfCombat(callback)
    end
end

function rm.runNextFrameOutOfCombat(callback)
    RunNextFrame(rm.outOfCombat(callback))
end

local function runQueuedCallbacks()
    local callbacks = queuedCallbacks
    queuedCallbacks = {}
    queuedCallbacksByKey = {}
    for _, queuedCallback in ipairs(callbacks) do
        if queuedCallback.callback then
            queuedCallback.callback()
        end
    end
end

-- Runs the functions below when one of the registered in-game events occur
local function handleEvent(event, ...)
    rm.handleAddonLoaded(event, ...)
    rm.handleSkillChange(event)
    rm.handleGuildRosterUpdate(event)
    rm.handlePlayerLevelUp(event, ...)
    rm.handleRecipeLearned(event, ...)
    rm.handleScaleChange(event)
    rm.handleProfessionFrame(event)
    rm.handleMouseDown(event)
end

rm.frame:RegisterEvent("PLAYER_REGEN_ENABLED")
rm.frame:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_REGEN_ENABLED" then
        runQueuedCallbacks()
    -- Recipe Master's frames and SavedVariables must exist even when reloading in combat
    elseif event == "ADDON_LOADED" then
        handleEvent(event, ...)
    else
        local arguments = {n = select("#", ...), ...}
        rm.runOutOfCombat(function()
            handleEvent(event, unpack(arguments, 1, arguments.n))
        end, event..":"..tostring(arguments[1]))
    end
end)
