function mods.FTLAP.util.vter(cvec)
    if not (type(cvec) == "userdata") then
        error("invalid arg passed to vter ("..tostring(cvec)..")", 2)
    end
    local i = -1
    local n = cvec:size()
    return function()
        i = i + 1
        if i < n then return cvec[i] end
    end
end