local _, GBI = ...

function GBI.UI:SaveOnScreenButtonPosition(frame)
    if not frame or not GBRT or not GBRT.Settings then
        return
    end

    local point, _, relativePoint, xOfs, yOfs = frame:GetPoint(1)
    GBRT.Settings.OnScreenButtonPosition = {
        point = point or "CENTER",
        relativePoint = relativePoint or "CENTER",
        xOfs = xOfs or 0,
        yOfs = yOfs or 0,
    }
end

function GBI.UI:ApplyOnScreenButtonPosition(frame)
    if not frame or not GBRT or not GBRT.Settings or not GBRT.Settings.OnScreenButtonPosition then
        return
    end

    local position = GBRT.Settings.OnScreenButtonPosition
    frame:ClearAllPoints()
    frame:SetPoint(position.point or "CENTER", UIParent, position.relativePoint or "CENTER", position.xOfs or 0, position.yOfs or 0)
end

local function UpdateOnScreenButtonDragState()
    if not GBI.UI.OnScreenButton then
        return
    end

    local canDrag = not (GBI.UI.OnScreenButtonLocked or false)
    GBI.UI.OnScreenButton:SetMovable(canDrag)
end

function GBI.UI:InitializeGroupStatusList()
     -- On screen button --
    local onScreenButtonPanel = GBI.Components:CreatePanel(UIParent, {
        name = "GBRTOnScreenButton",
        width = 35,
        height = 35,
        title = "",
        draggable = true
    })
    GBI.UI:ApplyOnScreenButtonPosition(onScreenButtonPanel)
    onScreenButtonPanel:ToggleVisibility(GBRT.Settings.OnScreenButton)
   
    GBI.UI.OnScreenButton = onScreenButtonPanel
    GBI.UI.OnScreenButtonLocked = false
    UpdateOnScreenButtonDragState()

    onScreenButtonPanel:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        GBI.UI:SaveOnScreenButtonPosition(self)
    end)

    GBI.Components:CreateIcon(onScreenButtonPanel, {
        name = "OnScreenIcon",
        offsetX = 0,
        offsetY = 0,
        point = "CENTER",
        relativePoint = "CENTER",
        texture = "Interface\\AddOns\\GuldbyenRaidTools\\Media\\minimap.tga",
        onClick = function()
            if GBI:IsValidScenario() then
                GBI.UI.GroupStatusPanel:ToggleVisibility()
            end
        end
    })

    -- Group status list panel --
    local groupStatusPanel = GBI.Components:CreatePanel(UIParent, {
        name = "GBRTGroupStatusPanel",
        width = 500,
        height = 500,
        title = "GBRT Group Status",
        draggable = false
    })
    groupStatusPanel:SetPoint("BOTTOMLEFT", onScreenButtonPanel, "BOTTOMLEFT", 0, 37)
    groupStatusPanel:Hide()
    GBI.UI.GroupStatusPanel = groupStatusPanel

    GBI.Components:CreateIcon(groupStatusPanel, {
        name = "RefreshIconButton",
        offsetX = -10,
        offsetY = -10,
        width = 24,
        height = 24,
        point = "TOPRIGHT",
        relativePoint = "TOPRIGHT",
        texture = "Interface\\AddOns\\GuldbyenRaidTools\\Media\\refresh.png",
        tooltip = "Refresh",
        onClick = function()
            GBI:UpdateGroupInfo()
        end
    })

    GBI.Components:CreateIcon(groupStatusPanel, {
        name = "GBRTLockButton",
        offsetX = -40,
        offsetY = -10,
        width = 24,
        height = 24,
        point = "TOPRIGHT",
        relativePoint = "TOPRIGHT",
        texture = "Interface\\AddOns\\GuldbyenRaidTools\\Media\\lock.png",
        tooltip = "Lock/Unlock anchor",
        onClick = function()
            GBI.UI.OnScreenButtonLocked = not (GBI.UI.OnScreenButtonLocked or false)
            UpdateOnScreenButtonDragState()
        end
    })

    local groupStatusPanelList = GBI.Components:CreatePanel(groupStatusPanel, {
        name = "GBRTGroupStatusPanelList",
        width = 500,
        height = 400,
        title = "",
        draggable = false,
        backdropColor = {0, 0, 0, 0},
        backdropBorderColor = {0, 0, 0, 0}
    })
    groupStatusPanelList:SetPoint("TOPLEFT", groupStatusPanel, "TOPLEFT", 0, -30)
    groupStatusPanelList:SetFrameLevel(groupStatusPanel:GetFrameLevel() + 10)
    groupStatusPanelList:SetClipsChildren(true)
    GBI.UI.GroupStatusPanelList = groupStatusPanelList
end

function GBI.UI:RefreshGroupStatusList()
    if not GBRT.GroupInfo then
        return
    end

    local listPanel = GBI.UI.GroupStatusPanelList
    listPanel:ClearComponents()

    local groupInfo = GBRT.GroupInfo



    if not next(groupInfo) then
        local emptyText = listPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        emptyText:SetText("No group data available yet.")
        listPanel:AddComponent(emptyText, "TOPLEFT", "TOPLEFT", 20, -80)
        return
    end

    local headerLabels = {"Name", "iLvl"}
    local columnStartX = 25
    local columnSpacingX = 120
    local headerOffsetsX = { 1, 0, 0, 0 }
    local headerY = 0
    local rowStartY = -20

    for index, label in ipairs(headerLabels) do
        local header = listPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        header:SetText(label)
        listPanel:AddComponent(header, "TOPLEFT", "TOPLEFT", columnStartX + ((index - 1) * columnSpacingX) + headerOffsetsX[index], headerY)
    end

 
    local sortedGroupInfo = {}

    for _, playerEntry in pairs(groupInfo) do
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

    print("Sorted Group Info:")

    for rowIndex, entry in ipairs(sortedGroupInfo) do
        local yOffset = rowStartY - ((rowIndex - 1) * 20)

        local rowContainer = CreateFrame("Frame", nil, listPanel)
        rowContainer:SetSize(220, 16)
        listPanel:AddComponent(rowContainer, "TOPLEFT", "TOPLEFT", 25, yOffset)

        local specIcon = rowContainer:CreateTexture(nil, "OVERLAY")
        specIcon:SetSize(18, 18)
        specIcon:SetTexture(entry.specIcon or "Interface\\Icons\\INV_Misc_QuestionMark")
        specIcon:SetPoint("LEFT", rowContainer, "LEFT", -20, 0)

        local nameCell = rowContainer:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        nameCell:SetText(entry.name or "Unknown")
        nameCell:SetPoint("LEFT", specIcon, "RIGHT", 4, 0)

        local columns = {
            entry.ilvl and tostring(entry.ilvl) or "n/a"
        }

        for columnIndex, value in ipairs(columns) do
            local cell = listPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            cell:SetText(value)
            listPanel:AddComponent(cell, "TOPLEFT", "TOPLEFT", columnStartX + ((columnIndex) * columnSpacingX), yOffset)
        end
    end
end