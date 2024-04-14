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

function rm.getSavedProfessionLevelByName(profession)
    return rm.getSavedProfessionByName(profession)["level"]
end

local function getRankName(maxSkillRank)
    if maxSkillRank > 225 then
        return "Artisan"
    elseif maxSkillRank > 150 then
        return "Expert"
    elseif maxSkillRank > 75 then
        return "Journeyman"
    end
    return "Apprentice"
end

local function storeLearnedProfession(currentProfessions, skillName, skillRank, maxSkillRank)
    local professionID = rm.getProfessionID(skillName)
    if professionID then
        currentProfessions[professionID] = {
            ["level"] = skillRank,
            ["rank"] = getRankName(maxSkillRank),
            ["skills"] = {},
            ["specialization"] = false
        }
    end
end

-- Returns the character's currently learned professions' ID and data
local function getAllLearnedProfessions()
    local currentProfessions = {}
    local numSkillLines = GetNumSkillLines()
    for i = 1, numSkillLines do
        local skillName, _, _, skillRank, _, _, maxSkillRank = GetSkillLineInfo(i)
        storeLearnedProfession(currentProfessions, skillName, skillRank, maxSkillRank)
    end
    return currentProfessions
end

-- Stores the character's current professions in SavedVariables if not saved yet
local function saveNewCharacterProfessions(currentProfessions)
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

local function updateSavedProfessions(currentProfessions)
    for professionID, professionData in pairs(currentProfessions) do
        local professionLevel = professionData["level"]
        local savedProfessionLevel = rm.getSavedProfessionByID(professionID)["level"]
        local professionRank = professionData["rank"]
        local savedProfessionRank = rm.getSavedProfessionByID(professionID)["rank"]
        local professionSpecialization = professionData["specialization"]
        local savedProfessionSpecialization = rm.getSavedSpecializationByID(professionID)
        if professionLevel ~= savedProfessionLevel then
            rm.getCharacterSavedVariables()[professionID]["level"] = professionLevel
        elseif professionRank ~= savedProfessionRank then
            rm.getCharacterSavedVariables()[professionID]["rank"] = professionRank
        elseif professionSpecialization and professionSpecialization ~= savedProfessionSpecialization then
            rm.getCharacterSavedVariables()[professionID]["specialization"] = savedProfessionSpecialization
        elseif isProfessionAbandoned(currentProfessions, professionID) then
            rm.getCharacterSavedVariables()[professionID] = nil
        end
    end
end

function rm.updateCharacterProfessions()
    local currentProfessions = getAllLearnedProfessions()
    local currentSpecializations = rm.getAllProfessionsSpecialization()
    saveNewCharacterProfessions(currentProfessions)
    rm.saveNewProfessionsSpecializations(currentSpecializations)
    updateSavedProfessions(currentProfessions)
    for professionID in pairs(rm.getCharacterSavedVariables()) do
        removeAbandonedProfession(currentProfessions, professionID)
        rm.removeAbandonedSpecialization(currentSpecializations, professionID)
    end
end
