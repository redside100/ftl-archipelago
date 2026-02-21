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
                local payload = json.decode(line)
                print(payload)
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

script.on_internal_event(Defines.InternalEvents.ON_TICK, onTick)
