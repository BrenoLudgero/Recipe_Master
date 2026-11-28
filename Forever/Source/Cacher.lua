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

-- Private replacement for Spell:ContinueOnSpellLoad / Item:ContinueOnItemLoad.
-- Those write into Blizzard's shared SpellEventListener / ItemEventListener tables, which taints them.
-- Blizzard UI that later loads the same IDs (e.g. the professions book loading its spell buttons)
-- then runs tainted: its protected SetShown calls get blocked and CooldownFrame_Set errors on secret values.
local pendingLoads = {
    SPELL_DATA_LOAD_RESULT = {},
    ITEM_DATA_LOAD_RESULT = {},
}

local loaderFrame = CreateFrame("Frame")
loaderFrame:RegisterEvent("SPELL_DATA_LOAD_RESULT")
loaderFrame:RegisterEvent("ITEM_DATA_LOAD_RESULT")
loaderFrame:SetScript("OnEvent", function(_, event, id, success)
    local pending = pendingLoads[event]
    local callbacks = pending and pending[id]
    if not callbacks then
        return
    end
    pending[id] = nil
    -- Same as Blizzard's listeners: item callbacks run even on failure, spell callbacks only on success
    if success or event == "ITEM_DATA_LOAD_RESULT" then
        for _, callback in ipairs(callbacks) do
            xpcall(callback, geterrorhandler())
        end
    end
end)

local function continueOnLoad(event, id, isCached, requestLoad, callback)
    if isCached(id) then
        callback()
        return
    end
    local pending = pendingLoads[event]
    if pending[id] then
        table.insert(pending[id], callback)
        return
    end
    pending[id] = {callback} -- Set before requesting, as the result may fire synchronously
    requestLoad(id)
end

local function continueOnSpellLoad(spellID, callback)
    continueOnLoad("SPELL_DATA_LOAD_RESULT", spellID, C_Spell.IsSpellDataCached, C_Spell.RequestLoadSpellData, callback)
end

local function continueOnItemLoad(itemID, callback)
    continueOnLoad("ITEM_DATA_LOAD_RESULT", itemID, C_Item.IsItemDataCachedByID, C_Item.RequestLoadItemDataByID, callback)
end

-- Spells have no quality, so they take the one of the item they craft
local function cacheCraftedItemQuality(recipeID, professionID)
    local recipe = rm.cachedRecipes[professionID][recipeID]
    if recipe.craftedItem and C_Item.DoesItemExistByID(recipe.craftedItem) then
        local craftedItemID = recipe.craftedItem
        continueOnItemLoad(craftedItemID, function()
            recipe.quality = C_Item.GetItemQualityByID(craftedItemID) or recipe.quality
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
                continueOnSpellLoad(recipeID, function()
                    rm.storeSpellData(recipeID, rawRecipeData, professionID)
                    storeCachedCraftedItem(recipeID, professionID)
                    cacheCraftedItemQuality(recipeID, professionID)
                    storeCachedRecipeBySource(recipeID, professionID)
                end)
            else
                continueOnItemLoad(recipeID, function()
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
                        continueOnItemLoad(itemID, function()
                            rm.cachedItemNames[itemID] = C_Item.GetItemNameByID(itemID)
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
