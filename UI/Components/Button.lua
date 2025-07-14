local _, GBI = ...

function GBI.Components:CreateButton(parent, config)
    local button = CreateFrame("Button", config.name, parent)
    
    -- Default configuration
    local defaults = {
        width = 100,
        height = 30,
        text = "Button",
        font = "GameFontNormal",
        normalTexture = "Interface\\Buttons\\UI-Panel-Button-Up",
        pushedTexture = "Interface\\Buttons\\UI-Panel-Button-Down",
        highlightTexture = "Interface\\Buttons\\UI-Panel-Button-Highlight",
        disabledTexture = "Interface\\Buttons\\UI-Panel-Button-Disabled",
        textColor = {1, 1, 1, 1}, -- white
        onClick = nil,
        tooltip = nil
    }
    
    -- Merge config with defaults
    for key, value in pairs(defaults) do
        if config[key] == nil then
            config[key] = value
        end
    end
    
    -- Set up button
    button:SetSize(config.width, config.height)
    button:SetNormalTexture(config.normalTexture)
    button:SetPushedTexture(config.pushedTexture)
    button:SetHighlightTexture(config.highlightTexture)
    button:SetDisabledTexture(config.disabledTexture)
    
    -- Create text
    local text = button:CreateFontString(nil, "OVERLAY")
    text:SetFontObject(config.font)
    text:SetPoint("CENTER")
    text:SetText(config.text)
    text:SetTextColor(unpack(config.textColor))
    button.text = text
    
    -- Set up click handler
    if config.onClick then
        button:SetScript("OnClick", config.onClick)
    end
    
    -- Set up tooltip
    if config.tooltip then
        button:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            GameTooltip:SetText(config.tooltip)
            GameTooltip:Show()
        end)
        button:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)
    end
    
    -- Add methods to button
    function button:SetButtonText(newText)
        self.text:SetText(newText)
    end
    
    function button:GetButtonText()
        return self.text:GetText()
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