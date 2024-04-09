local addonName, rm = ...
-- rm: Globals within Recipe Master (variables, functions, frames)
rm.frame = CreateFrame("Frame")
rm.version = GetAddOnMetadata(addonName, "Version")
rm.author = GetAddOnMetadata(addonName, "Author")
rm.character = UnitName("player")
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

local defaultMainWindowPreferences = {
    mainFrameOffsets = {0, 0}, -- Used when TradeSkillMaster is enabled
    mainFrameHeight = 413, -- Used when TradeSkillMaster is enabled
    sortAscending = false,
    sortRecipesBy = "Name"
}

local defaultOptionsWindowPreferences = {
    backgroundOpacity = 1,
    progressColor = {0.00, 0.44, 0.87},
    progressTexture = "Interface/TARGETINGFRAME/BarFill2",
    restoreButtonIconTexture = "Interface/Icons/INV_Scroll_04",
    iconSpacing = 5,
    showLearnedRecipes = false,
    showRecipesInfo = false,
}

function rm.resetOptionsWindowPreferences()
    RecipeMasterOptionsWindowPreferences = defaultOptionsWindowPreferences
    -- When set to true in defaultPreferences, boolean options
    -- are always loaded from SavedVariables as true for some reason
    RecipeMasterOptionsWindowPreferences["showLearnedRecipes"] = true
    RecipeMasterOptionsWindowPreferences["showRecipesInfo"] = true
end

local function oldPreferencesFound()
    return RecipeMasterPreferences
end

-- Detects if the old preferences exists ("RecipeMasterPreferences") and deletes it (1.0.3 -> 1.1.0)
-- Or creates tables to store the characters' learned skills and user preferences in SavedVariables
function rm.createSavedVariables()
    if oldPreferencesFound() then
        RecipeMasterPreferences = nil
    end
    if not RecipeMasterProfessionsAndSkills then
        RecipeMasterProfessionsAndSkills = {}
    end
    if not RecipeMasterMainWindowPreferences then
        RecipeMasterMainWindowPreferences = defaultMainWindowPreferences
        RecipeMasterMainWindowPreferences["sortAscending"] = true
    end
    if not RecipeMasterOptionsWindowPreferences then
        rm.resetOptionsWindowPreferences()
    end
end

-- Inserts new options created after an update in SavedVariables
function rm.updateSavedVariables()
    for key, value in pairs(defaultMainWindowPreferences) do
        if not RecipeMasterMainWindowPreferences[key] then
            RecipeMasterMainWindowPreferences[key] = value
        end
    end
    for key, value in pairs(defaultOptionsWindowPreferences) do
        if not RecipeMasterOptionsWindowPreferences[key] then
            RecipeMasterOptionsWindowPreferences[key] = value
        end
    end
end

function rm.updateSavedCharacters()
    if not RecipeMasterProfessionsAndSkills[rm.server] then
        RecipeMasterProfessionsAndSkills[rm.server] = {}
    end
    if not RecipeMasterProfessionsAndSkills[rm.server][rm.character] then
        RecipeMasterProfessionsAndSkills[rm.server][rm.character] = {}
    end
end

function rm.getPreference(preference)
    if RecipeMasterMainWindowPreferences[preference] ~= nil then
        return RecipeMasterMainWindowPreferences[preference]
    elseif RecipeMasterOptionsWindowPreferences[preference] ~= nil then
        return RecipeMasterOptionsWindowPreferences[preference]
    end
end

function rm.setPreference(preference, newValue)
    if RecipeMasterMainWindowPreferences[preference] ~= nil then
        RecipeMasterMainWindowPreferences[preference] = newValue
    elseif RecipeMasterOptionsWindowPreferences[preference] ~= nil then
        RecipeMasterOptionsWindowPreferences[preference] = newValue
    end
end
