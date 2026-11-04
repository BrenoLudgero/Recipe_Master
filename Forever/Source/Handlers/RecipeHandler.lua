local _, rm = ...
local L = rm.L

local _, currentCharacterClass = UnitClass("player") -- Always in English and upper case
local rankOrder = {
    Apprentice = 1, 
    Journeyman = 2, 
    Expert = 3, 
    Artisan = 4
}

local function isRecipeForCurrentClass(recipe)
    if not recipe.classes then
        return true
    end
    return rm.tableContains(recipe.classes, currentCharacterClass)
end

local function getCurrentSpecializations(professionID)
    return rm.getSpecializationsList(rm.getSavedSpecializationByProfessionID(professionID))
end

-- Detects if recipe teaches a specialization that's an alternative to one of the character's current specializations
-- e.g. Armorsmith for a Weaponsmith or Master Axesmith for a Master Swordsmith, but not Master Swordsmith for a Weaponsmith
local function recipeTeachesDifferentSpecialization(professionID, currentSpecializations, recipe)
    if not recipe.isSpecialization or rm.tableContains(currentSpecializations, recipe.teaches) then
        return false
    end
    for _, specializationID in ipairs(currentSpecializations) do
        if rm.getRequiredSpecialization(professionID, specializationID) == recipe.specialization then
            return true
        end
    end
    return false
end

-- The character has the specialization or can still learn it, along with the specialization it requires
-- e.g. Master Swordsmith for a Weaponsmith or a character without specializations, but not for an Armorsmith
local function isSpecializationAvailable(professionID, currentSpecializations, specializationID)
    if rm.tableContains(currentSpecializations, specializationID) then
        return true
    end
    local specializationRecipe = rm.cachedRecipes[professionID][specializationID]
    if not specializationRecipe then
        return #currentSpecializations == 0
    end
    local requiredSpecialization = specializationRecipe.specialization
    return (
        not requiredSpecialization
        or isSpecializationAvailable(professionID, currentSpecializations, requiredSpecialization)
    ) and not recipeTeachesDifferentSpecialization(professionID, currentSpecializations, specializationRecipe)
end

local function isRecipeForCurrentSpecialization(recipe)
    local professionID = rm.getProfessionID(rm.displayedProfession)
    local currentSpecializations = getCurrentSpecializations(professionID)
    return (
        not recipe.specialization 
        or isSpecializationAvailable(professionID, currentSpecializations, recipe.specialization)
    ) and not recipeTeachesDifferentSpecialization(professionID, currentSpecializations, recipe)
end

function rm.isRecipeAvailableForCharacter(recipe)
    return (
        isRecipeForCurrentClass(recipe) 
        and isRecipeForCurrentSpecialization(recipe)
    )
end

local function isSkillLearnedByCharacter(characterSkills, recipe)
    return rm.tableContains(characterSkills, recipe.teaches)
end

function rm.getAllCharactersRecipeStatus(recipe, professionID)
    local otherCharactersInfo = rm.getProfessionDataForOtherCharacters(professionID)
    local charactersMissingRecipeSkill = {}
    local charactersWithRecipeSkill = {}
    for characterName, professionData in pairs(otherCharactersInfo) do
        local professionSkills = professionData["skills"]
        if professionSkills then
            if isSkillLearnedByCharacter(professionSkills, recipe) then
                table.insert(charactersWithRecipeSkill, characterName)
            else
                charactersMissingRecipeSkill[characterName] = professionData
            end
        end
    end
    return charactersMissingRecipeSkill, charactersWithRecipeSkill
end

-- Identifies a rankup recipe that teaches a rank equal to or lower than the current profession rank
local function isLearnedRankupRecipe(recipe)
    if not rm.isRankupRecipe(recipe) then
        return false
    end
    local professionRank = rm.getSavedProfessionRank(rm.displayedProfession)
    return rankOrder[recipe.teaches] <= rankOrder[professionRank]
end

-- Identifies a specialization recipe that matches one of the character's current specializations
local function isLearnedSpecializationRecipe(recipe)
    if not recipe.isSpecialization then
        return false
    end
    local professionID = rm.getProfessionID(rm.displayedProfession)
    return rm.tableContains(getCurrentSpecializations(professionID), recipe.teaches)
end

function rm.isLearnedRecipe(recipe)
    local learnedSkills = rm.getSavedSkillsByProfessionName(rm.displayedProfession)
    return (
        isSkillLearnedByCharacter(learnedSkills, recipe) 
        or isLearnedRankupRecipe(recipe)
        or isLearnedSpecializationRecipe(recipe)
    )
