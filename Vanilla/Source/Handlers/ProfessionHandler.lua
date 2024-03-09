local _, rm = ...
local L = rm.L

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

function rm.getSavedProfessionByID(professionID)
    return rm.getCharacterSavedVariables()[professionID]
end

function rm.getSavedProfessionByName(profession)
    return rm.getCharacterSavedVariables()[rm.getProfessionID(profession)]
end

function getSavedProfessionRank(profession)
    return rm.getSavedProfessionByName(profession)["rank"]
end

local specializationIDs = {
    [164] = {9788, 17041, 17040, 17039, 9787},
    [202] = {20219, 20222},
    [165] = {10657, 10658, 10660}
}

local function storeCurrentSpecializations(currentSpecializations, spellID)
    for professionID, specs in pairs(specializationIDs) do
        if rm.tableContains(specs, spellID) then
            currentSpecializations[professionID] = spellID
        end
    end
end

local function getAllProfessionsSpecialization()
    local currentSpecializations = {}
    local numSpellTabs = GetNumSpellTabs()
    for i = 1, numSpellTabs do
        local offset, numSlots = select(3, GetSpellTabInfo(i))
        for j = offset + 1, offset + numSlots do
            local _, _, spellID = GetSpellBookItemName(j, BOOKTYPE_SPELL)
            storeCurrentSpecializations(currentSpecializations, spellID)
        end
    end
    return currentSpecializations
end

-- Stores the character's current professions in SavedVariables if not saved yet
local function saveCharacterProfessions(currentProfessions)
    for professionID in pairs(currentProfessions) do
        if not rm.getSavedProfessionByID(professionID) then
            rm.getCharacterSavedVariables()[professionID] = currentProfessions[professionID]
        end
    end
end

local function professionAbandoned(currentProfessions, professionID)
    return not currentProfessions[professionID] and rm.getSavedProfessionByID(professionID)
end

-- Removes abandoned professions from SavedVariables
local function removeAbandonedProfessions(currentProfessions, professionID)
    if professionAbandoned(currentProfessions, professionID) then
        rm.getCharacterSavedVariables()[professionID] = nil
    end
end

function rm.getSavedSpecializationByID(professionID)
    return rm.getCharacterSavedVariables()[professionID]["specialization"]
end

function rm.getSavedSpecializationByName(profession)
    return rm.getCharacterSavedVariables()[rm.getProfessionID(profession)]["specialization"]
end

-- Saves all current professions' specializations if any
local function saveProfessionsSpecializations(currentSpecializations)
    for professionID, specializationID in pairs(currentSpecializations) do
        if not rm.getSavedSpecializationByID(professionID) then
            rm.getSavedProfessionByID(professionID)["specialization"] = specializationID
        end
    end
end

local function specializationAbandoned(currentSpecializations, professionID)
    return not currentSpecializations[professionID] and rm.getSavedSpecializationByID(professionID)
end

local function removeAbandonedSpecializations(currentSpecializations, professionID)
    if specializationAbandoned(currentSpecializations, professionID) then
        rm.getSavedProfessionByID(professionID)["specialization"] = nil
    end
end

function rm.updateCharacterProfessions()
    local currentProfessions = getAllLearnedProfessions()
    local currentSpecializations = getAllProfessionsSpecialization()
    saveCharacterProfessions(currentProfessions)
    saveProfessionsSpecializations(currentSpecializations)
    for professionID in pairs(rm.getCharacterSavedVariables()) do
        removeAbandonedProfessions(currentProfessions, professionID)
        removeAbandonedSpecializations(currentSpecializations, professionID)
    end
end
