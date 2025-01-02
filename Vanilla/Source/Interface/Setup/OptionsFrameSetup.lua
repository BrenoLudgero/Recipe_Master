local _, rm = ...
local L = rm.L
local F = rm.F

function rm.updateBackgroundOpacity(opacitySlider)
    opacitySlider:SetScript("OnValueChanged", function(self, value)
        local valueToTwoDecimals = value / 100
        rm.setPreference("backgroundOpacity", valueToTwoDecimals)
        self.valueDisplay:SetText(value.."%")
        F.colors.mainBackground = {1, 1, 1, valueToTwoDecimals}
        F.colors.sourcesBackground = {0.7, 0.7, 0.7, valueToTwoDecimals}
    end)
end

function rm.updateInterfaceScale(scaleSlider)
    scaleSlider:SetScript("OnValueChanged", function(self, value)
        local valueToTwoDecimals = math.floor(value * 100 + 0.5) / 100
        rm.setPreference("interfaceScale", valueToTwoDecimals)
        local valueToHundreds = (valueToTwoDecimals + 1) * 100
        self.valueDisplay:SetText(valueToHundreds.."%")
        rm.mainFrame:SetScale(UIParent:GetEffectiveScale() + rm.getPreference("interfaceScale"))
        rm.restoreButton:SetScale(UIParent:GetEffectiveScale() + rm.getPreference("interfaceScale"))
    end)
end

local function updateFrameTexture(frame, savedVariable)
    if frame and frame ~= rm.progressBar then
        frame:SetTexture(rm.getPreference(savedVariable))
    elseif frame == rm.progressBar then
        frame:SetStatusBarTexture(rm.getPreference(savedVariable))
    end
end

local function updatePreferenceAndTexture(dropdown, value, savedVariable, frame)
    rm.setPreference(savedVariable, value)
    if savedVariable == "progressColor" then
        frame:SetStatusBarColor(unpack(rm.getPreference(savedVariable)))
    else
        updateFrameTexture(frame, savedVariable)
    end
end

function rm.handleTextureOptions(dropdown, options, savedVariable, frame)
    dropdown:SetupMenu(function(self, rootDescription)
        for _, item in ipairs(options) do
            local name = item[1]
            local value = item[2]
            rootDescription:CreateButton(name, function()
                updatePreferenceAndTexture(self, value, savedVariable, frame)
                self:SetDefaultText(name)
            end)
        end
    end)
end

function rm.updateIconSpacing(spacingSlider, valueDisplay)
    spacingSlider:SetScript("OnValueChanged", function(self, value)
        valueDisplay:SetText(value)
        rm.setPreference("iconSpacing", value)
    end)
end

function rm.toggleCheckButtonPreferenceOnClick(button, preference)
    button:SetScript("OnClick", function(self)
        rm.toggleBooleanPreference(preference)
    end)
end

local function updateSlider(slider, value, displayValue)
    slider:SetValue(value)
    slider.valueDisplay:SetText(displayValue)
end

local function updateDropdown(dropdown, label)
    UIDropDownMenu_SetText(dropdown, label)
end

local function updateCheckbox(checkbox, isChecked)
    checkbox:SetChecked(isChecked)
end

function rm.resetSavedOptionsOnClick(resetDefaultsButton)
    resetDefaultsButton:SetScript("OnClick", function(self)
        rm.resetOptionsFramePreferences()
        local options = rm.optionsFrameElements
        local opacity = rm.getPreference("backgroundOpacity")
        local scale = rm.getPreference("interfaceScale")
        local spacing = rm.getPreference("iconSpacing")
        local progressColorPref = rm.getPreference("progressColor")
        local restoreButtonIconTexture = rm.getPreference("restoreButtonIconTexture")
        local showRecipesInfoPref = rm.getPreference("showRecipesInfo")
        local showLearnedRecipes = rm.getPreference("showLearnedRecipes")
        local showDifficultyTooltipInfo = rm.getPreference("showDifficultyTooltipInfo")
        local showSourcesTooltipInfo = rm.getPreference("showSourcesTooltipInfo")
        local showAltsTooltipInfo = rm.getPreference("showAltsTooltipInfo")
        -- Sliders --
        updateSlider(options.opacitySlider, opacity * 100, (opacity * 100) .. "%")
        updateSlider(options.scaleSlider, scale, ((scale + 1) * 100) .. "%")
        updateSlider(options.spacingSlider, spacing, spacing)
        -- Dropdowns --
        updateDropdown(options.progressBrightness, L.bright)
        updateDropdown(options.progressColor, L.blue)
        updateDropdown(options.restoreButton, L.epic)
        -- Textures and colors --
        updateFrameTexture(rm.progressBar, "progressTexture")
        rm.progressBar:SetStatusBarColor(unpack(progressColorPref))
        rm.restoreButton.texture:SetTexture(restoreButtonIconTexture)
        -- Checkboxes --
        updateCheckbox(options.showRecipesInfo, showRecipesInfoPref)
        updateCheckbox(options.showLearnedButton, showLearnedRecipes)
        updateCheckbox(options.showDifficultyTooltipInfo, showDifficultyTooltipInfo)
        updateCheckbox(options.showSourcesTooltipInfo, showSourcesTooltipInfo)
        updateCheckbox(options.showAltsTooltipInfo, showAltsTooltipInfo)
        -- Frame scaling --
        local effectiveScale = UIParent:GetEffectiveScale()
        rm.mainFrame:SetScale(effectiveScale + scale)
        rm.restoreButton:SetScale(effectiveScale + scale)
    end)
end
