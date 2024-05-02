local _, rm = ...
local L = rm.L

local function isRecipeForCurrentSeason(recipe)
    local serverSeason = rm.getSeason()
    return not recipe.season or (recipe.season == serverSeason)
end

local function isRecipeForCurrentClass(recipe)
    local _, characterClass = UnitClass("player") -- Always in English and upper case
    return not recipe.class or (string.upper(recipe.class) == characterClass)
end

local function isRecipeForCurrentSpecialization(recipe)
    local professionID = rm.getProfessionID(rm.displayedProfession)
    local currentSpecialization = rm.getSavedSpecializationByID(professionID)
    return (
        not recipe.specialization 
        or not currentSpecialization 
        or (currentSpecialization == recipe.specialization)
    )
end

function rm.isRecipeAvailableForCharacter(recipe)
    return (
        isRecipeForCurrentSeason(recipe) 
        and isRecipeForCurrentClass(recipe) 
        and isRecipeForCurrentSpecialization(recipe)
    )
end

local function isRankupRecipe(recipe)
    return type(recipe.teachesSpell) == "string"
end

local function isSkillLearnedByCharacter(characterSkills, recipe)
    return (
        rm.tableContains(characterSkills, recipe.teachesItem)
        or rm.tableContains(characterSkills, recipe.teachesSpell)
    )
end

function rm.getAllCharactersRecipeStatus(recipe, professionID)
    local characters = rm.getProfessionSkillsForAllCharacters(professionID)
    local charactersMissingRecipeSkill = {}
    local charactersWithRecipeSkill = {}
    for character in pairs(characters) do
        local characterSkills = characters[character][professionID]
        if character ~= rm.currentCharacter and not isRankupRecipe(recipe) and characterSkills then
            if not isSkillLearnedByCharacter(characterSkills, recipe) then
                table.insert(charactersMissingRecipeSkill, character)
            else
                table.insert(charactersWithRecipeSkill, character)
            end
        end
    end
    return charactersMissingRecipeSkill, charactersWithRecipeSkill
end

-- Identifies all rankup recipes that teach a rank equal to or lower than the current profession rank
local function isLearnedRankupRecipe(recipe, professionRank)
    if isRankupRecipe(recipe) then
        local rankOrder = {Apprentice = 1, Journeyman = 2, Expert = 3, Artisan = 4}
        return rankOrder[recipe.teachesSpell] <= rankOrder[professionRank]
    end
    return false
end

function rm.isLearnedRecipe(recipe)
    local learnedSkills = rm.getSavedSkillsByProfessionName(rm.displayedProfession)
    local professionRank = rm.getSavedProfessionRank(rm.displayedProfession)
    local isLearnedRecipe = isSkillLearnedByCharacter(learnedSkills, recipe)
    return isLearnedRecipe or isLearnedRankupRecipe(recipe, professionRank)
end

function rm.isMissingRecipeOfCurrentFaction(recipe)
    local characterFaction = UnitFactionGroup("player") -- Always in English
    return not recipe.faction or (recipe.faction == characterFaction)
end

-- Removing spaces is required for Engineering and Leatherworking in Korean
function rm.isRecipeForDisplayedProfession(recipe)
    return rm.removeSpaces(recipe.profession) == rm.removeSpaces(rm.displayedProfession)
end

-- Recipes that return a profession name different than the profession's display name for some languages
function rm.handleMismatchedProfessionNames(professionName)
    if professionName == "가죽세공" then
        return "가죽 세공"
    elseif professionName == "기계 공학" then
        return "기계공학"
    elseif professionName == "Зачаровывание" then
        return "Наложение чар"
    elseif professionName == "Sastrería" and rm.locale == "esES" then
        return "Costura"
    end
    return professionName
end

local function isMiningSkill(recipeID)
    return recipeID == 14891 or recipeID == 22967
end

local function getAdditionalRecipeData(ID)
   local name, link, quality, _, _, _, profession, _, _, texture = C_Item.GetItemInfo(ID)
   profession = rm.handleMismatchedProfessionNames(profession)
    if isMiningSkill(ID) then
       name = GetSpellInfo(ID)
       link = "|cff71d5ff|Hspell:"..ID.."|h["..name.."]|h|r"
       profession = L.professions[186]
       texture = rm.recipes[186][ID].icon
    end
    return rm.removeRecipePrefix(name, true), link, quality, profession, texture
end

local function saveRecipeData(recipeID, recipeData)
    local rName, rLink, rQuality, rProfession, rTexture = getAdditionalRecipeData(recipeID)
    return {
        class = recipeData["class"], 
        faction = recipeData["faction"], 
        link = rLink,
        name = rName, 
        profession = rProfession, 
        quality = rQuality, 
        repFaction = recipeData["repFaction"], 
        repLevel = recipeData["repLevel"], 
        season = recipeData["season"], 
        skill = recipeData["skill"], 
        specialization = recipeData["specialization"], 
        teachesItem = recipeData["teachesItem"], 
        teachesSpell = recipeData["teachesSpell"], 
        texture = rTexture
    }
end

-- Compares all the available skills for the currently displayed profession 
-- with each spell teached / item crafted by the recipes in RecipeDatabase
function rm.getAllProfessionRecipes(getNumSkillsFunction, getSkillInfoFunction)
    local professionRecipes = {}
    local savedProfessionsAndSkills = rm.getCurrentCharacterSavedVariables()
    local numSkills = getNumSkillsFunction()
    for i = 1, numSkills do
        local _, skillType, craftType = getSkillInfoFunction(i)
        if skillType ~= "header" and craftType ~= "header" then
            for professionID, professionData in pairs(savedProfessionsAndSkills) do
                local professionRank = professionData["rank"]
                local professionRecipesDatabase = rm.recipes[professionID]
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
