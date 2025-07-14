local _, GBI = ...

-- Create main UI frame
local frame = CreateFrame("Frame", "GuldbyenUIFrame", UIParent, "BasicFrameTemplateWithInset")
frame:SetSize(300, 200)
frame:SetPoint("CENTER")
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame.title = frame:CreateFontString(nil, "OVERLAY")
frame.title:SetFontObject("GameFontHighlight")
frame.title:SetPoint("LEFT", frame.TitleBg, "LEFT", 5, 0)
frame.title:SetText("Guldbyen Raid Tools")

-- Hide frame initially
frame:Hide()

function GBI:GetFrame()
    return frame
end

function GBI:Hide()
    frame:Hide()
end

function GBI:Show()
    frame:Show()
end

function GBI:IsShown()
    return frame:IsShown()
end

-- Create a button to show current values
local button = CreateFrame("Button", "MyAddonButton", frame, "GameMenuButtonTemplate")
button:SetSize(120, 30)
button:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 15, 40)
button:SetText("Fetch MRT note")
button:SetScript("OnClick", function()
    local boss = GBI.selectedBoss
    local pulltimerEnabled = GBRT.Settings["AutoReadyCheck"] and "Enabled" or "Disabled"
    print("Boss: " .. boss .. ", Checkbox: " .. pulltimerEnabled)
end)


function GBI:InitializeUI()
    if not GBI:GetFrame() then
        print("Error: Main frame not found!")
        return
    end

    -- Initialize dropdown and checkbox
    if GBI.InitializeDropdown then
        GBI:InitializeDropdown()
    end
    if GBI.InitializeCheckbox then
        GBI:InitializeCheckbox()
    end
end