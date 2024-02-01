if GetResourceState('ps-inventory') ~= 'started' then return end
local QBCore = exports['qb-core']:GetCoreObject()


OpenStash = function(data,identifier)
	local PlayerData = QBCORE.Functions.GetPlayerData()
    local motel = GlobalState.Motels[data.motel]
	local moteldoor = motel and motel.rooms[data.index]
	if moteldoor and DoesPlayerHaveAccess(motel.rooms[data.index].players)
		or moteldoor and DoesPlayerHaveKey(data, moteldoor) then
			TriggerServerEvent('inventory:server:OpenInventory', 'stash', 'stash_'..data.motel..'_'..identifier..'_'..data.index, {})
			TriggerServerEvent("InteractSound_SV:PlayOnSource", "StashOpen", 0.4)
			TriggerEvent("inventory:client:SetCurrentStash", 'stash_'..data.motel..'_'..identifier..'_'..data.index)
	else
		QBCore.Functions.Notify("You do not have they keys to this stash...", "error")
	end
end