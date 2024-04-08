local _, rm = ...
local L = rm.L
local F = rm.F

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
    local slider = CreateFrame("Slider", nil, rm.optionsFrame, F.templates.slider)
    slider:SetSize(F.sizes.sliderWidth, F.sizes.sliderHeight)
    slider:SetOrientation("HORIZONTAL")
    slider:SetPoint("TOPLEFT", F.offsets.sliderX, yOffset)
    slider.Low:AdjustPointsOffset(0, -3)
    slider.High:AdjustPointsOffset(0, -3)
    local sliderDescription = rm.createOptionsText(F.fonts.optionDescription, description)
    sliderDescription:SetPoint("CENTER", slider, "TOP", 0, F.offsets.sliderDescriptionY)
    slider.valueDisplay = slider:CreateFontString(nil, "ARTWORK", F.fonts.optionDescription)
    return slider
end

function rm.createOpacitySlider()
    local slider = createSlider(F.offsets.opacitySliderY, L.backgroundOpacity)
    slider:SetMinMaxValues(0.40, 1)
    slider:SetValueStep(0.01)
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
    local dropdown = CreateFrame("Button", nil, rm.optionsFrame, F.templates.dropdown)
    dropdown:SetPoint("TOPLEFT", xOffset, yOffset)
    dropdown.Text:SetPoint("CENTER", 0, 2.5)
    local label = rm.createOptionsText(F.fonts.optionDescription, label, nil, nil)
    label:SetPoint("CENTER", dropdown, "TOP", 0, F.offsets.optionsDropdownLabelY)
    UIDropDownMenu_SetWidth(dropdown, F.sizes.optionsDropdownWidth)
    return dropdown
end

function rm.createIconDropdown()
    local dropdown = createOptionsDropdown(F.offsets.updateIconDropdownX, F.offsets.updateIconDropdownY, L.updateIconDropdown)
    dropdown.values = {
        {text = L.common, value = "Interface/Icons/INV_Scroll_03"},
        {text = L.uncommon, value = "Interface/Icons/INV_Scroll_06"},
        {text = L.rare, value = "Interface/Icons/INV_Scroll_05"},
        {text = L.epic, value = "Interface/Icons/INV_Scroll_04"}
    }
    rm.handleTextureOptions(dropdown, "restoreButtonIconTexture", rm.restoreButton.texture)
    rm.setInitialDropdownValue(dropdown, "restoreButtonIconTexture")
    return dropdown
end

function rm.createSpacingSlider()
    local slider = createSlider(F.offsets.spacingSliderY, L.recipeIconSpacing)
    slider:SetMinMaxValues(1, 10)
    slider:SetValueStep(1)
    slider:SetObeyStepOnDrag(true)
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
    local button = CreateFrame("CheckButton", nil, rm.optionsFrame, F.templates.checkButton)
    button:SetPoint("TOPLEFT", F.offsets.showLearnedButtonX, F.offsets.showLearnedButtonY)
    button:SetChecked(rm.getPreference("showLearnedRecipes"))
    local label = rm.createOptionsText(F.fonts.optionDescription, L.showLearned, nil, nil)
    label:SetPoint("LEFT", button, "RIGHT", F.offsets.showLearnedTextX, 0)
    rm.toggleShowLearnedRecipesOnClick(button)
    return button
end

function rm.createProgressBrightnessDropdown()
    local dropdown = createOptionsDropdown(F.offsets.brightnessDropdownX, F.offsets.brightnessDropdownY, L.brightness)
    dropdown.values = {
        {text = L.bright, value = "Interface/TARGETINGFRAME/BarFill2"},
        {text = L.dark, value = "Interface/CHARACTERFRAME/BarFill"}
    }
    rm.handleTextureOptions(dropdown, "progressTexture", rm.progressBar)
    rm.setInitialDropdownValue(dropdown, "progressTexture")
    return dropdown
end

function rm.createProgressColorDropdown()
    local dropdown = createOptionsDropdown(F.offsets.updateIconDropdownX, F.offsets.brightnessDropdownY, L.color)
    dropdown.values = {
        {text = L.blue, value = {0.00, 0.44, 0.87}},
        {text = L.gray, value = {0.62, 0.62, 0.62}},
        {text = L.green, value = {0.12, 1, 0}},
        {text = L.orange, value = {1, 0.5, 0}},
        {text = L.purple, value = {0.64, 0.21, 0.93}}
    }
    rm.handleTextureOptions(dropdown, "progressColor", nil)
    rm.setInitialDropdownValue(dropdown, "progressColor")
    return dropdown
end

function rm.createResetDefaultsButton(opacitySlider, spacingSlider, restoreButtonDropdown, progressBrightness, progressColor, showLearnedButton)
    local button = CreateFrame("Button", nil, rm.optionsFrame, F.templates.button)
    button:SetText(L.resetDefaults)
    button:SetSize(140, 35)
    button:SetPoint("TOPLEFT", F.offsets.resetDefaultsX, F.offsets.resetDefaultsY)
    rm.resetSavedVariablesOnClick(button, opacitySlider, spacingSlider, restoreButtonDropdown, progressBrightness, progressColor, showLearnedButton)
    return button
end
