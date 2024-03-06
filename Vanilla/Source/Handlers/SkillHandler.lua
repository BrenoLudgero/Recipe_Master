local function getSavedSkillsByProfessionID(professionID)
    return getSavedProfessionByID(professionID)["skills"]
end

function getSavedSkillsByProfessionName(profession)
    return getSavedProfessionByName(profession)["skills"]
end

local function skillNotSavedYet(skillLineID, skillID)
    --      Profession exists in savedVariables  and     the skill is not saved yet
    return getSavedProfessionByID(skillLineID) and not tableContains(getSavedSkillsByProfessionID(skillLineID), skillID)
end

function saveNewSkill(skillLineID, skillID)
    if skillNotSavedYet(skillLineID, skillID) then
        table.insert(getSavedSkillsByProfessionID(skillLineID), skillID)
    end
end

local function getSkillID(i, getItemLinkFunction)
    local itemLink = getItemLinkFunction(i)
    if itemLink then
        local _, splitLink = strsplit(":", itemLink)
        local skillID = tonumber(string.match(splitLink, "%d+")) -- Extract only numerical part
        return skillID
    end
end

-- Saves the ID of all the skills / crafts available for the profession
function saveNewTradeSkills(getNumSkillsFunction, getSkillInfoFunction, getItemLinkFunction)
    local numSkills = getNumSkillsFunction()
    local skillLineID = getProfessionID(displayedProfession) -- e.g. 202 (Engineering)
    for i = 1, numSkills do
        local _, skillType, craftType = getSkillInfoFunction(i)
        if skillType ~= "header" and craftType ~= "header" then
            local skillID = getSkillID(i, getItemLinkFunction)
            saveNewSkill(skillLineID, skillID)
        end
    end
end
