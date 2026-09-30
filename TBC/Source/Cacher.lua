local _, rm = ...
local L = rm.L

rm.cachedRecipes = {}
rm.cachedItemNames = {}
rm.craftedItems = {} -- [itemID] = {recipe, professionID}
rm.craftedEnchantingItems = {} -- [itemName] = {recipe, professionID}
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
    if rm.isRankupRecipe(recipe) then
        return
    end
    -- Enchanting recipes teach spells, whose crafted items share their names (e.g. Greater Magic Wand)
    if professionID == 333 then
        storeCraftedItem(rm.craftedEnchantingItems, recipe.name, recipe, professionID)
    else
        storeCraftedItem(rm.craftedItems, recipe.teaches, recipe, professionID)
    end
end

local function storeCachedRecipeBySource(recipeID, professionID)
    local recipe = rm.cachedRecipes[professionID][recipeID]
    -- not recipe: Recipes not stored (e.g. from another season)
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
    for _, npc in pairs(rm.uniqueDB) do
        for zoneID in pairs(npc.zones) do
            local zone = C_Map.GetAreaInfo(zoneID)
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
    cacheAllRecipes()
    cacheAllItemNames()
    cacheAllZoneNames()
    cacheAllQuests()
    cacheAllTradeSkills()
    cacheAllCrafts()
end
