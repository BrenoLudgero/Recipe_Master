local _, rm = ...
local L = rm.L
local F = rm.F

-- The world map creates pins from the XML templates in MapPins.xml, which find their mixins by global name
local pinTemplate = "RecipeMasterMapPinTemplate"
local areaTemplate = "RecipeMasterMapAreaTemplate"

------------------------- Pin -------------------------
local function createCircle(pin, color, size, subLevel)
    local circle = pin:CreateTexture(nil, "ARTWORK", nil, subLevel)
    circle:SetSize(size, size)
    circle:SetPoint("CENTER")
    circle:SetColorTexture(unpack(color))
    local mask = pin:CreateMaskTexture()
    mask:SetAllPoints(circle)
    mask:SetTexture(F.textures.circleMask, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    circle:AddMaskTexture(mask)
end

-- Bordered dot, shared by the world map and minimap pins
function rm.createMapPinDot(pin)
    pin:SetSize(F.sizes.mapPin, F.sizes.mapPin)
    createCircle(pin, F.colors.mapPinBorder, F.sizes.mapPin, 0)
    createCircle(pin, F.colors.mapPinFill, F.sizes.mapPin - (2 * F.sizes.mapPinBorder), 1)
end

-- Shared by the pins and areas of the world map and minimap
-- mapPinAction: What the source does, e.g. "Drops Recipe: X"
function rm.showMarkerTooltip(owner, source, anchor)
    GameTooltip:SetOwner(owner, anchor)
    GameTooltip:SetText(source.name, 1, 1, 1)
    if source.mapPinAction then
        GameTooltip:AddLine(source.mapPinAction, 1, 1, 1)
    end
    GameTooltip:AddLine(source.zone)
    GameTooltip:AddLine(L.clickToDismiss, unpack(F.colors.gray))
    GameTooltip:Show()
end

local function hideTooltipIfOwnedBy(owner)
    if GameTooltip:IsOwned(owner) then
        GameTooltip:Hide()
    end
end

-- A spawn, or the entrance of the instance the source is in
RecipeMasterMapPinMixin = CreateFromMixins(MapCanvasPinMixin)

function RecipeMasterMapPinMixin:OnLoad()
    self:UseFrameLevelType("PIN_FRAME_LEVEL_AREA_POI")
    self:SetScalingLimits(1, 1, 1.2) -- Keeps its size on screen, growing a little when zooming in
    rm.createMapPinDot(self)
end

function RecipeMasterMapPinMixin:OnAcquired(x, y, source)
    self.source = source
    self:SetPosition(x, y)
end

function RecipeMasterMapPinMixin:OnReleased()
    hideTooltipIfOwnedBy(self)
end

function RecipeMasterMapPinMixin:OnMouseEnter()
    rm.showMarkerTooltip(self, self.source, "ANCHOR_RIGHT")
end

function RecipeMasterMapPinMixin:OnMouseLeave()
    GameTooltip:Hide()
end

-- The pin takes the map's clicks, so right-clicking it still zooms out
function RecipeMasterMapPinMixin:OnClick(button)
    if button == "LeftButton" then
        rm.setMarkedSource(nil)
    elseif button == "RightButton" then
        self:GetMap():NavigateToParentMap()
    end
end

------------------------- Area -------------------------
-- Where the source can be found, around its spawns.
-- It covers the whole map but ignores the mouse, so the cursor is checked against its shape instead
RecipeMasterMapAreaMixin = CreateFromMixins(MapCanvasPinMixin)

function RecipeMasterMapAreaMixin:OnLoad()
    self:UseFrameLevelType("PIN_FRAME_LEVEL_QUEST_BLOB")
    self:SetIgnoreGlobalPinScale(true) -- Scales with the map, covering the same ground at any zoom level
    self.fillTextures = {}
    self.borderTextures = {}
    self:SetScript("OnUpdate", self.UpdateHover)
end

-- Other pins above the cursor take the hover from the area
function RecipeMasterMapAreaMixin:IsCursorInArea()
    local map = self:GetMap()
    if not map:IsCanvasMouseFocus() then
        return false
    end
    local x, y = map:GetNormalizedCursorPosition()
    local mapRect = self.mapRect
    local mapX = (x - mapRect.left) / (mapRect.right - mapRect.left)
    local mapY = (y - mapRect.top) / (mapRect.bottom - mapRect.top)
    return rm.isInArea(self.area, mapX, mapY)
end

function RecipeMasterMapAreaMixin:UpdateHover()
    local isHovered = self:IsCursorInArea()
    if isHovered ~= self.isHovered then
        self.isHovered = isHovered
        if isHovered then
            rm.showMarkerTooltip(self, rm.markedSource, "ANCHOR_CURSOR")
        else
            hideTooltipIfOwnedBy(self)
        end
    end
end

function RecipeMasterMapAreaMixin:OnReleased()
    self.isHovered = false
    hideTooltipIfOwnedBy(self)
end

-- Textures are reused between areas
local function getAreaTexture(area, textures, index, color, subLevel)
    if not textures[index] then
        local texture = area:CreateTexture(nil, "ARTWORK", nil, subLevel)
        -- Snapping moves each edge to the nearest pixel, which can make the border a pixel wider or narrower
        texture:SetSnapToPixelGrid(false)
        texture:SetTexelSnappingBias(0)
        texture:SetColorTexture(unpack(color))
        textures[index] = texture
    end
    return textures[index]
end

-- Places rectangles with edges from 0 to 1 on the spawns' map, expanded by margin on every side
-- mapRect: Edges of the map of the spawns on the displayed map
function RecipeMasterMapAreaMixin:ShowRectangles(textures, rectangles, mapRect, color, subLevel, margin)
    local width, height = self:GetSize()
    local mapLeft, mapTop = mapRect.left * width, mapRect.top * height
    local mapWidth = (mapRect.right - mapRect.left) * width
    local mapHeight = (mapRect.bottom - mapRect.top) * height
    for i, rectangle in ipairs(rectangles) do
        local texture = getAreaTexture(self, textures, i, color, subLevel)
        local left = mapLeft + (rectangle.left * mapWidth) - margin
        local right = mapLeft + (rectangle.right * mapWidth) + margin
        local top = mapTop + (rectangle.top * mapHeight) - margin
        local bottom = mapTop + (rectangle.bottom * mapHeight) + margin
        texture:SetPoint("TOPLEFT", self, "TOPLEFT", left, -top)
        texture:SetPoint("BOTTOMRIGHT", self, "TOPLEFT", right, -bottom)
        texture:Show()
    end
    for i = #rectangles + 1, #textures do
        textures[i]:Hide()
    end
end

-- Covers the whole canvas, so the rectangles are placed like pins: from 0 to 1 across the map
-- area: Fill and border on the map of the spawns (see LocationHandler)
-- mapRect: Edges of the map of the spawns on the displayed map
function RecipeMasterMapAreaMixin:OnAcquired(area, mapRect)
    self.area, self.mapRect = area, mapRect
    self:SetSize(self:GetMap():GetCanvas():GetSize())
    self:ShowRectangles(self.fillTextures, area.fill, mapRect, F.colors.mapArea, 0, 0)
    -- Border lines are centered on the area's edges, and extended to close its corners
    self:ShowRectangles(self.borderTextures, area.border, mapRect, F.colors.mapAreaBorder, 1, F.sizes.mapAreaBorder / 2)
    self:SetPosition(0.5, 0.5)
end

------------------------- Data provider -------------------------
-- Shows the marked source's spawns (see rm.setMarkedSource)
local dataProvider = CreateFromMixins(MapCanvasDataProviderMixin)

local function isInsideMap(uiMapID, outerMapID)
    local mapInfo = C_Map.GetMapInfo(uiMapID)
    while mapInfo and mapInfo.parentMapID ~= 0 do
        if mapInfo.parentMapID == outerMapID then
            return true
        end
        mapInfo = C_Map.GetMapInfo(mapInfo.parentMapID)
    end
    return false
end

-- Edges of the spawns' map on the displayed map, from 0 to 1.
-- Spawns are shown on their own map and, zoomed out, on their continent's map
local function getMapRect(uiMapID, displayedMapID)
    if uiMapID == displayedMapID then
        return {left = 0, right = 1, top = 0, bottom = 1}
    end
    local displayedMap = C_Map.GetMapInfo(displayedMapID)
    if displayedMap and displayedMap.mapType == Enum.UIMapType.Continent and isInsideMap(uiMapID, displayedMapID) then
        local left, right, top, bottom = C_Map.GetMapRectOnMap(uiMapID, displayedMapID)
        return {left = left, right = right, top = top, bottom = bottom}
    end
end

function dataProvider:RemoveAllData()
    self:GetMap():RemoveAllPinsByTemplate(pinTemplate)
    self:GetMap():RemoveAllPinsByTemplate(areaTemplate)
end

function dataProvider:RefreshAllData()
    self:RemoveAllData()
    local source = rm.markedSource
    if not source then
        return
    end
    local map = self:GetMap()
    for uiMapID, points in pairs(source.pointsByMap) do
        local mapRect = getMapRect(uiMapID, map:GetMapID())
        if mapRect and rm.isShownAsArea(points) then
            map:AcquirePin(areaTemplate, rm.getArea(points), mapRect)
        elseif mapRect then
            for _, point in ipairs(points) do
                local x = mapRect.left + (point[1] / 100 * (mapRect.right - mapRect.left))
                local y = mapRect.top + (point[2] / 100 * (mapRect.bottom - mapRect.top))
                map:AcquirePin(pinTemplate, x, y, source)
            end
        end
    end
end

function dataProvider:OnHide()
    self:RemoveAllData()
end

-- Clicking an area dismisses it instead of navigating the map
local function dismissHoveredArea(map, button)
    if button == "LeftButton" then
        for area in map:EnumeratePinsByTemplate(areaTemplate) do
            if area.isHovered then
                rm.setMarkedSource(nil)
                return true
            end
        end
    end
    return false
end

local function addDataProvider()
    if not dataProvider:GetMap() then
        WorldMapFrame:AddDataProvider(dataProvider)
        WorldMapFrame:AddCanvasClickHandler(dismissHoveredArea)
    end
end

function rm.refreshWorldMapMarker()
    addDataProvider()
    dataProvider:RefreshAllData()
end

-- The map replaces a single profession window, but pushes two of them aside,
-- so they're closed beforehand, as one would be
local function closeDefaultProfessionFrames()
    if TradeSkillFrame and TradeSkillFrame:IsShown() 
    and CraftFrame and CraftFrame:IsShown() then
        HideUIPanel(TradeSkillFrame)
        HideUIPanel(CraftFrame)
    end
end

-- source: Sources table row with the NPC's or object's name, zone and coordinates in that zone.
-- OpenWorldMap(mapID) can't be used, as it calls a method that the Classic world maps don't have
function rm.showSourceOnWorldMap(source)
    closeDefaultProfessionFrames()
    ShowUIPanel(WorldMapFrame)
    WorldMapFrame:SetMapID(rm.getMapToShow(source.pointsByMap))
    rm.setMarkedSource(source) -- Also refreshes the map, which doesn't when it already displays the same map
end
