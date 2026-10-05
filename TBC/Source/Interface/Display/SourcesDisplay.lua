local _, rm = ...
local L = rm.L

local function formatChance(chance)
    if type(chance) == "number" then
        return chance.." %"
    end
    return chance
end

-- Columns of each source type's table, from left to right
--   field:    Key of the cell's value in the source info (see SourceHandler)
--   header:   Column title
--   fill:     Takes up the width left by the other columns (one per table)
--   width:    Fixed width. Without it, the column fits its widest text
--   maxWidth: Width limit of a column that fits its text
--   align:    Text alignment. "LEFT", "CENTER" (default) or "RIGHT"
--   format:   Function converting the field's value into the cell's text
local columns = {
    ["trainer"] = {
        {field = "name", header = L.name, fill = true, align = "LEFT"},
        {field = "zone", header = L.zone, width = 130}
    },
    ["vendor"] = {
        {field = "name", header = L.name, fill = true, align = "LEFT"},
        {field = "price", header = L.price, width = 77},
        {field = "stock", header = L.stock, width = 59},
        {field = "zone", header = L.zone, maxWidth = 110}
    },
    ["quest"] = {
        {field = "name", header = L.name, fill = true, align = "LEFT"},
        {field = "level", header = L.level, width = 60},
        {field = "minimum", header = L.minimum, width = 80}
    },
    ["drop"] = {
        {field = "name", header = L.name, fill = true, align = "LEFT"},
        {field = "level", header = L.level, width = 60},
        {field = "chance", header = L.chance, width = 60, format = formatChance},
        {field = "zone", header = L.zone, width = 100}
    },
    ["pickpocket"] = {
        {field = "name", header = L.name, fill = true, align = "LEFT"},
        {field = "level", header = L.level, width = 60},
        {field = "chance", header = L.chance, width = 60, format = formatChance},
        {field = "zone", header = L.zone, width = 100}
    },
    ["item"] = {
        {field = "name", header = L.name, fill = true, align = "LEFT"},
        {field = "chance", header = L.chance, width = 80, format = formatChance}
    },
    ["object"] = {
        {field = "name", header = L.name, fill = true, align = "LEFT"},
        {field = "chance", header = L.chance, width = 60, format = formatChance},
        {field = "zone", header = L.zone, width = 130}
    },
    ["fishing"] = {
        {field = "zone", header = L.zone, fill = true, align = "LEFT"},
        {field = "chance", header = L.chance, width = 80, format = formatChance}
    },
    ["unique"] = {
        {field = "name", header = L.name, fill = true, align = "LEFT"},
        {field = "level", header = L.level, width = 60},
        {field = "zone", header = L.zone, width = 130}
    }
}

-- What each source type does with the recipe, shown on the source's map pins.
-- Quests show the NPC who starts them instead (see SourceHandler)
local mapPinActions = {
    ["drop"] = L.dropsRecipe,
    ["pickpocket"] = L.dropsRecipe,
    ["object"] = L.dropsRecipe,
    ["vendor"] = L.sellsRecipe,
    ["trainer"] = L.teachesRecipe
}

local displayedSources = {} -- [sourceType] = Info of each source of the displayed recipe

local function setMapPinActions(sourceType, sources, recipe)
    local action = mapPinActions[sourceType]
    if action then
        local _, _, _, qualityColor = C_Item.GetItemQualityColor(recipe.quality)
        local text = action:format(WrapTextInColorCode(recipe.name, qualityColor))
        for _, source in ipairs(sources) do
            source.mapPinAction = text
        end
    end
end

local function getAllSourcesInfo(sourceType, recipeSource)
    local info = {}
    for sourceID, sourceData in pairs(recipeSource) do
        local source
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

local function getSortableChance(source)
    return tonumber(source.chance) or 0 -- Unknown chances go last
end

local function sortListByChance(sources)
    if sources[1].chance then
        table.sort(sources, function(a, b)
            return getSortableChance(a) > getSortableChance(b)
        end)
    end
    return sources
end

-- A source present in multiple zones takes up one row per zone
local function getTableRows(sources)
    local rows = {}
    for _, source in ipairs(sources) do
        if source.zones then
            for _, zone in ipairs(source.zones) do
                local row = {zone = zone.name, pointsByMap = zone.pointsByMap}
                table.insert(rows, setmetatable(row, {__index = source}))
            end
        else
            table.insert(rows, source)
        end
    end
    return rows
end

function rm.showSourcesTab(sourceType)
    local sources = displayedSources[sourceType]
    rm.populateSourcesTable(columns[sourceType], getTableRows(sources))
    if sourceType == "unique" then
        rm.showUniqueSourceText(sources[1].instructions)
    else
        rm.uniqueSourceText:Hide()
    end
    rm.activateSourcesTabAndDeactivateOthers(sourceType)
end

function rm.showAllSources(recipe)
    rm.showUpdatedSourcesHeader(recipe)
    if recipe.sources then
        local sourceTypes = {}
        wipe(displayedSources)
        for _, sourceType in ipairs(rm.sourcesOrder) do
            if recipe.sources[sourceType] then
                local sourcesInfo = getAllSourcesInfo(sourceType, recipe.sources[sourceType])
                setMapPinActions(sourceType, sourcesInfo, recipe)
                displayedSources[sourceType] = sortListByChance(sourcesInfo)
                table.insert(sourceTypes, sourceType)
            end
        end
        rm.showSourcesTabs(sourceTypes)
        rm.sourcesTableArea:Show()
        rm.showSourcesTab(sourceTypes[1])
    end
end
