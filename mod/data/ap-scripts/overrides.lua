---@diagnostic disable: lowercase-global


function override_has_augmentation(ship, augment, value)
    if value == "FTL_JUMPER" then
        print(augment .. " check " .. value)
        return Defines.Chain.HALT, 1
    end
    return Defines.Chain.CONTINUE, value
end

script.on_internal_event(Defines.InternalEvents.HAS_AUGMENTATION, override_has_augmentation)