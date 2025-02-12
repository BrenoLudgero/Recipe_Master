local _, rm = ...
local L = rm.L

local function getSavedSkillsByProfessionID(professionID)
    return rm.getSavedProfessionByID(professionID)["skills"]
end

function rm.getSavedSkillsByProfessionName(profession)
    return rm.getSavedProfessionByName(profession)["skills"]
end

function rm.getProfessionSkillsForOtherCharacters(professionID)
    local characters = {}
    for character in pairs(rm.getServerSavedVariables()) do
        if character ~= rm.currentCharacter then
            characters[character] = {}
            characters[character][professionID] = {}
            if rm.getServerSavedVariables()[character][professionID] then
                characters[character][professionID] = rm.getServerSavedVariables()[character][professionID]["skills"]
            else
                characters[character][professionID] = false
            end
        end
    end
    return characters
end

local function isSkillAnEnchantment(altVerb)
    return altVerb == L.enchant
end

local function getSkillID(i, altVerb)
    if isSkillAnEnchantment(altVerb) then
        local enchantmentLink = GetTradeSkillRecipeLink(i)
        if enchantmentLink then
            return rm.getIDFromLink(enchantmentLink)
        end
    else
        local itemLink = GetTradeSkillItemLink(i)
        if itemLink then
            return rm.getIDFromLink(itemLink)
        end
    end
    return false
end

local function skillNotSavedYet(skillLineID, skillID)
    return (
        -- Profession exists in SavedVariables
        rm.getSavedProfessionByID(skillLineID)
        --  the skill was not found in SavedVariables
        and not rm.tableContains(getSavedSkillsByProfessionID(skillLineID), skillID)
    )
end

local function saveNewSkill(skillLineID, skillID)
    if skillID and skillNotSavedYet(skillLineID, skillID) then
        table.insert(getSavedSkillsByProfessionID(skillLineID), skillID)
    end
end

-- Saves the ID of all the skills available for the profession
function rm.saveNewTradeSkills()
    local numSkills = GetNumTradeSkills()
    local skillLineID = rm.getProfessionID(rm.displayedProfession) -- e.g. 202 (Engineering)
    for i = 1, numSkills do
        local _, skillType, _, _, altVerb = GetTradeSkillInfo(i)
        if skillType ~= "header" then
            local skillID = getSkillID(i, altVerb)
            saveNewSkill(skillLineID, skillID)
        end
    end
end

function rm.saveNewlyLearnedSkill(spellID)
    local spellName = GetSpellInfo(spellID)
    for professionID, recipes in pairs(rm.cachedRecipes) do
        if rm.getSavedProfessionByID(professionID) then -- Profession is learned by the character
            for _, recipeData in pairs(recipes) do
                if spellID == recipeData.spell or spellID == recipeData.item then
                    local recipeName = recipeData.name
                    -- Comparing names because items and spells might have the same ID
                    if recipeName == spellName or string.find(recipeName, spellName) then
                        table.insert(getSavedSkillsByProfessionID(professionID), recipeData.item)
                        return
                    end
                end
            end
        end
    end
end
