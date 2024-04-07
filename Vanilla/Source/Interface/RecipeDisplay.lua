local _, rm = ...
local L = rm.L

local function handleLearnedRecipe(recipe)
    if not rm.isLearnedRecipe(recipe) then
        return
    end
    if rm.getPreference("showLearnedRecipes") then
        rm.createRecipeRow(recipe, 0.5, 0.5, 0.5, true) -- Gray text and desaturated icon
    end
    rm.learnedRecipesCount = rm.learnedRecipesCount + 1
end

local function handleMissingRecipe(recipe)
    if not rm.isMissingRecipeOfCurrentFaction(recipe) or rm.isLearnedRecipe(recipe) then
        return
    end
    local r, g, b = C_Item.GetItemQualityColor(recipe.quality)
    rm.createRecipeRow(recipe, r, g, b)
    rm.missingRecipesCount = rm.missingRecipesCount + 1
end

local function populateRecipeRow(recipe)
    if rm.isRecipeForDisplayedProfession(recipe) and rm.isRecipeAvailableForCharacter(recipe) then
        handleLearnedRecipe(recipe)
        handleMissingRecipe(recipe)
    end
end

local function getComparisonValues(a, b)
    if rm.getPreference("sortRecipesBy") == "Name" then
        return a.name, b.name
    elseif rm.getPreference("sortRecipesBy") == "Quality" then
        return a.quality, b.quality
    elseif rm.getPreference("sortRecipesBy") == "Skill" then
        return a.skill, b.skill
    end
end

local function compareRecipes(a, b)
    local valueA, valueB = getComparisonValues(a, b)
    local sortAscending = rm.getPreference("sortAscending")
    if valueA and valueB then
        if sortAscending then
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
    rm.totalRecipesCount = rm.learnedRecipesCount + rm.missingRecipesCount
    rm.learnedPercentage = math.floor((rm.learnedRecipesCount / rm.totalRecipesCount) * 100)
end

local function showAllRecipeRows()
    local recipeSection = rm.recipeContainer.children
    for _, rowText in pairs(recipeSection) do
        rowText:Show()
        rowText.associatedIcon:Show()
    end
end

function rm.showProfessionRecipes(getNumSkillsFunction, getSkillInfoFunction)
    local professionRecipes = rm.getAllProfessionRecipes(getNumSkillsFunction, getSkillInfoFunction)
    populateAllRecipeRows(professionRecipes)
    showAllRecipeRows()
end

local function isCraft(profession)
    return profession == L.professionNames[333] -- Enchanting
end

function rm.showRecipesForProfession(profession)
    rm.displayedProfession = profession
    if not isCraft(rm.displayedProfession) then
        rm.updateRecipeDisplay(GetNumTradeSkills, GetTradeSkillInfo)
        return
    end
    rm.updateRecipeDisplay(GetNumCrafts, GetCraftInfo)
end

function rm.showSortedRecipes()
    if rm.displayedProfession == L.professionNames[356] then -- Fishing
        rm.showRecipesForProfession(rm.displayedProfession)
        return
    end
    rm.showRecipesForProfession(rm.lastDisplayedProfession)
end
