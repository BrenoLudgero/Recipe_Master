local _, rm = ...

local function getSavedSkillsByProfessionID(professionID)
    return rm.getSavedProfessionByID(professionID)["skills"]
end

function rm.getSavedSkillsByProfessionName(profession)
    return rm.getSavedProfessionByName(profession)["skills"]
end

function rm.getSavedProfessionLevelByName(profession)
    return rm.getSavedProfessionByName(profession)["level"]
end

function rm.getCharactersSkillsForProfession(professionID)
    local characters = {}
    for character in pairs(rm.getSavedVariablesForServer()) do
        characters[character] = {}
        characters[character][professionID] = {}
        if rm.getSavedVariablesForServer()[character][professionID] then
            characters[character][professionID] = rm.getSavedVariablesForServer()[character][professionID]["skills"]
        else
            characters[character][professionID] = false
        end
    end
    return characters
end

local function getSkillID(i, getItemLinkFunction)
    local itemLink = getItemLinkFunction(i)
    if itemLink then
        local skillID = rm.getIdFromItemLink(itemLink)
        return skillID
    end
end

local function skillNotSavedYet(skillLineID, skillID)
    --      Profession exists in SavedVariables       the skill was not found in SavedVariables
    return rm.getSavedProfessionByID(skillLineID) and not rm.tableContains(getSavedSkillsByProfessionID(skillLineID), skillID)
end

local function saveNewSkill(skillLineID, skillID)
    if skillNotSavedYet(skillLineID, skillID) then
        table.insert(getSavedSkillsByProfessionID(skillLineID), skillID)
    end
end

-- Saves the ID of all the skills / crafts available for the profession
function rm.saveNewTradeSkills(getNumSkillsFunction, getSkillInfoFunction, getItemLinkFunction)
    local numSkills = getNumSkillsFunction()
    local skillLineID = rm.getProfessionID(rm.displayedProfession) -- e.g. 202 (Engineering)
    for i = 1, numSkills do
        local _, skillType, craftType = getSkillInfoFunction(i)
        if skillType ~= "header" and craftType ~= "header" then
            local skillID = getSkillID(i, getItemLinkFunction)
            saveNewSkill(skillLineID, skillID)
        end
    end
end
