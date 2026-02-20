---@diagnostic disable: lowercase-global


-- Override the run seed to a fixed value each time, so world generation is consistent
function override_get_run_seed()
    return true, 42424242
end

script.on_internal_event(Defines.InternalEvents.GET_RUN_SEED, override_get_run_seed)