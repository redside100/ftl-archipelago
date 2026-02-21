---@diagnostic disable: lowercase-global

local function sendTestProxyEvent()
    payload = {
        type = "debug_info",
        data = {
            sector = Hyperspace.App.world.starMap.currentSector.level,
            beacon = {
                x = Hyperspace.App.world.starMap.currentLoc.loc.x,
                y = Hyperspace.App.world.starMap.currentLoc.loc.y
            }
        }
    }
    mods.FTLAP.proxy.writeEvent(payload)
end

local function jumbleStarMap()
    local starMap = Hyperspace.App.world.starMap
    for location in mods.FTLAP.util.vter(starMap.locations) do
        location.loc.x = math.random(0, 500)
        location.loc.y = math.random(0, 500)
    end
end

local function toggleDebugDisplay()
    mods.FTLAP.debug.debugDisplay = not mods.FTLAP.debug.debugDisplay
end

function mods.FTLAP.debug.openDebugMenu()
    Hyperspace.CustomEventsParser.GetInstance():LoadEvent(Hyperspace.App.world, "AP_DEBUG", true,
        Hyperspace.Global.currentSeed)
end

script.on_game_event("AP_DEBUG_SEND_TEST_PROXY_EVENT", false, sendTestProxyEvent)
script.on_game_event("AP_DEBUG_JUMBLE_STAR_MAP", false, jumbleStarMap)
script.on_game_event("AP_DEBUG_TOGGLE_DEBUG_DISPLAY", false, toggleDebugDisplay)
