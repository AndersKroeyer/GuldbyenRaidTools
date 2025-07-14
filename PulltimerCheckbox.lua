local _, GBI = ...

if not GBRT then
    GBRT = {}
end

-- Internal function to initialize the checkbox (called from main file)
function GBI:InitializeCheckbox()
    if not GBI:GetFrame() then
        print("Error: Main frame not found!")
        return
    end

    -- Create checkbox
    local checkbox = CreateFrame("CheckButton", "GBRTCheckbox", GBI:GetFrame(), "InterfaceOptionsCheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", GBI:GetFrame(), "TOPLEFT", 15, -40)
    checkbox.Text:SetText("Ready on ressurection")
    
    checkbox:SetScript("OnClick", function(self)
        -- Update global variable
        GBI.readyOnRess = self:GetChecked() and true or false
        
        -- Call update function if it exists
        if GBI.UpdateUI then
            GBI:UpdateUI()
        end
        
        -- Call any registered callback functions
        if GBI.OnCheckboxChanged then
            GBI:OnCheckboxChanged(GBRT.checkboxEnabled)
        end
    end)
    
    -- Set initial state
    checkbox:SetChecked(GBRT.checkboxEnabled)
end

-- Internal function to programmatically set checkbox state
function GBI:SetCheckboxState(enabled)
    GBRT.checkboxEnabled = enabled
    if self.checkbox then
        self.checkbox:SetChecked(enabled)
    end
end

-- Internal function to get current checkbox state
function GBI:GetCheckboxState()
    return GBRT.checkboxEnabled
end

-- Internal callback function that other parts of the addon can override
function GBI:OnCheckboxChanged(enabled)
    -- This function can be overridden by other files
    -- Example: GBI.OnCheckboxChanged = function(self, enabled) ... end
end