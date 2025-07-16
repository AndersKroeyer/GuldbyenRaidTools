local _, GBI = ...

-- Slash command to toggle the frame
SLASH_GBUI1 = "/gbrt"
SlashCmdList["GBUI"] = function(msg)
    if GBI.UI:IsShown() then
        print("about to hide the frame")
        GBI.UI:Hide()
    else
        GBI.UI:Show()
    end
end

SLASH_GBSETUP1 = "/gbrt-setup"
SlashCmdList["GBSETUP"] = function(msg)
    local bossName = UnitName("target")
    GBI:SetupFarmByBossUnitName(bossName)
end