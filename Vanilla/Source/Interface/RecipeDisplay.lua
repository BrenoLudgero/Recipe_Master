local _, rm = ...
local L = rm.L
local F = rm.F

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
    if rm.isRecipeForDisplayedProfession(recipe) and rm.isRecipeAvailableForCharacter(recipe) then
        handleLearnedRecipe(recipe)
        handleMissingRecipe(recipe)
    end
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

local function insertNonDuplicateRecipe(recipe, sodRecipes)
    local sameName = false
    for _, sodRecipe in pairs(sodRecipes) do
        if recipe.name == sodRecipe.name then
            sameName = true
            break
        end
    end
    if not sameName then
        table.insert(sodRecipes, recipe)
    end
end

local function sortRecipes(professionRecipes)
    local season = rm.getSeason()
    local sodRecipes, regularRecipes = splitSeasonalRecipes(professionRecipes)
    if season == "SoD" then
        for _, recipe in pairs(regularRecipes) do
            insertNonDuplicateRecipe(recipe, sodRecipes)
        end
        table.sort(sodRecipes, compareRecipes)
        return sodRecipes
    end
    table.sort(regularRecipes, compareRecipes)
    return regularRecipes
end

local function populateAllRecipeRows(professionRecipes)
    local sortedRecipes = sortRecipes(professionRecipes)
    for _, recipe in ipairs(sortedRecipes) do
        populateRecipeRow(recipe)
    end
    rm.totalRecipesCount = rm.learnedRecipesCount + rm.missingRecipesCount
    rm.learnedPercentage = math.floor((rm.learnedRecipesCount / rm.totalRecipesCount) * 100)
end

local function showAllRecipeRows()
    local recipeSection = rm.recipeContainer.children
    for _, rowIcon in pairs(recipeSection) do
        rowIcon:Show()
        rowIcon.associatedText:Show()
        if rowIcon.associatedText.additionalInfo then
            rowIcon.associatedText.additionalInfo:Show()
        end
    end
end

function rm.showProfessionRecipes(getSkillInfo)
    local professionRecipes = rm.getAllProfessionRecipes(getSkillInfo)
    populateAllRecipeRows(professionRecipes)
    showAllRecipeRows()
end

local function isCraft(profession)
    return profession == L.professions[333] -- Enchanting
end

function rm.showRecipesForSpecificProfession(profession)
    rm.displayedProfession = profession
    if not isCraft(rm.displayedProfession) then
        rm.updateRecipeDisplay(GetTradeSkillInfo)
        return
    end
    rm.updateRecipeDisplay(GetCraftInfo)
end

function rm.showSortedRecipes()
    if rm.displayedProfession == L.professions[356] then -- Fishing
        rm.showRecipesForSpecificProfession(rm.displayedProfession)
        return
    end
    rm.showRecipesForSpecificProfession(rm.lastDisplayedProfession)
end
