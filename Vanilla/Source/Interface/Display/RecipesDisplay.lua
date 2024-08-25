local _, rm = ...
local L = rm.L
local F = rm.F

local function splitSeasonalRecipes(professionRecipes)
    local sodRecipes = {}
    local regularRecipes = {}
    for _, recipe in pairs(professionRecipes) do
        if recipe.season then
            table.insert(sodRecipes, recipe)
        else
            table.insert(regularRecipes, recipe)
        end
    end
    return sodRecipes, regularRecipes
end

local function storeNonDuplicateRecipe(regularRecipe, sodRecipes)
    local sameName = false
    for _, sodRecipe in pairs(sodRecipes) do
        if regularRecipe.name == sodRecipe.name then
            sameName = true
            break
        end
    end
    if not sameName then
        table.insert(sodRecipes, regularRecipe)
    end
end

local function filterSeasonalRecipes(professionRecipes)
    local sodRecipes, regularRecipes = splitSeasonalRecipes(professionRecipes)
    if rm.currentSeason == "SoD" then
        for _, recipe in pairs(regularRecipes) do
            storeNonDuplicateRecipe(recipe, sodRecipes)
        end
        return sodRecipes
    end
    return regularRecipes
end

local function getComparisonValues(a, b)
    local sortBy = rm.getPreference("sortRecipesBy")
    if sortBy == "Name" then
        return a.name, b.name
    elseif sortBy == "Quality" then
        return a.quality, b.quality
    elseif sortBy == "Skill" then
        return a.skill, b.skill
    end
end

local function compareRecipes(a, b)
    local valueA, valueB = getComparisonValues(a, b)
    if valueA and valueB then
        local sortAscending = rm.getPreference("sortAscending")
        if sortAscending then
            return valueA < valueB
        end
        return valueA > valueB
    end
end

local function sortRecipes(professionRecipes)
    local filteredRecipes = filterSeasonalRecipes(professionRecipes)
    table.sort(filteredRecipes, compareRecipes)
    return filteredRecipes
end

local function handleLearnedRecipe(recipe)
    if not rm.isLearnedRecipe(recipe) then
        return
    end
    local showLearned = rm.getPreference("showLearnedRecipes")
    if showLearned then
        rm.createRecipeRow(recipe, F.colors.gray, true) -- Gray text and desaturated icon
    end
    rm.learnedRecipesCount = rm.learnedRecipesCount + 1
end

local function handleMissingRecipe(recipe)
    if not rm.isMissingRecipeOfCurrentFaction(recipe) or rm.isLearnedRecipe(recipe) then
        return
    end
    local r, g, b = C_Item.GetItemQualityColor(recipe.quality)
    rm.createRecipeRow(recipe, {r, g, b})
    rm.missingRecipesCount = rm.missingRecipesCount + 1
end

local function populateRecipeRow(recipe)
    if rm.isRecipeAvailableForCharacter(recipe) then
        handleLearnedRecipe(recipe)
        handleMissingRecipe(recipe)
    end
end

local function populateAllRecipeRows(professionRecipes)
    local sortedRecipes = sortRecipes(professionRecipes)
    for _, recipe in ipairs(sortedRecipes) do
        populateRecipeRow(recipe)
    end
    rm.totalRecipesCount = rm.learnedRecipesCount + rm.missingRecipesCount
    rm.learnedPercentage = math.floor((rm.learnedRecipesCount / rm.totalRecipesCount) * 100)
end

function rm.listProfessionRecipes(getSkillInfo)
    local professionRecipes = rm.getProfessionRecipes(getSkillInfo)
    populateAllRecipeRows(professionRecipes)
end

local function isCraft(profession)
    return profession == L.professions[333] -- Enchanting
end

function rm.showRecipesForSpecificProfession(profession)
    rm.displayedProfession = profession
    if isCraft(rm.displayedProfession) then
        rm.updateRecipesList(GetCraftInfo)
    else
        rm.updateRecipesList(GetTradeSkillInfo)
    end
end

local function isFishingDisplayed()
    return rm.displayedProfession == L.professions[356]
end

function rm.showSortedRecipes()
    if isFishingDisplayed() then
        rm.showRecipesForSpecificProfession(rm.displayedProfession)
    else
        rm.showRecipesForSpecificProfession(rm.lastDisplayedProfession)
    end
end
