--- Event Handlers

if Config.Inventory == 'ox_inventory' then
    AddEventHandler('onServerResourceStart', function(resourceName)
        if resourceName == 'ox_inventory' or resourceName == Config.Resource then
            -- Armory
            exports['ox_inventory']:RegisterShop('jailarmory', {
                name = Locales['stash_armory'],
                inventory = {
                    { name = 'weapon_stungun', price = 250 },
                    { name = 'weapon_nightstick', price = 0 },
                    { name = 'weapon_flashlight', price = 75 },
                    { name = 'handcuffs', price = 25 },
                    { name = 'radio', price = 34 },
                    { name = 'bandage', price = 25 },
                },
                groups = {
                    police = 0,
                    lspd = 0,
                    bcso = 0,
                    sapr = 0,
                    sast = 0,
                },
            })
            
        end

    end)
end

--- Commands

lib.addCommand('increasesentence', {
    help = Locales['command_increase_help'],
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = Locales['command_increase_arg1_help'],
            optional = false
        },
        {
            name = 'amount',
            type = 'number',
            help = Locales['command_increase_arg2_help'],
            optional = false
        }
    },
}, function(source, args, raw)
    local Player = QBCore.Functions.GetPlayer(source)
    local OtherPlayer = QBCore.Functions.GetPlayer(args.target)
    local amount = args.amount

    if Player and OtherPlayer and amount and Utils.PlayerIsLeo(Player.PlayerData.job) then
        if increasePlayerJailSentence(args.target, amount) then
            Utils.Notify(source, Locales['notify_success_increase'], 'success', 2500)
            Utils.CreateLog(Player.PlayerData.name, 'Increase Sentence', 'Increased Sentence', Player.PlayerData.name .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')' .. ' increased jail sentence of ' .. OtherPlayer.PlayerData.name .. ' with ' .. amount)
        else
            Utils.Notify(source, Locales['notify_fail_increase'], 'error', 2500)
        end
    else
        Utils.Notify(source, Locales['notify_for_police'], 'error', 2500)
    end
end)

lib.addCommand('reducesentence', {
    help = 'Reduce Player Sentence',
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = Locales['command_increase_arg1_help'],
            optional = false
        },
        {
            name = 'amount',
            type = 'number',
            help = Locales['command_increase_arg2_help'],
            optional = false
        }
    },
}, function(source, args, raw)
    local Player = QBCore.Functions.GetPlayer(source)
    local OtherPlayer = QBCore.Functions.GetPlayer(args.target)
    local amount = args.amount

    if Player and OtherPlayer and amount and Utils.PlayerIsLeo(Player.PlayerData.job) then
        if reducePlayerJailSentence(args.target, amount) then
            Utils.Notify(source, Locales['notify_success_reduce'], 'success', 2500)
            Utils.CreateLog(Player.PlayerData.name, 'Reduce Sentence', 'Reduce Sentence', Player.PlayerData.name .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')' .. ' reduced jail sentence of ' .. OtherPlayer.PlayerData.name .. ' with ' .. amount)
        else
            Utils.Notify(source, Locales['notify_fail_reduce'], 'error', 2500)
        end
    else
        Utils.Notify(source, Locales['notify_for_police'], 'error', 2500)
    end
end)
