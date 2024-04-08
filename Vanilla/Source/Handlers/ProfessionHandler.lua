local _, rm = ...
local L = rm.L

function rm.getSavedProfessionByID(professionID)
    return rm.getCharacterSavedVariables()[professionID]
end

function rm.getSavedProfessionByName(profession)
    return rm.getCharacterSavedVariables()[rm.getProfessionID(profession)]
end

function rm.getSavedProfessionRank(profession)
    return rm.getSavedProfessionByName(profession)["rank"]
end

local function getRankName(skillMaxRank)
    if skillMaxRank > 225 then
        return "Artisan"
    elseif skillMaxRank > 150 then
        return "Expert"
    elseif skillMaxRank > 75 then
        return "Journeyman"
    end
    return "Apprentice"
end

local function storeLearnedProfession(currentProfessions, skillName, skillRank, skillMaxRank)
    for professionID, professionName in pairs(L.professionNames) do
        if professionName == skillName then
            currentProfessions[professionID] = {
                ["level"] = skillRank,
                ["rank"] = getRankName(skillMaxRank),
                ["skills"] = {},
                ["specialization"] = false
            }
        end
    end
end

-- Returns the character's currently learned professions' ID and data
local function getAllLearnedProfessions()
    local currentProfessions = {}
    local numSkillLines = GetNumSkillLines()
    for i = 1, numSkillLines do
        local skillName, _, _, skillRank, _, _, skillMaxRank = GetSkillLineInfo(i)
        if rm.getProfessionID(skillName) then
            storeLearnedProfession(currentProfessions, skillName, skillRank, skillMaxRank)
        end
    end
    return currentProfessions
end

-- Stores the character's current professions in SavedVariables if not saved yet
local function saveCharacterProfessions(currentProfessions)
    for professionID in pairs(currentProfessions) do
        if not rm.getSavedProfessionByID(professionID) then
            rm.getCharacterSavedVariables()[professionID] = currentProfessions[professionID]
        end
    end
end

local function isProfessionAbandoned(currentProfessions, professionID)
    return not currentProfessions[professionID] and rm.getSavedProfessionByID(professionID)
end

-- Removes abandoned professions from SavedVariables
local function removeAbandonedProfession(currentProfessions, professionID)
    if isProfessionAbandoned(currentProfessions, professionID) then
        rm.getCharacterSavedVariables()[professionID] = nil
    end
end

function rm.updateCharacterProfessions()
    local currentProfessions = getAllLearnedProfessions()
    local currentSpecializations = rm.getAllProfessionsSpecialization()
    saveCharacterProfessions(currentProfessions)
    rm.saveProfessionsSpecializations(currentSpecializations)
    for professionID in pairs(rm.getCharacterSavedVariables()) do
        removeAbandonedProfession(currentProfessions, professionID)
        rm.removeAbandonedSpecialization(currentSpecializations, professionID)
    end
end
