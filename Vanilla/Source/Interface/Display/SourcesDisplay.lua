local _, rm = ...
local L = rm.L
local F = rm.F

local columns = {
    ["trainer"] = {
        L.name,
        L.zone
    },
    ["vendor"] = {
        L.name,
        L.price,
        L.stock,
        L.zone
    },
    ["quest"] = {
        L.name,
        L.level,
        L.minimum
    },
    ["drop"] = {
        L.name,
        L.level,
        L.chance,
        L.zone
    },
    ["pickpocket"] = {
        L.name,
        L.level,
        L.chance,
        L.zone
    },
    ["item"] = {
        L.name,
        L.chance
    },
    ["object"] = {
        L.name,
        L.chance,
        L.zone
    },
    ["fishing"] = {
        L.zone,
        L.chance
    },
    ["unique"] = {
        L.name,
        L.level,
        L.zone
    }
}

local function getSourceColumns(sourceType)
    return columns[sourceType]
end

local function getAllSourcesInfo(sourceType, recipeSource)
    local info = {}
    for sourceID, sourceData in pairs(recipeSource) do
        local source = nil
        if sourceType == "drop" or sourceType == "pickpocket" then
            source = rm.getCreatureInfo(sourceID, sourceData)
        elseif sourceType == "vendor" then
            source = rm.getVendorInfo(sourceID, sourceData)
        elseif sourceType == "quest" then
            source = rm.getQuestInfo(sourceID)
        elseif sourceType == "unique" then
            source = rm.getUniqueInfo(sourceData)
        elseif sourceType == "object" then
            source = rm.getObjectInfo(sourceID, sourceData)
        elseif sourceType == "trainer" then
            source = rm.getTrainerInfo(sourceID)
        elseif sourceType == "fishing" then
            source = rm.getFishingInfo(sourceID, sourceData)
        elseif sourceType == "item" then
            source = rm.getItemInfo(sourceID, sourceData)
        end
        table.insert(info, source)
    end
    return info
end

local function sortListByChance(sources)
    if sources[1][L.chance] then
        table.sort(sources, function(a, b)
            return a[L.chance] > b[L.chance]
        end)
    end
    return sources
end

local function showSourceColumns(columnList)
    for _, column in pairs(columnList) do
        column:Show()
    end
end

function rm.showTabRows(sources, sourceType, columnList)
    showSourceColumns(columnList)
    if sources[sourceType] then
        rm.createAllRowsForSourceType(sources[sourceType], columnList)
    else
        rm.createAllRowsForSourceType(sources, columnList)
    end
    rm.updateListHeight()
    if sourceType == "unique" then
        rm.showUniqueSourceText(sources[sourceType][1]["instructions"])
    end
    rm.activateSourcesTabAndDeactivateOthers(sourceType)
end

local function openFirstTab(sources)
    for _, sourceType in ipairs(rm.sourcesOrder) do
        local columnList = rm.sourcesListColumns[sourceType]
        if columnList then
            rm.showTabRows(sources, sourceType, columnList)
            break
        end
    end
end

function rm.showAllSources(recipe)
    rm.showUpdatedSourcesHeader(recipe)
    if recipe.sources then
        rm.clearSourcesColumns()
        rm.sourcesScrollFame:Show()
        local tabXOffset = 0
        local sources = {}
        for _, sourceType in ipairs(rm.sourcesOrder) do
            if recipe.sources[sourceType] then
                local sourcesInfo = getAllSourcesInfo(sourceType, recipe.sources[sourceType])
                sources[sourceType] = sortListByChance(sourcesInfo)
                local sourceName = rm.getLocalizedSourceType(sourceType)
                local sourceTab = rm.createSourceTypeTab(sourceName, sourceType, tabXOffset, sources[sourceType])
                local columnList = getSourceColumns(sourceType)
                rm.sourcesListColumns[sourceType] = rm.createSourcesListColumns(columnList, sourceName)
                tabXOffset = tabXOffset + sourceTab:GetWidth() + F.offsets.sourcesListTabX
            end
        end
        openFirstTab(sources)
    end
end
