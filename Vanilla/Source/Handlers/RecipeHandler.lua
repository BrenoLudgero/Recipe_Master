local _, rm = ...
local L = rm.L

local _, currentCharacterClass = UnitClass("player") -- Always in English and upper case
local rankOrder = {
    Apprentice = 1, 
    Journeyman = 2, 
    Expert = 3, 
    Artisan = 4
}
local recipesToIgnoreInSod = {
    19212, -- Plans: Nightfall
}

local function isRecipeForCurrentClass(recipe)
    if not recipe.classes then
        return true
    end
    return rm.tableContains(recipe.classes, currentCharacterClass)
end

-- Detects if recipe teaches a specialization that's not the character's current specialization
local function recipeTeachesDifferentSpecialization(currentSpecialization, recipe)
    return (
        currentSpecialization
        and recipe.isSpecialization
        and recipe.teaches ~= currentSpecialization
    )
end

local function isRecipeForCurrentSpecialization(recipe)
    if rm.currentSeason == "SoD" then
        return true
    end
    local professionID = rm.getProfessionID(rm.displayedProfession)
    local currentSpecialization = rm.getSavedSpecializationByID(professionID)
    return (
        not recipe.specialization 
        or not currentSpecialization 
        or currentSpecialization == recipe.specialization
    ) and not recipeTeachesDifferentSpecialization(currentSpecialization, recipe)
end

function rm.isRecipeAvailableForCharacter(recipe)
    return (
        isRecipeForCurrentClass(recipe) 
        and isRecipeForCurrentSpecialization(recipe)
    )
end

local function isSkillLearnedByCharacter(characterSkills, recipe)
    return rm.tableContains(characterSkills, recipe.teaches)
end

function rm.getAllCharactersRecipeStatus(recipe, professionID)
    local otherCharactersInfo = rm.getProfessionDataForOtherCharacters(professionID)
    local charactersMissingRecipeSkill = {}
    local charactersWithRecipeSkill = {}
    for characterName, professionData in pairs(otherCharactersInfo) do
        local professionSkills = professionData["skills"]
        if professionSkills then
            if isSkillLearnedByCharacter(professionSkills, recipe) then
                table.insert(charactersWithRecipeSkill, characterName)
            else
                charactersMissingRecipeSkill[characterName] = professionData
            end
        end
    end
    return charactersMissingRecipeSkill, charactersWithRecipeSkill
end

local function isRankupRecipe(recipe)
    return type(recipe.teaches) == "string"
end

-- Identifies a rankup recipe that teaches a rank equal to or lower than the current profession rank
local function isLearnedRankupRecipe(recipe)
    if not isRankupRecipe(recipe) then
        return false
    end
    local professionRank = rm.getSavedProfessionRank(rm.displayedProfession)
    return rankOrder[recipe.teaches] <= rankOrder[professionRank]
end

-- Identifies a specialization recipe that matches the character's current specialization
local function isLearnedSpecializationRecipe(recipe)
    if not recipe.isSpecialization then
        return false
    end
    local currentSpecialization = rm.getSavedSpecializationByID(professionID)
    if not currentSpecialization then
        return false
    end
    local professionID = rm.getProfessionID(rm.displayedProfession)
    return recipe.teaches == currentSpecialization
end

function rm.isLearnedRecipe(recipe)
    local learnedSkills = rm.getSavedSkillsByProfessionName(rm.displayedProfession)
    return (
        isSkillLearnedByCharacter(learnedSkills, recipe) 
        or isLearnedRankupRecipe(recipe)
        or isLearnedSpecializationRecipe(recipe)
    )
end

function rm.isMissingRecipeOfCurrentFaction(recipe)
    return not recipe.faction or (recipe.faction == rm.currentFaction)
end

local function isCapitalized(string)
    return string:sub(1, 1):upper() == string:sub(1, 1)
end

local function capitalizeName(string)
    if not isCapitalized(string) then
        return string:gsub("^%l", string.upper)
    end
end

