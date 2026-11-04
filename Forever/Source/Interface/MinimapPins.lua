local _, rm = ...
local F = rm.F

-- Shows the marked source's spawns on the minimap (see rm.setMarkedSource), like on the world map

-- Yards across the minimap at each zoom level (Minimap:GetZoom()), as measured by HereBeDragons
local minimapDiameters = {
    indoor = {[0] = 300, 240, 180, 120, 80, 50},
    outdoor = {[0] = 466 + 2/3, 400, 333 + 1/3, 266 + 2/6, 200, 133 + 1/3}
}

local layer -- Frame over the minimap holding the marker
local lastView = {} -- What the marker was last drawn for, so it's only redrawn when something changes

------------------------- View -------------------------
-- Add-ons that change the minimap's shape define GetMinimapShape
local function isMinimapSquare()
    return GetMinimapShape and GetMinimapShape() == "SQUARE"
end

-- The minimap turns with the player when rotation is enabled
local function getMinimapRotation()
    if GetCVar("rotateMinimap") == "1" then
        return GetPlayerFacing() or 0
    end
    return 0
end

local function getPixelsPerYard()
    local diameters = IsIndoors() and minimapDiameters.indoor or minimapDiameters.outdoor
    local diameter = diameters[Minimap:GetZoom()] or diameters[0]
    return Minimap:GetWidth() / diameter
end

local function hasViewChanged(view)
    local changed = false
    for key, value in pairs(view) do
        if lastView[key] ~= value then
            changed = true
            lastView[key] = value
        end
    end
    return changed
end

-- Player's position on the spawns' map and the map's size on the minimap
local function getMapView(uiMapID, pixelsPerYard, rotation)
    local playerX, playerY = rm.getPlayerPositionOnMap(uiMapID)
    local size = rm.getMapSizeInYards(uiMapID)
    if playerX and size then
        return {
            playerX = playerX,
            playerY = playerY,
            width = size.width * pixelsPerYard,
            height = size.height * pixelsPerYard,
            cos = math.cos(rotation),
            sin = math.sin(rotation)
        }
    end
end

-- Offset from the minimap's center in pixels, up being positive, of x and y from 0 to 1 on the spawns' map
local function getMinimapOffset(mapView, x, y)
    local east = (x - mapView.playerX) * mapView.width
    local south = (y - mapView.playerY) * mapView.height
    return (east * mapView.cos) - (south * mapView.sin), -((east * mapView.sin) + (south * mapView.cos))
end

------------------------- Area -------------------------
-- Textures are reused between updates. The mask clips them to the minimap's shape
local function getAreaTexture(textures, index, color, subLevel)
    if not textures[index] then
        local texture = layer:CreateTexture(nil, "ARTWORK", nil, subLevel)
        -- Snapping moves each edge to the nearest pixel, which can make the border a pixel wider or narrower
        texture:SetSnapToPixelGrid(false)
        texture:SetTexelSnappingBias(0)
        texture:SetColorTexture(unpack(color))
        texture:AddMaskTexture(layer.mask)
        textures[index] = texture
    end
    return textures[index]
end

-- Places the rectangles inside the minimap, expanded by margin on every side and turned with it.
-- Returns the number of textures used
local function showRectangles(textures, count, rectangles, mapView, color, subLevel, margin, rotation)
    local radius = Minimap:GetWidth() / 2
    for _, rectangle in ipairs(rectangles) do
        local x, y = getMinimapOffset(mapView, (rectangle.left + rectangle.right) / 2, (rectangle.top + rectangle.bottom) / 2)
        local width = ((rectangle.right - rectangle.left) * mapView.width) + (2 * margin)
        local height = ((rectangle.bottom - rectangle.top) * mapView.height) + (2 * margin)
        local halfDiagonal = math.sqrt((width * width) + (height * height)) / 2
        if math.sqrt((x * x) + (y * y)) - halfDiagonal < radius * math.sqrt(2) then -- Not entirely outside a square minimap
            count = count + 1
            local texture = getAreaTexture(textures, count, color, subLevel)
            texture:SetSize(width, height)
            texture:ClearAllPoints()
            texture:SetPoint("CENTER", layer, "CENTER", x, y)
            texture:SetRotation(-rotation)
            texture:Show()
        end
    end
    return count
