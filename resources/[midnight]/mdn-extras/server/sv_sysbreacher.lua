local QBCore = exports['qb-core']:GetCoreObject()
local HeistCD = Config.SysBreacher.Heists
GlobalState.HeistCD = HeistCD

RegisterNetEvent('mdn-extras:server:resHeist', function(heist, cid, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    HeistCD[heist].reserved = cid
    HeistCD[heist].resTime = os.time()
    GlobalState.HeistCD = HeistCD
    Player.PlayerData.items[item.slot].info = {heist = heist, tries = Config.SysBreacher.Heists[heist].tries}
    Player.Functions.SetInventory(Player.PlayerData.items)
    Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(HeistCD[heist].dongle, 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[HeistCD[heist].dongle], "remove", 1)
end)

RegisterNetEvent('mdn-extras:server:RemoveHackUse', function(heist)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local sb = Player.Functions.GetItemByName('uhackingdevice')
    if Player.PlayerData.items[sb.slot].info.heist == heist then
        Player.PlayerData.items[sb.slot].info.tries = Player.PlayerData.items[sb.slot].info.tries - 1
        if Player.PlayerData.items[sb.slot].info.tries <= 0 then
            HeistCD[Player.PlayerData.items[sb.slot].info.heist].reserved = nil
            GlobalState.HeistCD = HeistCD
            Player.PlayerData.items[sb.slot].info.heist = nil
        end
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)

function SetCooldown(heist, state)
    HeistCD[heist].onCooldown = state
    GlobalState.HeistCD = HeistCD
end exports('SetCooldown', SetCooldown)

RegisterNetEvent('mdn-extras:server:RemoveProt', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item = Player.Functions.GetItemByName('uhackingdevice')
    local heist = Player.PlayerData.items[item.slot].info.heist
    if not heist then print("Tried Removing Protocol but no heist on device.") return end
    HeistCD[heist].reserved = nil
    Player.PlayerData.items[item.slot].info.tries = 0
    Player.PlayerData.items[item.slot].info.heist = nil
    Player.Functions.SetInventory(Player.PlayerData.items)
    GlobalState.HeistCD = HeistCD
end)

QBCore.Functions.CreateCallback('mdn-extras:FetchServerTime', function(_, cb, _) cb(os.time()) end)

QBCore.Functions.CreateUseableItem('uhackingdevice', function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player.Functions.GetItemByName('uhackingdevice') then return end
    TriggerClientEvent('mdn-extras:client:SysBreacher', source, item)
end)