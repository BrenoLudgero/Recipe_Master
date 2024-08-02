local _, rm = ...

-- Runs the functions below when one of the registered in-game events occur
rm.frame:SetScript("OnEvent", function(_, event, ...)
    rm.handleAddonLoaded(event, ...)
    rm.handleSkillChange(event)
    rm.handleProfessionFrame(event)
    rm.handleScaleChange(event)
end)
