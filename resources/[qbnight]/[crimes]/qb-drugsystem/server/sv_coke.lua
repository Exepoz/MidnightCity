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
