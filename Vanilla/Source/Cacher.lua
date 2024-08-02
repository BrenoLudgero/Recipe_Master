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

local function cacheAllSkills()
    local numTradeSkills = GetNumTradeSkills()
    for i = 1, numTradeSkills do
        local skill = GetTradeSkillInfo(i)
    end
    local numCrafts = GetNumCrafts()
    for i = 1, numCrafts do
        local craft = GetCraftInfo(i)
    end
end

function rm.cacheAllAssets()
    cacheAllRecipes()
    cacheAllSkills()
end
