local _, GBI = ...

function GBI:InCombat()
    return (UnitAffectingCombat("player") or InCombatLockdown())
end

-- function GBI:IsValidScenario()
--     return not GBI:InCombat()
--         and not C_Secrets.ShouldAurasBeSecret()
--         and IsInRaid()
--         and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player"))
-- end

function GBI:IsValidScenario()
    return not GBI:InCombat()
        and not C_Secrets.ShouldAurasBeSecret()
        --and IsInRaid()
        --and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player"))
end