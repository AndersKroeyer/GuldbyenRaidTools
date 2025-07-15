-- local _, GBI = ...

-- function GBI.Components:CreateDropdown(parent, config)
--     local container = CreateFrame("Frame", config.name .. "Container", parent)
    
--     -- Default configuration
--     local defaults = {
--         width = 200,
--         height = 20,
--         label = "",
--         options = {},
--         selectedValue = nil,
--         placeholder = "Select option...",
--         onChange = nil
--     }
    
--     -- Merge config with defaults
--     for key, value in pairs(defaults) do
--         if config[key] == nil then
--             config[key] = value
--         end
--     end
    
--     container:SetSize(config.width, config.height + 20)
    
--     -- Create label
--     local label = container:CreateFontString(nil, "OVERLAY", "GameFontNormal")
--     label:SetPoint("TOPLEFT", container, "TOPLEFT", 0, 0)
--     label:SetText(config.label)
--     label:SetTextColor(0.8, 0.8, 0.2, 1)
    
--     -- Create dropdown
--     local dropdown = CreateFrame("Frame", config.name, container, "UIDropDownMenuTemplate")
--     dropdown:SetPoint("TOPLEFT", label, "BOTTOMLEFT", -15, -5)
--     UIDropDownMenu_SetWidth(dropdown, config.width)
--     UIDropDownMenu_SetText(dropdown, config.placeholder)
    
--     -- Store selected value
--     local selectedValue = config.selectedValue

--     -- Dropdown initialize function
--     local function DropdownInitialize(self, level)
--         for i, option in ipairs(config.options) do
--             local info = UIDropDownMenu_CreateInfo()
--             info.text = option.text
--             info.value = option.value
--             info.func = function()
--                 selectedValue = option.value
--                 UIDropDownMenu_SetText(dropdown, option.text)
--                 if config.onChange then
--                     config.onChange(option.value, option.text)
--                 end
--             end
--             UIDropDownMenu_AddButton(info, level)
--         end
--     end
    
--     UIDropDownMenu_Initialize(dropdown, DropdownInitialize)
    
--     -- Add methods to container
--     function container:SetValue(value)
--         for i, option in ipairs(config.options) do
--             if option.value == value then
--                 selectedValue = value
--                 UIDropDownMenu_SetText(dropdown, option.text)
--                 break
--             end
--         end
--     end
    
--     function container:GetValue()
--         return selectedValue
--     end
    
--     function container:SetOptions(options)
--         config.options = options
--         UIDropDownMenu_Initialize(dropdown, DropdownInitialize)
--     end
    
--     function container:SetEnabled(enabled)
--         if enabled then
--             UIDropDownMenu_EnableDropDown(dropdown)
--         else
--             UIDropDownMenu_DisableDropDown(dropdown)
--         end
--     end

--     -- Create background
--     local bg = container:CreateTexture(nil, "BACKGROUND")
--     bg:SetAllPoints(container)
--     bg:SetColorTexture(0.2, 0.2, 0.2, 0.8) -- dark grey with some transparency
--     container.bg = bg

--     local dropdownText = _G[config.name.."Text"]
--     if dropdownText then
--         dropdownText:SetTextColor(0.8, 0.8, 0.2, 1)
--     end

--     container.dropdown = dropdown
--     container.label = label

--     return container
-- end