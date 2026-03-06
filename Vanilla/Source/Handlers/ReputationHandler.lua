local _, rm = ...
local L = rm.L

function rm.isReputationRequirementMet(recipe)
    local currentReputationLevel = select(3, GetFactionInfoByID(recipe.reputationFaction)) or 0
    return recipe.reputationLevel <= currentReputationLevel
end

function rm.getFactionName(factionID)
    local factionName = GetFactionInfoByID(factionID)
    return factionName or L.faction
end
