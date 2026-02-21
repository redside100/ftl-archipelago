---@diagnostic disable: lowercase-global


-- Override the run seed to a fixed value each time
function overrideGetRunSeed()
    return true, 42424242
end

script.on_internal_event(Defines.InternalEvents.GET_RUN_SEED, overrideGetRunSeed)