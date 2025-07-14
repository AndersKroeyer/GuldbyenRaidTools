local _, GBI = ...

function GBI.Components:CreateCheckbox(parent, config)
    local checkbox = CreateFrame("CheckButton", config.name, parent, "UICheckButtonTemplate")

    -- Default configuration
    local defaults = {
        width = 24,
        height = 24,
        text = "Checkbox",
        font = "GameFontNormal",
        checked = false,
        onClick = nil,
        textColor = {1, 1, 1, 1}, -- white
    }

    -- Merge config with defaults
    for key, value in pairs(defaults) do
        if config[key] == nil then
            config[key] = value
        end
    end

    checkbox:SetSize(config.width, config.height)
    checkbox:SetChecked(config.checked)

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