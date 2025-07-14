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
        width = 400,
        height = 300,
        title = "GBRT Main Panel"
    })
    panel:SetPoint("CENTER")
    panel:Hide()
    GBI.UI.MainPanel = panel

    local fetchButton = GBI.Components:CreateButton(panel, {
        name = "FetchButton",
        width = 200,
        height = 50,
        text = "Fetch",
        onClick = function()
            local boss = GBRT.Settings["SelectedBoss"]
            local pulltimerEnabled = GBRT.Settings["AutoReadyCheck"] and "Enabled" or "Disabled"
            print("Boss: " .. boss .. ", Checkbox: " .. pulltimerEnabled)
        end
    })
    panel:AddComponent(fetchButton, "BOTTOMLEFT", "BOTTOMLEFT", 20, 20)

    local checkbox = GBI.Components:CreateCheckbox(panel, {
        name = "AutoReadyCheckbox",
        text = "Ready on ressurection",
        checked = GBRT.Settings["AutoReadyCheck"],
        onClick = function(self, checked)
            GBRT.Settings["AutoReadyCheck"] = checked
        end
    })
    panel:AddComponent(checkbox, "TOPLEFT", "TOPLEFT", 15, -40)

    local checkbox = GBI.Components:CreateCheckbox(panel, {
        name = "ReadyCheckCheckbox",
        text = "GBRT Ready Check",
        checked = GBRT.Settings["ReadyCheck"],
        onClick = function(self, checked)
            GBRT.Settings["ReadyCheck"] = checked
        end
    })
    panel:AddComponent(checkbox, "TOPLEFT", "TOPLEFT", 15, -70)

    local dropdownOptions = {
        {text = "One armed bandit", value = "bandit"},
        {text = "Mug'zee", value = "mugzee"},
        {text = "Gally", value = "gally"}
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

    panel:AddComponent(dropdown, "BOTTOMLEFT", "BOTTOMLEFT", 20, 80)
end
