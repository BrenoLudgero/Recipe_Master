local _, rm = ...
local F = rm.F

local function createTabTexture(tab)
    local texture = tab:CreateTexture()
    texture:SetPoint("CENTER", tab, F.offsets.bottomTabTextureX, F.offsets.bottomTabTextureY)
    texture:SetSize(F.sizes.bottomTabTextureWidth, F.sizes.bottomTabTextureHeight)
    texture:SetTexture(F.textures.bottomTab)
    texture:SetDesaturated(tab.active)
    return texture
end

local function createTabText(tab, label)
    local text = tab:CreateFontString(nil, "OVERLAY")
    text:SetFont(F.fonts.bottomTab, F.fontSizes.bottomTab, "OUTLINE")
    text:SetText(label)
    text:SetPoint("CENTER", tab.texture, F.offsets.bottomTabTextX, F.offsets.bottomTabTextY)
    return text
end

function rm.createBottomTab(label, anchor, xOffset, active)
    local tab = CreateFrame("Button", nil, rm.mainFrame)
    local frameLevel = rm.mainFrame:GetFrameLevel() - 1
    tab:SetSize(F.sizes.bottomTabWidth, F.sizes.bottomTabHeight)
    tab:SetFrameLevel(frameLevel)
    tab:SetPoint("TOP", rm.mainFrameBorder, anchor, xOffset, 0)
    tab.active = active
    tab.texture = createTabTexture(tab)
    local text = createTabText(tab, label)
    tab.label = text:GetText()
    table.insert(rm.bottomTabs, tab)
    rm.highlightTabOnMouseover(tab)
    rm.handleTabSwitching(tab)
    return tab
end
