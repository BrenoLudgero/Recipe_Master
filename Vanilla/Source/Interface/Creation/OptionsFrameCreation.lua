local _, rm = ...
local L = rm.L
local F = rm.F

function rm.createOptionsFrame()
    rm.frame.name = L.title
    local category = Settings.RegisterCanvasLayoutCategory(rm.frame, rm.frame.name)
    category.ID = rm.frame.name
    Settings.RegisterAddOnCategory(category)
    return rm.frame
end

function rm.createOptionsText(font, string, xOffset, yOffset)
    local text = rm.optionsFrame:CreateFontString(nil, "ARTWORK", font)
    text:SetText(string)
    if xOffset and yOffset then
        text:SetPoint("TOPLEFT", xOffset, yOffset)
    end
    text:SetJustifyH("LEFT")
    return text
end

local function createSlider(xOffset, yOffset, description)
    local slider = CreateFrame("Slider", nil, rm.optionsFrame, F.templates.slider)
    slider:SetSize(F.sizes.sliderWidth, F.sizes.sliderHeight)
    slider:SetOrientation("HORIZONTAL")
    slider:SetPoint("TOPLEFT", xOffset, yOffset)
    slider:SetObeyStepOnDrag(true)
    local minValueText = rm.createOptionsText(F.fonts.optionDescription, "")
    minValueText:SetParent(slider)
    minValueText:SetPoint("TOPRIGHT", slider, "BOTTOMLEFT", F.offsets.sliderMinMaxTextX, 0)
    slider.min = minValueText
    local maxValueText = rm.createOptionsText(F.fonts.optionDescription, "")
    maxValueText:SetParent(slider)
    maxValueText:SetPoint("TOPLEFT", slider, "BOTTOMRIGHT", -F.offsets.sliderMinMaxTextX, 0)
    slider.max = maxValueText
    local label = rm.createOptionsText(F.fonts.optionDescription, description)
    label:SetParent(slider)
    label:SetPoint("CENTER", slider, "TOP", 0, F.offsets.sliderDescriptionY)
    slider.valueDisplay = slider:CreateFontString(nil, "ARTWORK", F.fonts.optionDescription)
    slider.valueDisplay:SetPoint("TOP", slider, "BOTTOM", 0, F.offsets.sliderValueY)
    return slider
end

function rm.createOpacitySlider()
    local slider = createSlider(F.offsets.firstColumnX, F.offsets.opacitySliderY, L.backgroundOpacity)
    slider:SetMinMaxValues(40, 100)
    slider:SetValueStep(1)
    slider.min:SetText("40%")
    slider.max:SetText("100%")
    local initialValue = rm.getPreference("backgroundOpacity") * 100
    slider:SetValue(initialValue)
    slider.valueDisplay:SetText(initialValue.."%")
    rm.updateBackgroundOpacity(slider)
    return slider
end

function rm.createScaleSlider()
    local slider = createSlider(F.offsets.scaleSliderX, F.offsets.scaleSliderY, L.uiScale)
    slider:SetMinMaxValues(0.0, 0.4)
    slider:SetValueStep(0.01)
    slider.min:SetText("100%")
    slider.max:SetText("140%")
    local initialValue = rm.getPreference("interfaceScale")
    slider:SetValue(initialValue)
    local roundedValue = math.floor(initialValue * 100 + 0.5) / 100
    local valueToHundreds = (roundedValue + 1) * 100
    slider.valueDisplay:SetText(valueToHundreds.."%")
    rm.updateInterfaceScale(slider)
    return slider
end

local function createOptionsDropdown(xOffset, yOffset, label)
    local dropdown = CreateFrame("DropdownButton", nil, rm.optionsFrame, F.templates.dropdown)
    dropdown:SetPoint("TOPLEFT", xOffset, yOffset)
    dropdown:SetWidth(F.sizes.optionsDropdownWidth)
    local label = rm.createOptionsText(F.fonts.optionDescription, label)
    label:SetParent(dropdown)
    label:SetPoint("CENTER", dropdown, "TOP", 0, F.offsets.dropdownLabelY)
    return dropdown
end

function rm.createRestoreIconDropdown()
    local dropdown = createOptionsDropdown(F.offsets.iconDropdownX, F.offsets.iconDropdownY, L.updateIconDropdown)
    local options = {
        {L.common, "Interface/Icons/INV_Scroll_03"},
        {L.uncommon, "Interface/Icons/INV_Scroll_06"},
        {L.rare, "Interface/Icons/INV_Scroll_05"},
        {L.epic, "Interface/Icons/INV_Scroll_04"}
    }
    rm.handleTextureOptions(dropdown, options, "restoreButtonIconTexture", rm.restoreButton.texture)
    rm.setInitialDropdownValue(dropdown, options, "restoreButtonIconTexture")
    return dropdown
