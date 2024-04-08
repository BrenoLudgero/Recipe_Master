local _, rm = ...

function rm.getFactionReputationStanding(factionID)
    local _, _, standingID = GetFactionInfoByID(factionID)
    if standingID == 0 then
        return "Unknown"
    elseif standingID == 1 then
        return "Hated"
    elseif standingID == 2 then
        return "Hostile"
    elseif standingID == 3 then
        return "Unfriendly"
    elseif standingID == 4 then
        return "Neutral"
    elseif standingID == 5 then
        return "Friendly"
    elseif standingID == 6 then
        return "Honored"
    elseif standingID == 7 then
        return "Revered"
    elseif standingID == 8 then
        return "Exalted"
    end
end

function rm.isReputationRequirementMet(recipe)
    local factionID = recipe.repFaction
    local currentRepLevel = rm.getFactionReputationStanding(factionID)
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
