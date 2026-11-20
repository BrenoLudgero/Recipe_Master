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
    local border = CreateFrame("Frame", nil, parent)
    border:SetFrameLevel(9)
    border:SetPoint("TOPLEFT")
    border:SetPoint("BOTTOMRIGHT", 0, 2)
    local nineSlice = CreateFrame("Frame", nil, border, F.templates.mainFrameBorder)
    nineSlice:SetFrameLevel(border:GetFrameLevel()) -- The template raises it above every frame in the window
    NineSliceUtil.ApplyLayoutByName(nineSlice, F.templates.mainFrameBorderLayout)
    local minimizeButton = CreateFrame("Button", nil, border, F.templates.closeButton)
    rm.showTooltipTextOnMouseover(minimizeButton, L.minimizeWindow, "ANCHOR_TOP")
    rm.minimizeMainFrameOnClick(minimizeButton)
    return border
end

function rm.createMainHeader(parent)
    local header = CreateFrame("Frame", nil, parent)
    header:SetPoint("TOPLEFT")
    header:SetPoint("TOPRIGHT")
    header:SetHeight(F.sizes.headerHeight)
    return header
end

function rm.createMainHeaderText(parent)
    local text = parent:CreateFontString(nil, "OVERLAY", F.fonts.header)
    text:SetText("Recipe Master")
    text:SetPoint("TOPLEFT", 0, F.offsets.headerTextY)
    text:SetPoint("TOPRIGHT", F.offsets.headerTextX, F.offsets.headerTextY)
    return text
end

function rm.createCenteredText(parent)
    local text = parent:CreateFontString(nil, "OVERLAY")
    text:SetFont(F.fonts.centeredText, F.fontSizes.centeredText, "OUTLINE")
    text:SetPoint("CENTER")
    text:Hide()
    return text
end

-- Looks like the profession tabs on ProfessionsFrame's right side, which set its size, tooltip and click sound
function rm.createRestoreButton()
    local button = CreateFrame("Button", nil, nil, "LargeSideTabButtonTemplate")
    button.tooltipText = "Recipe Master"
    rm.restoreMainFrameOnClick(button)
    button.texture = button.Icon
    button.texture:SetTexture(rm.getPreference("restoreButtonIconTexture"))
    button:SetFillToInterior(true)
    button:SetChecked(false) -- Hides the selected tab's border
    return button
end
