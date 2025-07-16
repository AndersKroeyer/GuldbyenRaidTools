local _, GBI = ...


function GBI:CreateBossSetup(boss)
    if not IsValidScenario() then
        return
    end

    print("Creating boss setup for: " .. boss) -- prints vexie-and-the-geargrinders
    local bossSetup = GBRT.FarmSetup["bossSetups"][boss]

    -- Move raiders out to bench groups (5-8)
    for i = 1, #bossSetup.raidersOut do
        local raiderOutCharacterName = NSAPI:GetChar(bossSetup.raidersOut[i])
        GBI:MoveToGroup(raiderOutCharacterName, "bench")
    end

    -- Move raiders in to raid groups (1-4)
    for i = 1, #bossSetup.raidersIn do
        local raiderInCharacterName = NSAPI:GetChar(bossSetup.raidersIn[i])
        GBI:MoveToGroup(raiderInCharacterName, "raid")
    end
end

function GBI:MoveToGroup(playerName, groupType)
    -- Check if player exists in raid
    if not UnitInRaid(playerName) then
        --print("Player " .. playerName .. " is not in the raid")
        return false
    end
    
    -- Get current group of the player
    local currentGroup, index = GBI:GetPlayerGroup(playerName)
    if not currentGroup or not index then
        --print("Could not determine current group for " .. playerName)
        return false
    end
    
    --print("Player " .. playerName .. " is currently in group " .. currentGroup .. " and has index: " .. index)
    
    -- Determine target group range based on type
    local minGroup, maxGroup
    if groupType == "bench" then
        minGroup, maxGroup = 5, 8
    elseif groupType == "raid" then
        minGroup, maxGroup = 1, 4
    else
        print("Invalid group type: " .. groupType)
        return false
    end
    
    -- Check if player is already in the correct group type
    if currentGroup >= minGroup and currentGroup <= maxGroup then
        --print("Player " .. playerName .. " is already in " .. groupType .. " group " .. currentGroup)
        return true
    end
    
    -- Find an available group in the target range
    local targetGroup = self:FindAvailableGroup(minGroup, maxGroup)
    if not targetGroup then
        --print("No available " .. groupType .. " groups found")
        return false
    end
    
    --print("Attempting to move " .. playerName .. " to " .. groupType .. " group " .. targetGroup)
    
    -- Attempt to move player to target group
    SetRaidSubgroup(index, targetGroup)
    
    -- Wait a moment for the change to take effect
    -- C_Timer.After(0.5, function()
    --     -- Verify the move was successful
    --     local newGroup = self:GetPlayerGroup(playerName)
    --     if newGroup == targetGroup then
    --         print("Successfully moved " .. playerName .. " to " .. groupType .. " group " .. targetGroup)
    --     else
    --         print("Failed to move " .. playerName .. " to " .. groupType .. " group. Current group: " .. (newGroup or "unknown"))
    --     end
    -- end)
    
    return true
end

-- Helper function to get a player's current group
function GBI:GetPlayerGroup(playerName)
    for i = 1, GetNumGroupMembers() do
        local name, rank, subgroup = GetRaidRosterInfo(i)
        if name == playerName then
            return subgroup, i
        end
    end
    return nil
end

-- Helper function to find an available group in a specified range
function GBI:FindAvailableGroup(minGroup, maxGroup)
    local groupCounts = {0, 0, 0, 0, 0, 0, 0, 0} -- Groups 1-8

    -- Count players in each group
    for i = 1, GetNumGroupMembers() do
        local name, rank, subgroup = GetRaidRosterInfo(i)
        if subgroup then
            groupCounts[subgroup] = groupCounts[subgroup] + 1
        end
    end

    -- Find the group in the specified range with the most players (but still below 5)
    local bestGroup = nil
    local maxCount = -1

    for group = minGroup, maxGroup do
        if groupCounts[group] < 5 and groupCounts[group] > maxCount then
            maxCount = groupCounts[group]
            bestGroup = group
        end
    end

    -- Return the group if it has space (max 5 players per group)
    if bestGroup and maxCount < 5 then
        return bestGroup
    end

    return nil -- No available groups in the specified range
end