local _, GBI = ...

if not GBRT then
    GBRT = {}
end

local f = CreateFrame("Frame")
f:RegisterEvent("RESURRECT_REQUEST")
f:RegisterEvent("PLAYER_LOGIN")

f:SetScript("OnEvent", function(self, event, ...)
    if event == "RESURRECT_REQUEST" then
        C_Timer.After(5, function()
            if IsInRaid() and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
                DoReadyCheck()
            end
        end)
    elseif event == "PLAYER_LOGIN" then
        print("Vi har loadet vores episke addon")
    end
end)
