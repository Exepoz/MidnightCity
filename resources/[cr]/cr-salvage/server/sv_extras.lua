RegisterNetEvent('cr-salvage:server:WorldWreckSpawnEvent')
AddEventHandler('cr-salvage:server:WorldWreckSpawnEvent', function()
end)

-- This function is triggered when the World Wreck gets generated if the Config option for the specific scenation is set to true (onGenerationEvent)
function WorldWreckOnGenerationEventSV(wwType)
    print("Generation Event | "..wwType)
end

-- Loot Generation
function GenerateLoot(items)
    local total_prob = 0
    for _, item in ipairs(items) do
        total_prob = total_prob + item.probability
    end

    local total_weight = 0
    for _, item in ipairs(items) do
        item.weight = math.ceil(item.probability / total_prob * 100)
        total_weight = total_weight + item.weight
    end
    local nothing_prob = 1 - total_prob
    local nothing_weight = math.ceil(nothing_prob / total_prob * 100)
    total_weight = total_weight + nothing_weight

    local chosenLoot = math.random(total_weight)
    local chosenItem = 0
    for k, item in pairs(items) do
        chosenLoot = chosenLoot - item.weight
        if chosenLoot <= 0 then chosenItem = k break end
    end
    return chosenItem
end