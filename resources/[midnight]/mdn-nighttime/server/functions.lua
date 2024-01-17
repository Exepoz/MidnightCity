Midnight.Functions = {
    Debug = function(...) print('^5[DEBUG]^3 '.. ...) end,

    IsNightTime = function()
        local time = exports['qb-weathersync']:getTime()
        return (time < 6 or time >= 21)
    end,
}
