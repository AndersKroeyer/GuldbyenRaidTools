local _, GBI = ...

function GBI.Components:CreateInputField(parent, config)
    local container = CreateFrame("Frame", config.name .. "Container", parent)
    
    -- Default configuration
    local defaults = {
        width = 200,
        height = 20,
        label = "Input:",
        placeholder = "Enter text...",
        maxLetters = 0, -- 0 = no limit
        numeric = false,
        onChange = nil,
        onEnter = nil
    }
    
    -- Merge config with defaults
    for key, value in pairs(defaults) do
        if config[key] == nil then
            config[key] = value
        end
    end
    
    container:SetSize(config.width, config.height + 20)
    
    -- Create label
    local label = container:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("TOPLEFT", container, "TOPLEFT", 0, 0)
    label:SetText(config.label)
    
    -- Create input field
    local input = CreateFrame("EditBox", config.name, container, "InputBoxTemplate")
    input:SetSize(config.width, config.height)
    input:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 0, -5)
    input:SetAutoFocus(false)
    
    if config.maxLetters > 0 then
        input:SetMaxLetters(config.maxLetters)
    end
    
    if config.numeric then
        input:SetNumeric(true)
    end
    
    -- Placeholder text
    local placeholderText = input:CreateFontString(nil, "OVERLAY", "GameFontDisable")
    placeholderText:SetPoint("LEFT", input, "LEFT", 5, 0)
    placeholderText:SetText(config.placeholder)
    
    -- Handle placeholder visibility
    local function updatePlaceholder()
        if input:GetText() == "" then
            placeholderText:Show()
        else
            placeholderText:Hide()
        end
    end
    
    input:SetScript("OnTextChanged", function(self, userInput)
        updatePlaceholder()
        if config.onChange and userInput then
            config.onChange(self:GetText())
        end
    end)
    
    input:SetScript("OnEnterPressed", function(self)
        if config.onEnter then
            config.onEnter(self:GetText())
        end
        self:ClearFocus()
    end)
    
    input:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
    end)
    
    -- Initialize placeholder
    updatePlaceholder()
    
    -- Add methods to container
    function container:SetValue(value)
        input:SetText(value or "")
        updatePlaceholder()
    end
    
    function container:GetValue()
        return input:GetText()
    end
    
    function container:SetEnabled(enabled)
        if enabled then
            input:Enable()
        else
            input:Disable()
        end
    end
    
    function container:Focus()
        input:SetFocus()
    end
    
    container.input = input
    container.label = label
    
    return container
end