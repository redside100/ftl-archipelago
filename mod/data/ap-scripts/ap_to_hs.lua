---@diagnostic disable: lowercase-global

-- ap_to_hs handles events from AP Proxy -> Hyperspace.
-- This usually includes other players' checks and deathlink triggers.

TICK_COUNT = 0
AP_TO_HS_PROXY_FILE = os.getenv("AP_TO_HS_PROXY_FILE")

-- Periodically fetch events from AP Proxy -> HS file and process them
function mods.FTLAP.proxy.fetchEvents()
    local file = io.open(AP_TO_HS_PROXY_FILE or "", "r")
    if file then
        local content = file:read("*a")
        file:close()
        if content and content ~= "" then
            -- Parse through events by newline
            for line in content:gmatch("[^\r\n]+") do
                local event_type, event_data = line:match("([^:]+):([^:]+)")
                if event_type and event_data then
                    -- Process the event (for now, just print it)
                    print("Received event from AP Proxy - Type: " .. event_type .. ", Data: " .. event_data)
                end
            end
        end
        -- After processing events, clear the file
        file = io.open(AP_TO_HS_PROXY_FILE or "", "w")
        if file then
            file:write("")
            file:close()
        end
    else
        return nil
    end
end

function onTick()
    TICK_COUNT = (TICK_COUNT + 1) % 60
    if TICK_COUNT == 0 then
        -- Every 60 ticks (1 second), fetch events from AP Proxy
        mods.FTLAP.proxy.fetchEvents()
    end
end

function init()
    print("FTL Archipelago - AP_TO_HS bridge active!")
end

script.on_internal_event(Defines.InternalEvents.ON_TICK, onTick)
script.on_internal_event(Defines.InternalEvents.MAIN_MENU, init)