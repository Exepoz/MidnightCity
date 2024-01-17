local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("is-playerstyles:server:SaveStyle", function(kind, current)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.SetMetaData(kind, current)
end)


QBCore.Commands.Add(Config.CommandName, 'Choose your styles', {}, false, function(source)
    TriggerClientEvent("is-playerstyles:client:OpenStylesMenu", source)
end)
