local _, GBI = ...

local function CreateCheckboxComponent(parent, config)
    local checkbox = CreateFrame("CheckButton", config.name, parent)

    -- Default configuration
    local defaults = {
        width = 24,
        height = 24,
        text = "Checkbox",
        font = "GameFontNormal",
        checked = false,
        onClick = nil,
        textColor = {1, 1, 1, 1}, -- white
        normalTexture = "Interface\\AddOns\\GuldbyenRaidTools\\Media\\checkbox.tga",
        pushedTexture = "Interface\\AddOns\\GuldbyenRaidTools\\Media\\checkbox_checked.tga",
        checkedTexture = "Interface\\AddOns\\GuldbyenRaidTools\\Media\\checkbox_checked.tga",
        disabledTexture = "Interface\\Buttons\\UI-CheckBox-Disabled"
    }

    -- Merge config with defaults
    for key, value in pairs(defaults) do
        if config[key] == nil then
            config[key] = value
        end
    end

    checkbox:SetSize(config.width, config.height)
    checkbox:SetChecked(config.checked)

    -- Set custom textures
    checkbox:SetNormalTexture(config.normalTexture)
    checkbox:SetPushedTexture(config.pushedTexture)
    checkbox:SetCheckedTexture(config.checkedTexture)
    checkbox:SetDisabledTexture(config.disabledTexture)

    -- Create label
    local label = checkbox:CreateFontString(nil, "OVERLAY")
    label:SetFontObject(config.font)
    label:SetPoint("LEFT", checkbox, "RIGHT", 4, 0)
    label:SetText(config.text)
    label:SetTextColor(unpack(config.textColor))
    checkbox.label = label

    -- Set up click handler
    if config.onClick then
        checkbox:SetScript("OnClick", function(self)
            config.onClick(self, self:GetChecked())
        end)
    end

    -- Add methods to checkbox
    function checkbox:SetCheckboxText(newText)
        self.label:SetText(newText)
    end

    function checkbox:GetCheckboxText()
        return self.label:GetText()
    end

    function checkbox:SetCheckedState(state)
        self:SetChecked(state)
    end

    function checkbox:IsCheckedState()
        return self:GetChecked()
    end

    return checkbox
end

function GBI.Components:CreateCheckbox(panel, config)
    local checkbox = CreateCheckboxComponent(panel, {
        name = config.name,
        text = config.text,
        checked = config.checked,
        onClick = config.onClick
    })
    panel:AddComponent(checkbox, config.point, config.relativePoint, config.offsetX, config.offsetY)
end

function GBI.Components:CreateSettingCheckbox(panel, config)
   self:CreateCheckbox(panel, {
        name = config.name,
        text = config.text,
        checked = GBRT.Settings[config.settingKey],
        onClick = function(self, checked)
            GBRT.Settings[config.settingKey] = checked

            if config.onChange then
                config.onChange(checked)
            end
        end,
        offsetX = config.offsetX,
        offsetY = config.offsetY,
        point = config.point,
        relativePoint = config.relativePoint
    })
end