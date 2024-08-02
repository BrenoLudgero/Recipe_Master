local _, rm = ...
local F = rm.F

local function updateHeaderIcon(recipe, xOffset)
    rm.sourcesHeader.recipeIcon:SetTexture(recipe.texture)
    rm.sourcesHeader.recipeIcon:SetPoint("TOP", rm.mainFrame, -xOffset, F.offsets.sourcesHeaderY)
end

local function updateHeaderText(recipe)
    rm.sourcesHeader.recipeName:SetText(recipe.name)
    local r, g, b = C_Item.GetItemQualityColor(recipe.quality)
    rm.sourcesHeader.recipeName:SetTextColor(unpack({r, g, b}))
end

function rm.showUpdatedSourcesHeader(recipe)
    rm.sourcesHeader.recipeIcon:Show()
    rm.sourcesHeader.recipeName:Show()
    updateHeaderText(recipe)
    local textWidth = rm.sourcesHeader.recipeName:GetWidth()
    local iconWidth = rm.sourcesHeader.recipeIcon:GetWidth()
    local iconXOffset = (iconWidth + textWidth - 14.8) / 2
    updateHeaderIcon(recipe, iconXOffset)
end

local function updateTabAppearance(tab)
    tab.text:ClearAllPoints()
    if tab.active then
        tab.texture:SetTexture(F.textures.sourcesListTabActive)
        tab.texture:SetAlpha(1)
        tab.text:SetAlpha(1)
        tab.text:SetPoint("CENTER", tab.texture, F.offsets.sourcesListTabTextX, -3)
    else
        tab.texture:SetTexture(F.textures.sourcesListTabInactive)
        tab.texture:SetAlpha(0.8)
        tab.text:SetAlpha(0.8)
        tab.text:SetPoint("CENTER", tab.texture, F.offsets.sourcesListTabTextX, -5.4)
    end
end

function rm.activateSourcesTabAndDeactivateOthers(tabSourceType)
    for sourceType, tab in pairs(rm.sourcesListTabs) do
        if sourceType == tabSourceType then
            tab.active = true
        else
            tab.active = false
        end
        updateTabAppearance(tab)
    end
end

function rm.updateListHeight()
    local listHeight = (#rm.sourcesList.children * F.sizes.sourcesListRowHeight) + F.sizes.sourcesListColumnHeight
    rm.sourcesList:SetHeight(listHeight + F.offsets.sourcesColumnsContainerY + F.sizes.sourcesListExtraBorderHeight)
end

function rm.clearSourcesColumns()
    for sourceType, columnList in pairs(rm.sourcesListColumns) do
        for _, column in pairs(columnList) do
            column:Hide()
        end
    end
    wipe(rm.sourcesListColumns)
end

function rm.clearSourcesList()
    for _, element in pairs(rm.sourcesList.children) do
        element:Hide()
    end
    wipe(rm.sourcesList.children)
end

local function clearSourcesTabs()
    for _, tab in pairs(rm.sourcesListTabs) do
        tab:Hide()
    end
    wipe(rm.sourcesListTabs)
end

function rm.clearSourcesFrameContent()
    rm.clearSourcesColumns()
    rm.clearSourcesList()
    clearSourcesTabs()
end

function rm.showSourcesFrameElements()
    rm.hideRecipesFrameElements()
    rm.mainFrame:SetBackdrop(F.backdrops.sourcesFrame)
    rm.mainFrame:SetBackdropColor(unpack(F.colors.sourcesBackground))
end

function rm.showUniqueSourceText(string)
    rm.uniqueSourceText:SetText(string)
    rm.uniqueSourceText:SetTextColor(unpack(F.colors.white))
    rm.uniqueSourceText:Show()
end
