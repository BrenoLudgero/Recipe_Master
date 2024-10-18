local _, rm = ...
local L = rm.L

rm.cachedRecipes = {}
rm.cachedItemNames = {}

local function isRecipeForCurrentSeason(recipeData)
    return not recipeData.season or recipeData.season == rm.currentSeason
end

local function isRecipeASpell(professionID, recipeData)
    return (
        professionID == 186 -- Mining
        or recipeData.isSpell
    )
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

local function hasTheSameNameOrTeachesSameItem(sodRecipe, regularRecipe)
    return (
        sodRecipe.name == regularRecipe.name
        or sodRecipe.teachesItem == regularRecipe.teachesItem
    )
end

-- Recipes that teach the same skill but have an SoD counterpart
local function isDuplicateRecipe(sodRecipes, regularRecipe)
    for _, sodRecipe in pairs(sodRecipes) do
        if not rm.isRankupRecipe(sodRecipe)
        and hasTheSameNameOrTeachesSameItem(sodRecipe, regularRecipe) then
            return true
        end
    end
    return false
end

local function filterSeasonalRecipes(professionRecipes)
    local sodRecipes, regularRecipes = splitSeasonalRecipes(professionRecipes)
    if rm.currentSeason == "SoD" then
        for recipeID, recipe in pairs(regularRecipes) do
            if not isDuplicateRecipe(sodRecipes, recipe) then
                sodRecipes[recipeID] = recipe
            end
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
                if isRecipeASpell(professionID, recipeData) then
                    local spell = Spell:CreateFromSpellID(recipeID)
                    spell:ContinueOnSpellLoad(function()
                        rm.storeSpellData(recipeID, recipeData, professionID)
                    end)
                else
                    local recipe = Item:CreateFromItemID(recipeID)
                    recipe:ContinueOnItemLoad(function()
                        rm.storeRecipeData(recipeID, recipeData, professionID)
                    end)
                end
            end
        end
        rm.cachedRecipes[professionID] = filterSeasonalRecipes(rm.cachedRecipes[professionID])
    end
end

local function cacheAllItemNames()
    for professionID in pairs(L.professions) do
        for _, sources in pairs(rm.sourceDB[professionID]) do
            for sourceType, values in pairs(sources) do
                if sourceType == "item" then
                    for itemID in pairs(values) do
                        if not rm.cachedItemNames[itemID] then
                            local item = Item:CreateFromItemID(itemID)
                            item:ContinueOnItemLoad(function()
                                rm.cachedItemNames[itemID] = item:GetItemName()
                            end)
                        end
                    end
                    break
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
