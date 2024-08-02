local _, rm = ...
local L = rm.L

rm.autoOpenRecipesFrame = true
rm.displayedProfession = ""
rm.lastDisplayedProfession = ""
rm.learnedRecipesCount = 0
rm.missingRecipesCount = 0
rm.totalRecipesCount = 0
rm.learnedPercentage = 0
rm.widestRecipeTextWidth = 0

function rm.isRecipeListEmpty()
    return #rm.recipesList.children == 0
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
    return RecipeMasterProfessionsAndSkills[rm.server]
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

function rm.getSeason()
    local season = C_Seasons.GetActiveSeason()
    local seasonNames = {
        [Enum.SeasonID.SeasonOfMastery] = "SoM",
        [Enum.SeasonID.SeasonOfDiscovery] = "SoD"
    }
    return seasonNames[season]
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
