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

    local checkbox = GBI.Components:CreateCheckbox(panel, {
        name = "AutoReadyCheckbox",
        text = "Ready on ressurection",
        checked = GBRT.Settings["AutoReadyCheck"],
        onClick = function(self, checked)
            GBRT.Settings["AutoReadyCheck"] = checked
        end
    })
    panel:AddComponent(checkbox, "TOPLEFT", "TOPLEFT", 20, -40)

    local checkbox = GBI.Components:CreateCheckbox(panel, {
        name = "ReadyCheckCheckbox",
        text = "GBRT Ready Check",
        checked = GBRT.Settings["ReadyCheck"],
        onClick = function(self, checked)
            GBRT.Settings["ReadyCheck"] = checked
        end
    })
    panel:AddComponent(checkbox, "TOPLEFT", "TOPLEFT", 20, -80)

    local dropdownOptions = {
        {text = "Vexie", value = "vexie-and-the-geargrinders"},
        {text = "Cauldron", value = "cauldron-of-carnage"},
        {text = "Rik", value = "rik-reverb"},
        {text = "Stix", value = "stix-bunkjunker"},
        {text = "Sprocket", value = "sprocketmonger-lockenstock"},
        {text = "One armed bandit", value = "one-armed-bandit"},
        {text = "Mug'zee", value = "mug-zee"},
        {text = "Gally", value = "chrome-king-gallywix"}
    }

    local dropdown = GBI.Components:CreateDropdown(panel, {
        name = "BossDropdown",
        options = dropdownOptions,
        selectedValue = GBRT.Settings["SelectedBoss"],
        onChange = function(selected)
            GBRT.Settings["SelectedBoss"] = selected
        end,
        placeholder = "Select a boss",
    })
    panel:AddComponent(dropdown, "BOTTOMLEFT", "BOTTOMLEFT", 15, 80)

    local fetchButton = GBI.Components:CreateButton(panel, {
        name = "FetchButton",
        width = 100,
        height = 20,
        text = "Update setup",
        onClick = function()
            local boss = GBRT.Settings["SelectedBoss"]
            GBI:SetupBoss(boss)
        end
    })
    panel:AddComponent(fetchButton, "BOTTOMLEFT", "BOTTOMLEFT", 20, 20)
end
