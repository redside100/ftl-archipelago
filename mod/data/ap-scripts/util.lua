-- Iterate over a C++ vector
function mods.FTLAP.util.vter(cvec)
    if not (type(cvec) == "userdata") then
        error("invalid arg passed to vter (" .. tostring(cvec) .. ")", 2)
    end
    local i = -1
    local n = cvec:size()
    return function()
        i = i + 1
        if i < n then return cvec[i] end
    end
end

-- Convenience function to get current sector, beacon X/Y
function mods.FTLAP.util.getLocation()
    return Hyperspace.App.world.starMap.currentSector.level, Hyperspace.App.world.starMap.currentLoc.loc.x,
        Hyperspace.App.world.starMap.currentLoc.loc.y
end
