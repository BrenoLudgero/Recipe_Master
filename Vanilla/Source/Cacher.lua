local _, rm = ...
local L = rm.L

local function cacheAllRecipes()
    for professionID in pairs(L.professions) do
        for recipeID in pairs(rm.recipeDB[professionID]) do
            local info = C_Item.GetItemInfo(recipeID)
            if not info then
                info = GetSpellInfo(recipeID)
            end
        end
    end
end

local function cacheAllItemNames()
    for professionID in pairs(L.professions) do
        for _, sources in pairs(rm.sourceDB[professionID]) do
            if type(sources) == "table" then
                for sourceType, values in pairs(sources) do
                    if sourceType == "item" and type(values) == "table" then
                        for item in pairs(values) do
                            local info = C_Item.GetItemInfo(item)
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
    cacheAllRecipes()
    cacheAllItemNames()
    cacheAllQuests()
    cacheAllTradeSkills()
    cacheAllCrafts()
end
