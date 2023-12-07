SD = SD or {}
SD.utils = SD.utils or {}

-- Weighted probability function
SD.utils.WeightedChance = function(tbl)
    local total = 0
    for k, reward in pairs(tbl) do
        total = total + reward.chance
    end

    local rand = math.random() * total
    for k, reward in pairs(tbl) do
        rand = rand - reward.chance
        if rand <= 0 then
            return k
        end
    end
end

-- Check if a Value exists in a passed table
SD.utils.Contains = function(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

-- Removed a passed value from a passed table
SD.utils.RemoveValue = function(table, value)
    for k, v in pairs(table) do
        if v == value then
            table[k] = nil
            break
        end
    end
end

-- Get the index of a value in a table
SD.utils.indexOf = function(t, object)
    if type(t) == 'table' then
        for i, value in ipairs(t) do
            if object == value then
                return i
            end
        end
    end
    return nil
end
