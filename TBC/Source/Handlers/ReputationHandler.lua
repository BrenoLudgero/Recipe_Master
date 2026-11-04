local _, rm = ...
local L = rm.L

local hatedStandingID = 1

-- Reputations that only one faction can earn
local reputationFactions = {
    [941] = "Horde", -- The Mag'har
    [946] = "Alliance", -- Honor Hold
    [947] = "Horde", -- Thrallmar
    [978] = "Alliance", -- Kurenai
}

-- Reputations that exclude each other, as gaining one lowers the other
local mutuallyExclusiveReputations = {
    [932] = true, -- The Aldor
    [934] = true, -- The Scryers
}

-- Alliance / Horde if only that faction can earn the reputation, nil otherwise
function rm.getReputationFaction(factionID)
    return reputationFactions[factionID]
end

-- Detects if the character is Hated with the recipe's reputation for choosing the opposing one
-- e.g. Aldor recipes for a character devoted to The Scryers
function rm.isRecipeOfOpposingReputation(recipe)
    if not mutuallyExclusiveReputations[recipe.reputationFaction] then
        return false
    end
    local currentReputationLevel = select(3, GetFactionInfoByID(recipe.reputationFaction))
    return currentReputationLevel == hatedStandingID
end

function rm.isReputationRequirementMet(recipe)
    local currentReputationLevel = select(3, GetFactionInfoByID(recipe.reputationFaction)) or 0
    return recipe.reputationLevel <= currentReputationLevel
end

function rm.getFactionName(factionID)
    local factionName = GetFactionInfoByID(factionID)
    return factionName or L.faction
end
