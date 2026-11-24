local _, rm = ...

local function getSavedSkillsByProfessionID(professionID)
    return rm.getSavedProfessionByID(professionID)["skills"]
end

function rm.getSavedSkillsByProfessionName(profession)
    return rm.getSavedProfessionByName(profession)["skills"]
end

function rm.getProfessionDataForOtherCharacters(professionID)
    local characters = {}
    local savedCharactersData
    if rm.getPreference("showOppositeFactionAltsTooltipInfo") == true then
        savedCharactersData = rm.getSavedVariablesForCurrentServerAndAllFactions()
    else
        savedCharactersData = rm.getSavedVariablesForCurrentServerAndFaction()
    end
    for characterName, characterData in pairs(savedCharactersData) do
        if characterName ~= rm.currentCharacter then
            local characterProfessionData = characterData[professionID]
            if characterProfessionData then
                characters[characterName] = characterProfessionData
            end
        end
    end
    return characters
end

local function skillNotSavedYet(skillLineID, skillID)
    return (
        -- Profession exists in SavedVariables
        rm.getSavedProfessionByID(skillLineID)
        -- the skill was not found in SavedVariables
        and not rm.tableContains(getSavedSkillsByProfessionID(skillLineID), skillID)
    )
end

-- Returns true if the skill was saved
local function saveNewSkill(skillLineID, skillID)
    if skillID and skillNotSavedYet(skillLineID, skillID) then
        table.insert(getSavedSkillsByProfessionID(skillLineID), skillID)
        return true
    end
    return false
end

-- Linked, guild and NPC professions belong to someone else, so their recipes aren't saved as the character's
local function isCharacterProfessionDisplayed()
    return not (
        C_TradeSkillUI.IsTradeSkillLinked()
        or C_TradeSkillUI.IsTradeSkillGuild()
        or C_TradeSkillUI.IsNPCCrafting()
    )
end

-- Saves the spell ID of all the recipes learned for the open profession
-- Returns true if any of them wasn't saved yet
function rm.saveLearnedTradeSkills()
    local savedNewSkill = false
    if not isCharacterProfessionDisplayed() then
        return savedNewSkill
    end
    local professionInfo = C_TradeSkillUI.GetBaseProfessionInfo()
    local skillLineID = professionInfo.professionID -- e.g. 202 (Engineering)
    for _, recipeID in ipairs(C_TradeSkillUI.GetAllRecipeIDs()) do
        local recipeInfo = C_TradeSkillUI.GetRecipeInfo(recipeID)
        if recipeInfo and recipeInfo.learned and saveNewSkill(skillLineID, recipeID) then
            savedNewSkill = true
        end
    end
    return savedNewSkill
end

-- Recipes are otherwise only saved while their profession is open, so the ones learned before Recipe Master
-- was installed (or while it was disabled) went missing, showing the character as needing them
-- A recipe's spell is the one saved for it (see getTaughtSkill), and rankup recipes teach a rank name instead
function rm.saveKnownRecipeSpells()
    for professionID in pairs(rm.getSavedVariablesForCurrentCharacter()) do
        for recipeID, recipeData in pairs(rm.recipeDB[professionID] or {}) do
            local spellID = recipeData.isSpell and recipeID or recipeData.teaches
            if type(spellID) == "number" and IsPlayerSpell(spellID) then
                saveNewSkill(professionID, spellID)
            end
        end
    end
end

-- newSkillID: The learned recipe's spell, which can be learned while its profession is closed (e.g. from a trainer)
function rm.saveNewlyLearnedSkill(newSkillID)
    local tradeSkillID, _, parentTradeSkillID = C_TradeSkillUI.GetTradeSkillLineForRecipe(newSkillID)
    if tradeSkillID then
        local professionID = parentTradeSkillID or tradeSkillID
        saveNewSkill(professionID, newSkillID)
    end
end
