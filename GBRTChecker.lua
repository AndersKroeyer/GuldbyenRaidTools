local _, GBI = ...

local function GetRoleLabel(role)
    if role == "TANK" then
        return "Tank"
    elseif role == "HEALER" then
        return "Healer"
    elseif role == "DAMAGER" then
        return "DPS"
    end

    return "DPS"
end

local function GetSpecializationLabel(unit)
    local specIndex

    if unit == "player" then
        specIndex = GetSpecialization()
    else
        specIndex = GetInspectSpecialization(unit)
    end

    if specIndex and specIndex > 0 then
        local _, specName = GetSpecializationInfo(specIndex)
        return specName or nil
    end

    return nil
end

function GBI:UpdateGroupInfo(callback)
    -- if not GBI:IsValidScenario() then
    --     return nil
    -- end

    GBI.GroupInfo = {}

    local raidSize = GetNumGroupMembers()
    local units = {}

    for i = 1, raidSize do
        local unit = "raid" .. i
        if UnitExists(unit) then
            local index = #units + 1
            table.insert(units, {
                unit = unit,
                nickname = NSAPI:Shorten(UnitName(unit)),
                index = index
            })
        end
    end

    local function processNext()
        local entry = table.remove(units, 1)
        if not entry then
            local sortedGroupInfo = {}

            for _, playerEntry in pairs(GBI.GroupInfo) do
                table.insert(sortedGroupInfo, playerEntry)
            end

            table.sort(sortedGroupInfo, function(a, b)
                local roleOrder = {
                    Tank = 1,
                    Healer = 2,
                    DPS = 3
                }

                local roleA = roleOrder[a.role] or 4
                local roleB = roleOrder[b.role] or 4

                if roleA ~= roleB then
                    return roleA < roleB
                end

                return (a.name or "") < (b.name or "")
            end)

            GBI.GroupInfo = sortedGroupInfo
            GBRT.GroupInfo = sortedGroupInfo

            if callback then
                callback(sortedGroupInfo)
            end
            return
        end

        self:GetInspectItemLevel(entry.unit, function(itemLevel)
            if not itemLevel or itemLevel <= 0 then
                itemLevel = nil
            end

            local role = GetRoleLabel(UnitGroupRolesAssigned(entry.unit))
            local specialization = GetSpecializationLabel(entry.unit)

            GBI.GroupInfo[entry.index] = {
                name = entry.nickname,
                role = role,
                spec = specialization or "Unknown",
                ilvl = itemLevel
            }

            processNext()
        end)
    end

    processNext()
end

function GBI:GetInspectItemLevel(unit, callback)
    if not unit or not UnitExists(unit) then
        if callback then callback(nil) end
        return nil
    end

    if not UnitIsVisible(unit) or not CheckInteractDistance(unit, 1) then
        if callback then callback(nil) end
        return nil
    end

    if not CanInspect(unit) then
        if callback then callback(nil) end
        return nil
    end

    local function calculateAverage()
        local totalItemLevel = 0
        local equippedItems = 0

        for slot = 1, 16 do
            local itemLink = GetInventoryItemLink(unit, slot)
            if itemLink then
                local itemLevel = GetDetailedItemLevelInfo(itemLink)
                if itemLevel and itemLevel > 0 then
                    totalItemLevel = totalItemLevel + itemLevel
                    equippedItems = equippedItems + 1
                end
            end
        end

        if equippedItems > 0 then
            return math.floor(totalItemLevel / equippedItems)
        end

        return nil
    end

    local inspectFrame = CreateFrame("Frame")
    local finished = false

    local function finish()
        if finished then
            return
        end

        finished = true
        inspectFrame:UnregisterAllEvents()
        inspectFrame:SetScript("OnEvent", nil)

        local itemLevel = calculateAverage()
        if callback then
            callback(itemLevel)
        end
    end

    inspectFrame:RegisterEvent("INSPECT_READY")
    inspectFrame:SetScript("OnEvent", function(self, event, inspectedUnit)
        if inspectedUnit == unit then
            finish()
        end
    end)

    NotifyInspect(unit)

    C_Timer.After(0.5, finish)
    return nil
end