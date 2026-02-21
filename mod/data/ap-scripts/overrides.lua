---@diagnostic disable: lowercase-global


-- Override the run seed to a fixed value each time
function overrideGetRunSeed()
    return true, 42424242
end

-- TODO: Configure starmap from config
function on_sector_start()
    local payload = {
        type = "debug_info",
        data = {
            event = "sector_start",
            sector = Hyperspace.App.world.starMap.currentSector.level,
            beacon = {
                x = Hyperspace.App.world.starMap.currentLoc.loc.x,
                y = Hyperspace.App.world.starMap.currentLoc.loc.y
            }
        }
    }
    mods.FTLAP.proxy.writeEvent(payload)
end

local gameStarted = nil
local startEvents = {}
do
    local doc = RapidXML.xml_document("data/sector_data.xml")
    local root = doc:first_node("FTL") or doc
    local sectorNode = root:first_node("sectorDescription")
    while sectorNode do
        local startEventNode = sectorNode:first_node("startEvent")
        if startEventNode then startEvents[startEventNode:value()] = true end
        sectorNode = sectorNode:next_sibling("sectorDescription")
    end
    doc:clear()
end

for startEvent, _ in pairs(startEvents) do
    script.on_game_event(startEvent, false, on_sector_start)
end

script.on_internal_event(Defines.InternalEvents.GET_RUN_SEED, overrideGetRunSeed)

script.on_init(function(newGame) gameStarted = newGame end)

script.on_internal_event(Defines.InternalEvents.ON_TICK, function()
    if gameStarted ~= nil then
        on_sector_start()
        gameStarted = nil
    end
end)
