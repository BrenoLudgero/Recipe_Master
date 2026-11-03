local _, rm = ...
local L = rm.L

-- Reputations that only one faction can earn
local reputationFactions = {
    [941] = "Horde", -- The Mag'har
    [946] = "Alliance", -- Honor Hold
    [947] = "Horde", -- Thrallmar
    [978] = "Alliance", -- Kurenai
}

-- Alliance / Horde if only that faction can earn the reputation, nil otherwise
function rm.getReputationFaction(factionID)
    return reputationFactions[factionID]
end

function rm.isReputationRequirementMet(recipe)
    local currentReputationLevel = select(3, GetFactionInfoByID(recipe.reputationFaction)) or 0
    return recipe.reputationLevel <= currentReputationLevel
end

function rm.getFactionName(factionID)
    local factionName = GetFactionInfoByID(factionID)
    return factionName or L.faction
end
