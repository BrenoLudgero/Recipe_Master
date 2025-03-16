local _, rm = ...
local L = rm.L

-- true and false represents whether the displayed profession is a craft (Enchanting) or not
local skillFunctions = {
    ["getInfo"] = {
        [true] = GetCraftInfo,
        [false] = GetTradeSkillInfo
    },
    ["getNum"] = {
        [true] = GetNumCrafts,
        [false] = GetNumTradeSkills
    },
    ["getLink"] = {
        [true] = GetCraftItemLink,
        [false] = GetTradeSkillItemLink
    }
}

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

local function isEnchantingDisplayed()
    return rm.displayedProfession == L.professions[333]
end

local function getSkillFunction(functionsTableIndex)
    return skillFunctions[functionsTableIndex][isEnchantingDisplayed()]
end

local function getSkillID(i)
    local itemLink = getSkillFunction("getLink")(i)
    if itemLink then
        return rm.getIDFromLink(itemLink)
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

-- Saves the ID of all the skills / crafts available for the profession
function rm.saveNewTradeSkills()
    local skillLineID = rm.getProfessionID(rm.displayedProfession) -- e.g. 202 (Engineering)
    local numSkills = getSkillFunction("getNum")()
    local skillInfoFunction = getSkillFunction("getInfo")
    for i = 1, numSkills do
        local _, skillType, craftType = skillInfoFunction(i)
        if skillType ~= "header" and craftType ~= "header" then
            local skillID = getSkillID(i)
            saveNewSkill(skillLineID, skillID)
        end
    end
end

function rm.saveNewlyLearnedSkill(spellID)
    local spellName = GetSpellInfo(spellID)
    for professionID, recipes in pairs(rm.cachedRecipes) do
        if rm.getSavedProfessionByID(professionID) then -- Profession is learned by the character
            for _, recipeData in pairs(recipes) do
                if spellID == recipeData.spell or spellID == recipeData.item 
                or (type(recipeData.item) == "table" and rm.tableContains(recipeData.item, spellID)) then
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
