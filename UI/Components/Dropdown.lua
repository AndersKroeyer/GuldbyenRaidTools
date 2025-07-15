local _, GBI = ...

function GBI.Components:CreateDropdown(parent, config)
    local container = CreateFrame("Frame", config.name .. "Container", parent)
    
    -- Default configuration
    local defaults = {
        width = 200,
        height = 25,
        label = "",
        options = {},
        selectedValue = nil,
        placeholder = "Select option...",
        onChange = nil,
        maxMenuHeight = 200,
        -- Color configuration
        colors = {
            -- Container background
            containerBg = {0.2, 0.2, 0.2, 0.8},
            -- Label colors
            labelText = {0.8, 0.8, 0.2, 1},
            -- Dropdown button colors
            buttonBg = {0.3, 0.3, 0.3, 1},
            buttonBgHover = {0.4, 0.4, 0.4, 1},
            buttonBorder = {0.5, 0.5, 0.5, 1},
            -- Dropdown text colors
            dropdownText = {0.9, 0.9, 0.9, 1},
            placeholderText = {0.6, 0.6, 0.6, 1},
            -- Arrow color
            arrowColor = {0.8, 0.8, 0.8, 1},
            -- Menu colors
            menuBg = {0.1, 0.1, 0.1, 0.95},
            menuBorder = {0.4, 0.4, 0.4, 1},
            menuItemText = {0.9, 0.9, 0.9, 1},
            menuItemTextHover = {1, 1, 1, 1},
            menuItemBgHover = {0.3, 0.5, 0.8, 1}
        }
    }
    
    -- Merge config with defaults (including nested colors)
    for key, value in pairs(defaults) do
        if config[key] == nil then
            config[key] = value
        elseif key == "colors" and type(value) == "table" then
            -- Merge color configurations
            for colorKey, colorValue in pairs(value) do
                if config.colors[colorKey] == nil then
                    config.colors[colorKey] = colorValue
                end
            end
        end
    end
    
    container:SetSize(config.width, config.height + 25)
    
    -- Create label
    local label = container:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("TOPLEFT", container, "TOPLEFT", 5, -5)
    label:SetText(config.label)
    label:SetTextColor(unpack(config.colors.labelText))
    
    -- Create dropdown button
    local dropdownButton = CreateFrame("Button", config.name .. "Button", container, "BackdropTemplate")
    dropdownButton:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 0, -5)
    dropdownButton:SetSize(config.width, config.height)
    dropdownButton:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = false,
        tileSize = 0,
        edgeSize = 1,
        insets = {left = 1, right = 1, top = 1, bottom = 1}
    })
    dropdownButton:SetBackdropColor(unpack(config.colors.buttonBg))
    dropdownButton:SetBackdropBorderColor(unpack(config.colors.buttonBorder))
    dropdownButton:EnableMouse(true)
    
    -- Create dropdown text
    local dropdownText = dropdownButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dropdownText:SetPoint("LEFT", dropdownButton, "LEFT", 8, 0)
    dropdownText:SetPoint("RIGHT", dropdownButton, "RIGHT", -20, 0)
    dropdownText:SetJustifyH("LEFT")
    dropdownText:SetText(config.placeholder)
    dropdownText:SetTextColor(unpack(config.colors.placeholderText))
    
    -- Create arrow
    local arrow = dropdownButton:CreateTexture(nil, "OVERLAY")
    arrow:SetPoint("RIGHT", dropdownButton, "RIGHT", -8, 0)
    arrow:SetSize(16, 16)
    arrow:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")

    -- Create dropdown menu (initially hidden)
    local menu = CreateFrame("Frame", config.name .. "Menu", container, "BackdropTemplate")
    menu:SetPoint("TOPLEFT", dropdownButton, "BOTTOMLEFT", 0, -1)
    menu:SetSize(config.width, 100) -- Will be resized based on content
    menu:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = false,
        tileSize = 0,
        edgeSize = 1,
        insets = {left = 1, right = 1, top = 1, bottom = 1}
    })
    menu:SetBackdropColor(unpack(config.colors.menuBg))
    menu:SetBackdropBorderColor(unpack(config.colors.menuBorder))
    menu:SetFrameStrata("DIALOG")
    menu:Hide()
    
    -- Create scroll frame for menu items
    local scrollFrame = CreateFrame("ScrollFrame", config.name .. "ScrollFrame", menu)
    scrollFrame:SetPoint("TOPLEFT", menu, "TOPLEFT", 2, -2)
    scrollFrame:SetPoint("BOTTOMRIGHT", menu, "BOTTOMRIGHT", -2, 2)
    
    local scrollChild = CreateFrame("Frame", config.name .. "ScrollChild", scrollFrame)
    scrollFrame:SetScrollChild(scrollChild)
    scrollChild:SetWidth(config.width - 4)
    
    -- Store variables
    local selectedValue = config.selectedValue
    local menuItems = {}
    local isOpen = false
    
    -- Function to create menu items
    local function CreateMenuItems()
        -- Clear existing items
        for _, item in ipairs(menuItems) do
            item:Hide()
            item:SetParent(nil)
        end
        menuItems = {}
        
        local totalHeight = 0
        
        for i, option in ipairs(config.options) do
            local item = CreateFrame("Button", config.name .. "Item" .. i, scrollChild, "BackdropTemplate")
            item:SetSize(config.width - 4, config.height)
            item:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, -totalHeight)
            item:SetBackdrop({
                bgFile = "Interface\\Buttons\\WHITE8X8",
                tile = false,
                tileSize = 0,
                edgeSize = 0
            })
            item:SetBackdropColor(0, 0, 0, 0) -- Transparent initially
            
            -- Create item text
            local itemText = item:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            itemText:SetPoint("LEFT", item, "LEFT", 8, 0)
            itemText:SetPoint("RIGHT", item, "RIGHT", -8, 0)
            itemText:SetJustifyH("LEFT")
            itemText:SetText(option.text)
            itemText:SetTextColor(unpack(config.colors.menuItemText))
            
            -- Hover effects
            item:SetScript("OnEnter", function(self)
                self:SetBackdropColor(unpack(config.colors.menuItemBgHover))
                itemText:SetTextColor(unpack(config.colors.menuItemTextHover))
            end)
            
            item:SetScript("OnLeave", function(self)
                self:SetBackdropColor(0, 0, 0, 0)
                itemText:SetTextColor(unpack(config.colors.menuItemText))
            end)
            
            -- Click handler
            item:SetScript("OnClick", function(self)
                selectedValue = option.value
                dropdownText:SetText(option.text)
                dropdownText:SetTextColor(unpack(config.colors.dropdownText))
                menu:Hide()
                isOpen = false
                
                if config.onChange then
                    config.onChange(option.value, option.text)
                end
            end)
            
            table.insert(menuItems, item)
            totalHeight = totalHeight + config.height
        end
        
        -- Set scroll child height
        scrollChild:SetHeight(math.max(totalHeight, 1))
        
        -- Set menu height (with max limit)
        local menuHeight = math.min(totalHeight + 4, config.maxMenuHeight)
        menu:SetHeight(menuHeight)
        
        -- Show/hide scrollbar if needed
        if totalHeight > config.maxMenuHeight - 4 then
            scrollFrame:EnableMouseWheel(true)
            scrollFrame:SetScript("OnMouseWheel", function(self, delta)
                local current = self:GetVerticalScroll()
                local maxScroll = math.max(0, totalHeight - (config.maxMenuHeight - 4))
                local newScroll = math.max(0, math.min(maxScroll, current - (delta * 20)))
                self:SetVerticalScroll(newScroll)
            end)
        else
            scrollFrame:EnableMouseWheel(false)
            scrollFrame:SetScript("OnMouseWheel", nil)
        end
    end
    
    -- Button hover effects
    dropdownButton:SetScript("OnEnter", function(self)
        self:SetBackdropColor(unpack(config.colors.buttonBgHover))
    end)
    
    dropdownButton:SetScript("OnLeave", function(self)
        self:SetBackdropColor(unpack(config.colors.buttonBg))
    end)
    
    -- Toggle menu on button click
    dropdownButton:SetScript("OnClick", function(self)
        if isOpen then
            menu:Hide()
            isOpen = false
        else
            CreateMenuItems()
            menu:Show()
            isOpen = true
        end
    end)
    
    -- Close menu when clicking outside
    local function CloseMenu()
        if isOpen then
            menu:Hide()
            isOpen = false
        end
    end
    
    -- Hook global mouse clicks to close menu
    container:SetScript("OnHide", CloseMenu)
    
    -- Initial setup
    CreateMenuItems()
    
    -- Add methods to container
    function container:SetValue(value)
        for i, option in ipairs(config.options) do
            if option.value == value then
                selectedValue = value
                dropdownText:SetText(option.text)
                dropdownText:SetTextColor(unpack(config.colors.dropdownText))
                CloseMenu()
                return
            end
        end
    end
    
    function container:GetValue()
        return selectedValue
    end
    
    function container:SetOptions(options)
        config.options = options
        CreateMenuItems()
    end
    
    function container:SetEnabled(enabled)
        dropdownButton:SetEnabled(enabled)
        if not enabled then
            CloseMenu()
        end
    end
    
    function container:SetPlaceholder(text)
        config.placeholder = text
        if not selectedValue then
            dropdownText:SetText(text)
        end
    end
    
    -- Color customization methods
    function container:SetContainerBackgroundColor(r, g, b, a)
        config.colors.containerBg = {r, g, b, a or 1}
        self.containerBg:SetColorTexture(unpack(config.colors.containerBg))
    end
    
    function container:SetLabelTextColor(r, g, b, a)
        config.colors.labelText = {r, g, b, a or 1}
        label:SetTextColor(unpack(config.colors.labelText))
    end
    
    function container:SetButtonColors(bg, bgHover, border)
        if bg then
            config.colors.buttonBg = bg
            dropdownButton:SetBackdropColor(unpack(config.colors.buttonBg))
        end
        if bgHover then
            config.colors.buttonBgHover = bgHover
        end
        if border then
            config.colors.buttonBorder = border
            dropdownButton:SetBackdropBorderColor(unpack(config.colors.buttonBorder))
        end
    end
    
    function container:SetTextColors(normal, placeholder)
        if normal then
            config.colors.dropdownText = normal
            if selectedValue then
                dropdownText:SetTextColor(unpack(config.colors.dropdownText))
            end
        end
        if placeholder then
            config.colors.placeholderText = placeholder
            if not selectedValue then
                dropdownText:SetTextColor(unpack(config.colors.placeholderText))
            end
        end
    end
    
    function container:SetMenuColors(bg, border, itemText, itemTextHover, itemBgHover)
        if bg then
            config.colors.menuBg = bg
            menu:SetBackdropColor(unpack(config.colors.menuBg))
        end
        if border then
            config.colors.menuBorder = border
            menu:SetBackdropBorderColor(unpack(config.colors.menuBorder))
        end
        if itemText then
            config.colors.menuItemText = itemText
        end
        if itemTextHover then
            config.colors.menuItemTextHover = itemTextHover
        end
        if itemBgHover then
            config.colors.menuItemBgHover = itemBgHover
        end
        -- Recreate items to apply new colors
        if isOpen then
            CreateMenuItems()
        end
    end
    
    function container:GetColors()
        return config.colors
    end
    
    function container:Close()
        CloseMenu()
    end

    container.dropdown = dropdownButton
    container.menu = menu
    container.label = label
    container.text = dropdownText
    container.arrow = arrow

    return container
end