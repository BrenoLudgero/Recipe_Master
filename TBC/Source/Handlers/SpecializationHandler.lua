local _, rm = ...

function rm.getSavedSpecializationByProfessionID(professionID)
    if rm.getSavedVariablesForCurrentCharacter()[professionID] then -- Avoids an error when unlearning a profession
        return rm.getSavedVariablesForCurrentCharacter()[professionID]["specialization"]
    end
end

function rm.getSavedSpecializationByProfessionName(professionName)
    local savedProfession = rm.getSavedVariablesForCurrentCharacter()[rm.getProfessionID(professionName)]
    if savedProfession then
        return savedProfession["specialization"]
    end
    return false
end

function rm.getSpecializationName(specializationID)
    local specializationName = GetSpellInfo(specializationID)
    return specializationName
end

-- specialization: A saved specialization, which is a spell ID, a list of them or false / nil if none
-- (see isProfessionWithMultipleSpecializations)
function rm.getSpecializationsList(specialization)
    if type(specialization) == "table" then
        return specialization
    elseif specialization then
        return {specialization}
    end
    return {}
end

-- The specialization needed to learn another, e.g. Weaponsmith for Master Swordsmith. nil if none
function rm.getRequiredSpecialization(professionID, specializationID)
    local specializationRecipe = rm.cachedRecipes[professionID][specializationID]
    return specializationRecipe and specializationRecipe.specialization
end

local specializationIDs = {
    [164] = {9787, 9788, 17039, 17040, 17041}, -- Blacksmithing
    [165] = {10657, 10658, 10660}, -- Leatherworking
    [171] = {28672, 28675, 28677}, -- Alchemy
    [197] = {26797, 26798, 26801}, -- Tailoring
    [202] = {20219, 20222}, -- Engineering
}

-- Professions whose specializations are saved as a list, as they can be learned together
local professionsWithMultipleSpecializations = {
    [164] = true, -- Blacksmithing: Weaponsmith and Master Axesmith, Hammersmith or Swordsmith
}

local function professionHasSpecializations(professionID)
    return specializationIDs[professionID] ~= nil
end

local function isProfessionWithMultipleSpecializations(professionID)
    return professionsWithMultipleSpecializations[professionID] == true
end

local function storeLearnedSpecializations(currentSpecializations, spellID)
    for professionID, specs in pairs(specializationIDs) do
        if rm.tableContains(specs, spellID) then
            if isProfessionWithMultipleSpecializations(professionID) then
                currentSpecializations[professionID] = currentSpecializations[professionID] or {}
                if not rm.tableContains(currentSpecializations[professionID], spellID) then
                    table.insert(currentSpecializations[professionID], spellID)
                end
            else
                currentSpecializations[professionID] = spellID
            end
        end
    end
end

function rm.getLearnedSpecializations()
    local currentSpecializations = {}
    local numSpellTabs = GetNumSpellTabs()
    for i = 1, numSpellTabs do
        local offset, numSlots = select(3, GetSpellTabInfo(i))
        for j = offset + 1, offset + numSlots do
            local _, _, spellID = GetSpellBookItemName(j, BOOKTYPE_SPELL)
            storeLearnedSpecializations(currentSpecializations, spellID)
        end
    end
    return currentSpecializations
end

function rm.saveNewSpecializations(currentSpecializations)
    for professionID, specializationID in pairs(currentSpecializations) do
        local savedSpecialization = rm.getSavedSpecializationByProfessionID(professionID)
        if isProfessionWithMultipleSpecializations(professionID) then
            -- Also replaces a single specialization saved by older versions
            if type(savedSpecialization) ~= "table" then
                savedSpecialization = {}
                rm.getSavedProfessionByID(professionID)["specialization"] = savedSpecialization
            end
            for _, learnedSpecializationID in ipairs(specializationID) do
                if not rm.tableContains(savedSpecialization, learnedSpecializationID) then
                    table.insert(savedSpecialization, learnedSpecializationID)
                end
            end
        elseif not savedSpecialization then
            rm.getSavedProfessionByID(professionID)["specialization"] = specializationID
        end
    end
end

local function isLearnedProfessionWithSpecializations(professionID)
    return rm.getSavedProfessionByID(professionID) and professionHasSpecializations(professionID)
end

local function isSpecializationAbandoned(currentSpecializations, professionID)
    return not currentSpecializations[professionID]
end

function rm.removeAbandonedSpecialization(currentSpecializations, professionID)
    if isLearnedProfessionWithSpecializations(professionID) then
        local savedSpecs = rm.getSavedProfessionByID(professionID)["specialization"]
        if type(savedSpecs) == "table" then
            for i = #savedSpecs, 1, -1 do
                if not rm.tableContains(currentSpecializations[professionID] or {}, savedSpecs[i]) then
                    table.remove(savedSpecs, i)
                end
            end
        else
            if isSpecializationAbandoned(currentSpecializations, professionID) then
                rm.getSavedProfessionByID(professionID)["specialization"] = nil
            end
        end
    end
end
