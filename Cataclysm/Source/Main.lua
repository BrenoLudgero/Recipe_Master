local _, rm = ...

-- Runs the functions below when one of the registered in-game events occur
rm.frame:SetScript("OnEvent", function(_, event, ...)
    rm.handleAddonLoaded(event, ...)
    rm.handlePlayerLogin(event)
    rm.handleSkillChange(event)
    rm.handleScaleChange(event)
    rm.handleProfessionFrame(event)
end)
