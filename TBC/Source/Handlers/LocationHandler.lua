local _, rm = ...
local L = rm.L

-- Coordinates are percentages of the map's width (x) and height (y), as in Database/Coordinates.
-- Distances are measured in percentage of the map's width
local mapAspectRatio = 1.5 -- Width / height of every map, in yards and in pixels (1002 x 668)
local spawnRadius = 2 -- Around each spawn, the area where the source can be found
local areaCellSize = 0.5 -- Width of the squares composing an area. Smaller is smoother, but uses more textures
local maxPinsPerMap = 2 -- More spawns than this are shown as an area
local maxWaypoints = 3

local areasCache = {} -- [points] = Area around the points (see rm.getArea)
local waypoints = {} -- TomTom waypoints set by Recipe Master, replaced by the next ones

local function getDistanceSquared(x1, y1, x2, y2)
    local xDistance = x1 - x2
    local yDistance = (y1 - y2) / mapAspectRatio
    return (xDistance * xDistance) + (yDistance * yDistance)
end

------------------------- Areas -------------------------
function rm.isShownAsArea(points)
    return #points > maxPinsPerMap
end

-- Marks the cells of a grid within spawnRadius of a point. filledRows[row][column] = true
local function fillCellsAroundPoint(filledRows, point, cellWidth, cellHeight)
    local reach = math.ceil(spawnRadius / areaCellSize) -- In cells
    local pointColumn = math.floor(point[1] / cellWidth)
    local pointRow = math.floor(point[2] / cellHeight)
    for row = pointRow - reach, pointRow + reach do
        local cellCenterY = (row + 0.5) * cellHeight
        for column = pointColumn - reach, pointColumn + reach do
            local cellCenterX = (column + 0.5) * cellWidth
            if getDistanceSquared(point[1], point[2], cellCenterX, cellCenterY) <= spawnRadius * spawnRadius then
                filledRows[row] = filledRows[row] or {}
                filledRows[row][column] = true
            end
        end
    end
end

local function isFilled(filledRows, row, column)
    return filledRows[row] ~= nil and filledRows[row][column] == true
end

local function addToSet(sets, key, value)
    sets[key] = sets[key] or {}
    sets[key][value] = true
end

-- Edges between filled and empty cells, on the lines between rows and between columns.
-- horizontalEdges[rowLine][column] = true, verticalEdges[columnLine][row] = true
local function getBorderEdges(filledRows)
    local horizontalEdges, verticalEdges = {}, {}
    for row, filledColumns in pairs(filledRows) do
        for column in pairs(filledColumns) do
            if not isFilled(filledRows, row - 1, column) then
                addToSet(horizontalEdges, row, column)
            end
            if not isFilled(filledRows, row + 1, column) then
                addToSet(horizontalEdges, row + 1, column)
            end
            if not isFilled(filledRows, row, column - 1) then
                addToSet(verticalEdges, column, row)
            end
            if not isFilled(filledRows, row, column + 1) then
                addToSet(verticalEdges, column + 1, row)
            end
        end
    end
    return horizontalEdges, verticalEdges
end

-- Consecutive numbers of a set, merged into {first, last} runs so they're drawn with fewer textures
local function getRuns(numberSet)
    local numbers = {}
    for number in pairs(numberSet) do
        table.insert(numbers, number)
    end
    table.sort(numbers)
    local runs = {}
    local first = numbers[1]
    for i, number in ipairs(numbers) do
        if numbers[i + 1] ~= number + 1 then -- Last number of the run
            table.insert(runs, {first, number})
            first = numbers[i + 1]
        end
    end
    return runs
end

-- Converts edges in cells into edges from 0 to 1
local function getRectangle(left, right, top, bottom, cellWidth, cellHeight)
    return {
        left = left * cellWidth / 100,
        right = right * cellWidth / 100,
        top = top * cellHeight / 100,
        bottom = bottom * cellHeight / 100
    }
end