end

function rm.isMissingRecipeOfCurrentFaction(recipe)
    return not recipe.faction or (recipe.faction == rm.currentFaction)
end

-- spellID: A recipe's spell, or the rank taught by a rankup recipe (e.g. "Expert")
local function isExistingSpell(spellID)
    return type(spellID) == "number" and C_Spell.DoesSpellExist(spellID)
end

-- The item crafted by the recipe's spell. nil if none (e.g. enchantments)
local function getRecipeOutputItem(spellID)
    if isExistingSpell(spellID) then
        local outputInfo = C_TradeSkillUI.GetRecipeOutputItemData(spellID)
        return outputInfo and outputInfo.itemID
    end
end

-- Recipe items are named after the spell they teach, which is their name without a prefix (e.g. "Plans: ")
local function getInitialRecipeData(ID, recipeData)
    local name, link, quality, _, minLevel, _, _, _, _, texture, _, classID = C_Item.GetItemInfo(ID)
    -- Recipes taught by trainers are keyed by the item they craft
    if classID ~= Enum.ItemClass.Recipe then
        return name, link, quality, texture, nil, ID
    end
    local taughtSpellName = isExistingSpell(recipeData.teaches) and C_Spell.GetSpellName(recipeData.teaches)
    return taughtSpellName or name, link, quality, texture, minLevel, getRecipeOutputItem(recipeData.teaches)
end

local function getInitialSpellData(ID, spellData, professionID)
    local name = C_Spell.GetSpellName(ID)
    local craftedItem
    -- Appends rank level to a rankup spell's name
    if rm.isRankupRecipe(spellData) then
        name = name.." - "..L[spellData.teaches:lower()]
    else
        -- Recipes keyed by their spell store the item they craft under teaches (e.g. Smelt Copper's Copper Bar)
        craftedItem = (type(spellData.teaches) == "number" and spellData.teaches) or getRecipeOutputItem(ID)
    end
    local link = C_Spell.GetSpellLink(ID)
    local texture = C_Spell.GetSpellTexture(ID)
    -- Fallback for undesired placeholder icon
    if texture == 136235 and craftedItem then
        texture = C_Item.GetItemIconByID(craftedItem)
    end
    return name, link, nil, texture, nil, craftedItem
end

-- The skill saved for the character once learned: the recipe's spell, or the rank taught by a rankup recipe
local function getTaughtSkill(recipeID, recipeData)
    if recipeData["isSpell"] and not rm.isRankupRecipe(recipeData) then
        return recipeID
    end
    return recipeData["teaches"] or recipeID
end

local function getRecipeData(recipeID, recipeData, professionID, initialDataFunction)
    local rName, rLink, rQuality, rTexture, rLevel, rCraftedItem = initialDataFunction(recipeID, recipeData, professionID)
    return {
        ID = recipeID,
        classes = recipeData["classes"], 
        craftedItem = rCraftedItem,
        difficulty = recipeData["difficulty"],
        faction = recipeData["faction"] or rm.getReputationFaction(recipeData["reputationFaction"]), 
        isFactionExclusive = recipeData["isFactionExclusive"], 
        isSpecialization = recipeData["isSpecialization"],
        link = rLink,
        name = rName, 
        quality = rQuality or recipeData["quality"] or 1, 
        reputationFaction = recipeData["reputationFaction"], 
        reputationLevel = recipeData["reputationLevel"], 
        requiredLevel = rLevel or recipeData["requiredLevel"] or 1, 
        requiredSkill = recipeData["requiredSkill"] or 1, 
        sources = rm.recipeSourceDB[professionID][recipeID],
        specialization = recipeData["specialization"], 
        teaches = getTaughtSkill(recipeID, recipeData), 
        texture = rTexture
    }
end

-- Called in Cacher.cacheAllRecipes
function rm.storeRecipeData(recipeID, rawRecipeData, professionID)
    local recipe = getRecipeData(recipeID, rawRecipeData, professionID, getInitialRecipeData)
    rm.cachedRecipes[professionID][recipeID] = recipe
end

function rm.storeSpellData(spellID, rawSpellData, professionID)
    local spell = getRecipeData(spellID, rawSpellData, professionID, getInitialSpellData)
    rm.cachedRecipes[professionID][spellID] = spell
end

-- Retrieves all cached recipe data for the currently displayed profession
function rm.getProfessionRecipes()
    local displayedProfessionID = rm.getProfessionID(rm.displayedProfession)
    return rm.cachedRecipes[displayedProfessionID]
end
