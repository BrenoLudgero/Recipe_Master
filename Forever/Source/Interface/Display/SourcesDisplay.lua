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
    ["trainer"] = L.teachesRecipe,
    ["fishing"] = "%s" -- The recipe's name alone, under "Fishing"
}

local displayedSources = {} -- [sourceType] = Info of each source of the displayed recipe
local displayedSourceType
local sortStates = {} -- [sourceType] = Field and order its table is sorted by, kept between recipes

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

local function getAllSourcesInfo(sourceType, recipeSource, recipeID)
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
            source = rm.getFishingInfo(sourceID, sourceData, recipeID)
        elseif sourceType == "item" then
            source = rm.getItemInfo(sourceID, sourceData)
        end
        table.insert(info, source)
    end
    return info
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

----------------------------- Sorting -----------------------------
local function removeColorsAndIcons(text)
    return (text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|T.-|t", ""))
end

-- The row's value in its sortValues (see SourceHandler) or the field's text without colors and icons.
-- Numeric text is compared as a number and other text regardless of case. nil if unknown
local function getSortValue(row, field)
    local value = row.sortValues and row.sortValues[field]
    if value == nil then
        value = row[field]
    end
    if type(value) ~= "string" then
        return value
    end
    local text = strtrim(removeColorsAndIcons(value))
    if text == "" or text == L.unknown then
        return nil
    end
    return tonumber(text) or text:lower()
end

-- nil if the values are equal. Unknown values go last and numbers before text, in both orders
local function isSortedBefore(valueA, valueB, ascending)
    if valueA == valueB then
        return nil
    elseif valueA == nil or valueB == nil then
        return valueB == nil
    elseif type(valueA) ~= type(valueB) then
        return type(valueA) == "number"
    elseif ascending then
        return valueA < valueB
    end
    return valueA > valueB
end

-- Ties are sorted by name, then by zone (e.g., a source found in multiple zones, or fishing)
local function sortRows(rows, sortState)
    table.sort(rows, function(a, b)
        local isBefore = isSortedBefore(getSortValue(a, sortState.field), getSortValue(b, sortState.field), sortState.ascending)
        if isBefore == nil then
            isBefore = isSortedBefore(getSortValue(a, "name"), getSortValue(b, "name"), true)
        end
        if isBefore == nil then
            isBefore = isSortedBefore(getSortValue(a, "zone"), getSortValue(b, "zone"), true)
        end
        return isBefore == true
    end)
end

-- How each source type's table is sorted until another column is chosen
local defaultSortStates = {
    ["trainer"] = {field = "zone", ascending = true},
    ["vendor"] = {field = "price", ascending = true},
    ["quest"] = {field = "level", ascending = true},
    ["drop"] = {field = "chance", ascending = false},
    ["pickpocket"] = {field = "chance", ascending = false},
    ["item"] = {field = "chance", ascending = false},
    ["object"] = {field = "chance", ascending = false},
    ["fishing"] = {field = "chance", ascending = false},
    ["unique"] = {field = "name", ascending = true},
}

local function getSortState(sourceType)
    local default = defaultSortStates[sourceType]
    if not sortStates[sourceType] and default then
        -- A copy, as the order is reversed when clicking the column's header
        sortStates[sourceType] = {field = default.field, ascending = default.ascending}
    end
    return sortStates[sourceType]
end

-- Clicking the header of the column the table is sorted by reverses the order
function rm.sortDisplayedSourcesBy(field)
    local sortState = getSortState(displayedSourceType)
    if sortState and sortState.field == field then
        sortState.ascending = not sortState.ascending
    else
        sortStates[displayedSourceType] = {field = field, ascending = true}
    end
    rm.showSourcesTab(displayedSourceType)
end

----------------------------- Display -----------------------------
function rm.showSourcesTab(sourceType)
    local sources = displayedSources[sourceType]
    local rows = getTableRows(sources)
    local sortState = getSortState(sourceType)
    if sortState then
        sortRows(rows, sortState)
    end
    displayedSourceType = sourceType
    rm.populateSourcesTable(columns[sourceType], rows, sortState)
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
                local sourcesInfo = getAllSourcesInfo(sourceType, recipe.sources[sourceType], recipe.ID)
                setMapPinActions(sourceType, sourcesInfo, recipe)
                displayedSources[sourceType] = sourcesInfo
                table.insert(sourceTypes, sourceType)
            end
        end
        rm.showSourcesTabs(sourceTypes)
        rm.sourcesTableArea:Show()
        rm.showSourcesTab(sourceTypes[1])
    end
end
