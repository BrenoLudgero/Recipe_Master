local addonName, rm = ...
-- rm: Globals within Recipe Master (variables, functions, frames)
rm.frame = CreateFrame("Frame")
rm.version = GetAddOnMetadata(addonName, "Version")
rm.author = GetAddOnMetadata(addonName, "Author")
rm.currentCharacter = UnitName("player")
rm.currentFaction = UnitFactionGroup("player") -- Alliance/Horde, always in English
rm.locale = GetLocale()
rm.server = GetRealmName()
rm.recipes = {}
rm.L = {} -- Localized text
rm.L.title = GetAddOnMetadata(addonName, "Title")
rm.F = { -- Frame settings
    backdrops = {},
    colors = {},
    fonts = {},
    fontSizes = {},
    offsets = {},
    sizes = {},
    templates = {},
    textures = {}
}

SLASH_RECIPEMASTER1 = "/rm"
SlashCmdList["RECIPEMASTER"] = function()
    Settings.OpenToCategory(rm.L.title)
end

local defaultMainFramePreferences = {
    mainFrameOffsets = {0, 0}, -- Used when TradeSkillMaster is enabled
    mainFrameHeight = 413, -- Used when TradeSkillMaster is enabled
    sortAscending = false,
    sortRecipesBy = "Name"
}

local defaultOptionsFramePreferences = {
    backgroundOpacity = 1,
    progressColor = {0.00, 0.44, 0.87},
    progressTexture = "Interface/TARGETINGFRAME/BarFill2",
    restoreButtonIconTexture = "Interface/Icons/INV_Scroll_04",
    iconSpacing = 5,
    showLearnedRecipes = false,
    showRecipesInfo = false,
}

function rm.resetOptionsFramePreferences()
    RecipeMasterOptionsFramePreferences = defaultOptionsFramePreferences
    -- When set to true in defaultPreferences, boolean options
    -- are always loaded from SavedVariables as true for some reason
    RecipeMasterOptionsFramePreferences["showLearnedRecipes"] = true
    RecipeMasterOptionsFramePreferences["showRecipesInfo"] = true
end

local function oldPreferencesFound()
    return RecipeMasterPreferences
end

-- Detects if the old preferences exists ("RecipeMasterPreferences") and deletes it (1.0.3 -> 1.1.0)
-- or creates tables to store the characters' learned skills and user preferences in SavedVariables
function rm.createSavedVariables()
    if oldPreferencesFound() then
        RecipeMasterPreferences = nil
    end
    if not RecipeMasterProfessionsAndSkills then
        RecipeMasterProfessionsAndSkills = {}
    end
    if not RecipeMasterMainFramePreferences then
        RecipeMasterMainFramePreferences = defaultMainFramePreferences
        RecipeMasterMainFramePreferences["sortAscending"] = true
    end
    if not RecipeMasterOptionsFramePreferences then
        rm.resetOptionsFramePreferences()
    end
end

-- Inserts new options created after an update in SavedVariables
function rm.updateSavedVariables()
    for key, value in pairs(defaultMainFramePreferences) do
        if not RecipeMasterMainFramePreferences[key] then
            RecipeMasterMainFramePreferences[key] = value
        end
    end
    for key, value in pairs(defaultOptionsFramePreferences) do
        if not RecipeMasterOptionsFramePreferences[key] then
            RecipeMasterOptionsFramePreferences[key] = value
        end
    end
end

function rm.updateSavedCharacters()
    if not RecipeMasterProfessionsAndSkills[rm.server] then
        RecipeMasterProfessionsAndSkills[rm.server] = {}
    end
    if not RecipeMasterProfessionsAndSkills[rm.server][rm.currentCharacter] then
        RecipeMasterProfessionsAndSkills[rm.server][rm.currentCharacter] = {}
    end
end

function rm.getPreference(preference)
    if RecipeMasterMainFramePreferences[preference] ~= nil then
        return RecipeMasterMainFramePreferences[preference]
    elseif RecipeMasterOptionsFramePreferences[preference] ~= nil then
        return RecipeMasterOptionsFramePreferences[preference]
    end
end

function rm.setPreference(preference, newValue)
    if RecipeMasterMainFramePreferences[preference] ~= nil then
        RecipeMasterMainFramePreferences[preference] = newValue
    elseif RecipeMasterOptionsFramePreferences[preference] ~= nil then
        RecipeMasterOptionsFramePreferences[preference] = newValue
    end
end
