local _, GBI = ...

if not GBRT then
    GBRT = {}
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")

f:SetScript("OnEvent", function(self, ...)
    help:EventHandler(e, ...)
end)

function help:EventHandler(event, ...) {

}