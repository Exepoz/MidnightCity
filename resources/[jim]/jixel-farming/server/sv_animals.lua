
local collected = false
--[[
             _   _   _____   __  __              _
     /\     | \ | | |_   _| |  \/  |     /\     | |
    /  \    |  \| |   | |   | \  / |    /  \    | |
   / /\ \   | . ` |   | |   | |\/| |   / /\ \   | |
  / ____ \  | |\  |  _| |_  | |  | |  / ____ \  | |____
 /_/____\_\_|_| \_|_|_____|_|_|_ |_| /_/____\_\ |______|
 |  ____| \ \    / / |  ____| | \ | | |__   __|  / ____|
 | |__     \ \  / /  | |__    |  \| |    | |    | (___
 |  __|     \ \/ /   |  __|   | . ` |    | |     \___ \
 | |____     \  /    | |____  | |\  |    | |     ____) |
 |______|     \/     |______| |_| \_|    |_|    |_____/
--]]


RegisterServerEvent("jixel-farming:KillAnimal", function(animalType, rep, takeItem)
    local amount = 0
    local item = nil
    local repAmount = 0
    rep = rep or false
    if animalType == "cows" then
        amount = AnimalSettings.Cows.Setup.MeatAmount()
        item = "rawbeef"
        repAmount = AnimalSettings.Cows.Setup.KillRepAmount
    elseif animalType == "pigs" then
        amount = AnimalSettings.Pigs.Setup.MeatAmount()
        item = "rawpork"
        repAmount = AnimalSettings.Pigs.Setup.KillRepAmount
    elseif animalType == "chickens" then
        amount = 1
        item = "deadchicken"
        repAmount = AnimalSettings.Chickens.Setup.KillRepAmount
	else return end
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.AddItem(item, amount) then
        if takeItem then TriggerEvent("jixel-farming:server:toggleItem", false, takeItem, 1, src) end
		TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[item], "add", amount)
		if Config.ScriptOptions.FarmingRep and rep then
            Player.Functions.SetMetaData("farmingrep", (Player.PlayerData.metadata["farmingrep"] or 0) + repAmount)
			if Config.ScriptOptions.FarmingRepNotifications then
				triggerNotify(nil, "You Received "..repAmount.." Rep", "success", src)
			end
		end
        if AnimalSettings.KnifeBreak then
            if math.random(1, 100) <= AnimalSettings.KnifeBreakChance then
                Player.Functions.RemoveItem("weapon_knife", 1)
                TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["weapon_knife"], "remove", 1)
                triggerNotify(nil, Loc[Config.CoreOptions.Lan].notification["broke"], "primary", src)
            end
        end
        triggerNotify(nil, string.format("%s%s(%s)",Loc[Config.CoreOptions.Lan].success["kill_success"], QBCore.Shared.Items[item].label, amount), "success", src)
        killed = killed and true
    else
        triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["full"], "error", src)
        killed = killed and false
    end
end)


RegisterServerEvent("jixel-farming:server:getcowbucket", function(amount)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player.Functions.AddItem("emptymilkbucket", amount) then
		TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["emptymilkbucket"], "add", amount)
		triggerNotify(nil, Loc[Config.CoreOptions.Lan].success["bucket"], "success", src)
	else
		triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["full"], "error", src)
	end
end)

RegisterServerEvent("jixel-farming:server:MilkCow", function()
    local amount = 1
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local milkrep = AnimalSettings.Cows.Setup.MilkRepAmount
    if Player.Functions.RemoveItem("emptymilkbucket", amount) then
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["emptymilkbucket"], "remove", amount)
        Wait(1000)
    if Player.Functions.AddItem("milkbucket", amount) then
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["milkbucket"], "add", amount)
        if Config.ScriptOptions.FarmingRep then
        Player.Functions.SetMetaData("farmingrep",  Player.PlayerData.metadata["farmingrep"] + milkrep)
            if Config.ScriptOptions.FarmingRepNotifications then
                triggerNotify(nil, "You Received "..json.encode(milkrep).." Rep", "success", src)
            end
        end
        triggerNotify(nil, "Gathered A Bucket of Milk", "success", src)
        collected = collected and true
    else
        Player.Functions.AddItem("emptymilkbucket", amount)
        triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["full"], "error", src)
        collected = collected and false
        end
    end
end)

RegisterServerEvent("jixel-farming:CollectEggs", function()
	local amount = AnimalSettings.Chickens.Setup.EggReward()
    local eggrep = AnimalSettings.Chickens.Setup.EggCollectRepAmount
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	if Player.Functions.AddItem("egg", amount) then
      TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["egg"], "add", amount)
	  triggerNotify(nil, Loc[Config.CoreOptions.Lan].success["gathered"]..amount.." Eggs.", "success", src)
	  if Config.ScriptOptions.FarmingRep then
	  	Player.Functions.SetMetaData("farmingrep",  Player.PlayerData.metadata["farmingrep"] + eggrep)
			if Config.ScriptOptions.FarmingRepNotifications then
				triggerNotify(nil, "You Received "..json.encode(eggrep).." Rep", "success", src)
			end
		end
	  collected = collected and true
	else
		triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["full"], "error", src)
		collected = collected and false
	end
end)

RegisterServerEvent("jixel-farming:DeFeatherChicken", function()
	local amount = 1
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem("deadchicken", amount) then
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["deadchicken"], "remove", amount) if Config.DebugOptions.Debug then print("^5Debug^7: ^1Removing ^2from Player^7(^2"..src.."^7) '^6"..QBCore.Shared.Items[item].label.."^7(^2x^6"..(amount or "1").."^7)'") end
        Wait(1000)
    if Player.Functions.AddItem("rawchicken", amount) then
            TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["rawchicken"], "add", amount)
	else
		triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["full"], "error", src)
		Player.Functions.AddItem("deadchicken", amount)
		end
	end
end)


