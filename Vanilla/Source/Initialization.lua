local addonName, rm = ...
-- rm: Globals within Recipe Master (variables, functions, frames)

local function getCurrentSeason()
    local season = C_Seasons.GetActiveSeason()
    local seasonNames = {
        [Enum.SeasonID.SeasonOfMastery] = "SoM",
        [Enum.SeasonID.SeasonOfDiscovery] = "SoD"
    }
    return seasonNames[season]
end

rm.frame = CreateFrame("Frame")
rm.version = C_AddOns.GetAddOnMetadata(addonName, "Version")
rm.author = C_AddOns.GetAddOnMetadata(addonName, "Author")
rm.currentCharacter = UnitName("player")
rm.currentFaction = UnitFactionGroup("player") -- Alliance/Horde, always in English
rm.currentSeason = getCurrentSeason()
rm.currentServer = GetRealmName()
rm.locale = GetLocale()
rm.recipeDB = {}
rm.sourceDB = {}
rm.L = {} -- Localized text
rm.L.title = C_AddOns.GetAddOnMetadata(addonName, "Title")
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

-- Creates the chat command "/rm" to open the add-on's options menu
SLASH_RECIPEMASTER1 = "/rm"
SlashCmdList["RECIPEMASTER"] = function()
    Settings.OpenToCategory(rm.frame.name)
end

local defaultMainFramePreferences = {
    sortAscending = true,
    sortRecipesBy = "Name"
}

local defaultOptionsFramePreferences = {
    backgroundOpacity = 1,
    iconSpacing = 5,
    interfaceScale = 0.1,
    progressColor = {0.00, 0.44, 0.87},
    progressTexture = "Interface/TARGETINGFRAME/BarFill2",
    restoreButtonIconTexture = "Interface/Icons/INV_Scroll_04",
    showLearnedRecipes = true,
    showRecipesInfo = true,
    showAltsTooltipInfo = true,
    showSourcesTooltipInfo = true
}

local function oldPreferencesFound()
    return RecipeMasterPreferences
end

function rm.resetOptionsFramePreferences()
    RecipeMasterOptionsFramePreferences = defaultOptionsFramePreferences
end

-- Detects and deletes the old preferences table "RecipeMasterPreferences" (1.0.3 -> 1.1.0)
-- and/or creates new tables to store the characters' learned skills and user preferences in SavedVariables
function rm.createSavedVariables()
    if oldPreferencesFound() then
        RecipeMasterPreferences = nil
    end
    if not RecipeMasterProfessionsAndSkills then
        RecipeMasterProfessionsAndSkills = {}
    end
    if not RecipeMasterMainFramePreferences then
        RecipeMasterMainFramePreferences = defaultMainFramePreferences
    end
    if not RecipeMasterOptionsFramePreferences then
        rm.resetOptionsFramePreferences()
    end
end

local function insertNewOptionsInSavedVariables()
    for key, value in pairs(defaultMainFramePreferences) do
        if RecipeMasterMainFramePreferences[key] == nil then
            RecipeMasterMainFramePreferences[key] = value
        end
    end
    for key, value in pairs(defaultOptionsFramePreferences) do
        if RecipeMasterOptionsFramePreferences[key] == nil then
            RecipeMasterOptionsFramePreferences[key] = value
        end
    end
end

local function removeUnusedOptionsFromSavedVariables()
    for key in pairs(RecipeMasterMainFramePreferences) do
        if not defaultMainFramePreferences[key] then
            RecipeMasterMainFramePreferences[key] = nil
        end
    end
    for key in pairs(RecipeMasterOptionsFramePreferences) do
        if not defaultOptionsFramePreferences[key] then
            RecipeMasterOptionsFramePreferences[key] = nil
        end
    end
end

function rm.updateSavedVariables()
    insertNewOptionsInSavedVariables()
    removeUnusedOptionsFromSavedVariables()
end

function rm.updateSavedCharacters()
    if not RecipeMasterProfessionsAndSkills[rm.currentServer] then
        RecipeMasterProfessionsAndSkills[rm.currentServer] = {}
    end
    if not RecipeMasterProfessionsAndSkills[rm.currentServer][rm.currentCharacter] then
        RecipeMasterProfessionsAndSkills[rm.currentServer][rm.currentCharacter] = {}
    end
end
