
local PaidDeposit = {}

QBCore.Functions.CreateCallback("jixel-farming:TractorRent", function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cashamount = Player.PlayerData.money["cash"]
    local bankamount = Player.PlayerData.money["bank"]
    if Config.DebugOptions.Debug then print("Cash amount:", cashamount) end-- Debug print for cash amount
    print("Bank amount:", bankamount) -- Debug print for bank amount
    if cashamount >= WheatZone.TractorOptions.TractorRent then
        Player.Functions.RemoveMoney('cash', WheatZone.TractorOptions.TractorRent, "Rented a Tractor")
        triggerNotify(nil, Loc[Config.CoreOptions.Lan].success["rentedcash"], 'success', src)
        cb(true)
		if Config.DebugOptions.Debug then print("Deposit paid:", true) end -- Debug print for deposit paid
		PaidDeposit[source] = true
    elseif bankamount >= WheatZone.TractorOptions.TractorRent then
        Player.Functions.RemoveMoney('bank', WheatZone.TractorOptions.TractorRent,"Rented a Tractor")
        triggerNotify(nil, Loc[Config.CoreOptions.Lan].success["rentedbank"], 'success', src)
        cb(true)
		if Config.DebugOptions.Debug then print("Deposit paid:", true) end -- Debug print for deposit paid
		PaidDeposit[source] = true
    else
        triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["nomoney"], "error", src)
        cb(false)
		if Config.DebugOptions.Debug then print("Deposit paid:", false) end -- Debug print for deposit not paid
    end
end)

RegisterServerEvent("jixel-farming:TractorMoneyReturn", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if PaidDeposit[source] then
        Player.Functions.AddMoney('cash', WheatZone.TractorOptions.TractorRent, "Returned Tractor")
        triggerNotify(nil, Loc[Config.CoreOptions.Lan].success["depositreturned"], 'success', src)
       table.remove(PaidDeposit, src)
    else
        triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["notractor"], 'error', src)
    end
end)


RegisterServerEvent("jixel-farming:server:pickWheat", function()
	local amount = 1
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player.Functions.AddItem("wheat", amount, false, {organic = true}) then
		TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["wheat"], "add", 1)
		if Config.ScriptOptions.FarmingRep then
		Player.Functions.SetMetaData("farmingrep",  Player.PlayerData.metadata["farmingrep"] + WheatZone.RepAmount)
			if Config.ScriptOptions.FarmingRepNotifications then
				triggerNotify(nil, "You Received "..json.encode(WheatZone.RepAmount).." Rep", "success", src)
			end
		end
		picked = picked and true
	else
		triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["full"], "error", src)
		picked = picked and false
	end
end)

