autoOpenRecipeMaster = true
displayedProfession = ""
lastDisplayedProfession = ""
displayedRecipesCount = 0
learnedRecipesCount = 0
missingRecipesCount = 0
totalRecipesCount = 0
learnedPercentage = 0
widestRecipeTextWidth = 0

function tableContains(table, item)
    for _, value in ipairs(table) do
        if value == item then
            return true
        end
    end
    return false
end

function getCharacterSavedVariables()
    return RecipeMasterProfessionsAndSkills[server][character]
end

function getProfessionID(professionName)
    return tInvert(professionNames)[professionName]
end
