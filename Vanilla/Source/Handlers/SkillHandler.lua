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

function rm.getProfessionDataForOtherCharacters(professionID)
    local characters = {}
    local savedCharactersData
    if rm.getPreference("showOppositeFactionAltsTooltipInfo") == true then
        savedCharactersData = rm.getSavedVariablesForCurrentServerAndAllFactions()
    else
        savedCharactersData = rm.getSavedVariablesForCurrentServerAndFaction()
    end
    for characterName, characterData in pairs(savedCharactersData) do
        if characterName ~= rm.currentCharacter then
            local characterProfessionData = characterData[professionID]
            if characterProfessionData then
                characters[characterName] = characterProfessionData
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

local function getSkillID(index)
    local itemLink = getSkillFunction("getLink")(index)
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

function rm.saveNewlyLearnedSkill(newSkillID)
    local newSkillName = GetSpellInfo(newSkillID)
    for professionID, recipes in pairs(rm.cachedRecipes) do
        if rm.getSavedProfessionByID(professionID) then -- Profession is learned by the character
            for _, recipeData in pairs(recipes) do
                local recipeName = recipeData.name
                if recipeName == newSkillName 
                or string.find(recipeName, newSkillName) then
                    table.insert(getSavedSkillsByProfessionID(professionID), recipeData.teaches)
                    return
                end
            end
        end
    end
end
