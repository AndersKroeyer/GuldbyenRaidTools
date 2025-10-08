local _, GBI = ...

if not GBI.Components then
    GBI.Components = {}
end

if not GBI.UI then
    GBI.UI = {}
end

function GBI.UI:Hide()
    GBI.UI.MainPanel:Hide()
end

function GBI.UI:Show()
    GBI.UI.MainPanel:Show()
end

function GBI.UI:IsShown()
    return GBI.UI.MainPanel:IsShown()
end

function GBI.UI:InitializeUI()
    GBI.UI:InitializeMinimap()

    local panel = GBI.Components:CreatePanel(UIParent, {
        name = "GBRTMainPanel",
        width = 500,
        height = 400,
        title = "Guldbyen Raid Tools",
        draggable = true
    })
    panel:SetPoint("CENTER")
    panel:Hide()
    GBI.UI.MainPanel = panel

    GBI.Components:CreateIcon(panel, {
        name = "CloseIcon",
        offsetX = 0,
        offsetY = 0,
        point = "TOPRIGHT",
        relativePoint = "TOPRIGHT",
        texture = "Interface\\AddOns\\GuldbyenRaidTools\\Media\\close.tga",
        tooltip = "Close",
        onClick = function()
            GBI.UI:Hide()
        end
    })

    GBI.Components:CreateSettingCheckbox(panel, {
        name = "AutoReadyCheckbox",
        text = "Ready on ressurection",
        settingKey = "AutoReadyCheck",
        offsetX = 20,
        offsetY = -40,
        point = "TOPLEFT",
        relativePoint = "TOPLEFT"
    })

    GBI.Components:CreateSettingCheckbox(panel, {
        name = "ReadyCheckCheckbox",
        text = "GBRT Ready Check",
        settingKey = "ReadyCheck",
        offsetX = 20,
        offsetY = -80,
        point = "TOPLEFT",
        relativePoint = "TOPLEFT"
    })

   local bossMap = {
        ["Plexus Sentinel"] = "plexus-sentinel",
        ["Loom'ithar"] = "loomithar",
        ["Soulbinder Naazindhri"] = "soulbinder-naazindhri",
        ["Forgeweaver Araz"] = "forgeweaver-araz",
        ["Adarus Duskblaze"] = "the-soul-hunters",
        ["Velaryn Bloodwrath"] = "the-soul-hunters",
        ["Ilyssa Darksorrow"] = "the-soul-hunters",
        ["Fractillus"] = "fractillus",
        ["Nexus-King Salhadaar"] = "nexus-king-salhadaar",
        ["Dimensius"] = "dimensius-the-all-devouring"
    }

    -- Dropdown for boss selection
    local dropdownOptions = {
        { text = "Plexus Sentinel", value = "plexus-sentinel" },
        { text = "Loomithar",       value = "loomithar" },
        { text = "Soulbinder",      value = "soulbinder-naazindhri" },
        { text = "Forgeweaver",     value = "forgeweaver-araz" },
        { text = "Soul Hunters",    value = "the-soul-hunters" },
        { text = "Fractillus",      value = "fractillus" },
        { text = "Nexus King",      value = "nexus-king-salhadaar" },
        { text = "Dimy",            value = "dimensius-the-all-devouring" }
    }
    GBI.Components:CreateDropdown(panel, {
        name = "BossPicker",
        options = dropdownOptions,
        selectedValue = GBRT.Settings["SelectedBoss"],
        onChange = function(selected)
            GBRT.Settings["SelectedBoss"] = selected
        end,
        point = "BOTTOMLEFT",
        relativePoint = "BOTTOMLEFT",
        offsetX = 15,
        offsetY = 80
    })

    -- Update MRT note and raid groups button
    GBI.Components:CreateButton(panel, {
        name = "FetchButton",
        text = "Update setup",
        onClick = function()
            local boss = GBRT.Settings["SelectedBoss"]
            GBI:SetupBoss(boss)
        end,
        offsetX = 20,
        offsetY = 20,
        point = "BOTTOMLEFT",
        relativePoint = "BOTTOMLEFT"
    })
end
