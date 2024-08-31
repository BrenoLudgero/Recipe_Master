local _, rm = ...
local L = rm.L

rm.cachedRecipes = {}

local function isRecipeForCurrentSeason(recipeData)
    return not recipeData.season or recipeData.season == rm.currentSeason
end

local function splitSeasonalRecipes(professionRecipes)
    local sodRecipes = {}
    local regularRecipes = {}
    for recipeID, recipe in pairs(professionRecipes) do
        if recipe.season then
           sodRecipes[recipeID] = recipe
        else
            regularRecipes[recipeID] = recipe
        end
    end
    return sodRecipes, regularRecipes
end

local function storeNonDuplicateRecipe(regularRecipe, regularRecipeID, sodRecipes)
    local sameName = false
    for _, sodRecipe in pairs(sodRecipes) do
        if regularRecipe.name == sodRecipe.name then
            sameName = true
            break
        end
    end
    if not sameName then
        sodRecipes[regularRecipeID] = regularRecipe
    end
end

local function filterSeasonalRecipes(professionRecipes)
    local sodRecipes, regularRecipes = splitSeasonalRecipes(professionRecipes)
    if rm.currentSeason == "SoD" then
        for recipeID, recipe in pairs(regularRecipes) do
            storeNonDuplicateRecipe(recipe, recipeID, sodRecipes)
        end
        return sodRecipes
    end
    return regularRecipes
end

-- Stores all recipe data for each profession in rm.cachedRecipes
-- to be retrieved locally instead of constantly querying the server
local function cacheAndStoreAllRecipes()
    for professionID in pairs(L.professions) do
        rm.cachedRecipes[professionID] = {}
        for recipeID, recipeData in pairs(rm.recipeDB[professionID]) do
            if isRecipeForCurrentSeason(recipeData) then
                local recipe = Item:CreateFromItemID(recipeID)
                recipe:ContinueOnItemLoad(function()
                    rm.storeRecipeData(recipeID, recipeData, professionID)
                end)
            end
        end
        rm.cachedRecipes[professionID] = filterSeasonalRecipes(rm.cachedRecipes[professionID])
    end
end

local function cacheAllItemNames()
    for professionID in pairs(L.professions) do
        for _, sources in pairs(rm.sourceDB[professionID]) do
            if type(sources) == "table" then
                for sourceType, values in pairs(sources) do
                    if sourceType == "item" and type(values) == "table" then
                        for itemID in pairs(values) do
                            local item = C_Item.GetItemInfo(itemID)
                        end
                    end
                end
            end
        end
    end
end

local function cacheAllQuests()
    for questID in pairs(rm.questDB) do
        local quest = C_QuestLog.GetQuestInfo(questID)
    end
end

local function cacheAllTradeSkills()
    local numTradeSkills = GetNumTradeSkills()
    for i = 1, numTradeSkills do
        local skill = GetTradeSkillInfo(i)
    end
end

local function cacheAllCrafts()
    local numCrafts = GetNumCrafts()
    for i = 1, numCrafts do
        local craft = GetCraftInfo(i)
    end
end

function rm.cacheAllAssets()
    cacheAndStoreAllRecipes()
    cacheAllItemNames()
    cacheAllQuests()
    cacheAllTradeSkills()
    cacheAllCrafts()
end
