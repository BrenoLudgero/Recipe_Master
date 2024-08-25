local _, rm = ...
local L = rm.L
local F = rm.F

local function getFactionIcon(data)
    return "|T"..F.textures.factionIcons[data["faction"]]..":14.5:14.5:-1.5:-0.5:32:32:4:32:4:32|t"
end

local function shortenLongName(str, maxLength)
    if #str > maxLength + 3 then
        return string.sub(str, 1, maxLength).."..."
    end
    return str
end

local function getObjectName(object)
    local fullName = object["names"][rm.locale] or object["names"]["enUS"]
    local displayName = shortenLongName(fullName, F.sizes.sourcesCellTextLength["object"])
    return displayName, fullName
end

local function getNPCName(npc)
    local fullName = npc["names"][rm.locale] or npc["names"]["enUS"]
    local displayName = ""
    if npc["faction"] then
        displayName = getFactionIcon(npc)
    end
    displayName = displayName..shortenLongName(fullName, F.sizes.sourcesCellTextLength["npc"])
    return displayName, fullName
end

local function getQuestName(sourceID, quest)
    local fullName = C_QuestLog.GetQuestInfo(sourceID)
    local displayName = ""
    if quest["faction"] then
        displayName = getFactionIcon(quest)
    end
    if fullName then
        displayName = displayName..shortenLongName(fullName, F.sizes.sourcesCellTextLength["quest"])
    else
        displayName = displayName..L.unknown
    end
    return displayName, fullName
end

local function getZoneName(infoTable, subject)
    local fullName
    if not subject["zones"] then
        return L.unknown
    elseif #subject["zones"] == 1 then
        fullName = C_Map.GetAreaInfo(subject["zones"][1])
        return shortenLongName(fullName, F.sizes.sourcesCellTextLength["zone"]), fullName
    else
        local names = {}
        local fullNames = {}
        for _, zone in pairs(subject["zones"]) do
            fullName = C_Map.GetAreaInfo(zone)
            local shortName = shortenLongName(fullName, F.sizes.sourcesCellTextLength["zone"])
            table.insert(names, shortName)
            fullNames[shortName] = fullName
        end
        return names, fullNames
    end
end

local function getLocalizedClassification(data)
    local class = data["classification"]
    if class == "Boss" then
        return L.boss
    elseif class == "Rare" then
        return L.rare
    elseif class == "Elite" then
        return L.elite
    elseif class == "Rare Elite" then
        return L.rareElite
    elseif class == "Dungeon" then
        return L.dungeon
    end
    return false
end

local function getClassificationColor(class)
    local colors = {
        ["Boss"] = F.colors.redHex,
        ["Rare"] = F.colors.grayishBlueHex,
        ["Elite"] = F.colors.orangeHex,
        ["Rare Elite"] = F.colors.lightPurpleHex,
        ["Dungeon"] =  F.colors.lightBrownHex
    }
    return colors[class] or F.colors.whiteHex
end

local function getColoredLevelBasedOnClassification(data)
    local class = data["classification"]
    local level = data["level"] or L.unknown
    local classColor = getClassificationColor(class)
    return WrapTextInColorCode(level, classColor)
end

local function storeCommonNPCInfo(infoTable, npc)
    infoTable[L.name], infoTable["fullName"] = getNPCName(npc)
    infoTable["classification"] = getLocalizedClassification(npc)
    infoTable[L.zone], infoTable["fullZoneName"] = getZoneName(infoTable, npc)
end

