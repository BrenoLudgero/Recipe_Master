function updateBackgroundOpacity(opacitySlider)
    opacitySlider:SetScript("OnValueChanged", function(self, value)
        RecipeMasterPreferences["backgroundOpacity"] = math.floor(value * 100) / 100 -- Rounded to two decimal places
        opacitySlider.valueDisplay:SetText(math.floor(value * 100).."%")
        colors.mainBackground = {1, 1, 1, RecipeMasterPreferences["backgroundOpacity"]}
        colors.detailsBackground = {0.7, 0.7, 0.7, RecipeMasterPreferences["backgroundOpacity"]}
    end)
end

function updateSavedVariable(dropdown, selectedID, savedVariable, frame)
    UIDropDownMenu_SetSelectedID(dropdown, selectedID)
    local selectedValue = dropdown.values[selectedID].value
    RecipeMasterPreferences[savedVariable] = selectedValue
    if frame and frame ~= progressBar then
        frame:SetTexture(RecipeMasterPreferences[savedVariable])
    elseif frame == progressBar then
        frame:SetStatusBarTexture(RecipeMasterPreferences[savedVariable])
    end
end

function handleTextureOptions(dropdown, savedVariable, frame)
    UIDropDownMenu_Initialize(dropdown, function(self)
        for _, option in ipairs(dropdown.values) do
            local info = UIDropDownMenu_CreateInfo()
            info.minWidth = sizes.optionsDropdownWidth + 10
            info.text = option.text
            info.value = option.value
            info.func = function(self)
                updateSavedVariable(dropdown, self:GetID(), savedVariable, frame)
            end
            UIDropDownMenu_AddButton(info)
        end
    end)
end

function updateRowSpacing(spacingSlider, valueDisplay)
    spacingSlider:SetScript("OnValueChanged", function(self, value)
        RecipeMasterPreferences["rowSpacing"] = math.floor(value * 1) -- Rounded to an integer
        valueDisplay:SetText(math.floor(value * 1))
    end)
end

function toggleShowLearnedRecipesOnClick(showLearnedButton)
    showLearnedButton:SetScript("OnClick", function(self)
        local showLearned = RecipeMasterPreferences["showLearnedRecipes"]
        if showLearned then
            RecipeMasterPreferences["showLearnedRecipes"] = false
            return
        end
        RecipeMasterPreferences["showLearnedRecipes"] = true
    end)
end

function resetSavedVariablesOnClick(resetDefaultsButton, opacitySlider, spacingSlider, restoreButtonDropdown, progressBrightness, progressColor, showLearnedButton)
    resetDefaultsButton:SetScript("OnClick", function(self)
        resetSavedPreferences()
        opacitySlider:SetValue(RecipeMasterPreferences["backgroundOpacity"])
        opacitySlider.valueDisplay:SetText((RecipeMasterPreferences["backgroundOpacity"] * 100).."%")
        spacingSlider:SetValue(RecipeMasterPreferences["rowSpacing"])
        spacingSlider.valueDisplay:SetText(RecipeMasterPreferences["rowSpacing"])
        setInitialDropdownValue(restoreButtonDropdown, "restoreButtonIconTexture")
        UIDropDownMenu_SetText(restoreButtonDropdown, strings.epic)
        setInitialDropdownValue(progressBrightness, "progressTexture")
        UIDropDownMenu_SetText(progressBrightness, strings.bright)
        setInitialDropdownValue(progressColor, "progressColor")
        UIDropDownMenu_SetText(progressColor, strings.blue)
        showLearnedButton:SetChecked(RecipeMasterPreferences["showLearnedRecipes"])
    end)
end
