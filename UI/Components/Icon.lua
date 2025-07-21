local _, GBI = ...

local function CreateIconComponent(parent, config)
    local iconButton = CreateFrame("Button", config.name, parent)

    -- Set size
    iconButton:SetSize(config.width, config.height)

    -- Icon texture
    local icon = iconButton:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints(iconButton)
    icon:SetTexture(config.texture)
    iconButton.icon = icon

    -- Optional: Add tooltip
    if config.tooltip then
        iconButton:SetScript("OnEnter", function()
            GameTooltip:SetOwner(iconButton, "ANCHOR_RIGHT")
            GameTooltip:SetText(config.tooltip)
            GameTooltip:Show()
        end)
        iconButton:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end

    -- Click handler
    if config.onClick then
        iconButton:SetScript("OnClick", config.onClick)
    end

    return iconButton
end


function GBI.Components:CreateIcon(panel, config)
    local icon = CreateIconComponent(panel, {
        name = config.name,
        width = config.width or 32,
        height = config.height or 32,
        texture = config.texture or "Interface\\Icons\\INV_Misc_QuestionMark",
        tooltip = config.tooltip or "Close",
        onClick = config.onClick
    })
    panel:AddComponent(icon, config.point, config.relativePoint, config.offsetX, config.offsetY)
end
