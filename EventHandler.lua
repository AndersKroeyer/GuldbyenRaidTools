local _, GBI = ...

local f = CreateFrame("Frame")
f:RegisterEvent("RESURRECT_REQUEST")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("READY_CHECK")
f:SetScript("OnEvent", function(self, e, ...)
    if e == "ADDON_LOADED" then
        local name = ...

        if name == "GuldbyenRaidTools" then
            if not GBRT then
                GBRT = {}
            end

            if not GBRT.Settings then
                GBRT.Settings = {}
            end

            GBRT.Settings["AutoReadyCheck"] = GBRT.Settings["AutoReadyCheck"] or false
            GBRT.Settings["SelectedBoss"] = GBRT.Settings["SelectedBoss"] or ""
            GBRT.Settings["ReadyCheck"] = GBRT.Settings["ReadyCheck"] or false

            if GBI.UI.InitializeUI then
                GBI.UI:InitializeUI()
            end
        end
    elseif e == "PLAYER_LOGIN" then
        print("GuldbyenRaidTools er blevet loaded. Brug /gbrt for at tilgå brugergrænsefladen.")
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