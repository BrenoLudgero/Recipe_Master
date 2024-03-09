local _, rm = ...
local L = rm.L

function rm.createOptionsFrame()
    rm.frame.name = L.title
    InterfaceOptions_AddCategory(rm.frame)
    return rm.frame
end

function rm.createOptionsText(font, string, xPosition, yPosition)
    local text = rm.optionsFrame:CreateFontString(nil, "ARTWORK", font)
    text:SetText(string)
    if xPosition and yPosition then
        text:SetPoint("TOPLEFT", xPosition, yPosition)
    end
    text:SetJustifyH("LEFT")
    return text
end

local function createSlider(yOffset, description)
    local slider = CreateFrame("Slider", nil, rm.optionsFrame, L.templates.slider)
    slider:SetSize(L.sizes.sliderWidth, L.sizes.sliderHeight)
    slider:SetOrientation("HORIZONTAL")
    slider:SetPoint("TOPLEFT", L.offsets.sliderX, yOffset)
    slider.Low:AdjustPointsOffset(0, -3)
    slider.High:AdjustPointsOffset(0, -3)
    local sliderDescription = rm.createOptionsText(L.fonts.optionDescription, description)
    sliderDescription:SetPoint("CENTER", slider, "TOP", 0, L.offsets.sliderDescriptionY)
    slider.valueDisplay = slider:CreateFontString(nil, "ARTWORK", L.fonts.optionDescription)
    return slider
end

function rm.createOpacitySlider()
    local slider = createSlider(L.offsets.opacitySliderY, L.strings.backgroundOpacity)
    slider:SetMinMaxValues(0.4, 1)
    slider:SetValueStep(0.1)
    slider.Low:SetText("40%")
    slider.High:SetText("100%")
    local initialValue = rm.getPreference("backgroundOpacity")
    slider:SetValue(initialValue)
    slider.valueDisplay:SetText((initialValue * 100).."%")
    slider.valueDisplay:SetPoint("TOP", slider.BottomEdge, "BOTTOM", 0, 2)
    rm.updateBackgroundOpacity(slider)
    return slider
end

local function createOptionsDropdown(xOffset, yOffset, label)
    local dropdown = CreateFrame("Button", nil, rm.optionsFrame, L.templates.dropdown)
    dropdown:SetPoint("TOPLEFT", xOffset, yOffset)
    dropdown.Text:SetPoint("CENTER", 0, 2.5)
    local label = rm.createOptionsText(L.fonts.optionDescription, label, nil, nil)
    label:SetPoint("CENTER", dropdown, "TOP", 0, L.offsets.optionsDropdownLabelY)
    UIDropDownMenu_SetWidth(dropdown, L.sizes.optionsDropdownWidth)
    return dropdown
end

function rm.createIconDropdown()
    local dropdown = createOptionsDropdown(L.offsets.updateIconDropdownX, L.offsets.updateIconDropdownY, L.strings.updateIconDropdown)
    dropdown.values = {
        {text = L.strings.common, value = "Interface/Icons/INV_Scroll_03"},
        {text = L.strings.uncommon, value = "Interface/Icons/INV_Scroll_06"},
        {text = L.strings.rare, value = "Interface/Icons/INV_Scroll_05"},
        {text = L.strings.epic, value = "Interface/Icons/INV_Scroll_04"}
    }
    rm.handleTextureOptions(dropdown, "restoreButtonIconTexture", rm.restoreButton.texture)
    rm.setInitialDropdownValue(dropdown, "restoreButtonIconTexture")
    return dropdown
end

function rm.createSpacingSlider()
    local slider = createSlider(L.offsets.spacingSliderY, L.strings.recipeIconSpacing)
    slider:SetMinMaxValues(1, 10)
    slider:SetValueStep(1)
    slider.Low:SetText("1")
    slider.High:SetText("10")
    local initialValue = rm.getPreference("rowSpacing")
    slider:SetValue(initialValue)
    slider.valueDisplay:SetText(initialValue)
    slider.valueDisplay:SetPoint("TOP", slider.BottomEdge, "BOTTOM", 0, 2)
    rm.updateRowSpacing(slider, slider.valueDisplay)
    return slider
end

function rm.createShowLearnedCheckButton()
    local button = CreateFrame("CheckButton", nil, rm.optionsFrame, L.templates.checkButton)
    button:SetPoint("TOPLEFT", L.offsets.showLearnedButtonX, L.offsets.showLearnedButtonY)
    button:SetChecked(rm.getPreference("showLearnedRecipes"))
    local label = rm.createOptionsText(L.fonts.optionDescription, L.strings.showLearned, nil, nil)
    label:SetPoint("LEFT", button, "RIGHT", L.offsets.showLearnedTextX, 0)
    rm.toggleShowLearnedRecipesOnClick(button)
    return button
end

function rm.createProgressBrightnessDropdown()
    local dropdown = createOptionsDropdown(L.offsets.brightnessDropdownX, L.offsets.brightnessDropdownY, L.strings.brightness)
    dropdown.values = {
        {text = L.strings.bright, value = "Interface/TARGETINGFRAME/BarFill2"},
        {text = L.strings.dark, value = "Interface/CHARACTERFRAME/BarFill"}
    }
    rm.handleTextureOptions(dropdown, "progressTexture", rm.progressBar)
    rm.setInitialDropdownValue(dropdown, "progressTexture")
    return dropdown
end

function rm.createProgressColorDropdown()
    local dropdown = createOptionsDropdown(L.offsets.updateIconDropdownX, L.offsets.brightnessDropdownY, L.strings.color)
    dropdown.values = {
        {text = L.strings.blue, value = {0.00, 0.44, 0.87}},
        {text = L.strings.gray, value = {0.62, 0.62, 0.62}},
        {text = L.strings.green, value = {0.12, 1, 0}},
        {text = L.strings.orange, value = {1, 0.5, 0}},
        {text = L.strings.purple, value = {0.64, 0.21, 0.93}}
    }
    rm.handleTextureOptions(dropdown, "progressColor", nil)
    rm.setInitialDropdownValue(dropdown, "progressColor")
    return dropdown
end

function rm.createResetDefaultsButton(opacitySlider, spacingSlider, restoreButtonDropdown, progressBrightness, progressColor, showLearnedButton)
    local button = CreateFrame("Button", nil, rm.optionsFrame, L.templates.button)
    button:SetText(L.strings.resetDefaults)
    button:SetSize(140, 35)
    button:SetPoint("TOPLEFT", L.offsets.resetDefaultsX, L.offsets.resetDefaultsY)
    rm.resetSavedVariablesOnClick(button, opacitySlider, spacingSlider, restoreButtonDropdown, progressBrightness, progressColor, showLearnedButton)
    return button
end
