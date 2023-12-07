local QBCore = exports['qb-core']:GetCoreObject()

local onCooldown, CurrentPlayer, MethAmount, VehicleNetId
local runPurity = 0
GlobalState.RunInProgress = false

RegisterNetEvent('cr-methrun:server:callCops', function(info, coords, vehicle)
    TriggerClientEvent('cr-methrun:client:callCops', -1, info, coords, vehicle)
end)

RegisterNetEvent('cr-methrun:server:SendBlip', function(coords)
    TriggerClientEvent('cr-methrun:client:SendBlip', -1, coords)
end)

RegisterNetEvent('cr-methrun:server:getMethPackage', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem("outdoorfurniturecleaner", 1, false)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["outdoorfurniturecleaner"], "add")
end)

RegisterNetEvent('cr-methrun:server:RemoveMethPackage', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem("outdoorfurniturecleaner", amount, false)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["outdoorfurniturecleaner"], "remove", amount)
end)

RegisterNetEvent('cr-methrun:server:MethRunEnded', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Config.SellAllMeth then
        local MoneyReward = (MethAmount * math.random(Config.Reward.MoneyRewardPerBag.Min, Config.Reward.MoneyRewardPerBag.Max))
        local purMoney = 0.2*runPurity*MoneyReward
        MoneyReward = MoneyReward + purMoney
        Player.Functions.AddMoney(Config.Reward.MoneyType, MoneyReward)
    else
        Player.Functions.AddMoney(Config.Reward.MoneyType, Config.Reward.MoneyReward)
    end
    if Config.Reward.ItemReward then
        local luck = math.random(100)
        if luck <= Config.Reward.Chance then
            Player.Functions.AddItem(Config.Reward.Item, Config.Reward.Amount, false)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Reward.Item], "add", Config.Reward.Amount)
        end
    end
end)

RegisterNetEvent("cr-methrun:server:StartRun", function()
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local meth = xPlayer.Functions.GetItemsByName(Config.MethItem)
    if not meth[1] then MethRunNotify(3, Lcl("notif_MissingMeth"), Lcl("notif_MethRunTitle")) Player(src).state:set('textui', false, true) return end
    local am = 0
    local pur = 0
    for k, v in pairs(meth) do
        am = am + 1
        pur = pur + v.info.purity
        xPlayer.Functions.RemoveItem(Config.MethItem, 1, v.slot)
        if am >= 10 then break end
    end
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.MethItem], "remove", am)
    MethAmount = am
    runPurity = (pur / am)/100
    -- if meth.amount < Config.MethAmount then MethRunNotify(3, Lcl("notif_NotEnoughMeth"), Lcl("notif_MethRunTitle")) Player(src).state:set('textui', false, true) return end
    -- if Config.SellAllMeth then
    --     MethAmount = meth.amount
    --     xPlayer.Functions.RemoveItem(Config.MethItem, meth.amount, false)
    --     TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.MethItem], "remove", meth.amount)
    -- else
    --     xPlayer.Functions.RemoveItem(Config.MethItem, Config.MethAmount, false)
    --     TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.MethItem], "remove", Config.MethAmount)
    -- end
    MethRunNotify(1, Lcl("notif_GoodsGiven"), Lcl("notif_MethRunTitle"))
    TriggerClientEvent("cr-methrun:client:FindCar", src)
    CurrentPlayer = src
    GlobalState.RunInProgress = true
    Player(src).state:set('textui', false, true)
end)

AddEventHandler('onResourceStart', function(resource)
   if resource == GetCurrentResourceName() then
      Wait(100)
      if Config.ServerStartCooldown then
        print("Activating Server Start Cooldown...")
        TriggerEvent('cr-methrun:server:Cooldown')
      end
   end
end)

AddEventHandler('playerDropped', function(_)
    local src = source
    if src == CurrentPlayer then
        print("Player Dropped, Resetting Cooldown.")
        TriggerEvent('cr-methrun:server:Cooldown')
        TriggerClientEvent('cr-methrun:client:ResetRun', -1)
        CurrentPlayer = nil
    end
end)

RegisterNetEvent('cr-methrun:server:Cooldown', function()
    onCooldown = true
    print("Cooldown Set for "..Config.Cooldown.." minutes")
    Wait((Config.Cooldown * 1000) * 60)
    GlobalState.RunInProgress = false
    onCooldown = false
end)

QBCore.Functions.CreateCallback("cr-methrun:server:CooldownCheck",function(_, cb)
    if onCooldown or GlobalState.RunInProgress then cb(true)
    else cb(false) end
end)

RegisterNetEvent('cr-methrun:server:MethRunVehicle', function(id)
    VehicleNetId = id
end)

RegisterServerEvent('baseevents:enteredVehicle')
AddEventHandler('baseevents:enteredVehicle', function(_, _, _, netId)
    if netId == VehicleNetId and source == CurrentPlayer then TriggerClientEvent('cr-methrun:client:isInVehicle', source) VehicleNetId = nil end
end)