local _, rm = ...
local L = rm.L

rm.cachedRecipes = {}

-- Stores all recipe data for each profession in rm.cachedRecipes
-- to be retrieved locally instead of constantly querying the server
local function cacheAndStoreAllRecipes()
    for professionID in pairs(L.professions) do
        rm.cachedRecipes[professionID] = {}
        for recipeID, recipeData in pairs(rm.recipeDB[professionID]) do
            local recipe = Item:CreateFromItemID(recipeID)
            recipe:ContinueOnItemLoad(function()
                rm.storeRecipeData(recipeID, recipeData, professionID)
            end)
        end
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
