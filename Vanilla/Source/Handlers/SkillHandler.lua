local _, rm = ...

local function getSavedSkillsByProfessionID(professionID)
    return rm.getSavedProfessionByID(professionID)["skills"]
end

function rm.getSavedSkillsByProfessionName(profession)
    return rm.getSavedProfessionByName(profession)["skills"]
end

function rm.getProfessionSkillsForAllCharacters(professionID)
    local characters = {}
    for character in pairs(rm.getServerSavedVariables()) do
        characters[character] = {}
        characters[character][professionID] = {}
        if rm.getServerSavedVariables()[character][professionID] then
            characters[character][professionID] = rm.getServerSavedVariables()[character][professionID]["skills"]
        else
            characters[character][professionID] = false
        end
    end
    return characters
end

local function getSkillID(i, getItemLink)
    local itemLink = getItemLink(i)
    if itemLink then
        local skillID = rm.getIDFromLink(itemLink)
        return skillID
    end
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
    if skillNotSavedYet(skillLineID, skillID) then
        table.insert(getSavedSkillsByProfessionID(skillLineID), skillID)
    end
end

-- Saves the ID of all the skills / crafts available for the profession
function rm.saveNewTradeSkills(getNumSkills, getSkillInfo, getItemLink)
    local numSkills = getNumSkills()
    local skillLineID = rm.getProfessionID(rm.displayedProfession) -- e.g. 202 (Engineering)
    for i = 1, numSkills do
        local _, skillType, craftType = getSkillInfo(i)
        if skillType ~= "header" and craftType ~= "header" then
            local skillID = getSkillID(i, getItemLink)
            saveNewSkill(skillLineID, skillID)
        end
    end
end
