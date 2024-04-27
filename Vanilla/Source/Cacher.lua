local _, rm = ...

function rm.cacheAllRecipes()
    local professionIDs = {
        171,
        164,
        185,
        333,
        202,
        129,
        356,
        165,
        186,
        197
    }
    for _, ID in pairs(professionIDs) do
        for recipeID in pairs(rm.recipes[ID]) do
            local info = C_Item.GetItemInfo(recipeID)
            if not info then
                info = GetSpellInfo(recipeID)
            end
        end
    end
end

function rm.cacheAllTradeSkills()
    local numTradeSkills = GetNumTradeSkills()
    for i = 1, numTradeSkills do
        local skill = GetTradeSkillInfo(i)
    end
    local numCrafts = GetNumCrafts()
    for i = 1, numCrafts do
        local craft = GetCraftInfo(i)
    end
end
