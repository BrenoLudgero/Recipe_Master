local function handleLearnedRecipe(recipe)
    if not isLearnedRecipe(recipe) then
        return
    end
    if RecipeMasterPreferences["showLearnedRecipes"] then
        createRecipeRow(recipe, 0.5, 0.5, 0.5, true) -- Gray text and desaturated icon
    end
    learnedRecipesCount = learnedRecipesCount + 1
end

local function handleMissingRecipe(recipe)
    if not isMissingRecipeOfCurrentFaction(recipe) or isLearnedRecipe(recipe) then
        return
    end
    local r, g, b = GetItemQualityColor(recipe.quality)
    createRecipeRow(recipe, r, g, b)
    missingRecipesCount = missingRecipesCount + 1
end

local function populateRecipeRow(recipe)
    if isRecipeForDisplayedProfession(recipe) and isRecipeAvailableForCharacter(recipe) then
        handleLearnedRecipe(recipe)
        handleMissingRecipe(recipe)
    end
end

local function getComparisonValues(a, b)
    if RecipeMasterPreferences["sortRecipesBy"] == "Name" then
        return a.name, b.name
    elseif RecipeMasterPreferences["sortRecipesBy"] == "Quality" then
        return a.quality, b.quality
    elseif RecipeMasterPreferences["sortRecipesBy"] == "Skill" then
        return a.skill, b.skill
    end
end

local function compareRecipes(a, b)
    local valueA, valueB = getComparisonValues(a, b)
    if valueA and valueB then
        if RecipeMasterPreferences["sortAscending"] == true then
            return valueA < valueB
        end
        return valueA > valueB
    end
end

local function sortRecipes(professionRecipes)
    local sortedRecipes = {}
    for _, recipe in pairs(professionRecipes) do
        table.insert(sortedRecipes, recipe)
    end
    table.sort(sortedRecipes, compareRecipes)
    return sortedRecipes
end

local function populateAllRecipeRows(professionRecipes)
    local sortedRecipes = sortRecipes(professionRecipes)
    for _, recipe in ipairs(sortedRecipes) do
        populateRecipeRow(recipe)
    end
    totalRecipesCount = learnedRecipesCount + missingRecipesCount
    learnedPercentage = math.floor((learnedRecipesCount / totalRecipesCount) * 100)
end

local function showAllRecipeRows()
    local recipeSection = recipeContainer.children
    for _, rowText in pairs(recipeSection) do
        rowText:Show()
        rowText.associatedIcon:Show()
    end
end

function showProfessionRecipes(getNumSkillsFunction, getSkillInfoFunction)
    local professionRecipes = getAllProfessionRecipes(getNumSkillsFunction, getSkillInfoFunction)
    populateAllRecipeRows(professionRecipes)
    showAllRecipeRows()
end

local function isCraft(profession)
    return profession == professionNames[333] -- Enchanting
end

function showRecipesForProfession(profession)
    displayedProfession = profession
    if isCraft(displayedProfession) then
        updateRecipeDisplay(GetNumCrafts, GetCraftInfo)
        return
    end
    updateRecipeDisplay(GetNumTradeSkills, GetTradeSkillInfo)
end

function showSortedRecipes()
    if displayedProfession ~= professionNames[356] then -- Not Fishing
        showRecipesForProfession(lastDisplayedProfession)
    else
        showRecipesForProfession(displayedProfession)
    end
end