local function getFormattedCost(cost)
    if not cost then
        return L.unknown
    end
    local gold = tonumber(cost:match("(%d+)g")) or 0
    local silver = tonumber(cost:match("(%d+)s")) or 0
    local copper = tonumber(cost:match("(%d+)c")) or 0
    local ticket = tonumber(cost:match("(%d+)t")) or 0
    local formattedCost = ""
    if gold > 0 then
        formattedCost = formattedCost.." "..gold.."|T"..F.textures.goldIcon..":11:10:2:0.5:64:64:4:60:4:60|t"
    end
    if silver > 0 then
        formattedCost = formattedCost.." "..silver.."|T"..F.textures.silverIcon..":11:10:2:0.5:64:64:4:60:4:60|t"
    end
    if copper > 0 then
        formattedCost = formattedCost.." "..copper.."|T"..F.textures.copperIcon..":11:10:2:0.5:64:64:4:60:4:60|t"
    end
    if ticket > 0 then
        formattedCost = formattedCost.." "..ticket.."|T"..F.textures.exchangeTicket..":11:10:2:0.5:64:64:4:60:4:60|t"
    end
    return formattedCost
end

local function storeVendorSupply(sourceData, vendorInfo)
    for dataType, value in pairs(sourceData) do
        if dataType == "cost" then
            vendorInfo[L.price] = getFormattedCost(value)
        elseif dataType == "stock" then
            vendorInfo[L.stock] = value
        end
    end
    if not sourceData["stock"] then
        vendorInfo[L.stock] = L.unlimited
    end
end

function rm.getVendorInfo(sourceID, sourceData)
    local vendorInfo = {}
    local vendor = rm.npcDB[sourceID]
    storeCommonNPCInfo(vendorInfo, vendor)
    storeVendorSupply(sourceData, vendorInfo)
    return vendorInfo
end

function rm.getCreatureInfo(sourceID, sourceData)
    local npcInfo = {}
    local npc = rm.npcDB[sourceID]
    storeCommonNPCInfo(npcInfo, npc)
    npcInfo[L.level] = getColoredLevelBasedOnClassification(npc)
    npcInfo[L.chance] = sourceData
    return npcInfo
end

function rm.getQuestInfo(sourceID)
    local questInfo = {}
    local quest = rm.questDB[sourceID]
    questInfo["classification"] = getLocalizedClassification(quest)
    questInfo[L.name], questInfo["fullName"] = getQuestName(sourceID, quest)
    questInfo[L.level] = getColoredLevelBasedOnClassification(quest)
    questInfo[L.minimum] = quest["reqLevel"]
    return questInfo
end

function rm.getUniqueNPCInfo(sourceID)
    local uniqueNPCInfo = {}
    local uniqueNPC = rm.uniqueDB[sourceID]
    storeCommonNPCInfo(uniqueNPCInfo, uniqueNPC)
    uniqueNPCInfo[L.level] = getColoredLevelBasedOnClassification(uniqueNPC)
    uniqueNPCInfo["instructions"] = L.uniqueSourceInstructions[sourceID][rm.locale]
    return uniqueNPCInfo
end

function rm.getObjectInfo(sourceID, sourceData)
    local objectInfo = {}
    local object = rm.objectDB[sourceID]
    objectInfo[L.name], objectInfo["fullName"] = getObjectName(object)
    objectInfo[L.chance] = sourceData
    objectInfo[L.zone], objectInfo["fullZoneName"] = getZoneName(objectInfo, object)
    return objectInfo
end

function rm.getTrainerInfo(sourceID)
    local trainerInfo = {}
    local trainer = rm.npcDB[sourceID]
    storeCommonNPCInfo(trainerInfo, trainer)
    return trainerInfo
end

local function getNameAndChance(getNameFunction, firstColumn, sourceID, sourceData)
    local info = {}
    local name = getNameFunction(sourceID)
    info["fullName"] = name
    info[firstColumn] = shortenLongName(name, F.sizes.sourcesCellTextLength["firstOfTwoColumns"])
    info[L.chance] = sourceData
    return info
end

function rm.getFishingInfo(sourceID, sourceData)
    return getNameAndChance(C_Map.GetAreaInfo, L.zone, sourceID, sourceData)
end

function rm.getItemInfo(sourceID, sourceData)
    return getNameAndChance(C_Item.GetItemInfo, L.name, sourceID, sourceData)
end
