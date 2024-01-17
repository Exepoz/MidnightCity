local QBCore = exports['qb-core']:GetCoreObject()

--|~===================|--
--|~ Money Laundering ~|--
--|~===================|--

local Machines = Config.Machines
for k, v in ipairs(Machines) do
	Machines[k].worth = 0
	Machines[k].startTime = 0
end
GlobalState.WashingMachines = Machines


CreateThread(function()
	local LoadJson = json.decode(LoadResourceFile(GetCurrentResourceName(), 'machines.json'))
    Machines = LoadJson
	GlobalState.WashingMachines = Machines
end)

RegisterNetEvent('rsg_moneywash:server:DepositMoney', function(machine)
	local src = source
	local worth, remAmount = 0, 0
	local Player = QBCore.Functions.GetPlayer(src)
	if not Player.Functions.GetItemByName('cleaningkit') then TriggerClientEvent('QBCore:Notify', src, 'You need cleaning product to use the machine!', 'error', 3000) return end
	local marked = Player.Functions.GetItemsByName("markedbills")
	for _,v in pairs(marked) do
		for i = 1, v.amount do
			if worth >= 25000 then break end
			worth = worth + Player.PlayerData.items[v.slot].info.worth
			Player.Functions.RemoveItem('markedbills', 1, v.slot)
			remAmount = remAmount + 1
		end
	end
	if remAmount == 0 then TriggerClientEvent('QBCore:Notify', src, 'You don\'t have any money to wash!', 'error', 3000) return end
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "remove", remAmount)
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['cleaningkit'], "remove", 1)
	Player.Functions.RemoveItem('cleaningkit', 1)
	Machines[machine].worth = worth
	Machines[machine].startTime = os.time()
	GlobalState.WashingMachines = Machines
	TriggerClientEvent('QBCore:Notify', src, 'Your money will be ready in 60 minutes.', 'success', 3000)
	SaveResourceFile(GetCurrentResourceName(), "machines.json", json.encode(Machines), -1)

    local charinfo = Player.PlayerData.charinfo
    local firstName = charinfo.firstname:sub(1,1):upper()..charinfo.firstname:sub(2)
    local lastName = charinfo.lastname:sub(1,1):upper()..charinfo.lastname:sub(2)
    local pName = firstName.." "..lastName
    local logString = "Player : ".. GetPlayerName(src) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n\nMachine :** #"..machine.."\nAmount : "..worth
    TriggerEvent("qb-log:server:CreateLog", "moneywash", "Money Added.", "blue", {ply = GetPlayerName(src), txt = logString, amt = worth})
end)

RegisterNetEvent('rsg_moneywash:server:TakeMoney', function(machine)
	local src = source
	local time = Machines[machine].startTime
	if time+3600 - os.time() > 0 then TriggerClientEvent('QBCore:Notify', src, 'The wash isn\'t done...', 'error', 3000) return end
	local worth = Machines[machine].worth
	local retreiveAmount = math.floor(worth * 0.80)
	local Player = QBCore.Functions.GetPlayer(src)
	local reason = "Money Wash (Machines)"
	Player.Functions.AddMoney('cash', retreiveAmount, reason)

    local charinfo = Player.PlayerData.charinfo
    local firstName = charinfo.firstname:sub(1,1):upper()..charinfo.firstname:sub(2)
    local lastName = charinfo.lastname:sub(1,1):upper()..charinfo.lastname:sub(2)
    local pName = firstName.." "..lastName
    local logString =  "Player : ".. GetPlayerName(src) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n\nMachine :** #"..machine.."\nAmount Washed: $"..worth.."\nPlayer Received : $"..retreiveAmount
    TriggerEvent("qb-log:server:CreateLog", "moneywash", "Money Taken.", "green", {ply = GetPlayerName(src), txt = logString, amt = retreiveAmount})

	Machines[machine].worth = 0
	Machines[machine].startTime = 0
	GlobalState.WashingMachines = Machines
	SaveResourceFile(GetCurrentResourceName(), "machines.json", json.encode(Machines), -1)
end)

QBCore.Functions.CreateCallback('rsg_moneywash:server:GetTime', function(_, cb) cb(os.time()) end)