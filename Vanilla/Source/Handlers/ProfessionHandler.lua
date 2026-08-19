local _, rm = ...

local _, currentCharacterClass = UnitClass("player") -- Always in English and upper case

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

local function storeLearnedProfession(currentProfessions, skillName, skillRank, maxSkillRank)
    local professionID = rm.getProfessionID(skillName)
    if professionID then
        currentProfessions[professionID] = {
            ["class"] = currentCharacterClass,
            ["level"] = skillRank,
            ["maxLevel"] = maxSkillRank,
            ["rank"] = getRankName(maxSkillRank),
            ["skills"] = {},
            ["specialization"] = false,
        }
        if rm.isSodProfessionWithSpecializations(professionID) then
            currentProfessions[professionID].specialization = {}
        end
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

local function isSodSavedSpecializationFormatOutdated(professionID, savedSpecialization)
    if rm.isSodProfessionWithSpecializations(professionID) then
        return savedSpecialization == false or type(savedSpecialization) == "number"
    end
end

local function updateSavedProfessions(currentProfessions)
    for professionID, professionData in pairs(currentProfessions) do
        local professionLevel = professionData["level"]
        local savedProfessionLevel = rm.getSavedProfessionByID(professionID)["level"]
        local professionMaxLevel = professionData["maxLevel"]
        local professionRank = professionData["rank"]
        local savedProfessionRank = rm.getSavedProfessionByID(professionID)["rank"]
        local professionSpecialization = professionData["specialization"]
        local savedProfessionSpecialization = rm.getSavedSpecializationByID(professionID)
        -- Transforms a previously unique saved specialization into a table of specializations (2.6.0 -> 2.6.1)
        if isSodSavedSpecializationFormatOutdated(professionID, savedProfessionSpecialization) then
            savedProfessionSpecialization = {}
        end
        -- Stored separately as they are only needed to display the character's progress
        if professionMaxLevel ~= rm.getSavedProfessionByID(professionID)["maxLevel"] then
            rm.getSavedProfessionByID(professionID)["maxLevel"] = professionMaxLevel
        end
        if currentCharacterClass ~= rm.getSavedProfessionByID(professionID)["class"] then
            rm.getSavedProfessionByID(professionID)["class"] = currentCharacterClass
        end
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

-- A character's class is only stored when it logs in
-- Guild members are filled in beforehand so that their names can be class colored right away
local function isClassMissingForAnySavedCharacter()
    for _, characterData in pairs(rm.getSavedVariablesForCurrentServerAndFaction()) do
        for _, professionData in pairs(characterData) do
            if type(professionData) == "table" and not professionData["class"] then
                return true
            end
        end
    end
    return false
end

local function saveClassForSavedCharacter(characterName, class)
    local characterData = rm.getSavedVariablesForCurrentServerAndFaction()[characterName]
    if not characterData then
        return
    end
    for _, professionData in pairs(characterData) do
        if type(professionData) == "table" and not professionData["class"] then
            professionData["class"] = class
        end
    end
end

-- Called when the guild roster is received
function rm.saveGuildMembersClasses()
    if not IsInGuild() or not isClassMissingForAnySavedCharacter() then
        return
    end
    for i = 1, GetNumGuildMembers() do
        local memberName, _, _, _, _, _, _, _, _, _, classFilename = GetGuildRosterInfo(i)
        if memberName and classFilename then
            saveClassForSavedCharacter(Ambiguate(memberName, "short"), classFilename)
        end
    end
end

local function requestGuildRosterIfClassesAreMissing()
    if IsInGuild() and C_GuildInfo and isClassMissingForAnySavedCharacter() then
        C_GuildInfo.GuildRoster()
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
    requestGuildRosterIfClassesAreMissing()
end
