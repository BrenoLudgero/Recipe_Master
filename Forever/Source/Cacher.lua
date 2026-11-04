local _, rm = ...
local L = rm.L

rm.cachedRecipes = {}
rm.cachedItemNames = {}
rm.craftedItems = {} -- [itemID] = {recipe, professionID}
rm.recipesBySource = {} -- [professionID] = {[sourceType] = {[recipeID] = true}}

-- Stores the recipe under what it crafts, preferring the recipe of the current faction
local function storeCraftedItem(craftedItems, key, recipe, professionID)
    local storedItem = craftedItems[key]
    if not storedItem or not rm.isMissingRecipeOfCurrentFaction(storedItem.recipe) then
        craftedItems[key] = {recipe = recipe, professionID = professionID}
    end
end

local function storeCachedCraftedItem(recipeID, professionID)
    local recipe = rm.cachedRecipes[professionID][recipeID]
    -- not recipe.craftedItem: Recipes that craft no item (e.g. enchantments)
    if rm.isRankupRecipe(recipe) or not recipe.craftedItem then
        return
    end
    storeCraftedItem(rm.craftedItems, recipe.craftedItem, recipe, professionID)
end

-- Spells have no quality, so they take the one of the item they craft
local function cacheCraftedItemQuality(recipeID, professionID)
    local recipe = rm.cachedRecipes[professionID][recipeID]
    if recipe.craftedItem and C_Item.DoesItemExistByID(recipe.craftedItem) then
        local craftedItem = Item:CreateFromItemID(recipe.craftedItem)
        craftedItem:ContinueOnItemLoad(function()
            recipe.quality = craftedItem:GetItemQuality() or recipe.quality
        end)
    end
end

local function storeCachedRecipeBySource(recipeID, professionID)
    local recipe = rm.cachedRecipes[professionID][recipeID]
    if not recipe or not recipe.sources then
        return
    end
    local professionSources = rm.recipesBySource[professionID]
    for sourceType in pairs(recipe.sources) do
        professionSources[sourceType] = professionSources[sourceType] or {}
        professionSources[sourceType][recipeID] = true
    end
end

-- Stores all recipe data for each profession in rm.cachedRecipes
-- to be retrieved locally without the risk of querying unavailable data
local function cacheAllRecipes()
    for professionID in pairs(L.professions) do
        rm.cachedRecipes[professionID] = {}
        rm.recipesBySource[professionID] = {}
        for recipeID, rawRecipeData in pairs(rm.recipeDB[professionID]) do
            if rawRecipeData.isSpell then
                local spell = Spell:CreateFromSpellID(recipeID)
                spell:ContinueOnSpellLoad(function()
                    rm.storeSpellData(recipeID, rawRecipeData, professionID)
                    storeCachedCraftedItem(recipeID, professionID)
                    cacheCraftedItemQuality(recipeID, professionID)
                    storeCachedRecipeBySource(recipeID, professionID)
                end)
            else
                local recipe = Item:CreateFromItemID(recipeID)
                recipe:ContinueOnItemLoad(function()
                    rm.storeRecipeData(recipeID, rawRecipeData, professionID)
                    storeCachedCraftedItem(recipeID, professionID)
                    storeCachedRecipeBySource(recipeID, professionID)
                end)
            end
        end
    end
end

local function cacheAllItemNames()
    for professionID in pairs(L.professions) do
        for _, recipeSources in pairs(rm.recipeSourceDB[professionID]) do
            if recipeSources["item"] then
                for itemID in pairs(recipeSources["item"]) do
                    if not rm.cachedItemNames[itemID] then
                        local item = Item:CreateFromItemID(itemID)
                        item:ContinueOnItemLoad(function()
                            rm.cachedItemNames[itemID] = item:GetItemName()
                        end)
                    end
                end
            end
        end
    end
end

local function cacheAllZoneNames()
    for professionID in pairs(L.professions) do
        for _, recipeSources in pairs(rm.recipeSourceDB[professionID]) do
            if recipeSources["fishing"] then
                for zoneID in pairs(recipeSources["fishing"]) do
                    local zone = C_Map.GetAreaInfo(zoneID)
                end
            end
        end
    end
    for _, npc in pairs(rm.npcDB) do
        if npc.zones then
            for zoneID in pairs(npc.zones) do
                local zone = C_Map.GetAreaInfo(zoneID)
            end
        end
    end
end

-- Loads the quests' names (see C_QuestLog.GetTitleForQuestID)
local function cacheAllQuests()
    for questID in pairs(rm.questDB) do
        C_QuestLog.RequestLoadQuestByID(questID)
    end
end

function rm.cacheAllAssets()
    cacheAllRecipes()
    cacheAllItemNames()
    cacheAllZoneNames()
    cacheAllQuests()
end
