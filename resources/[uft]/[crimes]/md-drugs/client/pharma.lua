local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand('prescriptionpad', function()
if QBCore.Functions.GetPlayerData().job.name == Config.PharmaJob then
   lib.registerContext({
   id = 'prescriptionpad',
   title = "Prescription Pad",
   options = {
        {
            title  = 'Give Vicodin',
            description  = 'Give Vicodin ',
            icon = 'fa-solid fa-file-prescription',
            event = 'md-drugs:client:givevicodinprescription',
        },
        {
            title  = 'Give Adderal',
            description  = 'Give Adderal ',
            icon = 'fa-solid fa-file-prescription',
            event = 'md-drugs:client:giveadderalprescription',
        },
		{
            title  = 'Give Morphine',
            description  = 'Give Morphine ',
            icon = 'fa-solid fa-file-prescription',
            event = 'md-drugs:client:givemorphineprescription',

        },
        {
            title  = 'Give Xanax',
            description  = 'Give Vicodin ',
            icon = 'fa-solid fa-file-prescription',
			event = 'md-drugs:client:givexanaxprescription',
        },
	}
    })
lib.showContext('prescriptionpad')
else
QBCore.Functions.Notify("Youre Not A Medical Person", "error")
end
end)


RegisterNetEvent("md-drugs:client:givevicodinprescription")
AddEventHandler("md-drugs:client:givevicodinprescription", function()
 exports["rpemotes"]:EmoteCommandStart("uncuff", 0)
    QBCore.Functions.Progressbar("drink_something", "Getting The Prescription Written", 4000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
        disableInventory = true,
    }, {}, {}, {}, function()-- Done
	    TriggerServerEvent("md-drugs:server:givevicodinprescription")
        ClearPedTasks(PlayerPedId())
    end)
end)
RegisterNetEvent("md-drugs:client:giveadderalprescription")
AddEventHandler("md-drugs:client:giveadderalprescription", function()
exports["rpemotes"]:EmoteCommandStart("uncuff", 0)
    QBCore.Functions.Progressbar("drink_something", "Getting The Prescription Written", 4000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
        disableInventory = true,
    }, {}, {}, {}, function()-- Done
	    TriggerServerEvent("md-drugs:server:giveadderalprescription")
        ClearPedTasks(PlayerPedId())
    end)
end)

RegisterNetEvent("md-drugs:client:givemorphineprescription")
AddEventHandler("md-drugs:client:givemorphineprescription", function()
exports["rpemotes"]:EmoteCommandStart("uncuff", 0)
    QBCore.Functions.Progressbar("drink_something", "Getting The Prescription Written", 4000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
        disableInventory = true,
    }, {}, {}, {}, function()-- Done
	    TriggerServerEvent("md-drugs:server:givemorphineprescription")
        ClearPedTasks(PlayerPedId())
    end)
end)
RegisterNetEvent("md-drugs:client:givexanaxprescription")
AddEventHandler("md-drugs:client:givexanaxprescription", function()
exports["rpemotes"]:EmoteCommandStart("uncuff", 0)
    QBCore.Functions.Progressbar("drink_something", "Getting The Prescription Written", 4000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
        disableInventory = true,
    }, {}, {}, {}, function()-- Done
	    TriggerServerEvent("md-drugs:server:givexanaxprescription")
        ClearPedTasks(PlayerPedId())
    end)
end)

RegisterNetEvent("md-drugs:client:fillprescription")
AddEventHandler("md-drugs:client:fillprescription", function()
exports["rpemotes"]:EmoteCommandStart("uncuff", 0)
    QBCore.Functions.Progressbar("drink_something", "Picking Up Your Prescription", 4000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
        disableInventory = true,
    }, {}, {}, {}, function()-- Done
	    TriggerServerEvent("md-drugs:server:fillprescription")
        ClearPedTasks(PlayerPedId())
    end)
end)

RegisterNetEvent("md-drugs:client:openingvicodin")
AddEventHandler("md-drugs:client:openingvicodin", function()
exports["rpemotes"]:EmoteCommandStart("uncuff", 0)
    QBCore.Functions.Progressbar("drink_something", "Opening Bottle", 4000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
        disableInventory = true,
    }, {}, {}, {}, function()-- Done
        ClearPedTasks(PlayerPedId())
    end)
end)


-- RegisterNetEvent('md-drugs:client:takepharma', function(itemName)
-- 	    QBCore.Functions.Progressbar("use_lsd", "Get Pain Relief!", 1750, false, true, {
--         disableMovement = false,
--         disableCarMovement = false,
-- 		disableMouse = false,
-- 		disableCombat = true,
--     }, {
-- 		animDict = "mp_suicide",
-- 		anim = "pill",
-- 		flags = 49,
--     }, {}, {}, function() -- Done
--         StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)

-- 		if itemName == "vicodin" then
-- 			TriggerEvent('debuffs:stopEffect', "debuff_pain")
--             TriggerEvent('evidence:client:SetStatus', 'widepupils', 300)
-- 		elseif itemName == "adderal" then
-- 			TriggerEvent('debuffs:stopEffect', "debuff_pain")
-- 		elseif itemName == "xanax" then
-- 			TriggerEvent('debuffs:stopEffect', "debuff_pain")
--         elseif itemName == 'morphine' then
--             TriggerEvent('debuffs:stopEffect', "debuff_pain")
--             TriggerEvent('evidence:client:SetStatus', 'widepupils', 300)
-- 		end
--     end, function() -- Cancel
--         StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
--         QBCore.Functions.Notify("Canceled", "error")
--     end)
-- end)
