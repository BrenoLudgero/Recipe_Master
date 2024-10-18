local _, rm = ...
local L = rm.L

function rm.getSavedProfessionByID(professionID)
    return rm.getCurrentCharacterSavedVariables()[professionID]
end

function rm.getSavedProfessionByName(profession)
    return rm.getCurrentCharacterSavedVariables()[rm.getProfessionID(profession)]
end

function rm.getSavedProfessionRank(profession)
    return rm.getSavedProfessionByName(profession)["rank"]
end

function rm.getSavedProfessionLevelByName(profession)
    return rm.getSavedProfessionByName(profession)["level"]
end

function rm.getSavedProfessionLevelForCharacter(character, profession)
    return rm.getServerSavedVariables()[character][profession]["level"]
end

local function getRankName(skillRank, maxSkillRank)
    if skillRank == 525 then
        return "IllustriousGrandMaster"
    end
    if maxSkillRank > 375 then
        return "GrandMaster"
    elseif maxSkillRank > 300 then
        return "Master"
    elseif maxSkillRank > 225 then
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
            ["rank"] = getRankName(skillRank, maxSkillRank),
            ["skills"] = {},
            ["specialization"] = false
        }
    end
end

-- Returns the character's currently learned professions' ID and data
local function getCurrentCharacterLearnedProfessions()
    local currentProfessions = {}
    local numSkillLines = GetNumSkillLines()
    for i = 1, numSkillLines do
        local skillName, _, _, skillRank, _, _, maxSkillRank = GetSkillLineInfo(i)
        storeLearnedProfession(currentProfessions, skillName, skillRank, maxSkillRank)
    end
    return currentProfessions
end

-- Stores the character's current professions in SavedVariables if not saved yet
local function saveNewProfessions(currentProfessions)
    for professionID in pairs(currentProfessions) do
        if not rm.getSavedProfessionByID(professionID) then
            rm.getCurrentCharacterSavedVariables()[professionID] = currentProfessions[professionID]
        end
    end
end

local function isProfessionAbandoned(currentProfessions, professionID)
    return not currentProfessions[professionID] and rm.getSavedProfessionByID(professionID)
end

-- Removes abandoned professions from SavedVariables
local function removeAbandonedProfession(currentProfessions, professionID)
    if isProfessionAbandoned(currentProfessions, professionID) then
        rm.getCurrentCharacterSavedVariables()[professionID] = nil
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
            rm.getSavedProfessionByID(professionID)["level"] = professionLevel
        elseif professionRank ~= savedProfessionRank then
            rm.getSavedProfessionByID(professionID)["rank"] = professionRank
        elseif professionSpecialization and professionSpecialization ~= savedProfessionSpecialization then
            rm.getSavedProfessionByID(professionID)["specialization"] = savedProfessionSpecialization
        elseif isProfessionAbandoned(currentProfessions, professionID) then
            rm.getCurrentCharacterSavedVariables()[professionID] = nil
        end
    end
end

function rm.updateCharacterProfessions()
    local currentProfessions = getCurrentCharacterLearnedProfessions()
    local currentSpecializations = rm.getLearnedSpecializations()
    saveNewProfessions(currentProfessions)
    rm.saveNewSpecializations(currentSpecializations)
    updateSavedProfessions(currentProfessions)
    for professionID in pairs(rm.getCurrentCharacterSavedVariables()) do
        removeAbandonedProfession(currentProfessions, professionID)
        rm.removeAbandonedSpecialization(currentSpecializations, professionID)
    end
end
