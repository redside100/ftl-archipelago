---@diagnostic disable: lowercase-global

function print_sector_beacon()
    local sector_message = "Sector " .. Hyperspace.App.world.starMap.currentSector.level
    local beacon_message = "Beacon (" .. Hyperspace.App.world.starMap.currentLoc.loc.x .. ", " .. Hyperspace.App.world.starMap.currentLoc.loc.y .. ")"
    print(sector_message)
    print(beacon_message)
    write_event("DEBUG_PRINT", sector_message)
    write_event("DEBUG_PRINT", beacon_message)
end

script.on_game_event("AP_DEBUG_PRINT_SECTOR_BEACON", false, print_sector_beacon)