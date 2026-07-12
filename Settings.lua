local _, GBI = ...

GBI.Settings = GBI.Settings or {}
GBI.Settings.Defaults = {
    AutoReadyCheck = false,
    SelectedBoss = "",
    ReadyCheck = false,
    OnScreenButton = false,
}

function GBI:InitializeSettings()
    if not GBRT then
        GBRT = {}
    end

    if not GBRT.Settings then
        GBRT.Settings = {}
    end

    for key, defaultValue in pairs(self.Settings.Defaults) do
        if GBRT.Settings[key] == nil then
            GBRT.Settings[key] = defaultValue
        end
    end
    return GBRT.Settings
end
