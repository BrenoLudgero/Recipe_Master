local addonName, rm = ...
-- rm: Globals within Recipe Master (variables, functions, frames)

rm.L = {} -- Localized text
rm.L.title = C_AddOns.GetAddOnMetadata(addonName, "Title")
rm.frame = CreateFrame("Frame")
rm.frame.name = rm.L.title
rm.version = C_AddOns.GetAddOnMetadata(addonName, "Version")
rm.author = C_AddOns.GetAddOnMetadata(addonName, "Author")
-- On WoW Forever, UnitName's 2nd return is the character's surname instead of a realm name
-- Characters are saved and displayed with their whole name there (e.g. "Gogopriest Gogo")
local function getCurrentCharacterName()
    local name, surname = (UnitNameUnmodified or UnitName)("player")
    rm.currentFirstName = name
    if surname and surname ~= "" and RegionalUniqueNamesEnabled and RegionalUniqueNamesEnabled() then
        local separators = Constants.CharacterNameSeparatorConsts
        local ending = (separators and separators.CHARACTERNAME_SURNAME_SEPARATOR or " ")..surname
        if name:sub(-#ending) ~= ending then -- Some builds already return the whole name
            name = name..ending
        end
    end
    return name
end

rm.currentCharacter = getCurrentCharacterName()
rm.currentFaction = UnitFactionGroup("player") -- Alliance/Horde, always in English
rm.currentLevel = UnitLevel("player")
rm.currentServer = GetRealmName()
rm.locale = GetLocale()
rm.recipeDB = {}
rm.recipeSourceDB = {}
rm.F = { -- Frame settings
    atlases = {},
    backdrops = {},
    colors = {},
    fonts = {},
    fontSizes = {},
    offsets = {},
    sizes = {},
    templates = {},
    textures = {},
}

local defaultMainFramePreferences = {
    sortAscending = true,
    sortRecipesBy = "Name",
    showLearnedRecipes = false,
    showRecipesInfo = true,
    maximizeMainFrame = true,
}

local defaultOptionsFramePreferences = {
    backgroundOpacity = 1,
    iconSpacing = 5,
    interfaceScale = 0.1,
    progressColor = {0.00, 0.44, 0.87},
    progressTexture = "Interface/TARGETINGFRAME/BarFill2",
    restoreButtonIconTexture = "Interface/Icons/INV_Scroll_04",
    showDifficultyTooltipInfo = true,
    showAltsTooltipInfo = true,
    showOppositeFactionAltsTooltipInfo = true,
    showSourcesTooltipInfo = true,
}

function rm.resetOptionsFramePreferences()
    RecipeMasterOptionsFramePreferences = defaultOptionsFramePreferences
end

-- Creates new tables to store the characters' learned skills and user preferences in SavedVariables
function rm.createSavedVariables()
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
        if defaultMainFramePreferences[key] == nil then
            RecipeMasterMainFramePreferences[key] = nil
        end
    end
    for key in pairs(RecipeMasterOptionsFramePreferences) do
        if defaultOptionsFramePreferences[key] == nil then
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
    if not RecipeMasterProfessionsAndSkills[rm.currentServer][rm.currentFaction] then
        RecipeMasterProfessionsAndSkills[rm.currentServer][rm.currentFaction] = {}
    end
    local factionCharacters = RecipeMasterProfessionsAndSkills[rm.currentServer][rm.currentFaction]
    local firstName = rm.currentFirstName
    -- Moves data saved under the first name alone (before surnames were supported) to the whole name
    if firstName ~= rm.currentCharacter and factionCharacters[firstName] then
        factionCharacters[rm.currentCharacter] = factionCharacters[rm.currentCharacter] or factionCharacters[firstName]
        factionCharacters[firstName] = nil
        local classes = RecipeMasterProfessionsAndSkills[rm.currentServer]["classes"]
        if classes then
            classes[firstName] = nil
        end
    end
    if not factionCharacters[rm.currentCharacter] then
        factionCharacters[rm.currentCharacter] = {}
    end
end

-- Creates the chat command "/rm" to open the add-on's options menu
function rm.createChatCommand()
    SLASH_RECIPEMASTER1 = "/rm"
    SlashCmdList["RECIPEMASTER"] = function()
        Settings.OpenToCategory(rm.category:GetID())
    end
end
