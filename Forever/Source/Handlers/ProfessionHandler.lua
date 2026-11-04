local _, rm = ...
local L = rm.L

function rm.getSavedProfessionByID(professionID)
    return rm.getSavedVariablesForCurrentCharacter()[professionID]
end

function rm.getSavedProfessionByName(profession)
    return rm.getSavedVariablesForCurrentCharacter()[rm.getProfessionID(profession)]
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

-- skillInfo: The profession's skill line data. nil if not learned
local function storeLearnedProfession(currentProfessions, professionID, skillInfo)
    if skillInfo then
        currentProfessions[professionID] = {
            ["level"] = skillInfo.rank,
            ["rank"] = getRankName(skillInfo.maxRank),
            ["skills"] = {},
            ["specialization"] = false,
        }
    end
end

-- Returns the character's currently learned professions' ID and data
local function getCurrentCharacterLearnedProfessions()
    local currentProfessions = {}
    for professionID in pairs(L.professions) do
        local skillInfo = C_SkillInfo.GetSkillLineInfoByID(professionID)
        storeLearnedProfession(currentProfessions, professionID, skillInfo)
    end
    return currentProfessions
end

-- Stores the character's current professions in SavedVariables if not saved yet
local function saveNewProfessions(currentProfessions)
    for professionID in pairs(currentProfessions) do
        if not rm.getSavedProfessionByID(professionID) then
            rm.getSavedVariablesForCurrentCharacter()[professionID] = currentProfessions[professionID]
        end
    end
end

local function isProfessionAbandoned(currentProfessions, professionID)
    return not currentProfessions[professionID] and rm.getSavedProfessionByID(professionID)
end

-- Removes abandoned professions from SavedVariables
local function removeAbandonedProfession(currentProfessions, professionID)
    if isProfessionAbandoned(currentProfessions, professionID) then
        rm.getSavedVariablesForCurrentCharacter()[professionID] = nil
    end
end

local function updateSavedProfessions(currentProfessions)
    for professionID, professionData in pairs(currentProfessions) do
        local professionLevel = professionData["level"]
        local savedProfessionLevel = rm.getSavedProfessionByID(professionID)["level"]
        local professionRank = professionData["rank"]
        local savedProfessionRank = rm.getSavedProfessionByID(professionID)["rank"]
        local professionSpecialization = professionData["specialization"]
        local savedProfessionSpecialization = rm.getSavedSpecializationByProfessionID(professionID)
        if professionLevel ~= savedProfessionLevel then
            rm.getSavedProfessionByID(professionID)["level"] = professionLevel
        elseif professionRank ~= savedProfessionRank then
            rm.getSavedProfessionByID(professionID)["rank"] = professionRank
        elseif professionSpecialization and professionSpecialization ~= savedProfessionSpecialization then
            rm.getSavedProfessionByID(professionID)["specialization"] = savedProfessionSpecialization
        elseif isProfessionAbandoned(currentProfessions, professionID) then
            rm.getSavedVariablesForCurrentCharacter()[professionID] = nil
        end
    end
end

function rm.updateCharacterProfessions()
    local currentProfessions = getCurrentCharacterLearnedProfessions()
    local currentSpecializations = rm.getLearnedSpecializations()
    saveNewProfessions(currentProfessions)
    rm.saveNewSpecializations(currentSpecializations)
    updateSavedProfessions(currentProfessions)
    for professionID in pairs(rm.getSavedVariablesForCurrentCharacter()) do
        removeAbandonedProfession(currentProfessions, professionID)
        rm.removeAbandonedSpecialization(currentSpecializations, professionID)
    end
end
