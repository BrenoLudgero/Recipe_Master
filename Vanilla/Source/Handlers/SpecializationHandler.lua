local _, rm = ...

function rm.getSavedSpecializationByID(professionID)
    if rm.getCurrentCharacterSavedVariables()[professionID] then -- Avoids an error when unlearning a profession
        return rm.getCurrentCharacterSavedVariables()[professionID]["specialization"]
    end
end

function rm.getSavedSpecializationByName(profession)
    return rm.getCurrentCharacterSavedVariables()[rm.getProfessionID(profession)]["specialization"]
end

function rm.getSavedProfessionSpecializationForCharacter(character, professionID)
    return rm.getServerSavedVariables()[character][professionID]["specialization"]
end

function rm.getSpecializationName(specializationID)
    local specializationName = GetSpellInfo(specializationID)
    return specializationName
end

local specializationIDs = {
    [164] = {9788, 17041, 17040, 17039, 9787},
    [202] = {20219, 20222},
    [165] = {10657, 10658, 10660}
}

function rm.isSodProfessionWithSpecializations(professionID)
    return rm.currentSeason == "SoD" and specializationIDs[professionID] ~= nil
end

local function storeCurrentSpecializations(currentSpecializations, spellID)
    for professionID, specs in pairs(specializationIDs) do
        if rm.tableContains(specs, spellID) then
            if rm.isSodProfessionWithSpecializations(professionID) then
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
            storeCurrentSpecializations(currentSpecializations, spellID)
        end
    end
    return currentSpecializations
end

function rm.saveNewSpecializations(currentSpecializations)
    for professionID, specializationID in pairs(currentSpecializations) do
        local savedSpecialization = rm.getSavedSpecializationByID(professionID)
        if rm.isSodProfessionWithSpecializations(professionID) then
            local savedSpecs = rm.getSavedProfessionByID(professionID)["specialization"]
            if type(savedSpecs) ~= "table" then
                savedSpecs = {}
                rm.getSavedProfessionByID(professionID)["specialization"] = savedSpecs
            end
            if not rm.tableContains(savedSpecs, specializationID) then
                table.insert(savedSpecs, specializationID)
            end
        else
            if not savedSpecialization then
                rm.getSavedProfessionByID(professionID)["specialization"] = specializationID
            end
        end
    end
end

local function isSpecializationAbandoned(currentSpecializations, professionID)
    if rm.isSodProfessionWithSpecializations(professionID) then
        local savedSpecs = rm.getSavedSpecializationByID(professionID)
        if type(savedSpecs) == "table" then
            for _, savedSpec in ipairs(savedSpecs) do
                if not rm.tableContains(currentSpecializations[professionID] or {}, savedSpec) then
                    return true
                end
            end
            return false
        end
    end
    return rm.getSavedSpecializationByID(professionID) and not currentSpecializations[professionID]
end

function rm.removeAbandonedSpecialization(currentSpecializations, professionID)
    if rm.isSodProfessionWithSpecializations(professionID) then
        local savedSpecs = rm.getSavedProfessionByID(professionID)["specialization"]
        if type(savedSpecs) == "table" then
            for i = #savedSpecs, 1, -1 do
                if not rm.tableContains(currentSpecializations[professionID] or {}, savedSpecs[i]) then
                    table.remove(savedSpecs, i)
                end
            end
        end
    else
        if isSpecializationAbandoned(currentSpecializations, professionID) then
            rm.getSavedProfessionByID(professionID)["specialization"] = nil
        end
    end
end
