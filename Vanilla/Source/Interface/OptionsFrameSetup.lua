local _, rm = ...
local L = rm.L
local F = rm.F

function rm.updateBackgroundOpacity(opacitySlider)
    opacitySlider:SetScript("OnValueChanged", function(self, value)
        local valueToTwoDecimals = value / 100
        rm.setPreference("backgroundOpacity", valueToTwoDecimals)
        opacitySlider.valueDisplay:SetText(value.."%")
        F.colors.mainBackground = {1, 1, 1, valueToTwoDecimals}
        F.colors.detailsBackground = {0.7, 0.7, 0.7, valueToTwoDecimals}
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
    updateFrameTexture(frame, savedVariable)
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

function rm.toggleShowLearnedRecipesOnClick(showLearnedButton)
    showLearnedButton:SetScript("OnClick", function(self)
        local showLearned = rm.getPreference("showLearnedRecipes")
        if showLearned then
            rm.setPreference("showLearnedRecipes", false)
            return
        end
        rm.setPreference("showLearnedRecipes", true)
    end)
end

function rm.resetSavedVariablesOnClick(resetDefaultsButton, options)
    resetDefaultsButton:SetScript("OnClick", function(self)
        rm.resetOptionsWindowPreferences()
        local opacity = rm.getPreference("backgroundOpacity")
        local spacing = rm.getPreference("iconSpacing")
        local progressColorPref = rm.getPreference("progressColor")
        local restoreButtonIconTexture = rm.getPreference("restoreButtonIconTexture")
        local showLearnedRecipes = rm.getPreference("showLearnedRecipes")
        options.opacitySlider:SetValue(opacity * 100)
        options.opacitySlider.valueDisplay:SetText((opacity * 100) .. "%")
        options.spacingSlider:SetValue(spacing)
        options.spacingSlider.valueDisplay:SetText(spacing)
        UIDropDownMenu_SetText(options.progressBrightness, L.bright)
        updateFrameTexture(rm.progressBar, "progressTexture")
        UIDropDownMenu_SetText(options.progressColor, L.blue)
        rm.progressBar:SetStatusBarColor(unpack(progressColorPref))
        UIDropDownMenu_SetText(options.restoreButton, L.epic)
        rm.restoreButton.texture:SetTexture(restoreButtonIconTexture)
        options.showLearnedButton:SetChecked(showLearnedRecipes)
    end)
end