-- The space within spawnRadius of the points, with edges from 0 to 1:
-- fill: Rectangles covering it
-- border: Lines around it, where left == right (vertical lines) or top == bottom (horizontal lines)
-- Built from a grid of cells instead of one shape per group, so it follows any spawn pattern and its overlaps aren't darker
function rm.getArea(points)
    if not areasCache[points] then
        local cellWidth = areaCellSize
        local cellHeight = areaCellSize * mapAspectRatio -- Square in yards
        local filledRows = {}
        for _, point in ipairs(points) do
            fillCellsAroundPoint(filledRows, point, cellWidth, cellHeight)
        end
        local area = {fill = {}, border = {}, filledRows = filledRows}
        for row, filledColumns in pairs(filledRows) do
            for _, run in ipairs(getRuns(filledColumns)) do
                table.insert(area.fill, getRectangle(run[1], run[2] + 1, row, row + 1, cellWidth, cellHeight))
            end
        end
        local horizontalEdges, verticalEdges = getBorderEdges(filledRows)
        for rowLine, columns in pairs(horizontalEdges) do
            for _, run in ipairs(getRuns(columns)) do
                table.insert(area.border, getRectangle(run[1], run[2] + 1, rowLine, rowLine, cellWidth, cellHeight))
            end
        end
        for columnLine, rows in pairs(verticalEdges) do
            for _, run in ipairs(getRuns(rows)) do
                table.insert(area.border, getRectangle(columnLine, columnLine, run[1], run[2] + 1, cellWidth, cellHeight))
            end
        end
        areasCache[points] = area
    end
    return areasCache[points]
end

-- x and y from 0 to 1 on the area's map
function rm.isInArea(area, x, y)
    local column = math.floor(x * 100 / areaCellSize)
    local row = math.floor(y * 100 / (areaCellSize * mapAspectRatio))
    return isFilled(area.filledRows, row, column)
end

------------------------- Player position -------------------------
local mapSizesCache = {} -- [uiMapID] = Width and height in yards

-- The map's diagonal in world coordinates, split by the map's proportions
function rm.getMapSizeInYards(uiMapID)
    if not mapSizesCache[uiMapID] then
        local _, topLeft = C_Map.GetWorldPosFromMapPos(uiMapID, CreateVector2D(0, 0))
        local _, bottomRight = C_Map.GetWorldPosFromMapPos(uiMapID, CreateVector2D(1, 1))
        if not topLeft or not bottomRight then
            return
        end
        local diagonal = math.sqrt(((bottomRight.x - topLeft.x) ^ 2) + ((bottomRight.y - topLeft.y) ^ 2))
        local height = diagonal / math.sqrt((mapAspectRatio ^ 2) + 1)
        mapSizesCache[uiMapID] = {width = height * mapAspectRatio, height = height}
    end
    return mapSizesCache[uiMapID]
end

-- From 0 to 1 on the map, or beyond when outside it.
-- Converted through world coordinates from the map the player is on, so it works from neighboring zones.
-- Nil when the player is on another continent or in an instance
function rm.getPlayerPositionOnMap(uiMapID)
    local playerMapID = C_Map.GetBestMapForUnit("player")
    local position = playerMapID and C_Map.GetPlayerMapPosition(playerMapID, "player")
    if not position then
        return
    elseif playerMapID == uiMapID then
        return position.x, position.y
    end
    local continentID, worldPosition = C_Map.GetWorldPosFromMapPos(playerMapID, position)
    local mapContinentID = C_Map.GetWorldPosFromMapPos(uiMapID, CreateVector2D(0, 0))
    if not worldPosition or continentID ~= mapContinentID then
        return
    end
    local _, mapPosition = C_Map.GetMapPosFromWorldPos(continentID, worldPosition, uiMapID)
    if mapPosition then
        return mapPosition.x, mapPosition.y
    end
end

------------------------- Spawn groups -------------------------
local function findGroupRoot(roots, index)
    while roots[index] ~= index do
        roots[index] = roots[roots[index]]
        index = roots[index]
    end
    return index
end

local function addPointToGrid(grid, index, column, row)
    grid[column] = grid[column] or {}
    grid[column][row] = grid[column][row] or {}
    table.insert(grid[column][row], index)
end

-- Links each point to the ones closer than linkDistance, comparing it only to the points in nearby cells of a grid
local function linkNearbyPoints(points, linkDistance)
    local grid = {} -- [column][row] = Indexes of the points in the cell
    local roots = {} -- [index] = Index of a point linked to it. Linked points lead to the same root
    for i, point in ipairs(points) do
        roots[i] = i
        local column = math.floor(point[1] / linkDistance)
        local row = math.floor(point[2] / mapAspectRatio / linkDistance)
        for nearbyColumn = column - 1, column + 1 do
            for nearbyRow = row - 1, row + 1 do
                local cell = grid[nearbyColumn] and grid[nearbyColumn][nearbyRow] or {}
                for _, j in ipairs(cell) do
                    local otherPoint = points[j]
                    if getDistanceSquared(point[1], point[2], otherPoint[1], otherPoint[2]) <= linkDistance * linkDistance then
                        roots[findGroupRoot(roots, i)] = findGroupRoot(roots, j)
                    end
                end
            end
        end
        addPointToGrid(grid, i, column, row)
    end
    return roots
