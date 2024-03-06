local function isRecipeForCurrentClass(recipe)
    local _, characterClass = UnitClass("player") -- Always in English and upper case
    return not recipe.class or (string.upper(recipe.class) == characterClass)
end

local function getSeason()
    local season = C_Seasons.GetActiveSeason()
    local seasonName = {
        [Enum.SeasonID.SeasonOfMastery] = "SoM",
        [Enum.SeasonID.SeasonOfDiscovery] = "SoD"
    }
    return seasonName[season]
end

local function isRecipeForCurrentSeason(recipe)
    local serverSeason = getSeason()
    return not recipe.season or (recipe.season == serverSeason)
end

local function isRecipeForCurrentSpecialization(recipe)
    local professionID = getProfessionID(displayedProfession)
    local professionSpecialization = getSavedSpecializationByID(professionID)
    return not recipeSpecialization or (professionSpecialization == recipe.specialization)
end

function isRecipeAvailableForCharacter(recipe)
    return isRecipeForCurrentSeason(recipe) and isRecipeForCurrentClass(recipe) and isRecipeForCurrentSpecialization(recipe)
end

-- Identifies all rankup recipes that teach a rank equal to or lower than the current profession rank
local function isLearnedRankupRecipe(recipe, professionRank)
    if type(recipe.teaches) == "string" then
        local rankOrder = {Apprentice = 1, Journeyman = 2, Expert = 3, Artisan = 4}
        return rankOrder[recipe.teaches] <= rankOrder[professionRank]
    end
    return false
end

function isLearnedRecipe(recipe)
    local learnedSkills = getSavedSkillsByProfessionName(displayedProfession)
    local professionRank = getSavedProfessionRank(displayedProfession)
    local learnedRecipe = tableContains(learnedSkills, recipe.teaches)
    return learnedRecipe or isLearnedRankupRecipe(recipe, professionRank)
end

function isMissingRecipeOfCurrentFaction(recipe)
    local characterFaction = UnitFactionGroup("player") -- Always in English
    return not recipe.faction or (recipe.faction == characterFaction)
end

-- Comparing recipe.profession with displayedProfession caused Engineering recipes to not display in Korean during testing
function isRecipeForDisplayedProfession(recipe)
    return removeSpaces(recipe.profession) == removeSpaces(displayedProfession)
end

local function isMiningSkill(recipeID)
    return recipeID == 14891 or recipeID == 22967
end

local function getMiningIcon(recipeID)
    if recipeID == 14891 then
        return 133233
    end
    return 133235
end

-- Recipes that return a profession name different than the profession's display name for some languages
local function handleMismatchedProfessionNames(profession)
    if displayedProfession == "Наложение чар" and profession == "Зачаровывание" then
        return displayedProfession
    elseif displayedProfession == "Costura" and profession == "Sastrería" then
        return displayedProfession
    end
    return profession
end

local function getAdditionalRecipeData(id)
   local name, link, quality, _, _, _, profession, _, _, texture = GetItemInfo(id)
   profession = handleMismatchedProfessionNames(profession)
    if isMiningSkill(id) then
       name = GetSpellInfo(id)
       link = "|cff71d5ff|Hspell:"..id.."|h["..name.."]|h|r"
       profession = professionNames[186]
       texture = getMiningIcon(id)
    end
    if quality then -- Avoids an error when Mining is the first profession window opened
        return removeRecipePrefix(name), link, quality, profession, texture
    end
end

local function saveRecipeData(recipeID, recipeData)
    local rName, rLink, rQuality, rProfession, rTexture = getAdditionalRecipeData(recipeID)
    return {
        id = recipeID, 
        class = recipeData["class"], 
        faction = recipeData["faction"], 
        link = rLink,
        name = rName, 
        profession = rProfession, 
        quality = rQuality, 
        season = recipeData["season"] , 
        skill = recipeData["reqSkill"], 
        texture = rTexture,
        specialization = recipeData["specialization"], 
        teaches = recipeData["teaches"]
    }
end

-- Compares all the available skills for the currently displayed profession 
-- with each spell teached / item crafted by the recipes in RecipeDatabase
function getAllProfessionRecipes(getNumSkillsFunction, getSkillInfoFunction)
    local professionRecipes = {}
    local savedProfessionsAndSkills = getCharacterSavedVariables()
    local numSkills = getNumSkillsFunction()
    for i = 1, numSkills do
        local _, skillType, craftType = getSkillInfoFunction(i)
        if skillType ~= "header" and craftType ~= "header" then
            for professionID, professionData in pairs(savedProfessionsAndSkills) do
                local professionRank = professionData["rank"]
                local professionRecipesDatabase = _G["id"..professionID] -- e.g. id202 (RecipeDatabase/Engineering.lua)
                for recipeID, recipeData in pairs(professionRecipesDatabase) do
                    local recipe = professionRecipes[recipeID]
                    if not recipe then
                        recipe = saveRecipeData(recipeID, recipeData)
                        professionRecipes[recipeID] = recipe
                    end
                end
            end
        end
    end
    return professionRecipes
end
