local QBCore = exports['qb-core']:GetCoreObject()

Midnight.Functions = {
    --Debug = function(...) print('^5[DEBUG]^3 '.. ... .. "^7") end,

    Debug = function(...) local str = "" for k, v in ipairs({...}) do if k ~= 1 then str = str.." | " end str = str..tostring(v) end print('^5[DEBUG]^3 '.. str .. "^7") end,

    --- Checks if it's night time
    IsNightTime = function()
        local time = exports['qb-weathersync']:getTime()
        return (time < 6 or time >= 21)
    end,

    --- Gets the player's character's name
    ---@param src? number -- Player source
    ---@param firstOnly? boolean -- If the return is only the Player's First Name or Full Name.
    ---@return string -- Player's Character Name
    GetCharName = function(src, firstOnly)
        local argType = 'src'
        local cid
        if src > 1000 then argType = 'cid' cid = src end
        if argType == 'src' then cid = QBCore.Functions.GetPlayer(tonumber(src)).PlayerData.citizenid end
        local Player = QBCore.Functions.GetPlayerByCitizenId(tostring(cid))
        if not Player then return "Unknown Individual" end
        local charinfo = Player.PlayerData.charinfo
        local firstName = charinfo.firstname:sub(1,1):upper()..charinfo.firstname:sub(2)
        local lastName = charinfo.lastname:sub(1,1):upper()..charinfo.lastname:sub(2)
        local pName = firstName..(firstOnly and "" or " "..lastName)
        return pName
    end,

    GenerateLoot = function(items)
        local total_prob = 0
        for _, item in pairs(items) do
            total_prob = total_prob + item.probability
        end

        local total_weight = 0
        for _, item in pairs(items) do
            item.weight = math.ceil(item.probability / total_prob * 100)
            total_weight = total_weight + item.weight
        end

        local chosenLoot = math.random(total_weight)
        local chosenItem
        for k, item in pairs(items) do
            chosenLoot = chosenLoot - item.weight
            if chosenLoot <= 0 then chosenItem = k break end
        end

        return chosenItem
    end,

    pickRandom = function(tb)
        local keys = {}
        for k in pairs(tb) do table.insert(keys, k) end
        return keys[math.random(#keys)]
    end
}