local function removeRecipePrefix(recipeName)
    for _, prefix in pairs(L.recipePrefixes) do
        if recipeName:sub(1, #prefix) == prefix then
            local strippedName = recipeName:sub(#prefix + 1)
            return capitalizeName(strippedName) or strippedName
        end
    end
    return recipeName
end

local function getInitialRecipeData(ID)
    local name, link, quality, _, _, _, _, _, _, texture = C_Item.GetItemInfo(ID)
    name = removeRecipePrefix(name)
    return name, link, quality, texture
end

local function getInitialSpellData(ID, spellData, professionID)
    local name = GetSpellInfo(ID)
    -- Appends rank level to a rankup spell's name
    if isRankupRecipe(spellData) then
        name = name.." - "..L[spellData.teaches:lower()]
    end
    local link = "|cff71d5ff|Hspell:"..ID.."|h["..name.."]|h|r"
    local texture = GetSpellTexture(ID)
    -- Fallback for undesired placeholder icon
    if texture == 136235 and type(spellData.teaches) == "number" then
        texture = C_Item.GetItemIconByID(spellData.teaches)
    end
    return name, link, nil, texture
end

local function getRecipeData(recipeID, recipeData, professionID, initialDataFunction)
    local rName, rLink, rQuality, rTexture = initialDataFunction(recipeID, recipeData, professionID)
    return {
        classes = recipeData["classes"], 
        difficulty = recipeData["difficulty"],
        faction = recipeData["faction"], 
        isFactionExclusive = recipeData["isFactionExclusive"], 
        isSpecialization = recipeData["isSpecialization"],
        link = rLink,
        name = rName, 
        quality = rQuality or recipeData["quality"] or 1, 
        reputationFaction = recipeData["reputationFaction"], 
        reputationLevel = recipeData["reputationLevel"], 
        requiredLevel = recipeData["requiredLevel"] or 1, 
        requiredSkill = recipeData["requiredSkill"] or 1, 
        season = recipeData["season"], 
        sources = rm.recipeSourceDB[professionID][recipeID],
        specialization = recipeData["specialization"], 
        teaches = recipeData["teaches"] or recipeID, 
        texture = rTexture
    }
end

local function isRecipeForCurrentSeason(rawRecipeData)
    return (
        not rawRecipeData.season 
        or rawRecipeData.season == rm.currentSeason
    )
end

local function isRecipeWithSodCounterpart(rawRecipeData)
    if rm.currentSeason ~= "SoD" then
        return false
    end
    return rawRecipeData.hasSodCounterpart
end

local function shouldIgnoreRecipeInSod(recipeID)
    if rm.currentSeason ~= "SoD" then
        return false
    end
    return rm.tableContains(recipesToIgnoreInSod, recipeID)
end

local function isRecipeRelevantForCurrentSeason(recipeID, rawRecipeData)
    return (
        isRecipeForCurrentSeason(rawRecipeData) 
        and not isRecipeWithSodCounterpart(rawRecipeData)
        and not shouldIgnoreRecipeInSod(recipeID)
    )
end

-- Called in Cacher.cacheAllRecipes
function rm.storeRelevantRecipeData(recipeID, rawRecipeData, professionID)
    if isRecipeRelevantForCurrentSeason(recipeID, rawRecipeData) then
        local recipe = getRecipeData(recipeID, rawRecipeData, professionID, getInitialRecipeData)
        rm.cachedRecipes[professionID][recipeID] = recipe
    end
end

function rm.storeRelevantSpellData(spellID, rawSpellData, professionID)
    if isRecipeRelevantForCurrentSeason(spellID, rawSpellData) then
        local spell = getRecipeData(spellID, rawSpellData, professionID, getInitialSpellData)
        rm.cachedRecipes[professionID][spellID] = spell
    end
end

-- Retrieves all cached recipe data for the currently displayed profession
function rm.getProfessionRecipes()
    local displayedProfessionID = rm.getProfessionID(rm.displayedProfession)
    return rm.cachedRecipes[displayedProfessionID]
end
