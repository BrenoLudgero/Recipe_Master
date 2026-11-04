local _, rm = ...
local L = rm.L
local F = rm.F

function rm.createMainFrame()
    local mainFrame = CreateFrame("Frame", nil, nil, F.templates.mainFrame)
    mainFrame:SetBackdrop(F.backdrops.recipesFrame)
    mainFrame:SetBackdropColor(unpack(F.colors.mainBackground))
    mainFrame:SetFrameLevel(7)
    mainFrame:SetToplevel(true) -- Raised above other frames in its strata when clicked
    mainFrame:SetScript("OnShow", mainFrame.Raise) -- Keeps action bars' text from showing in front of it
    mainFrame:SetClampedToScreen(true)
    mainFrame:EnableMouse(true)
    mainFrame:SetWidth(F.sizes.recipesFrameWidth)
    mainFrame:Hide()
    return mainFrame
end

function rm.createBorder(parent)
    local border = CreateFrame("Frame", nil, parent, F.templates.mainFrameBorder)
    local minimizeButton = border.CloseButton
    border:SetFrameLevel(9)
    border:SetPoint("TOPLEFT", 2.5, 0)
    border:SetPoint("BOTTOMRIGHT", 0, 2)
    rm.showTooltipTextOnMouseover(minimizeButton, L.minimizeWindow, "ANCHOR_TOP")
    rm.minimizeMainFrameOnClick(minimizeButton)
    return border
end

-- The border's left side and bottom left corner cast a drop shadow outwards, unlike its right side
-- Both are replaced: the side without its shadow, and the right corner mirrored
local function replaceBorderLeftSide(border, header)
    local sideInfo = C_Texture.GetAtlasInfo(F.atlases.borderLeftSide)
    local cornerInfo = C_Texture.GetAtlasInfo(F.atlases.borderBottomRightCorner)
    local sideX = -5 + F.sizes.borderShadowWidth
    local corner = border:CreateTexture(nil, "BORDER")
    corner:SetTexture(cornerInfo.file)
    corner:SetTexCoord(cornerInfo.rightTexCoord, cornerInfo.leftTexCoord, cornerInfo.topTexCoord, cornerInfo.bottomTexCoord)
    corner:SetSize(cornerInfo.width, cornerInfo.height)
    corner:SetPoint("BOTTOMLEFT", sideX - 1, -5)
    local shadowTexCoordWidth = (sideInfo.rightTexCoord - sideInfo.leftTexCoord) * F.sizes.borderShadowWidth / sideInfo.width
    local side = border:CreateTexture(nil, "BORDER")
    side:SetTexture(sideInfo.file)
    side:SetTexCoord(sideInfo.leftTexCoord + shadowTexCoordWidth, sideInfo.rightTexCoord, sideInfo.topTexCoord, sideInfo.bottomTexCoord)
    side:SetWidth(sideInfo.width - F.sizes.borderShadowWidth)
    side:SetPoint("TOPLEFT", header, "BOTTOMLEFT", sideX, 0)
    side:SetPoint("BOTTOMLEFT", corner, "TOPLEFT", 1, 0)
    border.LeftBorder:Hide()
    border.BotLeftCorner:Hide()
    border.BottomBorder:SetPoint("BOTTOMLEFT", corner, "BOTTOMRIGHT")
end

-- Pixel bounds of the profession window's header in its top textures (left: 256x256, right: 128x256)
local headerTop, headerBottom = 13, 34
local headerMiddleStart = 72 -- In the left texture, past the portrait's ring
local headerRightEnd = 93 -- In the right texture, where the close button's box ends
local headerEdgeWidth = 5 -- Right edge of the close button's box, mirrored to close the header's left end
local headerCloseBoxWidth = 24

local function createHeaderPiece(header, texture, left, right, textureWidth)
    local piece = header:CreateTexture(nil, "ARTWORK")
    piece:SetTexture(texture)
    piece:SetTexCoord(left / textureWidth, right / textureWidth, headerTop / 256, headerBottom / 256)
    return piece
end

