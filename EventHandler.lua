local _, GBI = ...

local f = CreateFrame("Frame")
f:RegisterEvent("RESURRECT_REQUEST")
f:RegisterEvent("PLAYER_LOGIN")

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

            GBRT.Settings["AutoReadyCheck"] = GBRT.Settings["AutoReadyCheck"] or true
        end
    elseif e == "PLAYER_LOGIN" then
        print("GuldbyenRaidTools er blevet loaded. Brug /gbrt for at tilgå brugergrænsefladen.")
    elseif e == "RESURRECT_REQUEST" then
        if GBRT.Settings["AutoReadyCheck"] then
            GBI:ReadyCheck()
        end
    end
end)