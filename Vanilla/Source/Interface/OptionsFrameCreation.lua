function createRMOptionsFrame()
    local frame = CreateFrame("Frame")
    frame.name = RecipeMaster
    InterfaceOptions_AddCategory(frame)
    return frame
end

function createRMOptionsText(font, string, xPosition, yPosition)
    local text = optionsFrame:CreateFontString(nil, "ARTWORK", font)
    text:SetText(string)
    if xPosition and yPosition then
        text:SetPoint("TOPLEFT", xPosition, yPosition)
    end
    text:SetJustifyH("LEFT")
    return text
end

local function createRMSlider(yOffset, description)
    local slider = CreateFrame("Slider", nil, optionsFrame, templates.slider)
    slider:SetSize(sizes.sliderWidth, sizes.sliderHeight)
    slider:SetOrientation("HORIZONTAL")
    slider:SetPoint("TOPLEFT", offsets.sliderX, yOffset)
    slider.Low:AdjustPointsOffset(0, -3)
    slider.High:AdjustPointsOffset(0, -3)
    local sliderDescription = createRMOptionsText(fonts.optionDescription, description)
    sliderDescription:SetPoint("CENTER", slider, "TOP", 0, offsets.sliderDescriptionY)
    slider.valueDisplay = slider:CreateFontString(nil, "ARTWORK", fonts.optionDescription)
    return slider
end

function createRMOpacitySlider()
    local slider = createRMSlider(offsets.opacitySliderY, strings.backgroundOpacity)
    slider:SetMinMaxValues(0.4, 1)
    slider:SetValueStep(0.1)
    slider.Low:SetText("40%")
    slider.High:SetText("100%")
    local initialValue = RecipeMasterPreferences["backgroundOpacity"]
    slider:SetValue(initialValue)
    slider.valueDisplay:SetText((initialValue * 100).."%")
    slider.valueDisplay:SetPoint("TOP", slider.BottomEdge, "BOTTOM", 0, 2)
    updateBackgroundOpacity(slider)
    return slider
end

local function createRMOptionsDropdown(xOffset, yOffset, label)
    local dropdown = CreateFrame("Button", nil, optionsFrame, templates.dropdown)
    dropdown:SetPoint("TOPLEFT", xOffset, yOffset)
    dropdown.Text:SetPoint("CENTER", 0, 2.5)
    local label = createRMOptionsText(fonts.optionDescription, label, nil, nil)
    label:SetPoint("CENTER", dropdown, "TOP", 0, offsets.optionsDropdownLabelY)
    UIDropDownMenu_SetWidth(dropdown, sizes.optionsDropdownWidth)
    return dropdown
end

function createRMIconDropdown()
    local dropdown = createRMOptionsDropdown(offsets.updateIconDropdownX, offsets.updateIconDropdownY, strings.updateIconDropdown)
    dropdown.values = {
        {text = strings.common, value = "Interface/Icons/INV_Scroll_03"},
        {text = strings.uncommon, value = "Interface/Icons/INV_Scroll_06"},
        {text = strings.rare, value = "Interface/Icons/INV_Scroll_05"},
        {text = strings.epic, value = "Interface/Icons/INV_Scroll_04"}
    }
    handleTextureOptions(dropdown, "restoreButtonIconTexture", restoreButton.texture)
    setInitialDropdownValue(dropdown, "restoreButtonIconTexture")
    return dropdown
end

function createRMSpacingSlider()
    local slider = createRMSlider(offsets.spacingSliderY, strings.recipeIconSpacing)
    slider:SetMinMaxValues(1, 10)
    slider:SetValueStep(1)
    slider.Low:SetText("1")
    slider.High:SetText("10")
    local initialValue = RecipeMasterPreferences["rowSpacing"]
    slider:SetValue(initialValue)
    slider.valueDisplay:SetText(initialValue)
    slider.valueDisplay:SetPoint("TOP", slider.BottomEdge, "BOTTOM", 0, 2)
    updateRowSpacing(slider, slider.valueDisplay)
    return slider
end

function createRMShowLearnedCheckButton()
    local button = CreateFrame("CheckButton", nil, optionsFrame, templates.checkButton)
    button:SetPoint("TOPLEFT", offsets.showLearnedButtonX, offsets.showLearnedButtonY)
    button:SetChecked(RecipeMasterPreferences["showLearnedRecipes"])
    local label = createRMOptionsText(fonts.optionDescription, strings.showLearned, nil, nil)
    label:SetPoint("LEFT", button, "RIGHT", offsets.showLearnedTextX, 0)
    toggleShowLearnedRecipesOnClick(button)
    return button
end

function createRMProgressBrightnessDropdown()
    local dropdown = createRMOptionsDropdown(offsets.brightnessDropdownX, offsets.brightnessDropdownY, strings.brightness)
    dropdown.values = {
        {text = strings.bright, value = "Interface/TARGETINGFRAME/BarFill2"},
        {text = strings.dark, value = "Interface/CHARACTERFRAME/BarFill"}
    }
    handleTextureOptions(dropdown, "progressTexture", progressBar)
    setInitialDropdownValue(dropdown, "progressTexture")
    return dropdown
end

function createRMProgressColorDropdown()
    local dropdown = createRMOptionsDropdown(offsets.updateIconDropdownX, offsets.brightnessDropdownY, strings.color)
    dropdown.values = {
        {text = strings.blue, value = {0.00, 0.44, 0.87}},
        {text = strings.gray, value = {0.62, 0.62, 0.62}},
        {text = strings.green, value = {0.12, 1, 0}},
        {text = strings.orange, value = {1, 0.5, 0}},
        {text = strings.purple, value = {0.64, 0.21, 0.93}}
    }
    handleTextureOptions(dropdown, "progressColor", nil)
    setInitialDropdownValue(dropdown, "progressColor")
    return dropdown
end

function createRMResetDefaultsButton(opacitySlider, spacingSlider, restoreButtonDropdown, progressBrightness, progressColor, showLearnedButton)
    local button = CreateFrame("Button", nil, optionsFrame, templates.button)
    button:SetText(strings.resetDefaults)
    button:SetSize(140, 35)
    button:SetPoint("TOPLEFT", offsets.resetDefaultsX, offsets.resetDefaultsY)
    resetSavedVariablesOnClick(button, opacitySlider, spacingSlider, restoreButtonDropdown, progressBrightness, progressColor, showLearnedButton)
    return button
end