end

function rm.createSpacingSlider()
    local slider = createSlider(F.offsets.firstColumnX, F.offsets.spacingSliderY, L.recipeIconSpacing)
    slider:SetMinMaxValues(1, 10)
    slider:SetValueStep(1)
    slider.min:SetText("1")
    slider.max:SetText("10")
    local initialValue = rm.getPreference("iconSpacing")
    slider:SetValue(initialValue)
    slider.valueDisplay:SetText(initialValue)
    rm.updateIconSpacing(slider, slider.valueDisplay)
    return slider
end

local function createCheckButton(xOffset, yOffset, savedVariable, labelText)
    local button = CreateFrame("CheckButton", nil, rm.optionsFrame, F.templates.checkButton)
    button:SetPoint("TOPLEFT", xOffset, yOffset)
    button:SetChecked(rm.getPreference(savedVariable))
    local label = rm.createOptionsText(F.fonts.optionDescription, labelText)
    label:SetParent(button)
    label:SetPoint("LEFT", button, "RIGHT", F.offsets.checkButtonTextX, 0)
    rm.toggleCheckButtonPreferenceOnClick(button, savedVariable)
    return button
end

function rm.createShowRecipesInfoCheckButton()
    return createCheckButton(
        F.offsets.showDetailsCheckX, 
        F.offsets.showDetailsCheckY, 
        "showRecipesInfo", 
        L.showRecipesInfo
    )
end

function rm.createShowLearnedCheckButton()
    return createCheckButton(
        F.offsets.showLearnedCheckX, 
        F.offsets.showDetailsCheckY, 
        "showLearnedRecipes", 
        L.showLearnedRecipes
    )
end

function rm.createDifficultyTooltipInfoCheckButton()
    return createCheckButton(
        F.offsets.showDifficultyTooltipCheckX,
        F.offsets.showDifficultyTooltipCheckY,
        "showDifficultyTooltipInfo",
        L.showDifficultyTooltipInfo
    )
end

function rm.createSourcesTooltipInfoCheckButton()
    return createCheckButton(
        F.offsets.showSourceTooltipCheckX,
        F.offsets.showSourceTooltipCheckY,
        "showSourcesTooltipInfo",
        L.showSourcesTooltipInfo
    )
end

function rm.createAltsTooltipInfoCheckButton()
    return createCheckButton(
        F.offsets.showAltTooltipCheckX,
        F.offsets.showAltTooltipCheckY,
        "showAltsTooltipInfo",
        L.showAltsTooltipInfo
    )
end

function rm.createProgressBrightnessDropdown()
    local dropdown = createOptionsDropdown(F.offsets.brightnessDropdownX, F.offsets.brightnessDropdownY, L.brightness)
    local options = {
        {L.bright, "Interface/TARGETINGFRAME/BarFill2"},
        {L.dark, "Interface/CHARACTERFRAME/BarFill"}
    }
    rm.handleTextureOptions(dropdown, options, "progressTexture", rm.progressBar)
    rm.setInitialDropdownValue(dropdown, options, "progressTexture")
    return dropdown
end

function rm.createProgressColorDropdown()
    local dropdown = createOptionsDropdown(F.offsets.progressColorDropdownX, F.offsets.brightnessDropdownY, L.color)
    local options = {
        {L.blue, F.colors.blue},
        {L.gray, F.colors.gray},
        {L.green, F.colors.green},
        {L.orange, F.colors.orange},
        {L.purple, F.colors.purple}
    }
    rm.handleTextureOptions(dropdown, options, "progressColor", rm.progressBar)
    rm.setInitialDropdownValue(dropdown, options, "progressColor")
    return dropdown
end

function rm.createResetDefaultsButton()
    local button = CreateFrame("Button", nil, rm.optionsFrame, F.templates.button)
    button:SetText(L.resetDefaults)
    button:SetSize(F.sizes.resetDefaultsButtonWidth, F.sizes.resetDefaultsButtonHeight)
    button:SetPoint("TOPLEFT", F.offsets.resetDefaultsX, F.offsets.resetDefaultsY)
    rm.resetSavedOptionsOnClick(button)
    return button
end
