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

-- Main reward event (mod overwrites every reward with this event)
function on_reward()
    local sector, x, y = mods.FTLAP.util.getLocation()
    mods.FTLAP.proxy.writeEvent({
        type = "REWARD",
        data = {
            sector = sector,
            beacon = {
                x = x,
                y = y
            }
        }
    })
end

script.on_game_event("AP_REWARD", false, on_reward)
