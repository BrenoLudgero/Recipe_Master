-- © 2024 Breno Ludgero. All Rights Reserved.

-- Runs the functions below when one of the registered in-game events occur
RecipeMaster:SetScript("OnEvent", function(_, event, ...)
    if handleRecipeMasterLoaded then
        handleRecipeMasterLoaded(event, ...)
        handleRecipeMasterLoaded = nil
    end
    handleSkillChange(event)
    handleProfessionWindowOpened(event)
end)
