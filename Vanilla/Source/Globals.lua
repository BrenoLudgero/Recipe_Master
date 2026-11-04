local _, rm = ...
local L = rm.L

rm.activeTab = L.recipes
rm.displayedProfession = ""
rm.lastDisplayedProfession = ""
rm.selectedRecipeSource = "All"
rm.learnedRecipesCount = 0
rm.missingRecipesCount = 0
rm.totalRecipesCount = 0
rm.learnedPercentage = 0
rm.widestRecipeTextWidth = 0
rm.difficultyLevels = {
    {name = L.difficult, color = "ffFF8040"},
    {name = L.fair, color = "ffFFFF00"},
    {name = L.easy, color = "ff40C040"},
    {name = L.trivial, color = "ff808080"}
}
rm.sourcesOrder = {
    "trainer", 
    "vendor", 
    "quest", 
    "drop", 
    "pickpocket", 
    "object", 
    "item", 
    "fishing", 
    "unique"
}

local sourceTypes = {
    ["drop"] = L.drop,
    ["pickpocket"] = L.pickpocket,
    ["vendor"] = L.vendor,
    ["quest"] = L.quest,
    ["unique"] = L.unique,
    ["object"] = L.object,
    ["trainer"] = L.trainer,
    ["fishing"] = L.fishing,
    ["item"] = L.item
}

function rm.isRankupRecipe(recipe)
    return type(recipe.teaches) == "string"
end

function rm.getLocalizedSourceType(sourceType)
    return sourceTypes[sourceType]
end

-- Used when the database has no name in the game's language
local nearestLocales = {
    ["esES"] = "esMX",
    ["esMX"] = "esES",
    ["zhCN"] = "zhTW",
    ["zhTW"] = "zhCN"
}

-- names: Localized names from the database, by locale
function rm.getLocalizedName(names)
    local nearestLocale = nearestLocales[rm.locale]
    return names[rm.locale] or (nearestLocale and names[nearestLocale]) or names["enUS"]
end

function rm.tableContains(table, item)
    for _, value in ipairs(table) do
        if value == item then
            return true
        end
    end
    return false
end

function rm.getSavedVariablesForCurrentServerAndFaction()
    return RecipeMasterProfessionsAndSkills[rm.currentServer][rm.currentFaction]
end

function rm.getSavedVariablesForCurrentServerAndAllFactions()
    local allFactionsSavedVariables = {}
    local currentServerSavedVariables = RecipeMasterProfessionsAndSkills[rm.currentServer]
    local allianceCharactersData = currentServerSavedVariables["Alliance"]
    local hordeCharactersData = currentServerSavedVariables["Horde"]
    for characterName, professionData in pairs(allianceCharactersData or {}) do
        allFactionsSavedVariables[characterName] = professionData
    end
    for characterName, professionData in pairs(hordeCharactersData or {}) do
        allFactionsSavedVariables[characterName] = professionData
    end
    return allFactionsSavedVariables
end

function rm.getSavedVariablesForCurrentCharacter()
    return rm.getSavedVariablesForCurrentServerAndFaction()[rm.currentCharacter]
end

-- Class files are kept apart from the characters' profession data, which is iterated by profession ID
-- RecipeMasterProfessionsAndSkills[server]["classes"][character] = classFile (e.g. "DRUID")
local function getSavedClasses()
    local currentServerSavedVariables = RecipeMasterProfessionsAndSkills[rm.currentServer]
    currentServerSavedVariables["classes"] = currentServerSavedVariables["classes"] or {}
    return currentServerSavedVariables["classes"]
end

function rm.saveCurrentCharacterClass()
    getSavedClasses()[rm.currentCharacter] = select(2, UnitClass("player"))
end

-- A character's class is only stored when it logs in
-- Guilded alts are filled in from the guild roster so that their names are class colored right away
local function isClassMissingForAnySavedCharacter()
    local savedClasses = getSavedClasses()
    for characterName in pairs(rm.getSavedVariablesForCurrentServerAndAllFactions()) do
        if not savedClasses[characterName] then
            return true
        end
    end
    return false
end

function rm.requestGuildRosterIfClassesAreMissing()
    if IsInGuild() and C_GuildInfo and isClassMissingForAnySavedCharacter() then
        C_GuildInfo.GuildRoster()
    end
end

function rm.saveGuildMembersClasses()
    if not IsInGuild() or not isClassMissingForAnySavedCharacter() then
        return
    end
    local savedClasses = getSavedClasses()
    local savedCharacters = rm.getSavedVariablesForCurrentServerAndAllFactions()
    for i = 1, GetNumGuildMembers() do
        local memberName, _, _, _, _, _, _, _, _, _, classFile = GetGuildRosterInfo(i)
        if memberName and classFile then
            local characterName, realm = strsplit("-", memberName)
            local isCurrentServer = not realm or realm == rm.currentServer:gsub("[%s%-]", "")
            if isCurrentServer and savedCharacters[characterName] and not savedClasses[characterName] then
                savedClasses[characterName] = classFile
            end
        end
    end
end

-- Supports class color add-ons. Falls back to white for characters whose class is unknown yet
function rm.getClassColoredCharacterName(characterName)
    local class = getSavedClasses()[characterName]
    local classColor = class and ((CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class]) or RAID_CLASS_COLORS[class])
    if not classColor then
        return characterName
    end
    local classColorHex = string.format(
        "ff%02X%02X%02X",
        math.floor(classColor.r * 255),
        math.floor(classColor.g * 255),
        math.floor(classColor.b * 255)
    )
    return WrapTextInColorCode(characterName, classColorHex)
end

function rm.getProfessionID(professionName)
    return tInvert(L.professions)[professionName]
end

-- Includes gathering professions (e.g. Herbalism), which are tracked but have no recipes
function rm.getTrackedProfessionID(professionName)
    return rm.getProfessionID(professionName) or tInvert(L.gatheringProfessions)[professionName]
end

function rm.getIDFromLink(link)
    local strippedLink = select(2, strsplit(":", link))
    local ID = tonumber(string.match(strippedLink, "%d+")) -- Extracts only numerical part
    return ID
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

function rm.toggleBooleanPreference(preference)
    local currentPreference = rm.getPreference(preference)
    rm.setPreference(preference, not currentPreference)
end
