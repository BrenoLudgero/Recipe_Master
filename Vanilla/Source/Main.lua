local _, rm = ...

-- Runs the functions below when one of the registered in-game events occur
rm.frame:SetScript("OnEvent", function(_, event, ...)
    if rm.handleAddonLoaded then
        rm.handleAddonLoaded(event, ...)
        rm.handleAddonLoaded = nil
    end
    rm.handleSkillChange(event)
    rm.handleProfessionFrame(event)
end)
