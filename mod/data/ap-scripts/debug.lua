---@diagnostic disable: lowercase-global

function printSectorBeacon()
    local sectorMessage = "Sector " .. Hyperspace.App.world.starMap.currentSector.level
    local beaconMessage = "Beacon (" ..
        Hyperspace.App.world.starMap.currentLoc.loc.x .. ", " .. Hyperspace.App.world.starMap.currentLoc.loc.y .. ")"
    print(sectorMessage)
    print(beaconMessage)

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

function jumbleStarMap()
    local starMap = Hyperspace.App.world.starMap
    for location in mods.FTLAP.util.vter(starMap.locations) do
        location.loc.x = math.random(0, 500)
        location.loc.y = math.random(0, 500)
    end
end

script.on_game_event("AP_DEBUG_PRINT_SECTOR_BEACON", false, printSectorBeacon)
script.on_game_event("AP_DEBUG_JUMBLE_STAR_MAP", false, jumbleStarMap)
