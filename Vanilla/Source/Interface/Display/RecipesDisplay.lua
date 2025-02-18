local _, rm = ...
local L = rm.L
local F = rm.F

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
        if rm.getPreference("sortAscending") then
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

local function handleLearnedRecipe(recipe)
    if not rm.isLearnedRecipe(recipe) then
        return
    end
    if rm.getPreference("showLearnedRecipes") then
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
    if professionRecipes then -- Might be nil when opening Recipe Master after login
        populateAllRecipeRows(professionRecipes)
    end
end

function rm.showRecipesForSpecificProfession(profession)
    rm.displayedProfession = profession
    if rm.isEnchanting(rm.displayedProfession) then
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