-- Blizzard bakes the header into the profession window's frame textures, so it's rebuilt from slices of them
function rm.createMainHeader(parent)
    local header = CreateFrame("Frame", nil, parent)
    header:SetPoint("TOPLEFT")
    header:SetPoint("TOPRIGHT")
    header:SetHeight(headerBottom - headerTop)
    header:SetFrameLevel(parent:GetFrameLevel() + 1) -- Above the border, so its edges cover the border's sides
    local leftEdge = createHeaderPiece(header, F.textures.headerRight, headerRightEnd, headerRightEnd - headerEdgeWidth, 128)
    leftEdge:SetPoint("TOPLEFT", F.offsets.headerLeftEdgeX, 0) -- Aligned with the border's sides
    leftEdge:SetPoint("BOTTOMLEFT", F.offsets.headerLeftEdgeX, 0)
    leftEdge:SetWidth(headerEdgeWidth)
    local rightEnd = createHeaderPiece(header, F.textures.headerRight, 0, headerRightEnd, 128)
    rightEnd:SetPoint("TOPRIGHT", F.offsets.headerRightEndX, 0)
    rightEnd:SetPoint("BOTTOMRIGHT", F.offsets.headerRightEndX, 0)
    rightEnd:SetWidth(headerRightEnd)
    local middle = createHeaderPiece(header, F.textures.headerLeft, headerMiddleStart, 256, 256)
    middle:SetPoint("TOPLEFT", leftEdge, "TOPRIGHT")
    middle:SetPoint("BOTTOMRIGHT", rightEnd, "BOTTOMLEFT")

    -- Replaces the border's own title bar, extending its sides up to the header
    parent.TopLeftCorner:Hide()
    parent.TopRightCorner:Hide()
    parent.TopBorder:Hide()
    -- The template anchors its right side at 1 from the top corner but 0 from the bottom one, so its bottom corner was off by 1
    parent.BotRightCorner:SetPoint("BOTTOMRIGHT", -1, -5)
    parent.RightBorder:SetPoint("TOPRIGHT", header, "BOTTOMRIGHT")
    parent.RightBorder:SetPoint("BOTTOMRIGHT", parent.BotRightCorner, "TOPRIGHT", 1, 0)
    replaceBorderLeftSide(parent, header)

    local closeButton = parent.CloseButton
    closeButton:ClearAllPoints()
    closeButton:SetPoint("TOPRIGHT", rightEnd, F.offsets.headerCloseButtonX, F.offsets.headerCloseButtonY)
    closeButton:SetFrameLevel(header:GetFrameLevel() + 1)
    return header
end

function rm.createMainHeaderText(parent)
    local text = parent:CreateFontString(nil, "OVERLAY", F.fonts.header)
    text:SetText("Recipe Master")
    text:SetPoint("TOPLEFT", 0, F.offsets.headerTextY)
    text:SetPoint("TOPRIGHT", -headerCloseBoxWidth, F.offsets.headerTextY)
    return text
end

function rm.createInnerBorder(parent)
    local innerBorder = CreateFrame("Frame", nil, parent, F.templates.innerBorder)
    innerBorder:SetPoint("TOPLEFT", rm.header, "BOTTOMLEFT", 1, 0)
    innerBorder:SetPoint("BOTTOMRIGHT", rm.mainFrameBorder, "BOTTOMRIGHT", -3, 2)
    innerBorder:SetFrameLevel(8)
    return innerBorder
end

function rm.createCenteredText(parent)
    local text = parent:CreateFontString(nil, "OVERLAY")
    text:SetFont(F.fonts.centeredText, F.fontSizes.centeredText, "OUTLINE")
    text:SetPoint("CENTER")
    text:Hide()
    return text
end

function rm.createRestoreButton()
    local button = CreateFrame("Button", nil)
    button:SetSize(F.sizes.restoreButton, F.sizes.restoreButton)
    rm.showTooltipTextOnMouseover(button, "Recipe Master", "ANCHOR_RIGHT")
    rm.restoreMainFrameOnClick(button)
    button.texture = button:CreateTexture()
    button.texture:SetTexture(rm.getPreference("restoreButtonIconTexture"))
    button.texture:SetAllPoints(button)
    return button
end
