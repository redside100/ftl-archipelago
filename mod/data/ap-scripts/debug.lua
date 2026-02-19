---@diagnostic disable: lowercase-global

tick_count_debug = 0
function on_debug_tick()
    tick_count_debug = (tick_count_debug + 1) % 60
    if tick_count_debug == 0 then
        print("Sector" .. Hyperspace.App.world.starMap.currentSector.level)
        print("Beacon (" .. Hyperspace.App.world.starMap.currentLoc.loc.x .. ", " .. Hyperspace.App.world.starMap.currentLoc.loc.y .. ")")
    end
end

script.on_internal_event(Defines.InternalEvents.ON_TICK, on_debug_tick)