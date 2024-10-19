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

local function updatePreferenceAndTexture(dropdown, selectedID, savedVariable, frame)
    UIDropDownMenu_SetSelectedID(dropdown, selectedID)
    local selectedValue = dropdown.values[selectedID].value
    rm.setPreference(savedVariable, selectedValue)
    if savedVariable == "progressColor" then
        frame:SetStatusBarColor(unpack(rm.getPreference(savedVariable)))
    else
        updateFrameTexture(frame, savedVariable)
    end
end

function rm.handleTextureOptions(dropdown, savedVariable, frame)
    UIDropDownMenu_Initialize(dropdown, function(self)
        for _, option in ipairs(dropdown.values) do
            local info = UIDropDownMenu_CreateInfo()
            info.minWidth = F.sizes.optionsDropdownWidth + 10
            info.text = option.text
            info.value = option.value
            info.func = function(self)
                updatePreferenceAndTexture(dropdown, self:GetID(), savedVariable, frame)
            end
            UIDropDownMenu_AddButton(info)
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

function rm.resetSavedOptionsOnClick(resetDefaultsButton, options)
    resetDefaultsButton:SetScript("OnClick", function(self)
        rm.resetOptionsFramePreferences()
        local opacity = rm.getPreference("backgroundOpacity")
        local scale = rm.getPreference("interfaceScale")
        local spacing = rm.getPreference("iconSpacing")
        local progressColorPref = rm.getPreference("progressColor")
        local restoreButtonIconTexture = rm.getPreference("restoreButtonIconTexture")
        local showRecipesInfoPref = rm.getPreference("showRecipesInfo")
        local showLearnedRecipes = rm.getPreference("showLearnedRecipes")
        options.opacitySlider:SetValue(opacity * 100)
        options.opacitySlider.valueDisplay:SetText((opacity * 100).."%")
        options.scaleSlider:SetValue(scale)
        options.scaleSlider.valueDisplay:SetText(((scale + 1) * 100).."%")
        rm.mainFrame:SetScale(UIParent:GetEffectiveScale() + scale)
        rm.restoreButton:SetScale(UIParent:GetEffectiveScale() + scale)
        options.spacingSlider:SetValue(spacing)
        options.spacingSlider.valueDisplay:SetText(spacing)
        UIDropDownMenu_SetText(options.progressBrightness, L.bright)
        updateFrameTexture(rm.progressBar, "progressTexture")
        UIDropDownMenu_SetText(options.progressColor, L.blue)
        rm.progressBar:SetStatusBarColor(unpack(progressColorPref))
        UIDropDownMenu_SetText(options.restoreButton, L.epic)
        rm.restoreButton.texture:SetTexture(restoreButtonIconTexture)
        options.showRecipesInfo:SetChecked(showRecipesInfoPref)
        options.showLearnedButton:SetChecked(showLearnedRecipes)
    end)
end
