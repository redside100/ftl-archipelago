---@diagnostic disable: lowercase-global

-- hs_to_ap handles events from Hyperspace -> AP Proxy.
-- This usually includes the player's checks and deathlink triggers.

tick_count = 0
hs_to_ap_proxy_file = os.getenv("HS_TO_AP_PROXY_FILE")

function write_event(event_type, event_data)
    local file = io.open(hs_to_ap_proxy_file or "", "a")
    if file then
        file:write(event_type .. ":" .. event_data .. "\n")
        file:close()
    else
        return nil
    end
end

function init()
    print("FTL Archipelago - HS_TO_AP bridge active!")
end

script.on_internal_event(Defines.InternalEvents.MAIN_MENU, init)