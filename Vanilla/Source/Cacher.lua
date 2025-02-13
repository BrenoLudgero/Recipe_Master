local _, rm = ...
local L = rm.L

rm.cachedRecipes = {}
rm.cachedItemNames = {}

local recipesToIgnoreInSod = {
    19212, -- Plans: Nightfall
}

local function isRecipeForCurrentSeason(recipeData)
    return not recipeData.season or recipeData.season == rm.currentSeason
end

local function isNotDuplicateRecipe(recipeData)
    if rm.currentSeason ~= "SoD" then
        return true
    end
    return not recipeData.hasSodCounterpart
end

local function shouldIgnoreRecipeInSod(recipeID)
    if rm.currentSeason ~= "SoD" then
        return false
    end
    return rm.tableContains(recipesToIgnoreInSod, recipeID)
end

-- Stores all recipe data for each profession in rm.cachedRecipes
-- to be retrieved locally without the risk of querying unavailable data
local function cacheAllRecipes()
    for professionID in pairs(L.professions) do
        rm.cachedRecipes[professionID] = {}
        for recipeID, recipeData in pairs(rm.recipeDB[professionID]) do
            if isRecipeForCurrentSeason(recipeData) 
            and isNotDuplicateRecipe(recipeData)
            and not shouldIgnoreRecipeInSod(recipeID) then
                if recipeData.isSpell then
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

local function cacheAllZoneNames()
    for professionID in pairs(L.professions) do
        for _, sources in pairs(rm.sourceDB[professionID]) do
            for sourceType, values in pairs(sources) do
                if sourceType == "fishing" then
                    for zoneID in pairs(values) do
                        local zone = C_Map.GetAreaInfo(zoneID)
                    end
                    break
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
