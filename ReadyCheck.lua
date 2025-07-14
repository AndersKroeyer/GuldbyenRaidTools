local _, GBI = ...

function InCombat()
    return (UnitAffectingCombat("player") or InCombatLockdown())
end

function IsValidScenario()
    return not InCombat()
        and IsInRaid()
        and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player"))
        and IsInGuildGroup()
end

function GBI:ReadyCheck()
    if IsValidScenario() then
        print("--- READY CHECK TIMER STARTED! ---")
        C_Timer.After(5, function()
            if IsValidScenario() and not UnitIsDeadOrGhost("player") then
                DoReadyCheck()
            end
        end)
        print("--- READY CHECK END ---")
    end
end
