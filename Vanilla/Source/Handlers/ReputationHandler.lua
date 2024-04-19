local _, rm = ...

local function getFactionReputationLevel(factionID)
    local _, _, level = GetFactionInfoByID(factionID)
    if level == 0 then
        return "Unknown"
    elseif level == 1 then
        return "Hated"
    elseif level == 2 then
        return "Hostile"
    elseif level == 3 then
        return "Unfriendly"
    elseif level == 4 then
        return "Neutral"
    elseif level == 5 then
        return "Friendly"
    elseif level == 6 then
        return "Honored"
    elseif level == 7 then
        return "Revered"
    elseif level == 8 then
        return "Exalted"
    end
end

function rm.isReputationRequirementMet(recipe)
    local factionID = recipe.repFaction
    local currentRepLevel = getFactionReputationLevel(factionID)
    local standOrder = {
        Unknown = 0, 
        Hated = 1, 
        Hostile = 2, 
        Unfriendly = 3, 
        Neutral = 4, 
        Friendly = 5, 
        Honored = 6, 
        Revered = 7, 
        Exalted = 8
    }
    return standOrder[recipe.repLevel] <= standOrder[currentRepLevel]
end

function rm.getFactionName(factionID)
    local factionName = GetFactionInfoByID(factionID)
    return factionName
end
