local _, rm = ...
local L = rm.L

rm.autoOpenRecipesFrame = true
rm.displayedProfession = ""
rm.lastDisplayedProfession = ""
rm.displayedRecipesCount = 0
rm.learnedRecipesCount = 0
rm.missingRecipesCount = 0
rm.totalRecipesCount = 0
rm.learnedPercentage = 0
rm.widestRecipeTextWidth = 0

function rm.tableContains(table, item)
    for _, value in ipairs(table) do
        if value == item then
            return true
        end
    end
    return false
end

function rm.getCharacterSavedVariables()
    return RecipeMasterProfessionsAndSkills[rm.server][rm.character]
end

function rm.getProfessionID(professionName)
    return tInvert(L.professionNames)[professionName]
end
