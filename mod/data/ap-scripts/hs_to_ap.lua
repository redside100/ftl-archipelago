---@diagnostic disable: lowercase-global

-- hs_to_ap handles events from Hyperspace -> AP Proxy.
-- This usually includes the player's checks and deathlink triggers.

HS_TO_AP_PROXY_FILE = os.getenv("HS_TO_AP_PROXY_FILE")

function mods.FTLAP.proxy.writeEvent(event_data)
    local file = io.open(HS_TO_AP_PROXY_FILE or "", "a")
    if file then
        file:write(json.encode(event_data) .. '\n')
        file:close()
    else
        return nil
    end
end
