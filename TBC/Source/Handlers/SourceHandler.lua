local _, rm = ...
local L = rm.L
local F = rm.F

local localizedClassifications = {
    ["Boss"] = L.boss,
    ["Rare"] = L.rare,
    ["Elite"] = L.elite,
    ["Rare Elite"] = L.rareElite,
    ["Dungeon"] = L.dungeon
}

------------------------- Shared -------------------------
local function getFactionIcon(data)
    if data["faction"] then
        return {
            texture = F.textures.factionIcons[data["faction"]],
            textureCoords = {0, 0.95, 0, 0.95} -- Crops the texture's top and left
        }
    end
end

local function getNPCName(npc)
    return npc["names"][rm.locale] or npc["names"]["enUS"]
end

local function getLocalizedClassification(data)
    local classification = data["classification"]
    return localizedClassifications[classification] or false
end

-- The zones where the source is found. The sources table shows one row per zone
-- name: Localized zone name
-- pointsByMap: Coordinates of the source in the zone, by UiMapID (see Database/Coordinates). nil if unknown
local function getZones(subject, coordinates)
    local zones = {}
    for _, zoneID in ipairs(subject["zones"] or {}) do
        table.insert(zones, {
            name = C_Map.GetAreaInfo(zoneID) or L.unknown,
            pointsByMap = coordinates and coordinates[zoneID]
        })
    end
    if #zones == 0 then
        table.insert(zones, {name = L.unknown})
    end
    return zones
end

-- tooltips: Extra info shown when hovering over the cell of the same field
-- icon: Shown at the left of the name
local function storeCommonNPCInfo(infoTable, npcID, npc)
    infoTable.name = getNPCName(npc)
    infoTable.zones = getZones(npc, rm.npcCoordinatesDB[npcID])
    infoTable.tooltips = {level = getLocalizedClassification(npc)}
    infoTable.icon = getFactionIcon(npc)
end

local function getClassificationColor(classification)
    local classificationColors = {
        ["Boss"] = F.colors.redHex,
        ["Rare"] = F.colors.cadetBlueHex,
        ["Elite"] = F.colors.orangeHex,
        ["Rare Elite"] = F.colors.lightPurpleHex,
        ["Dungeon"] =  F.colors.tanHex
    }
    return classificationColors[classification] or F.colors.whiteHex
end

local function getColoredLevelBasedOnClassification(data)
    local classification = data["classification"]
    local level = data["level"] or L.unknown
    local classificationColor = getClassificationColor(classification)
    return WrapTextInColorCode(level, classificationColor)
end

------------------------- Drop, Pickpocket -------------------------
function rm.getCreatureInfo(sourceID, sourceData)
    local npcInfo = {}
    local npc = rm.npcDB[sourceID]
    storeCommonNPCInfo(npcInfo, sourceID, npc)
    npcInfo.level = getColoredLevelBasedOnClassification(npc)
    npcInfo.chance = sourceData
    return npcInfo
end

------------------------- Vendor -------------------------
local function getCost(cost, currencySuffix)
    return tonumber(cost:match("(%d+)"..currencySuffix)) or 0
end

local function getCurrencyIcon(texture)
    return "|T"..texture..":11:10:2:0.5:64:64:4:60:4:60|t"
end

local function getFormattedCost(cost)
    local goldAmount = getCost(cost, "gld")
    local silverAmount = getCost(cost, "svr")
    local copperAmount = getCost(cost, "cpr")
    local engineeringExchangeTicket = getCost(cost, "eet")
    local tarnishedUndermineReal = getCost(cost, "tur")
    local formattedCost = ""
    if goldAmount > 0 then
        formattedCost = formattedCost.." "..goldAmount..getCurrencyIcon(F.textures.goldCoin)
    end
    if silverAmount > 0 then
        formattedCost = formattedCost.." "..silverAmount..getCurrencyIcon(F.textures.silverCoin)
    end
    if copperAmount > 0 then
        formattedCost = formattedCost.." "..copperAmount..getCurrencyIcon(F.textures.copperCoin)
    end
    if engineeringExchangeTicket > 0 then
        formattedCost = engineeringExchangeTicket..getCurrencyIcon(F.textures.exchangeTicket)
    end
    if tarnishedUndermineReal > 0 then
        formattedCost = tarnishedUndermineReal..getCurrencyIcon(F.textures.tarnishedUndermineReal)
    end
    return formattedCost
end

local function storeVendorSupply(sourceData, vendorInfo)
    local cost = sourceData["cost"]
    local stock = sourceData["stock"]
    if cost then
        vendorInfo.price = getFormattedCost(cost)
    else
        vendorInfo.price = L.unknown
    end
    if stock ~= nil then
        vendorInfo.stock = stock
    else
        vendorInfo.stock = L.unlimited
    end
end

function rm.getVendorInfo(sourceID, sourceData)
    local vendorInfo = {}
    local vendor = rm.npcDB[sourceID]
    storeCommonNPCInfo(vendorInfo, sourceID, vendor)
    storeVendorSupply(sourceData, vendorInfo)
    return vendorInfo
end

------------------------- Quest -------------------------
local function getClassAndRaceColor(classes, races)
    if not classes and not races then
        return F.colors.whiteHex
    elseif classes and races then
        return F.colors.yellowHex
    elseif classes then
        return F.colors.skyBlueHex
    elseif races then
        return F.colors.emeraldHex
    end
end

