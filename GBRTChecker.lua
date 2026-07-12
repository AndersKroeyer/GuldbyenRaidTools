local _, GBI = ...

local twoHandSlots = {
	["INVTYPE_2HWEAPON"] = true,
 	["INVTYPE_RANGED"] = true,
	["INVTYPE_RANGEDRIGHT"] = true,
}

local inspected = {}

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
        local _, specName, _, specIcon = GetSpecializationInfoByID(specIndex)
        return specName or nil, specIcon or nil
    end

    return nil, nil
end

function GBI:UpdateGroupInfo()
    -- if not GBI:IsValidScenario() then
    --     return nil
    -- end

    GBI.GroupInfo = GBI.GroupInfo or {}
    GBRT.GroupInfo = GBI.GroupInfo
    GBRT.Inspected = inspected

    local raidSize = GetNumGroupMembers()
    local units = {}

    for i = 1, raidSize do
        local unit = "raid" .. i
        if UnitExists(unit) then
            local index = #units + 1
            local name = UnitName(unit)
            local nickname = NSAPI:Shorten(name)
            local guid = UnitGUID(unit)
            if(not inspected[guid]) then
                table.insert(units, {
                    unit = unit,
                    nickname = nickname,
                    index = index
                })
            else 
                print("Already inspected: " .. nickname)
            end
        end
    end

    local function processNext()
        local entry = table.remove(units, 1)
        self:GetInspectData(entry.unit, function(itemLevel, specName, specIcon)
            if not itemLevel or itemLevel <= 0 then
                itemLevel = nil
            end

            local role = GetRoleLabel(UnitGroupRolesAssigned(entry.unit))
            local guid = UnitGUID(entry.unit)

            if specName and specName ~= "Unknown" and itemLevel and itemLevel > 0 then
                inspected[guid] = true
                GBI.GroupInfo[entry.index] = {
                    name = entry.nickname,
                    role = role,
                    spec = specName or "Unknown",
                    specIcon = specIcon,
                    ilvl = itemLevel
                }

                if GBI.UI and GBI.UI.RefreshGroupStatusList and GBI.UI.GroupStatusPanel and GBI.UI.GroupStatusPanel:IsVisible() then
                    GBI.UI:RefreshGroupStatusList()
                end

                processNext()
                return
            end

            entry.retries = (entry.retries or 0) + 1
            if entry.retries <= 3 then
                C_Timer.After(0.5, function()
                    print("Failed to inspect: " .. entry.nickname, "Retrying... (" .. entry.retries .. "/3)")
                    table.insert(units, entry)
                    processNext()
                end)
                return
            end
            processNext()
        end)
    end

    processNext()
end

function GBI:GetInspectData(unit, callback)
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
		local item_amount = 16
		local item_level = 0
		local failed = 0

		for equip_id = 1, 17 do
			if (equip_id ~= 4) then --shirt slot
				local item = GetInventoryItemLink(unit, equip_id)
				if (item) then
					local _, _, itemRarity, iLevel, _, _, _, _, equipSlot = C_Item.GetItemInfo(item)
					if (iLevel) then
						item_level = item_level + iLevel
						--16 = main hand 17 = off hand
						-- if using a two-hand, ignore the off hand slot
						if (equip_id == 16 and twoHandSlots [equipSlot]) then
							item_amount = 15
							break
						end
					end
				else
					failed = failed + 1
					if (failed > 2) then
						break
					end
				end
			end
		end

		local average = item_level / item_amount
        average = math.floor(average * 10 + 0.5) / 10

        return average
    end
    
    local inspectFrame = CreateFrame("Frame")
    local finished = false

    local function finish(resultItemLevel, resultSpecName, resultSpecIcon)
        if finished then
            return
        end

        finished = true
        inspectFrame:UnregisterAllEvents()
        inspectFrame:SetScript("OnEvent", nil)
        ClearInspectPlayer(unit)

        if callback then
            callback(resultItemLevel, resultSpecName, resultSpecIcon)
        end
    end

    inspectFrame:RegisterEvent("INSPECT_READY")
    inspectFrame:SetScript("OnEvent", function(self, event, inspectedUnit)
        if event == "INSPECT_READY" and inspectedUnit == UnitGUID(unit) then
            local itemLevel = calculateAverage()
            local specName, specIcon = GetSpecializationLabel(unit)
            finish(itemLevel, specName, specIcon)
        end
    end)

    NotifyInspect(unit)

    C_Timer.After(1.0, function()
        if not finished then
            finish(nil, nil, nil)
        end
    end)

    return nil
end