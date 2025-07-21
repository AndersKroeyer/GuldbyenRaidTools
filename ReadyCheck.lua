local _, GBI = ...

function GBI:ReadyCheck()
    if GBI:IsValidScenario() and IsInGuildGroup() then
        C_Timer.After(10, function()
            if GBI:IsValidScenario() and not UnitIsDeadOrGhost("player") then
                DoReadyCheck()
            end
        end)
    end
end
