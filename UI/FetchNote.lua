local _, GBI = ...

-- Dropdown options
local dropdownOptions = {
    {text = "One armed bandit", value = "bandit"},
    {text = "Mug'zee", value = "mugzee"},
    {text = "Gally", value = "gally"}
}

-- Function to initialize the dropdown (called from main file)
function GBI:InitializeFetchNoteUI()
    if not GBI:GetFrame() then
        print("Error: Main frame not found!")
        return
    end

    -- Create dropdown menu
    local dropdown = CreateFrame("Frame", "FetchNoteDropdown", GBI:GetFrame(), "UIDropDownMenuTemplate")
    dropdown:SetPoint("TOPLEFT", GBI:GetFrame(), "BOTTOMLEFT", 0, 80)
    UIDropDownMenu_SetWidth(dropdown, 200)
    UIDropDownMenu_SetText(dropdown, "Select boss to fetch note for")

    -- Variable to store selected option
    local selectedOption = nil

    -- Dropdown initialize function
    local function DropdownInitialize(self, level)
        for i, option in ipairs(dropdownOptions) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = option.text
            info.value = option.value
            info.func = function()
                -- Update global variable
                GBI.selectedBoss = option.value
                UIDropDownMenu_SetText(dropdown, option.text)
                
                -- Call update function if it exists
                if GBI.UpdateUI then
                    GBI:UpdateUI()
                end
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end

    UIDropDownMenu_Initialize(dropdown, DropdownInitialize)
end

-- Function to programmatically set dropdown value
function GBI:SetDropdownValue(value)
    for i, option in ipairs(dropdownOptions) do
        if option.value == value then
            self.selectedOption = value
            if self.dropdown then
                UIDropDownMenu_SetText(self.dropdown, option.text)
            end
            break
        end
    end
end

-- Function to get available dropdown options
function GBI:GetDropdownOptions()
    return dropdownOptions
end