end

-- Spawns whose areas touch form a group, which is shown as one continuous area on the map
local function getSpawnGroups(points)
    local roots = linkNearbyPoints(points, 2 * spawnRadius)
    local groups = {}
    local groupsByRoot = {}
    for i, point in ipairs(points) do
        local root = findGroupRoot(roots, i)
        if not groupsByRoot[root] then
            groupsByRoot[root] = {}
            table.insert(groups, groupsByRoot[root])
        end
        table.insert(groupsByRoot[root], point)
    end
    return groups
end

------------------------- Waypoints -------------------------
function rm.isTomTomLoaded()
    return TomTom ~= nil and TomTom.AddWaypoint ~= nil
end

local function getClosestPoint(points, x, y)
    local closestPoint, closestDistance
    for _, point in ipairs(points) do
        local distance = getDistanceSquared(point[1], point[2], x, y)
        if not closestPoint or distance < closestDistance then
            closestPoint, closestDistance = point, distance
        end
    end
    return closestPoint, closestDistance
end

local function getGroupCenter(group)
    local sumX, sumY = 0, 0
    for _, point in ipairs(group) do
        sumX, sumY = sumX + point[1], sumY + point[2]
    end
    return sumX / #group, sumY / #group
end

-- In percentages, like the coordinates. Nil when the player isn't on the map's continent
local function getPlayerPosition(uiMapID)
    local x, y = rm.getPlayerPositionOnMap(uiMapID)
    if x then
        return x * 100, y * 100
    end
end

-- One destination per spawn group: the spawn closest to the player,
-- or the one closest to the group's center when the player isn't on the map
local function getDestinations(pointsByMap)
    local destinations = {}
    for uiMapID, points in pairs(pointsByMap) do
        local playerX, playerY = getPlayerPosition(uiMapID)
        for _, group in ipairs(getSpawnGroups(points)) do
            local destination = {uiMapID = uiMapID, size = #group}
            if playerX then
                destination.point, destination.distance = getClosestPoint(group, playerX, playerY)
            else
                destination.point = getClosestPoint(group, getGroupCenter(group))
            end
            table.insert(destinations, destination)
        end
    end
    return destinations
end

-- Closest first, then the groups with most spawns
local function sortDestinations(destinations)
    table.sort(destinations, function(a, b)
        if a.distance and b.distance then
            return a.distance < b.distance
        elseif a.distance or b.distance then
            return a.distance ~= nil
        end
        return a.size > b.size
    end)
end

local function removeWaypoints()
    for _, waypoint in ipairs(waypoints) do
        TomTom:RemoveWaypoint(waypoint)
    end
    wipe(waypoints)
end

-- source: Sources table row with the NPC's or object's name and coordinates in the row's zone, or a quest's starter
function rm.setTomTomWaypoints(source)
    removeWaypoints()
    local destinations = getDestinations(source.pointsByMap)
    sortDestinations(destinations)
    for i = 1, math.min(#destinations, maxWaypoints) do
        local destination = destinations[i]
        local x, y = destination.point[1] / 100, destination.point[2] / 100
        local waypoint = TomTom:AddWaypoint(destination.uiMapID, x, y, {
            title = source.name,
            from = L.title,
            persistent = false,
            crazy = (i == 1) -- The arrow points to the first destination
        })
        if waypoint then
            table.insert(waypoints, waypoint)
        end
    end
end

------------------------- Marked source -------------------------
-- The source shown on the world map and minimap. Only one at a time, kept until dismissed or replaced
function rm.setMarkedSource(source)
    rm.markedSource = source
    rm.refreshWorldMapMarker()
    rm.refreshMinimapMarker()
end

------------------------- World map -------------------------
-- The map the player is on, or the one with the most spawns
function rm.getMapToShow(pointsByMap)
    local playerMapID = C_Map.GetBestMapForUnit("player")
    if playerMapID and pointsByMap[playerMapID] then
        return playerMapID
    end
    local mapToShow, mostPoints = nil, 0
    for uiMapID, points in pairs(pointsByMap) do
        if #points > mostPoints then
            mapToShow, mostPoints = uiMapID, #points
        end
    end
    return mapToShow
end
