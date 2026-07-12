local _, GBI = ...

local f = CreateFrame("Frame")
f:RegisterEvent("ENCOUNTER_START")
f:RegisterEvent("ENCOUNTER_END")
f:RegisterEvent("RESURRECT_REQUEST")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("READY_CHECK")
f:SetScript("OnEvent", function(self, e, ...)
    if e == "ADDON_LOADED" then
        local name = ...

        if name == "GuldbyenRaidTools" then
            GBI:InitializeSettings()

            if GBI.UI.InitializeUI then
                GBI.UI:InitializeUI()
            end
        end
    elseif e == "PLAYER_LOGIN" then
        print("GuldbyenRaidTools er blevet loaded. Brug /gbrt for at tilgå addon.")
    elseif e == "ENCOUNTER_START" then
        print("Encounter started")
        GBI.UI.GroupStatusPanel:Hide()
    elseif e == "RESURRECT_REQUEST" then
        if GBRT.Settings["AutoReadyCheck"] then
            GBI:ReadyCheck()
        end
    elseif e == "READY_CHECK" then
        if GBRT.Settings["ReadyCheck"] then
            C_Timer.After(1, function()
            GBI:GBRTChecker()
        end)
    end
    end
end)