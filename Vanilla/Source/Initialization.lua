RecipeMasterName = GetAddOnMetadata("RecipeMaster", "Title")
RecipeMasterVersion = GetAddOnMetadata("RecipeMaster", "Version")
RecipeMasterAuthor = GetAddOnMetadata("RecipeMaster", "Author")
character = UnitName("player")
server = GetRealmName()

SLASH_RM1 = "/rm"
SlashCmdList["RM"] = function()
    Settings.OpenToCategory(RecipeMaster)
end

local defaultPreferences = {
    -- Options window --
    backgroundOpacity = 1,
    progressColor = {0.00, 0.44, 0.87},
    progressTexture = "Interface/TARGETINGFRAME/BarFill2",
    restoreButtonIconTexture = "Interface/Icons/INV_Scroll_04",
    rowSpacing = 2,
    showLearnedRecipes = true,
    -- Recipes window --
    sortAscending = true,
    sortRecipesBy = "Name"
}

-- Creates a table to store the characters' learned skills in SavedVariables
-- And a second table for the user's preferences
function createRecipeMasterSavedVariables()
    if not RecipeMasterProfessionsAndSkills then
        RecipeMasterProfessionsAndSkills = {}
    end
    if not RecipeMasterPreferences then
        RecipeMasterPreferences = defaultPreferences
    end
end

function resetSavedPreferences()
    RecipeMasterPreferences = defaultPreferences
end

function updateRecipeMasterSavedCharacters()
    if not RecipeMasterProfessionsAndSkills[server] then
        RecipeMasterProfessionsAndSkills[server] = {}
    end
    if not RecipeMasterProfessionsAndSkills[server][character] then
        RecipeMasterProfessionsAndSkills[server][character] = {}
    end
end
