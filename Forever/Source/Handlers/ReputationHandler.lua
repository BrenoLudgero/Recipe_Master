local _, rm = ...
local L = rm.L

local hatedStandingID = 1

-- Reputations that only one faction can earn, as the other faction starts Hated with them
local reputationFactions = {
    [2586] = "Alliance", -- Azeroth Commerce Authority
    [2587] = "Horde", -- Durotar Supply and Logistics
    [2740] = "Alliance", -- Kirin Tor
    [2778] = "Horde", -- Windshapers
    [2779] = "Alliance", -- High Order
    [2782] = "Horde", -- Bolder'ok Clan
    [2787] = "Horde", -- Earthen Ring
    [2798] = "Horde", -- Darkspear Raiders
    [2799] = "Alliance", -- Theramore Expeditionary Force
    [2826] = "Alliance", -- Brotherhood of the Horse
}

-- Reputations that exclude each other, as gaining one lowers the other
local mutuallyExclusiveReputations = {
    [92] = true, -- Gelkis Clan Centaur
    [93] = true, -- Magram Clan Centaur
}

-- The character's standing with the faction (1 = Hated ... 8 = Exalted). nil if unknown
local function getCurrentReputationLevel(factionID)
    local factionData = C_Reputation.GetFactionDataByID(factionID)
    return factionData and factionData.reaction
end

-- Alliance / Horde if only that faction can earn the reputation, nil otherwise
function rm.getReputationFaction(factionID)
    return reputationFactions[factionID]
end

-- Detects if the character is Hated with the recipe's reputation for choosing the opposing one
-- e.g. Gelkis Clan Centaur recipes for a character devoted to the Magram Clan Centaur
function rm.isRecipeOfOpposingReputation(recipe)
    if not mutuallyExclusiveReputations[recipe.reputationFaction] then
        return false
    end
    local currentReputationLevel = getCurrentReputationLevel(recipe.reputationFaction)
    return currentReputationLevel == hatedStandingID
end

-- requirement: A recipe or one of its vendors (whose reputation can differ between vendors)
function rm.isReputationRequirementMet(requirement)
    local currentReputationLevel = getCurrentReputationLevel(requirement.reputationFaction) or 0
    return requirement.reputationLevel <= currentReputationLevel
end

function rm.getFactionName(factionID)
    local factionData = C_Reputation.GetFactionDataByID(factionID)
    return factionData and factionData.name or L.faction
end

-- e.g. "Requires Durotar Supply and Logistics - Honored", or "Requires Guardians of Hyjal" when its level is unknown
function rm.getReputationRequirementText(requirement)
    local factionName = rm.getFactionName(requirement.reputationFaction)
    if not requirement.reputationLevel then
        return L.requires:format(factionName)
    end
    local levelName = GetText("FACTION_STANDING_LABEL"..requirement.reputationLevel, UnitSex("player"))
    return L.requiresReputation:format(factionName, levelName)
end
