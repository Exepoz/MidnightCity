local QBCore = exports['qb-core']:GetCoreObject()

--|~===================|--
--|~ Money Laundering ~|--
--|~===================|--

local m = {}
for k, v in ipairs(Config.Machines) do
	local machine = lib.points.new(v.coords, 1.2)
	function machine:onEnter()
		m[k] = GetClosestObjectOfType(v.coords.x, v.coords.y, v.coords.z, 1.0, 'bkr_prop_prtmachine_dryer_spin', true, false, false)
		SetEntityDrawOutlineColor(16, 218, 232, 255)
		SetEntityDrawOutline(m[k], true)
		lib.showTextUI('[E] Check Machine')
	end
	function machine:onExit()
		SetEntityDrawOutline(m[k], false)
		if self.isClosest then lib.hideTextUI() end
	end
	function machine:nearby() if IsControlJustReleased(0, 38) then if not self.isClosest then return end TriggerEvent('rsg_moneywash:client:CheckMachine', k) end
	end
end

RegisterNetEvent('rsg_moneywash:client:CheckMachine', function(machine)
	local progress = 0
	QBCore.Functions.TriggerCallback('rsg_moneywash:server:GetTime', function(time)
		if GlobalState.WashingMachines[machine].startTime ~= 0 then
			local timeRemaining = GlobalState.WashingMachines[machine].startTime+3600 - time --3600
			if timeRemaining > 0 then progress = math.ceil(100 - ((timeRemaining / 3600) * 100)) else progress = 100 end
		end
		lib.registerContext({
			id = 'washingMachine'..machine, title = 'Washing Machine', canClose = true, options = {
				{title = 'Current Wash', description = 'Progress : '.. progress .. ' | Money in Machine : '..GlobalState.WashingMachines[machine].worth, progress = progress, disabled = true},
				{title = 'Take Money', disabled = progress < 100, onSelect = function() TriggerServerEvent('rsg_moneywash:server:TakeMoney', machine) end},
				{title = 'Deposit Money', disabled = progress ~= 0, onSelect = function() TriggerServerEvent('rsg_moneywash:server:DepositMoney', machine) end},
			}
		}) lib.showContext('washingMachine'..machine)
	end)
end)

Citizen.CreateThread(function()
    -- Getting the object to interact with
    BikerCounterfeit = exports['bob74_ipl']:GetBikerCounterfeitObject()

    -- Loading Ipls
    BikerCounterfeit.Ipl.Interior.Load()

    -- Setting the printers
	BikerCounterfeit.Printer.Set(BikerCounterfeit.Printer.none)

    -- Setting the security
    BikerCounterfeit.Security.Set(BikerCounterfeit.Security.basic)

    -- Setting the dryers
    BikerCounterfeit.Dryer1.Set(BikerCounterfeit.Dryer1.on)
    BikerCounterfeit.Dryer2.Set(BikerCounterfeit.Dryer2.on)
    BikerCounterfeit.Dryer3.Set(BikerCounterfeit.Dryer3.on)
    BikerCounterfeit.Dryer4.Set(BikerCounterfeit.Dryer4.on)

    -- Enabling details
    BikerCounterfeit.Details.Enable(BikerCounterfeit.Details.chairs)
    BikerCounterfeit.Details.Enable(BikerCounterfeit.Details.furnitures)
	BikerCounterfeit.Details.Enable(BikerCounterfeit.Details.cutter, false)
	BikerCounterfeit.Details.Enable(BikerCounterfeit.Details.Cash10.A, false)
	BikerCounterfeit.Details.Enable(BikerCounterfeit.Details.Cash10.B, false)
	BikerCounterfeit.Details.Enable(BikerCounterfeit.Details.Cash10.C, false)
	BikerCounterfeit.Details.Enable(BikerCounterfeit.Details.Cash10.D, false)
	BikerCounterfeit.Details.Enable(BikerCounterfeit.Details.Cash20.A, false)
	BikerCounterfeit.Details.Enable(BikerCounterfeit.Details.Cash20.A, false)
	BikerCounterfeit.Details.Enable(BikerCounterfeit.Details.Cash20.A, false)
	BikerCounterfeit.Details.Enable(BikerCounterfeit.Details.Cash20.A, false)
	BikerCounterfeit.Details.Enable(BikerCounterfeit.Details.Cash100.A, false)
	BikerCounterfeit.Details.Enable(BikerCounterfeit.Details.Cash100.B, false)
	BikerCounterfeit.Details.Enable(BikerCounterfeit.Details.Cash100.C, false)
	BikerCounterfeit.Details.Enable(BikerCounterfeit.Details.Cash100.D, false)

    -- Refreshing the interior to the see the result
    RefreshInterior(BikerCounterfeit.interiorId)
end)

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(7)
    end
end




-- money wash outside (enter)
Citizen.CreateThread(function()
	exports['qb-target']:AddBoxZone("wash-access", vector3(vector3(-3163.07, 1103.49, 24.36)), 1, 1, {
		name = "wash-access",
		heading = 247.16,
		debugPoly = false,
		minZ= 22.29,
		maxZ= 26.89,
	}, {
		options = {
			{
				type = "client",
				event = "rsg_moneywash:client:client:washenterance",
				icon = "fas fa-donate",
				label = "Enter Wash",
			},
		},
		distance = 2.5
	})

	exports['qb-target']:AddBoxZone("wash-exit", vector3(1138.21, -3199.14, -39.67), 1, 1, {
		name = "wash-exit",
		heading = 176.72,
		debugPoly = false,
		minZ=-41.4,
		maxZ=-37.4
	}, {
		options = {
			{
				type = "client",
				event = "rsg_moneywash:client:client:washexit",
				icon = "fas fa-comment-dots",
				label = "Exit Wash",
			},
		},
		distance = 2.5
	})
end)

-- enter wash
RegisterNetEvent('rsg_moneywash:client:client:washenterance')
AddEventHandler('rsg_moneywash:client:client:washenterance', function()
	local player = PlayerPedId()
	QBCore.Functions.Progressbar("enter-wash", "Entering..", 5000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
		}, {
			animDict = "mp_common",
			anim = "givetake1_a",
			flags = 8,
		}, {}, {}, function() -- Done
		DoScreenFadeOut(500)
		Wait(500)
		SetEntityCoords(player, 1138.02, -3199.19, -39.67)
		SetEntityHeading(player, 13.17)
		DoScreenFadeIn(500)
	end, function()
		QBCore.Functions.Notify("Cancelled..", "error")
	end)
end)

-- exit wash
RegisterNetEvent('rsg_moneywash:client:client:washexit')
AddEventHandler('rsg_moneywash:client:client:washexit', function()
	local player = PlayerPedId()
	QBCore.Functions.Progressbar("exit-wash", "Leaving..", 5000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
		}, {
			animDict = "mp_common",
			anim = "givetake1_a",
			flags = 8,
		}, {}, {}, function() -- Done
		DoScreenFadeOut(500)
		Wait(500)
		SetEntityCoords(player, -3162.96, 1103.47, 24.36)
		SetEntityHeading(player, 75.91)
		DoScreenFadeIn(500)
	end, function()
		QBCore.Functions.Notify("Cancelled..", "error")
	end)
end)