local _, rm = ...
local L = rm.L
local F = rm.F

function rm.createFrame()
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
    local button = border.CloseButton -- "X"
    local buttonWidth = button:GetWidth()
    local buttonHeight = button:GetHeight()
    border:SetFrameLevel(9)
    border:SetPoint("TOPLEFT", 2.5, 0)
    border:SetPoint("BOTTOMRIGHT", 0, 2)
    rm.setUpButtonWithTooltip(button, buttonWidth, buttonHeight, L.hideWindow, function(button, button, down)
        rm.autoOpenRecipesFrame = false
        rm.restoreButton:Show()
        rm.mainFrame:Hide()
    end)
    return border
end

function rm.createHeader(parent)
    local header = CreateFrame("Frame", nil, parent)
    local frameLevel = parent:GetFrameLevel() - 1
    header:SetPoint("LEFT")
    header:SetPoint("TOP", F.offsets.headerX, F.offsets.headerY)
    header:SetHeight(F.sizes.headerHeight)
    header:SetFrameLevel(frameLevel)
    local texture = header:CreateTexture(nil)
    texture:SetTexture(F.textures.header)
    texture:SetAllPoints(header)
    return header
end

function rm.createHeaderText(parent)
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
    rm.matchParentHeight(innerBorder)
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
    frame.texture:SetTexture(F.textures.mainBackground)
    frame.texture:SetColorTexture(0, 0, 0, 0.55)
    frame.mask = frame:CreateMaskTexture()
    frame.mask:SetAllPoints(frame.texture)
    frame.mask:SetTexture(F.textures.sourcesInstructionsMask, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    frame.texture:AddMaskTexture(frame.mask)
    local recipe = CreateFrame("Frame", nil, frame)
    recipe:SetPoint("CENTER", F.offsets.sourcesInstructionsRecipeX, F.offsets.sourcesInstructionsRecipeY)
    recipe:SetSize(F.sizes.sourcesInstructionsRecipe, F.sizes.sourcesInstructionsRecipe)
    recipe.texture = recipe:CreateTexture(nil, "ARTWORK")
    recipe.texture:SetAllPoints(recipe)
    recipe.texture:SetTexture(F.textures.commonRecipe)
    local cursor = CreateFrame("Frame", nil, frame)
    cursor:SetFrameLevel(recipe:GetFrameLevel() + 1)
    cursor:SetPoint("TOPLEFT", recipe, "BOTTOMRIGHT", F.offsets.sourcesInstructionsCursorX, F.offsets.sourcesInstructionsCursorY)
    cursor:SetSize(F.sizes.sourcesInstructionsCursor, F.sizes.sourcesInstructionsCursor)
    cursor.texture = cursor:CreateTexture(nil, "ARTWORK")
    cursor.texture:SetAllPoints(cursor)
    cursor.texture:SetTexture(F.textures.cursor)
    cursor.clickTexture = cursor:CreateTexture(nil, "ARTWORK")
    cursor.clickTexture:SetSize(F.sizes.sourcesInstructionsClickTexture, F.sizes.sourcesInstructionsClickTexture)
    cursor.clickTexture:SetPoint("BOTTOMRIGHT", cursor, "TOPLEFT", F.offsets.sourcesInstructionsClickTextureX, F.offsets.sourcesInstructionsClickTextureY)
    cursor.clickTexture:SetTexture(F.textures.cursorClick)
    frame:Hide()
    return frame
end

function rm.createRestoreButton()
    local button = CreateFrame("Button", nil)
    rm.setUpButtonWithTooltip(button, F.sizes.restoreButton, F.sizes.restoreButton, L.title, function(self, button, down)
        rm.autoOpenRecipesFrame = true
        self:Hide()
        rm.mainFrame:Show()
    end)
    button.texture = button:CreateTexture()
    button.texture:SetTexture(rm.getPreference("restoreButtonIconTexture"))
    button.texture:SetAllPoints(button)
    return button
end
