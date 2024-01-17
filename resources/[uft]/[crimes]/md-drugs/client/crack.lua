local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("md-drugs:client:makecrackone")
AddEventHandler("md-drugs:client:makecrackone", function() 
	exports["rpemotes"]:EmoteCommandStart("uncuff", 0)
    QBCore.Functions.Progressbar("drink_something", "Cooking Crack", 1000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
        disableInventory = true,
    }, {}, {}, {}, function()-- Done
        local success = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 1 }, 'medium'}, {'1', '2', '3', '4'})
    if success then
        TriggerServerEvent("md-drugs:server:makecrackone")       
        ClearPedTasks(PlayerPedId())
	else
		TriggerServerEvent("md-drugs:server:failcrackone")
        ClearPedTasks(PlayerPedId())
	end
end)
end)


RegisterNetEvent("md-drugs:client:bagcrack")
AddEventHandler("md-drugs:client:bagcrack", function() 
	exports["rpemotes"]:EmoteCommandStart("uncuff", 0)
    QBCore.Functions.Progressbar("drink_something", "bagging some good good", 4000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
        disableInventory = true,
    }, {}, {}, {}, function()-- Done
	    TriggerServerEvent("md-drugs:server:bagcrack")
        ClearPedTasks(PlayerPedId())
    end)
end)

