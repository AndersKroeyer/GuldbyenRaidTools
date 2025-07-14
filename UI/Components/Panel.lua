local _, GBI = ...

function GBI.Components:CreatePanel(parent, config)
    local panel = CreateFrame("Frame", config.name, parent, "BackdropTemplate")
    
    -- Default configuration
    local defaults = {
        width = 300,
        height = 200,
        title = "Panel",
        backdrop = {
            bgFile = "Interface\\AddOns\\GuldbyenRaidTools\\Media\\panel-bg.tga",
            edgeFile = "Interface\\AddOns\\GuldbyenRaidTools\\Media\\panel-bg.tga",
            tile = true,             -- Repeat both background and edge textures
            tileSize = 64,           -- Should match your snippet's height (or width if vertical)
            edgeSize = 8,           -- Match snippet's height/width for scaling
            insets = {               -- Controls how far the content sits from the edge
                left = 0,
                right = 0,
                top = 0,
                bottom = 0
            }
        },
        backdropColor = {1, 1, 1, 1},             -- Don't tint background
        backdropBorderColor = {1, 1, 1, 1}        -- Don't tint the edge border
    }
    
    -- Merge config with defaults
    for key, value in pairs(defaults) do
        if config[key] == nil then
            config[key] = value
        end
    end
    
    panel:SetSize(config.width, config.height)
    panel:SetBackdrop(config.backdrop)
    panel:SetBackdropColor(unpack(config.backdropColor))
    panel:SetBackdropBorderColor(unpack(config.backdropBorderColor))
    
    -- Create title
    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", panel, "TOP", 0, -10)
    title:SetText(config.title)
    
    -- Component management
    panel.components = {}

    panel:EnableMouse(true)
        
    function panel:AddComponent(component, point, relativePoint, x, y)
        table.insert(self.components, component)
        component:SetParent(self)
        component:SetPoint(point or "TOPLEFT", self, relativePoint or "TOPLEFT", x or 10, y or -30)
        return component
    end
    
    function panel:RemoveComponent(component)
        for i, comp in ipairs(self.components) do
            if comp == component then
                table.remove(self.components, i)
                component:Hide()
                component:SetParent(nil)
                break
            end
        end
    end
    
    function panel:ClearComponents()
        for _, component in ipairs(self.components) do
            component:Hide()
            component:SetParent(nil)
        end
        self.components = {}
    end
    
    panel.title = title
    
    return panel
end