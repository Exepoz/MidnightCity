-- -- server
-- local QBCore = exports['qb-core']:GetCoreObject()

-- RegisterServerEvent('qb-drugsystem:pickedUpCocaLeaf', function()
-- 	local src = source
-- 	local Player = QBCore.Functions.GetPlayer(src)

-- 	if Player.Functions.AddItem("coca_leaf", 1) then
-- 		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["coca_leaf"], "add")
-- 		TriggerClientEvent('QBCore:Notify', src, Lang:t("success.coca_leaf"), "success")
-- 	else
-- 		TriggerClientEvent('QBCore:Notify', src, Lang:t("error.no_coca_leaf"), "error")
-- 	end
-- end)


-- --config

-- Config.CircleZones = {

-- 	CokeField = {coords = vector3(2806.5, 4774.46, 46.98), name = ('Coke'), radius = 100.0},
-- }