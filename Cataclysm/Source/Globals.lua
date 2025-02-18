local _, rm = ...
local L = rm.L

rm.activeTab = L.recipes
rm.isMainFrameMaximized = true
rm.displayedProfession = ""
rm.lastDisplayedProfession = ""
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
    "spell", 
    "quest", 
    "achievement", 
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
    ["item"] = L.item,
    ["achievement"] = L.achievement,
    ["spell"] = L.spell
}

function rm.getLocalizedSourceType(sourceType)
    return sourceTypes[sourceType]
end

function rm.tableContains(table, item)
    for _, value in ipairs(table) do
        if value == item then
            return true
        end
    end
    return false
end

function rm.getServerSavedVariables()
    return RecipeMasterProfessionsAndSkills[rm.currentServer]
end

function rm.getCurrentCharacterSavedVariables()
    return rm.getServerSavedVariables()[rm.currentCharacter]
end

function rm.getProfessionID(professionName)
    return tInvert(L.professions)[professionName]
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
