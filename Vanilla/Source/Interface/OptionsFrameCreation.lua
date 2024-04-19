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
    slider:SetMinMaxValues(40, 100)
    slider:SetValueStep(1)
    slider:SetObeyStepOnDrag(true)
    slider.Low:SetText("40%")
    slider.High:SetText("100%")
    local initialValue = rm.getPreference("backgroundOpacity") * 100
    slider:SetValue(initialValue)
    slider.valueDisplay:SetText(initialValue.."%")
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
    local initialValue = rm.getPreference("iconSpacing")
    slider:SetValue(initialValue)
    slider.valueDisplay:SetText(initialValue)
    slider.valueDisplay:SetPoint("TOP", slider.BottomEdge, "BOTTOM", 0, 2)
    rm.updateIconSpacing(slider, slider.valueDisplay)
    return slider
end

local function createCheckButton(parentFrame, xOffset, yOffset, savedVariable, labelText)
    local button = CreateFrame("CheckButton", nil, parentFrame, F.templates.checkButton)
    button:SetPoint("TOPLEFT", xOffset, yOffset)
    button:SetChecked(rm.getPreference(savedVariable))
    local label = rm.createOptionsText(F.fonts.optionDescription, labelText, nil, nil)
    label:SetPoint("LEFT", button, "RIGHT", F.offsets.checkButtonTextX, 0)
    rm.toggleCheckButtonPreferenceOnClick(button, savedVariable)
    return button
end

function rm.createShowRecipesInfoCheckButton()
    return createCheckButton(
        rm.optionsFrame, 
        F.offsets.showRecipesInfoButtonX, 
        F.offsets.showRecipesInfoButtonY, 
        "showRecipesInfo", 
        L.showRecipesInfo
    )
end

function rm.createShowLearnedCheckButton()
    return createCheckButton(
        rm.optionsFrame, 
        F.offsets.showLearnedButtonX, 
        F.offsets.showRecipesInfoButtonY, 
        "showLearnedRecipes", 
        L.showLearned
    )
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
        {text = L.blue, value = F.colors.blue},
        {text = L.gray, value = F.colors.gray},
        {text = L.green, value = F.colors.green}, --{0.12, 1, 0}},
        {text = L.orange, value = F.colors.orange},
        {text = L.purple, value = F.colors.purple}
    }
    rm.handleTextureOptions(dropdown, "progressColor", rm.progressBar)
    rm.setInitialDropdownValue(dropdown, "progressColor")
    return dropdown
end

function rm.createResetDefaultsButton(options)
    local button = CreateFrame("Button", nil, rm.optionsFrame, F.templates.button)
    button:SetText(L.resetDefaults)
    button:SetSize(140, 35)
    button:SetPoint("TOPLEFT", F.offsets.resetDefaultsX, F.offsets.resetDefaultsY)
    rm.resetSavedOptionsOnClick(button, options)
    return button
end
