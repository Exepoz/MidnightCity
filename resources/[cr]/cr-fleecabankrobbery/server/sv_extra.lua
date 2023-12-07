--- Random Loot Generation (Based on weight/importance)
function GenerateLoot(lootType)
    local items = Config.Rewards[lootType].Loot
    local total_weight = 0
    for _, item in ipairs(items) do
        total_weight = total_weight + item.weight
    end
    local chosenLoot = math.random(total_weight)
    local chosenItem
    for k, item in ipairs(items) do
        chosenLoot = chosenLoot - item.weight
        if chosenLoot <= 0 then chosenItem = k break end
    end
    return chosenItem
end