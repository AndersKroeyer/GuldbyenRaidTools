local _, GBI = ...


function GBI.UI:InitializeGroupStatusList()
     -- On screen button --
    local onScreenButtonPanel = GBI.Components:CreatePanel(UIParent, {
        name = "GBRTOnScreenButton",
        width = 35,
        height = 35,
        title = "",
        draggable = true
    })
    onScreenButtonPanel:SetPoint("CENTER")
    onScreenButtonPanel:ToggleVisibility(GBRT.Settings.OnScreenButton)
   
    GBI.UI.OnScreenButton = onScreenButtonPanel

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
        title = "Group Status",
        draggable = false
    })
    groupStatusPanel:SetPoint("BOTTOMLEFT", onScreenButtonPanel, "BOTTOMLEFT", 0, 37)
    groupStatusPanel:Hide()
    groupStatusPanel:SetScript("OnShow", function()
        GBI.UI:RefreshGroupStatusList()
    end)
    GBI.UI.GroupStatusPanel = groupStatusPanel
end

function GBI.UI:RefreshGroupStatusList(refreshing)
    if not GBI.UI.GroupStatusPanel then
        return
    end

    local panel = GBI.UI.GroupStatusPanel
    panel:ClearComponents()

    GBI.Components:CreateIcon(panel, {
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
            GBI.UI:RefreshGroupStatusList(true)
        end
    })

    if refreshing then
        local loadingText = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        loadingText:SetText("Updating group data...")
        panel:AddComponent(loadingText, "TOPLEFT", "TOPLEFT", 20, -80)

        local refreshFinished = false
        local function finishRefresh()
            if refreshFinished then
                return
            end

            refreshFinished = true
            if GBI.UI.GroupStatusPanel and GBI.UI.GroupStatusPanel:IsVisible() then
                GBI.UI:RefreshGroupStatusList(false)
            end
        end

        GBI:UpdateGroupInfo(function()
            finishRefresh()
        end)

        return
    end

    local groupInfo = GBI.GroupInfo or GBRT.GroupInfo or {}

    if not next(groupInfo) then
        local emptyText = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        emptyText:SetText("No group data available yet.")
        panel:AddComponent(emptyText, "TOPLEFT", "TOPLEFT", 20, -80)
        return
    end

    local headerLabels = {"Name", "iLvl", "Role"}
    for index, label in ipairs(headerLabels) do
        local header = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        header:SetText(label)
        panel:AddComponent(header, "TOPLEFT", "TOPLEFT", 20 + ((index - 1) * 120), -50)
    end

    for rowIndex, entry in ipairs(groupInfo) do
        local yOffset = -80 - ((rowIndex - 1) * 20)
        local columns = {
            entry.name or "Unknown",
            entry.ilvl and tostring(entry.ilvl) or "n/a",
            entry.role or "Unknown"
        }

        for columnIndex, value in ipairs(columns) do
            local cell = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            cell:SetText(value)
            panel:AddComponent(cell, "TOPLEFT", "TOPLEFT", 20 + ((columnIndex - 1) * 120), yOffset)
        end
    end
end