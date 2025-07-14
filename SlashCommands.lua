local _, GBI = ...

-- Slash command to toggle the frame
SLASH_GBUI1 = "/gbrt"
SlashCmdList["GBUI"] = function(msg)
    if GBI:IsShown() then
        print("about to hide the frame")
        GBI:Hide()
    else
        GBI:Show()
    end
end
