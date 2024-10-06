local _, rm = ...
local L = rm.L
local F = rm.F

function rm.createMainFrame()
    local mainFrame = CreateFrame("Frame", nil, nil, F.templates.mainFrame)
    mainFrame:SetBackdrop(F.backdrops.recipesFrame)
    mainFrame:SetBackdropColor(unpack(F.colors.mainBackground))
    mainFrame:SetFrameLevel(7)
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

function rm.createMainHeader(parent)
    local header = CreateFrame("Frame", nil, parent)
    local frameLevel = parent:GetFrameLevel() - 1
    header:SetPoint("TOPLEFT")
    header:SetPoint("BOTTOMRIGHT", rm.mainFrameBorder.CloseButton, "BOTTOMLEFT", F.offsets.mainHeaderX, F.offsets.mainHeaderY)
    header:SetFrameLevel(frameLevel)
    local texture = header:CreateTexture(nil)
    texture:SetTexture(F.textures.header)
    texture:SetAllPoints(header)
    return header
end

function rm.createMainHeaderText(parent)
    local text = parent:CreateFontString(nil, "OVERLAY", F.fonts.header)
    text:SetText(L.title)
    text:SetTextColor(unpack(F.colors.yellow))
    text:SetAllPoints(parent)
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

function rm.createSourcesInstructions(parent)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetPoint("CENTER")
    frame:SetSize(F.sizes.sourcesInstructions, F.sizes.sourcesInstructions)
    frame.texture = frame:CreateTexture(nil, "ARTWORK")
    frame.texture:SetAllPoints(frame)
    frame.texture:AdjustPointsOffset(0, F.offsets.instructionsY)
    frame.texture:SetTexture(F.textures.mainBackground)
    frame.texture:SetColorTexture(0, 0, 0, 0.55)
    frame.mask = frame:CreateMaskTexture()
    frame.mask:SetAllPoints(frame.texture)
    frame.mask:SetTexture(F.textures.sourcesInstructionsMask, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    frame.texture:AddMaskTexture(frame.mask)
    local recipe = CreateFrame("Frame", nil, frame)
    recipe:SetPoint("CENTER", F.offsets.instructionsRecipeX, F.offsets.instructionsRecipeY)
    recipe:SetSize(F.sizes.sourcesInstructionsRecipe, F.sizes.sourcesInstructionsRecipe)
    recipe.texture = recipe:CreateTexture(nil, "ARTWORK")
    recipe.texture:SetAllPoints(recipe)
    recipe.texture:SetTexture(F.textures.commonRecipe)
    local cursor = CreateFrame("Frame", nil, frame)
    cursor:SetFrameLevel(recipe:GetFrameLevel() + 1)
    cursor:SetPoint("TOPLEFT", recipe, "BOTTOMRIGHT", F.offsets.instructionsCursorX, F.offsets.instructionsCursorY)
    cursor:SetSize(F.sizes.sourcesInstructionsCursor, F.sizes.sourcesInstructionsCursor)
    cursor.texture = cursor:CreateTexture(nil, "ARTWORK")
    cursor.texture:SetAllPoints(cursor)
    cursor.texture:SetTexture(F.textures.cursor)
    cursor.clickTexture = cursor:CreateTexture(nil, "ARTWORK")
    cursor.clickTexture:SetSize(F.sizes.sourcesInstructionsClickTexture, F.sizes.sourcesInstructionsClickTexture)
    cursor.clickTexture:SetPoint("BOTTOMRIGHT", cursor, "TOPLEFT", F.offsets.instructionsClickTextureX, F.offsets.instructionsClickTextureY)
    cursor.clickTexture:SetTexture(F.textures.cursorClick)
    frame:Hide()
    return frame
end

function rm.createRestoreButton()
    local button = CreateFrame("Button", nil)
    button:SetSize(F.sizes.restoreButton, F.sizes.restoreButton)
    rm.showTooltipTextOnMouseover(button, L.title, "ANCHOR_RIGHT")
    rm.restoreMainFrameOnClick(button)
    button.texture = button:CreateTexture()
    button.texture:SetTexture(rm.getPreference("restoreButtonIconTexture"))
    button.texture:SetAllPoints(button)
    return button
end
