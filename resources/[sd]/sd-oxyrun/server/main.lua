if not (GetResourceState('sd_lib') == 'started') then
    print("^1Error: sd_lib isn't installed or this resource has been started before sd_lib.")
end

local SD = exports['sd_lib']:getLib()

SD.VersionCheck() -- Version Check

local Cooldown = false

-- Event to set change a routes 'occupied' status
RegisterNetEvent('sd-oxyrun:server:SetRouteOccupied')
AddEventHandler('sd-oxyrun:server:SetRouteOccupied', function(route, toggle)
    if Config.Routes[route] and Config.Routes[route].info then
        Config.Routes[route].info.occupied = toggle
        TriggerClientEvent('sd-oxyrun:client:SetRouteOccupied', -1, route, toggle)
    end
end)

-- Event to set the OxyBoss location when resource starts
AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
		math.randomseed(os.time())
        GlobalState.OxyBossLocation = Config.BossLocation[math.random(#Config.BossLocation)]
    end
end)

-- Event to start the run
RegisterServerEvent('sd-oxyrun:server:startr', function()
	local src = source
	local hasMoney = SD.GetPlayerAccountFunds(src, 'money', Config.RunCost)

	if hasMoney >= Config.RunCost then
		TriggerClientEvent("sd-oxyrun:client:sendToOxy", src)
	else
		TriggerClientEvent('sd_bridge:notification', src, Lang:t('error.you_dont_have_enough_money'), 'error')
	end
end)

-- Event to take money from the player and if enabled, trigger the Cooldown
RegisterServerEvent('sd-oxyrun:server:TakeMoney')
AddEventHandler('sd-oxyrun:server:TakeMoney', function()
	SD.RemoveMoney(source, 'cash', Config.RunCost)

    if Config.Cooldown.EnableGlobalCooldown then
        TriggerEvent('sd-oxyrun:server:coolout')
    end
end)

-- Event to implement cooldown
RegisterServerEvent('sd-oxyrun:server:coolout')
AddEventHandler('sd-oxyrun:server:coolout', function()
    Cooldown = true
    local timer = Config.Cooldown.GlobalCooldown * 60000

    print(Lang:t('prints.global_cooldown_started'))

    while timer > 0 do
        Wait(1000)
        timer = timer - 1
        if timer == 0 then
            print(Lang:t('prints.global_cooldown_finished'))
            Cooldown = false
        end
    end
end)

-- Callback to check the cooldown status
SD.RegisterCallback("sd-oxyrun:server:coolc", function(source, cb)
    cb(Cooldown)
end)

-- Callback to count the number of cops
SD.RegisterCallback('sd-oxyrun:server:getCops', function(source, cb)
    local players = GetPlayers()
    local amount = 0
    for i=1, #players do
        local player = tonumber(players[i])
        if SD.HasGroup(player, SD.PoliceJobs) then
            amount = amount + 1
        end
    end
    cb(amount)
end)

-- Callback to check if the player has the required item
SD.RegisterCallback('sd-oxyrun:server:hasItem', function(source, cb)
    if SD.HasItem(source, Config.Items.Requirement) > 0 then
        cb(true)
    else
        cb(false)
    end
end)

-- Event to send the car
RegisterNetEvent("sd-oxyrun:server:sendCar")
AddEventHandler("sd-oxyrun:server:sendCar", function(Routes)
	TriggerClientEvent("sd-oxyrun:createOxyVehicle", source, Routes)
end)

-- Event to process package delivery and rewards
RegisterNetEvent("sd-oxyrun:server:deliver")
AddEventHandler("sd-oxyrun:server:deliver", function(doingOxy, holdingBox)
    local source = source
    local Player = SD.GetPlayer(source)
    if doingOxy and holdingBox and SD.HasItem(source, Config.Items.Package) > 0 then
        if Config.GiveItem then
            local rareitemchance = math.random(1, 100)
            local itemCount = math.random(Config.MinItemReward, Config.MaxItemReward)
            local itemCount2 = math.random(Config.MinSpecialReward, Config.MaxSpecialReward)
            SD.AddItem(source, Config.ItemReward, itemCount)
            if Config.EnableRareItem and rareitemchance <= Config.SpecialRewardChance then
                local itemIndex = math.random(1, #Config.SpecialItem)
                SD.AddItem(source, Config.SpecialItem[itemIndex], itemCount2)
            end
        end

        -- Handle dirty money cleaning
        if Config.MoneyWashing.CleanMoney then
            local chance = math.random(0, 100)
            
            local BillsCount = SD.HasItem(source, 'markedbills')
            local BandsCount = SD.HasItem(source, 'bands')
            local RollsCount = SD.HasItem(source, 'rolls')
            -- Handle 1-1 washing if enabled and player has enough
            if Config.MoneyWashing.WashItem.Enable then
                local itemAmount = SD.HasItem(source, Config.MoneyWashing.WashItem.ItemName)
                if itemAmount >= Config.MoneyWashing.WashItem.MinAmount then
                local upperBound = math.min(itemAmount, Config.MoneyWashing.WashItem.MaxAmount)
                local amountToWash = math.random(Config.MoneyWashing.WashItem.MinAmount, upperBound)
                
                local moneyToAdd = amountToWash
                if Config.MoneyWashing.Tax.Enable then
                    moneyToAdd = moneyToAdd - (moneyToAdd * (Config.MoneyWashing.Tax.Percentage / 100))
                    moneyToAdd = math.floor(moneyToAdd + 0.5)
                end
                
                SD.AddMoney(source, 'cash', moneyToAdd)
                SD.RemoveItem(source, Config.MoneyWashing.WashItem.ItemName, amountToWash)
            end
        else
            -- Washing logic for Bags, Bands, and Rolls
            local rewards = {
                {name = 'markedbills', chance = Config.MoneyWashing.Bills.Chance, payoutMin = Config.MoneyWashing.Bills.MinPayout, payoutMax = Config.MoneyWashing.Bills.MaxPayout, amount = BillsCount},
                {name = 'bands', chance = Config.MoneyWashing.Bands.Chance, payoutMin = Config.MoneyWashing.Bands.MinPayout, payoutMax = Config.MoneyWashing.Bands.MaxPayout, amount = BandsCount},
                {name = 'rolls', chance = Config.MoneyWashing.Rolls.Chance, payoutMin = Config.MoneyWashing.Rolls.MinPayout, payoutMax = Config.MoneyWashing.Rolls.MaxPayout, amount = RollsCount}
            }

            for _, reward in ipairs(rewards) do
                if chance < reward.chance and SD.HasItem(source, reward.name) > 0 then
                    local amount = Config.MoneyWashing.AmountType == 'random' and math.random(reward.amount) or 1
                    if amount > Config.MoneyWashing.MaxAmount then
                        amount = Config.MoneyWashing.MaxAmount
                    end

                    local moneyToAdd = 0
                    if reward.name == 'markedbills' then
                        if SD.Framework == 'qb' then
                            local worth = Player.Functions.GetItemByName('markedbills').info.worth
                            if worth then moneyToAdd = amount * worth else moneyToAdd = amount * math.random(reward.payoutMin, reward.payoutMax) end
                        elseif SD.Framework == 'esx' then
                            local black_money_player = Player.getAccount('black_money').money
                            if black_money_player > 0 then
                                if black_money_player > Config.MoneyWashing.MaxAmount then black_money_player = Config.MoneyWashing.MaxAmount end
                                Player.removeAccountMoney('black_money', black_money_player)
                                moneyToAdd = black_money_player
                            end
                        end
                    elseif reward.name == 'bands' then
                        moneyToAdd = amount * math.random(reward.payoutMin, reward.payoutMax)
                    elseif reward.name == 'rolls' then
                        moneyToAdd = amount * math.random(reward.payoutMin, reward.payoutMax)
                    end

                    if Config.MoneyWashing.Tax.Enable then
                        moneyToAdd = moneyToAdd - (moneyToAdd * (Config.MoneyWashing.Tax.Percentage / 100))
                        moneyToAdd = math.floor(moneyToAdd + 0.5)
                    end

                    SD.AddMoney(source, 'cash', moneyToAdd)
                    SD.RemoveItem(source, reward.name, amount)
                    break
                end
            end
          end
        end
        SD.RemoveItem(source, Config.Items.Package, 1)
    end
end)

RegisterNetEvent('sd-oxyrun:server:addItem')
AddEventHandler('sd-oxyrun:server:addItem', function(SupplierPosition, isOnRun)
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    local distanceThreshold = 5.0 -- Distance threshold in meters

    if isOnRun then
        if SupplierPosition then
            local supplierDistance = #(playerCoords - vector3(SupplierPosition.x, SupplierPosition.y, SupplierPosition.z))

            if supplierDistance <= distanceThreshold then
                SD.AddItem(source, Config.Items.Package, 1)
            end
        end
    end
end)