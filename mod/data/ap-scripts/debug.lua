---@diagnostic disable: lowercase-global

function printSectorBeacon()
    local sectorMessage = "Sector " .. Hyperspace.App.world.starMap.currentSector.level
    local beaconMessage = "Beacon (" .. Hyperspace.App.world.starMap.currentLoc.loc.x .. ", " .. Hyperspace.App.world.starMap.currentLoc.loc.y .. ")"
    print(sectorMessage)
    print(beaconMessage)
    mods.FTLAP.proxy.writeEvent("DEBUG_PRINT", sectorMessage)
    mods.FTLAP.proxy.writeEvent("DEBUG_PRINT", beaconMessage)
end

function jumbleStarMap()
    local starMap = Hyperspace.App.world.starMap
    for location in mods.FTLAP.util.vter(starMap.locations) do
        print(location.loc.x .. ", " .. location.loc.y)
        location.loc.x = math.random(0, 1000)
        location.loc.y = math.random(0, 1000)
        print("JUMBLED TO: " .. location.loc.x .. ", " .. location.loc.y)
    end
end

script.on_game_event("AP_DEBUG_PRINT_SECTOR_BEACON", false, printSectorBeacon)
script.on_game_event("AP_DEBUG_JUMBLE_STAR_MAP", false, jumbleStarMap)