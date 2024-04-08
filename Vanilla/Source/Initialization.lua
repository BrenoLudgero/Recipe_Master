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

local defaultPreferences = {
    -- Options window --
    backgroundOpacity = 1,
    progressColor = {0.00, 0.44, 0.87},
    progressTexture = "Interface/TARGETINGFRAME/BarFill2",
    restoreButtonIconTexture = "Interface/Icons/INV_Scroll_04",
    rowSpacing = 5,
    showLearnedRecipes = true,
    -- Recipes window --
    mainFrameOffsets = {605, -150},
    sortAscending = false,
    sortRecipesBy = "Skill"
}

-- Creates a table to store the characters' learned skills in SavedVariables
-- And a second table for the user's preferences
function rm.createSavedVariables()
    if not RecipeMasterProfessionsAndSkills then
        RecipeMasterProfessionsAndSkills = {}
    end
    if not RecipeMasterPreferences then
        RecipeMasterPreferences = defaultPreferences
    end
end

-- Inserts new options created after an update in SavedVariables
function rm.updateSavedVariables()
    for key, value in pairs(defaultPreferences) do
        if not RecipeMasterPreferences[key] then
            RecipeMasterPreferences[key] = value
        end
    end
end

function rm.resetSavedPreferences()
    RecipeMasterPreferences = defaultPreferences
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
    return RecipeMasterPreferences[preference]
end

function rm.setPreference(preference, newValue)
    RecipeMasterPreferences[preference] = newValue
end
