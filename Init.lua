local _, GBI = ...

if not GBRT then
    GBRT = {}
end

local f = CreateFrame("Frame")
f:RegisterEvent("RESURRECT_REQUEST")
f:RegisterEvent("PLAYER_LOGIN")

f:SetScript("OnEvent", function(self, event, ...)
    if event == "RESURRECT_REQUEST" then
        if not (UnitAffectingCombat("player") or InCombatLockdown()) then
            print("Timer started")
            C_Timer.After(5, function()
                if not (UnitAffectingCombat("player") or InCombatLockdown()) and IsInRaid() and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
                    print("Initiating ready check.")
                    DoReadyCheck()
                end
            end)
            print("------------------- END -------------------")
        end
    elseif event == "PLAYER_LOGIN" then
        print("Vi har loadet vores episke addon")
    end
end)
