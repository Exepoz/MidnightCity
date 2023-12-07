local QBCore = exports['qb-core']:GetCoreObject()

local Cooldown = false
local checkpackage = true
local packagerecieved = false
players = {}
entities = {}

-- Starting Conditions

RegisterServerEvent('sd-weedrun:server:startr', function()
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	if Player.PlayerData.money['cash'] >= Config.RunCost then
		Player.Functions.RemoveMoney('cash', Config.RunCost)
		TriggerClientEvent('sd-weedrun:client:generateloc', src)
		TriggerClientEvent('sd-weedrun:client:signoff', src)
		TriggerClientEvent('sd-weedrun:client:email', src)
		TriggerClientEvent('QBCore:Notify', src, Lang:t("error.no_refund"), 'error')
		if Config.EnableCooldown then
        TriggerEvent('sd-weedrun:server:coolout')
		end
	else
		TriggerClientEvent('QBCore:Notify', source, Lang:t("error.you_dont_have_enough_money"), 'error')
	end
end)

QBCore.Functions.CreateCallback('sd-weedrun:server:haspackage', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	local hasPackage = Player.Functions.GetItemByName(Config.Item)
 
	if hasPackage ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
		math.randomseed(os.time())
        local WeedBossLocation = math.random(#Config.BossLocation)
        GlobalState.WeedBossLocation = Config.BossLocation[WeedBossLocation]
		-- print(WeedBossLocation, GlobalState.WeedBossLocation)
    end
end)

-- Cooldown

RegisterServerEvent('sd-weedrun:server:coolout', function()
    Cooldown = true
    local timer = Config.Cooldown * 1000
    while timer > 0 do
        Wait(1000)
        timer = timer - 1000
        if timer == 0 then
			TriggerClientEvent('sd-weedrun:signin', -1)
            Cooldown = false

        end
    end
end)

RegisterServerEvent('sd-weedrun:server:signoff', function()
	Cooldown = false
end)

QBCore.Functions.CreateCallback("sd-weedrun:server:coolc",function(source, cb)
    if Cooldown then
        cb(true)
    else
        cb(false) 
    end
end)

-- Weed Run Packaging

RegisterNetEvent('sd-weedrun:server:processWeed', function(item, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local weedItem = Player.Functions.GetItemByName(item)
    local weedAmount = amount

	Player.Functions.RemoveItem(weedItem.name, weedAmount)
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[weedItem.name], "remove")

	Wait(15000) --15 sn
	TriggerClientEvent('now-can-collect-package', src)
end)

-- Packaging Reward

RegisterServerEvent("sd-weedrun:server:packagereward", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not packagerecieved then
        packagerecieved = false

        Player.Functions.AddItem(Config.Item, 1, false)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Item], 'add')
		TriggerClientEvent('QBCore:Notify', src, Lang:t("success.there_u_go"), 'success')

		TriggerClientEvent('sd-weedrun:client:removetarget', src)

    else
        TriggerClientEvent('QBCore:Notify', src, "Error!", "error", 2500)
    end
end)	

-- Weed Run Reward

RegisterServerEvent('remove-package', function()
	local ply = QBCore.Functions.GetPlayer(source)
	ply.Functions.RemoveItem(Config.Item, 1)
	TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.Item], "remove", 1)
end)

RegisterServerEvent('package-delivered', function(coords_i)
	local Player = QBCore.Functions.GetPlayer(source)
	local ply = QBCore.Functions.GetPlayer(source)
	local hasBags = Player.Functions.GetItemByName("markedbills")
	local hasBands = Player.Functions.GetItemByName("bands")
	local hasRolls = Player.Functions.GetItemByName("rolls")
	local itemCount = math.random(Config.MinSpecialReward, Config.MaxSpecialReward)

	local chance = math.random(0,100)
	local rareitemchance = math.random(0,100)

	TriggerEvent('sd-weedrun:server:setLocationAvailable', coords_i, true)

	ply.Functions.AddMoney('cash', math.random(Config.MinReward, Config.MaxReward))

	TriggerClientEvent('sd-weedrun:client:itemcheck', source)

	if rareitemchance <= Config.SpecialRewardChance then
		Player.Functions.AddItem(Config.SpecialItem, itemCount)
		TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.SpecialItem], "add", itemCount)
	end

			if Config.CleanMoney then

				if chance < Config.BagChance then
					if hasBags then
						worth = Player.Functions.GetItemByName('markedbills').info.worth
						if Config.Amount == 'random' then
						bagAmount = math.random(Player.Functions.GetItemByName("markedbills").amount)
						elseif Config.Amount == 'one' then
						bagAmount = 1
						end
	
						Player.Functions.AddMoney('cash', bagAmount*worth)
						Player.Functions.RemoveItem("markedbills", bagAmount)
						TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["markedbills"], "remove", bagAmount)
					end
				end
	
				if chance < Config.BandChance then
					if hasBands then
						if Config.Amount == 'random' then
						bandAmount = math.random(Player.Functions.GetItemByName("bands").amount)
						elseif Config.Amount == 'one' then
						bandAmount = 1
						end
	
						Player.Functions.AddMoney('cash', bandAmount*math.random(Config.BandMinPayout, Config.BandMaxPayout))
						Player.Functions.RemoveItem("bands", bandAmount)
						TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["bands"], "remove", bandAmount)
					end
				end
	
				if chance < Config.RollChance then
					if hasRolls then
						if Config.Amount == 'random' then
						 rollAmount = math.random(Player.Functions.GetItemByName("rolls").amount)
						elseif Config.Amount == 'one' then 
						rollAmount = 1
						end
	
						Player.Functions.AddMoney('cash', rollAmount*math.random(Config.RollMinPayout, Config.RollMaxPayout))
						Player.Functions.RemoveItem("rolls", rollAmount)
						TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["rolls"], "remove", rollAmount)
					end
				end
			end

	TriggerClientEvent('sd-weedrun:client:nextdelivery', source)

end)


-- Minimum Cop Callback

QBCore.Functions.CreateCallback('sd-weedrun:server:getCops', function(source, cb)
    local amount = 0
    local players = QBCore.Functions.GetQBPlayers()
    for _, Player in pairs(players) do
        if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    cb(amount)
end)


AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
		return
	end
	for i=1, 1000 do
		if GetPlayerPed(i) ~= 0 then
			players[i] = {}
		end
	end
end)

QBCore.Functions.CreateUseableItem(Config.Item, function(source)
	TriggerClientEvent('sd-weedrun:client:haspackage', source) 
end) 

RegisterNetEvent('sd-weedrun:server:setLocationAvailable', function(loc, available)
	Config.handoffPeds[loc].available = available
	TriggerClientEvent('sd-weedrun:client:setLocationAvailable', -1, loc, available)
end)
