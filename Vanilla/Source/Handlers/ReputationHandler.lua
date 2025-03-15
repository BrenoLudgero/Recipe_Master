local _, rm = ...
local L = rm.L

function rm.isReputationRequirementMet(recipe)
    local currentRepLevel = select(3, GetFactionInfoByID(recipe.repFaction)) or 0
    return recipe.repLevel <= currentRepLevel
end

function rm.getFactionName(factionID)
    local factionName = GetFactionInfoByID(factionID)
    return factionName or L.faction
end
