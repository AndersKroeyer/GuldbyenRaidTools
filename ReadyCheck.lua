local _, GBI = ...

function InCombat()
    return (UnitAffectingCombat("player") or InCombatLockdown())
end

-- Not sure what to name this function
-- Returns true if the player is NOT in combat, is in a raid and is either assist or lead, else false
function IsValidScenario()
    return not InCombat()
        and IsInRaid()
        and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player"))
end

function GBI:ReadyCheck()
    if IsValidScenario() then
        print("--- READY CHECK TIMER STARTED! ---")
        C_Timer.After(5, function()
            if IsValidScenario() then
                DoReadyCheck()
            end
        end)
        print("--- READY CHECK END ---")
    end
end