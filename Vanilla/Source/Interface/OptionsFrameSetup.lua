local _, rm = ...
local L = rm.L
local F = rm.F

function rm.updateBackgroundOpacity(opacitySlider)
    opacitySlider:SetScript("OnValueChanged", function(self, value)
        local roundedValue = math.floor(value * 100)
        local roundedValueToTwoDecimals = roundedValue / 100
        rm.setPreference("backgroundOpacity", roundedValueToTwoDecimals)
        opacitySlider.valueDisplay:SetText((roundedValue).."%")
        F.colors.mainBackground = {1, 1, 1, rm.getPreference("backgroundOpacity")}
        F.colors.detailsBackground = {0.7, 0.7, 0.7, rm.getPreference("backgroundOpacity")}
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

function rm.updateRowSpacing(spacingSlider, valueDisplay)
    spacingSlider:SetScript("OnValueChanged", function(self, value)
        local integerValue = math.floor(value * 1)
        rm.setPreference("rowSpacing", integerValue)
        valueDisplay:SetText(integerValue)
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

function rm.resetSavedVariablesOnClick(resetDefaultsButton, opacitySlider, spacingSlider, restoreButtonDropdown, progressBrightness, progressColor, showLearnedButton)
    resetDefaultsButton:SetScript("OnClick", function(self)
        rm.resetSavedPreferences()
        opacitySlider:SetValue(rm.getPreference("backgroundOpacity"))
        opacitySlider.valueDisplay:SetText((rm.getPreference("backgroundOpacity") * 100).."%")
        spacingSlider:SetValue(rm.getPreference("rowSpacing"))
        spacingSlider.valueDisplay:SetText(rm.getPreference("rowSpacing"))
        rm.setInitialDropdownValue(restoreButtonDropdown, "restoreButtonIconTexture")
        UIDropDownMenu_SetText(restoreButtonDropdown, L.epic)
        rm.setInitialDropdownValue(progressBrightness, "progressTexture")
        UIDropDownMenu_SetText(progressBrightness, L.bright)
        rm.setInitialDropdownValue(progressColor, "progressColor")
        UIDropDownMenu_SetText(progressColor, L.blue)
        showLearnedButton:SetChecked(rm.getPreference("showLearnedRecipes"))
        rm.restoreButton.texture:SetTexture(rm.getPreference("restoreButtonIconTexture"))
    end)
end
