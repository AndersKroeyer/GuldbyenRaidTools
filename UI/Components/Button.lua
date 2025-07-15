local _, GBI = ...

function GBI.Components:CreateButton(parent, config)
    local button = CreateFrame("Button", config.name, parent)

    -- Default configuration
    local defaults = {
        width = 100,
        height = 30,
        text = "Button",
        font = "GameFontNormal",
        normalTexture = "Interface\\AddOns\\GuldbyenRaidTools\\Media\\button_highlight.tga",
        pushedTexture = "Interface\\AddOns\\GuldbyenRaidTools\\Media\\button_pushed.tga",
        disabledTexture = "Interface\\Buttons\\UI-Panel-Button-Disabled",
        textColor = {1, 1, 1, 1}, -- white
        onClick = nil
    }

    -- Merge config with defaults
    for key, value in pairs(defaults) do
        if config[key] == nil then
            config[key] = value
        end
    end
        
    -- Set up button
    button:SetSize(config.width, config.height)

    local bg = button:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(button)
    -- bg:SetColorTexture(0.8, 0.6, 0.2, 1)
    bg:SetColorTexture(1, 1, 1, 1)
    bg:SetGradient("HORIZONTAL", CreateColor(0.8, 0.6, 0.2, 1), CreateColor(1, 0.9, 0.6, 1)) 
    button.bg = bg

    -- Create border texture
    -- local border = button:CreateTexture(nil, "BORDER")
    -- border:SetAllPoints(button)
    -- border:SetGradient("HORIZONTAL", CreateColor(0.8, 0.6, 0.2, 1), CreateColor(1, 0.9, 0.6, 1))
    -- button.border = border

    -- Custom textures
    --button:SetNormalTexture(config.normalTexture)
    --button:SetPushedTexture(config.pushedTexture)
    --button:SetDisabledTexture(config.disabledTexture)

    -- Create text 
    local text = button:CreateFontString(nil, "OVERLAY")
    text:SetFontObject(config.font)
    text:SetText(config.text)
    text:SetTextColor(unpack(config.textColor))
    text:SetJustifyH("CENTER")
    text:SetJustifyV("MIDDLE")
    text:ClearAllPoints()
    text:SetPoint("CENTER", button, "CENTER")
    button.text = text

    -- Set up click handler
    if config.onClick then
        button:SetScript("OnClick", config.onClick)
    end

    function button:SetEnabled(enabled)
        if enabled then
            self:Enable()
        else
            self:Disable()
        end
    end

    return button
end