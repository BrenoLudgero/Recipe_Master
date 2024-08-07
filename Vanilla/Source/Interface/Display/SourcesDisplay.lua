local _, rm = ...
local L = rm.L
local F = rm.F

local function getLocalizedSourceType(sourceType)
    local types = {
        ["drop"] = L.drop,
        ["pickpocket"] = L.pickpocket,
        ["vendor"] = L.vendor,
        ["quest"] = L.quest,
        ["unique"] = L.unique,
        ["object"] = L.object,
        ["trainer"] = L.trainer,
        ["fishing"] = L.fishing,
        ["item"] = L.item
    }
    return types[sourceType]
end

-- The first character of each column is used to sort the columns alphabetically, ensuring the order of the columns
local function getSourceColumns(sourceType)
    local columns = {
        ["drop"] = {
            "a"..L.name,
            "b"..L.level,
            "c"..L.chance,
            "d"..L.zone
        },
        ["pickpocket"] = {
            "a"..L.name,
            "b"..L.level,
            "c"..L.chance,
            "d"..L.zone
        },
        ["vendor"] = {
            "a"..L.name,
            "b"..L.price,
            "c"..L.stock,
            "d"..L.zone
        },
        ["quest"] = {
            "a"..L.name,
            "b"..L.level,
            "c"..L.minimum
        },
        ["unique"] = {
            "a"..L.name,
            "b"..L.level,
            "c"..L.zone
        },
        ["object"] = {
            "a"..L.name,
            "b"..L.chance,
            "c"..L.zone
        },
        ["trainer"] = {
            "a"..L.name,
            "b"..L.zone
        },
        ["fishing"] = {
            "a"..L.zone,
            "b"..L.chance
        },
        ["item"] = {
            "a"..L.name,
            "b"..L.chance
        }
    }
    return columns[sourceType]
end

--[[ local function isSourceForCurrentSeason(source)
    local currentSeason = rm.getSeason()
    return not source["season"] or (source["season"] == currentSeason)
end

local function storeSourceInfo(source, infoTable)
    if source and isSourceForCurrentSeason(source) then
        table.insert(infoTable, source)
    end
end ]]

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
            source = rm.getUniqueNPCInfo(sourceData)
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

function rm.showSourceColumns(columnList)
    for _, column in pairs(columnList) do
        column:Show()
    end
end

function rm.createAllRowsForSourceType(sources, columns)
    for _, source in pairs(sources) do
        rm.createSourceRow(columns, source)
    end
end

local function sortListByChance(sources)
    if sources[1][L.chance] then
        table.sort(sources, function(a, b)
            return a[L.chance] > b[L.chance]
        end)
    end
    return sources
end

local function showFirstTabRows(sources)
    for sourceType, columnList in pairs(rm.sourcesListColumns) do
        rm.showSourceColumns(columnList)
        rm.createAllRowsForSourceType(sources[sourceType], columnList)
        rm.updateListHeight()
        if sourceType == "unique" then
            rm.showUniqueSourceText(sources[sourceType][1]["instructions"])
        end
        rm.activateSourcesTabAndDeactivateOthers(sourceType)
        break
    end
end

-- trainer, vendor, quest, drop, pickpocket, object, item, fishing, unique

-- Called in RecipesFrameSetup.createChatLinkOrDisplaySourcesOnClick
function rm.showAllSources(recipe)
    rm.showUpdatedSourcesHeader(recipe)
    if recipe.sources then
        rm.clearSourcesColumns()
        rm.sourcesScrollFame:Show()
        local tabXOffset = 0
        local sources = {}
        for sourceType, source in pairs(recipe.sources) do
            local sourcesInfo = getAllSourcesInfo(sourceType, source)
            sources[sourceType] = sortListByChance(sourcesInfo)
            local sourceName = getLocalizedSourceType(sourceType)
            local sourceTab = rm.createSourceTypeTab(sourceName, sourceType, tabXOffset, sources[sourceType])
            local sourceColumns = getSourceColumns(sourceType)
            rm.sourcesListColumns[sourceType] = rm.createSourcesListColumns(sourceColumns, sourceName)
            tabXOffset = tabXOffset + sourceTab:GetWidth() + F.offsets.sourcesListTabX
        end
        showFirstTabRows(sources)
    else
        rm.showCenteredText(L.unknown, F.colors.white)
    end
end
