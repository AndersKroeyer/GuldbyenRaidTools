local _, GBI = ...

local FlaskBuffsTable = {
    [432021] = true, -- [Chaos]
    [432473] = true, -- [Saving Graces]
    [431971] = true, -- [Crit]
    [431972] = true, -- [Haste]
    [431974] = true, -- [Mastery]
    [431973] = true, -- [Versatility]
}

local FoodBuffsTable = {
    [461959] = true, -- Beledar's Bounty
    [462181] = true, -- Beledar's Bounty Hearty
    [457284] = true, -- Feast of the Midnight Masquerade
    [462210] = true, -- Feast of the Midnight Masquerade Hearty
}


function GBI:CheckPlayerBuffs(unit)
    local hasFlask = false
    local hasFood = false

    for i = 1, 40 do
        local auraData = C_UnitAuras.GetAuraDataByIndex(unit, i, "HELPFUL")
        if not auraData then break end

        if FlaskBuffsTable[auraData.spellId] then
            hasFlask = true
        end

        if auraData.icon == 136000 or FoodBuffsTable[auraData.spellId] then
            hasFood = true
        end

        if hasFlask and hasFood then
            break
        end
    end
    return hasFlask, hasFood
end

function GBI:CheckRaidConsumables()
    if IsValidScenario() then
    local missingFlask = {}
    local missingFood = {}
    local raidSize = GetNumGroupMembers()

    print("--- Checking consumables ---")

    for i = 1, raidSize do
        local unit = "raid" .. i
        if UnitExists(unit) and not UnitIsDeadOrGhost(unit) then
            local playerName = UnitName(unit)
            local hasFlask, hasFood = self:CheckPlayerBuffs(unit)

            if not hasFlask then
                table.insert(missingFlask, playerName)
            end

            if not hasFood then
                table.insert(missingFood, playerName)
            end
        end
    end

    if #missingFlask > 0 then
        print("Missing Flask: " .. table.concat(missingFlask, ", "))
    else
        print("All raid members have flask buffs!")
    end

    if #missingFood > 0 then
        print("Missing Food: " .. table.concat(missingFood, ", "))
        PlaySoundFile("Interface\\AddOns\\GuldbyenRaidTools\\Media\\my-tummy-feels-funny-peon.mp3")
    else
        print("All raid members have food buffs!")
    end

    end
end


function GBI:GBRTChecker()
    self:CheckRaidConsumables()
end