end

------------------------- Pin -------------------------
local function createPin()
    local pin = CreateFrame("Button", nil, layer)
    rm.createMapPinDot(pin)
    pin:RegisterForClicks("LeftButtonUp")
    pin:SetScript("OnEnter", function(self)
        rm.showMarkerTooltip(self, rm.markedSource, "ANCHOR_CURSOR")
    end)
    pin:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    pin:SetScript("OnClick", function()
        GameTooltip:Hide()
        rm.setMarkedSource(nil)
    end)
    return pin
end

-- Spawns beyond the minimap's edge are shown on it, pointing their way
local function clampToEdge(x, y)
    local radius = Minimap:GetWidth() / 2
    if isMinimapSquare() then
        return math.max(-radius, math.min(radius, x)), math.max(-radius, math.min(radius, y))
    end
    local distance = math.sqrt((x * x) + (y * y))
    if distance > radius then
        return x * radius / distance, y * radius / distance
    end
    return x, y
end

-- Returns the number of pins used
local function showPins(count, points, mapView)
    for _, point in ipairs(points) do
        count = count + 1
        layer.pins[count] = layer.pins[count] or createPin()
        local x, y = clampToEdge(getMinimapOffset(mapView, point[1] / 100, point[2] / 100))
        layer.pins[count]:ClearAllPoints()
        layer.pins[count]:SetPoint("CENTER", layer, "CENTER", x, y)
        layer.pins[count]:Show()
    end
    return count
end

------------------------- Updates -------------------------
local function hideUnused(regions, usedCount)
    for i = usedCount + 1, #regions do
        regions[i]:Hide()
    end
end

local function drawMarker()
    local fillCount, borderCount, pinCount = 0, 0, 0
    local rotation = getMinimapRotation()
    local pixelsPerYard = getPixelsPerYard()
    for uiMapID, points in pairs(rm.markedSource.pointsByMap) do
        local mapView = getMapView(uiMapID, pixelsPerYard, rotation)
        if mapView and rm.isShownAsArea(points) then
            local area = rm.getArea(points)
            fillCount = showRectangles(layer.fillTextures, fillCount, area.fill, mapView, F.colors.mapArea, 0, 0, rotation)
            -- Border lines are centered on the area's edges, and extended to close its corners
            local margin = F.sizes.mapAreaBorder / 2
            borderCount = showRectangles(layer.borderTextures, borderCount, area.border, mapView, F.colors.mapAreaBorder, 1, margin, rotation)
        elseif mapView then
            pinCount = showPins(pinCount, points, mapView)
        end
    end
    hideUnused(layer.fillTextures, fillCount)
    hideUnused(layer.borderTextures, borderCount)
    hideUnused(layer.pins, pinCount)
end

-- Runs every frame while there's a marked source, but only redraws when the player moves, turns or zooms
local function updateMarker()
    local playerMapID = C_Map.GetBestMapForUnit("player")
    local position = playerMapID and C_Map.GetPlayerMapPosition(playerMapID, "player")
    local view = {
        playerMapID = playerMapID or 0,
        x = position and position.x or -1,
        y = position and position.y or -1,
        rotation = getMinimapRotation(),
        pixelsPerYard = getPixelsPerYard()
    }
    if hasViewChanged(view) then
        drawMarker()
    end
end

local function updateMaskShape()
    local maskTexture = isMinimapSquare() and F.textures.squareMask or F.textures.circleMask
    layer.mask:SetTexture(maskTexture, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
end

local function createLayer()
    layer = CreateFrame("Frame", nil, Minimap)
    layer:SetAllPoints()
    layer.mask = layer:CreateMaskTexture()
    layer.mask:SetAllPoints()
    layer.fillTextures = {}
    layer.borderTextures = {}
    layer.pins = {}
    layer:SetScript("OnUpdate", updateMarker)
end

function rm.refreshMinimapMarker()
    if not layer then
        createLayer()
    end
    wipe(lastView) -- Redraws on the next update
    if rm.markedSource then
        updateMaskShape()
        layer:Show()
    else
        layer:Hide()
    end
end
