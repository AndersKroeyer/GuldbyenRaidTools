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
    --panel:Hide()
    GBI.UI.MainPanel = panel

    GBI.Components:CreateSettingCheckbox(panel, "AutoReadyCheckbox", "Ready on ressurection", "AutoReadyCheck", 20, -40, "TOPLEFT", "TOPLEFT")
    GBI.Components:CreateSettingCheckbox(panel, "ReadyCheckCheckbox", "GBRT Ready Check", "ReadyCheck", 20, -80, "TOPLEFT", "TOPLEFT")

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
    GBI.Components:CreateDropdown(panel, "BossPicker", dropdownOptions, "SelectedBoss", 15, 80, "BOTTOMLEFT", "BOTTOMLEFT")

    GBI.Components:CreateButton(panel, "FetchButton", "Update setup", "SelectedBoss", 20, 20, "BOTTOMLEFT", "BOTTOMLEFT")
end
