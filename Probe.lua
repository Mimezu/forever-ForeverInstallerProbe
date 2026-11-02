local ADDON = ...
local function Marker(db)
    return type(db) == "table" and type(db.marker) == "string" and db.marker or "(none)"
end
local atFileLoad = Marker(ForeverInstallerProbeDB)
local ready = false
local function Say(message) print("|cff80c0ffForever probe:|r " .. message) end
local function Status()
    if not ready then Say("Not ready yet."); return end
    Say("Saved marker: " .. Marker(ForeverInstallerProbeDB))
    Say("Marker restored before addon code this session: " .. atFileLoad)
end
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, _, name)
    if name ~= ADDON then return end
    self:UnregisterEvent("ADDON_LOADED")
    if type(ForeverInstallerProbeDB) ~= "table" then ForeverInstallerProbeDB = {} end
    ForeverInstallerProbeDB.lastFileLoadMarker = atFileLoad
    ready = true
    -- Silent at load; /fprobe reports on request.
end)
SLASH_FOREVERINSTALLERPROBE1 = "/fprobe"
SlashCmdList.FOREVERINSTALLERPROBE = function(message)
    if not ready then Say("Not ready yet."); return end
    message = (message or ""):match("^%s*(.-)%s*$")
    local marker = message:match("^set%s+([%w_-]+)$")
    if marker and #marker <= 40 then
        ForeverInstallerProbeDB.marker = marker
        Say("Marker changed to " .. marker .. ". Reload or exit normally to save it.")
    elseif message == "" or message == "status" then Status()
    else Say("Use /fprobe or /fprobe set apple (one word, up to 40 characters).") end
end