local function colorQuestNameIfClassRaceOrCompleted(quest, classes, races)
    if quest["completed"] then
        quest.name = WrapTextInColorCode(quest.name, F.colors.grayHex)
    else
        local classAndRaceColor = getClassAndRaceColor(classes, races)
        quest.name = WrapTextInColorCode(quest.name, classAndRaceColor)
    end
end

local function getClassName(classNumber)
    return C_CreatureInfo.GetClassInfo(classNumber).className
end

local function getFormattedClassNames(classes)
    local formattedClasses = ""
    if classes then
        formattedClasses = L.classes
        for _, classNumber in pairs(classes) do
            formattedClasses = formattedClasses..", "..getClassName(classNumber)
        end
    end
    return formattedClasses
end

local function getRaceName(raceNumber)
    return C_CreatureInfo.GetRaceInfo(raceNumber).raceName
end

local function getFormattedRaceNames(races)
    local formattedRaces = ""
    if races then
        formattedRaces = L.races
        for _, raceNumber in pairs(races) do
            formattedRaces = formattedRaces..", "..getRaceName(raceNumber)
        end
    end
    return formattedRaces
end

local function getFormattedClassAndRaceInfo(classes, races)
    local formattedInfo = ""
    formattedInfo = formattedInfo..getFormattedClassNames(classes)
    if formattedInfo == "" then
        formattedInfo = formattedInfo..getFormattedRaceNames(races)
    else
        formattedInfo = formattedInfo.."\n"..getFormattedRaceNames(races)
    end
    return formattedInfo:gsub("%%s, ", "") -- Removes every "%s, " found in formattedInfo
end

local function getQuestNameTooltip(questInfo, classesAndRaces)
    if questInfo["completed"] then
        return L.questCompleted
    elseif classesAndRaces ~= "" then
        return classesAndRaces
    end
end

-- The NPC who starts the quest, located by the quest's map button, in its first zone with coordinates.
-- mapPinAction: "Starts <questName>", shown on the NPC's map pins.
-- nil if the NPC or its coordinates are unknown
local function getQuestStarter(npcID, questName)
    local npc = rm.npcDB[npcID]
    if not npc then
        return nil
    end
    for _, zone in ipairs(getZones(npc, rm.npcCoordinatesDB[npcID])) do
        if zone.pointsByMap then
            return {
                name = getNPCName(npc),
                zone = zone.name,
                pointsByMap = zone.pointsByMap,
                mapPinAction = L.startsQuest:format(questName)
            }
        end
    end
end

function rm.getQuestInfo(sourceID)
    local questInfo = {questID = sourceID}
    local quest = rm.questDB[sourceID]
    local classes = quest["classes"]
    local races = quest["races"]
    local classesAndRaces = getFormattedClassAndRaceInfo(classes, races)
    local questName = C_QuestLog.GetQuestInfo(sourceID) or L.unknown
    questInfo.name = questName
    questInfo["completed"] = C_QuestLog.IsQuestFlaggedCompleted(sourceID)
    colorQuestNameIfClassRaceOrCompleted(questInfo, classes, races)
    questInfo.level = getColoredLevelBasedOnClassification(quest)
    questInfo.minimum = quest["requiredLevel"] or 1
    questInfo.tooltips = {
        name = getQuestNameTooltip(questInfo, classesAndRaces),
        level = getLocalizedClassification(quest)
    }
    questInfo.icon = getFactionIcon(quest)
    questInfo.starter = quest["startedByNPC"] and getQuestStarter(quest["startedByNPC"], questName)
    return questInfo
end

------------------------- Unique Sources -------------------------
function rm.getUniqueInfo(sourceID)
    local uniqueInfo = {}
    local uniqueNPC = rm.uniqueDB[sourceID]
    if uniqueNPC then
        storeCommonNPCInfo(uniqueInfo, sourceID, uniqueNPC)
        uniqueInfo.level = getColoredLevelBasedOnClassification(uniqueNPC)
    else
        uniqueInfo.name = ""
        uniqueInfo.level = ""
        uniqueInfo.zone = ""
    end
    uniqueInfo.instructions = L.uniqueSourceInstructions[sourceID][rm.locale] or L.uniqueSourceInstructions[sourceID]["enUS"]
    return uniqueInfo
end

------------------------- Object -------------------------
function rm.getObjectInfo(sourceID, sourceData)
    local objectInfo = {}
    local object = rm.objectDB[sourceID]
    objectInfo.name = object["names"][rm.locale] or object["names"]["enUS"]
    objectInfo.chance = sourceData
    objectInfo.zones = getZones(object, rm.objectCoordinatesDB[sourceID])
    return objectInfo
end

------------------------- Trainer -------------------------
function rm.getTrainerInfo(sourceID)
    local trainerInfo = {}
    local trainer = rm.npcDB[sourceID]
    storeCommonNPCInfo(trainerInfo, sourceID, trainer)
    return trainerInfo
end

------------------------- Fishing -------------------------
function rm.getFishingInfo(sourceID, sourceData)
    local info = {}
    info.zone = C_Map.GetAreaInfo(sourceID)
    info.chance = sourceData
    return info
end

------------------------- Item -------------------------
function rm.getItemInfo(sourceID, sourceData)
    local info = {}
    info.name = rm.cachedItemNames[sourceID]
    if sourceData ~= "" then
        info.chance = sourceData
    else
        info.chance = L.unknown
    end
    return info
end
