local _, rm = ...

function rm.isReputationRequirementMet(recipe)
    local currentRepLevel = select(3, GetFactionInfoByID(recipe.repFaction))
    return recipe.repLevel <= currentRepLevel
end

function rm.getFactionName(factionID)
    local factionName = GetFactionInfoByID(factionID)
    return factionName
end
