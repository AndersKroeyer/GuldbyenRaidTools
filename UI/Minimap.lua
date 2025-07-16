local _, GBI = ...

local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("MyAddon", {
    type = "data source",
    text = "MyAddon",
    icon = "Interface\\AddOns\\GuldbyenRaidTools\\Media\\minimap.tga",  -- Replace with your icon path
    OnClick = function(self, button)
        if GBI.UI:IsShown() then
            GBI.UI:Hide()
        else
            GBI.UI:Show()
        end
    end,
    OnTooltipShow = function(tooltip)
        tooltip:AddLine("Guldbyen Raid Tools")
        tooltip:AddLine("Click for at åbne ;)")
    end,
})

local icon = LibStub("LibDBIcon-1.0")

function GBI.UI:InitializeMinimap()
    self.db = LibStub("AceDB-3.0"):New("GBRT", {
        profile = {
            minimap = {
                hide = false,
            },
        },
    })

    icon:Register("GBRT", LDB, self.db.profile.minimap)
end
