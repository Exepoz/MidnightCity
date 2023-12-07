PlayerStress = {}
Framework = nil
Framework = GetFramework()
Citizen.Await(Framework)
Callback = Config.Framework == "ESX" or Config.Framework == "NewESX" and Framework.RegisterServerCallback or Framework.Functions.CreateCallback


Citizen.CreateThread(function()
    Citizen.Wait(2000)
    for _,v in pairs(GetPlayers()) do
        local Player = Config.Framework == "ESX" or Config.Framework == "NewESX" and Framework.GetPlayerFromId(tonumber(v)) or Framework.Functions.GetPlayer(tonumber(v))
        if Player ~= nil then
            TriggerClientEvent('HudPlayerLoad', -1)
            Wait(74)
        end
    end
end)


if Config.Framework == "ESX" or Config.Framework == "NewESX" then     
            Callback('Players', function(source, cb)
                local count = 0
                for k,v in pairs(Framework.GetPlayers()) do
                    if v ~= nil then count = count + 1 end
                end
                cb(count, source)
            end)

            RegisterCommand(Config.Refresh, function(source)
                local Player = Framework.GetPlayerFromId(source) 
                TriggerClientEvent('HudPlayerLoad', source)
            end)

            Callback('Player', function(source, cb)
                local xPlayer = Framework.GetPlayerFromId(source)
                if not xPlayer then return end
                cb(xPlayer.getMoney(), xPlayer.getAccount("bank").money, xPlayer.getAccount("black_money").money)
            end)

            RegisterNetEvent('esx:playerLoaded')
            AddEventHandler('esx:playerLoaded', function(src)
                Wait(1000)
                TriggerClientEvent('HudPlayerLoad', src)
            end)

elseif Config.Framework == "QBCore" or Config.Framework == "OLDQBCore" then
        Framework = exports["qb-core"]:GetCoreObject()

        Callback('Players', function(source, cb)
            local count = 0
            for k,v in pairs(Framework.Functions.GetPlayers()) do
                if v ~= nil then count = count + 1 end
            end
            cb(count, source)
        end)

        
        RegisterCommand(Config.Refresh, function(source)
            local Player = Framework.Functions.GetPlayer(source)
            TriggerClientEvent('HudPlayerLoad', source)
        end)


        Callback('Player', function(source, cb)
            local xPlayer = Framework.Functions.GetPlayer(source)
            if not xPlayer then return end
            cb(xPlayer.PlayerData.money["cash"], xPlayer.PlayerData.money["bank"], xPlayer.PlayerData.money["crypto"])
        end)

        RegisterNetEvent('QBCore:Server:OnPlayerLoaded')
        AddEventHandler('QBCore:Server:OnPlayerLoaded', function()
          local source = source
          local Player = Framework.Functions.GetPlayer(source)
          TriggerClientEvent('HudPlayerLoad', source)
      end)

end

RegisterServerEvent('RemoveNitroItem')
AddEventHandler('RemoveNitroItem', function(Plate)
    if Config.Framework == "ESX" or Config.Framework == "NewESX" then
        Framework.GetPlayerFromId(source).removeInventoryItem(Config.NitroItem, 1)
    else
        Framework.Functions.GetPlayer(source).Functions.RemoveItem(Config.NitroItem, 1)
    end
    if Plate then
        NitroVeh[Plate] = 100
        TriggerClientEvent('UpdateData', -1, NitroVeh, Plate)
    end
end)

RegisterServerEvent('UpdateNitro')
AddEventHandler('UpdateNitro', function(Plate, Get)
    if Plate then
        if NitroVeh[Plate] then
            NitroVeh[Plate] = Get
            TriggerClientEvent('UpdateData', -1, NitroVeh)
        end
    end
end)

RegisterNetEvent('SetStress', function(amount)
    local Player = (Config.Framework == "ESX" or Config.Framework == "NewESX") and Framework.GetPlayerFromId(source) or Framework.Functions.GetPlayer(source)
    local JobName = (Config.Framework == "ESX" or Config.Framework == "NewESX") and Player.job.label or Player.PlayerData.job.label
    local ID = (Config.Framework == "ESX" or Config.Framework == "NewESX") and Player.identifier or Player.PlayerData.citizenid
    local newStress
    if not Player or (Config.DisablePoliceStress and JobName == 'police') then return end
    if not PlayerStress[ID] then PlayerStress[ID] = 0 end
    newStress = PlayerStress[ID] + amount
    if newStress <= 0 then newStress = 0 end
    if newStress > 100 then newStress = 100 end
    PlayerStress[ID] = newStress
    TriggerClientEvent('UpdateStress', source, PlayerStress[ID])
end)

NitroVeh = {}
stressData = {}
Citizen.CreateThread(function()
    Citizen.Wait(3500)
    while Framework == nil do Citizen.Wait(72) end
    UsableItem = Config.Framework == "ESX" or Config.Framework == "NewESX" and Framework.RegisterUsableItem or Framework.Functions.CreateUseableItem

    UsableItem(Config.NitroItem, function(source)
        TriggerClientEvent('SetupNitro', source)
    end)
end)

RegisterNetEvent('hud:server:GainStress', function(amount)
    local src = source
    local identifier = GetIdentifier(src)
    if IsWhitelisted(src) then
        return
    end
    local newStress = math.min((tonumber(stressData[identifier]) or 0) + amount, 100)
    newStress = math.max(newStress, 0)
    stressData[identifier] = newStress
    TriggerClientEvent('hud:client:UpdateStress', src, newStress)
end)

RegisterNetEvent('hud:server:RelieveStress', function(amount)
    local src = source
    local identifier = GetIdentifier(src)
    local newStress = math.max((tonumber(stressData[identifier]) or 0) - amount, 0)
    newStress = math.min(newStress, 100)
    stressData[identifier] = newStress
    TriggerClientEvent('hud:client:UpdateStress', src, newStress)
end)

function IsWhitelisted(source)
    local player = (Config.Framework == 'ESX' or Config.Framework == 'NewESX') and Framework.GetPlayerFromId(source) or Framework.Functions.GetPlayer(source)
    if player then
        local jobName = (Config.Framework == 'ESX' or Config.Framework == 'NewESX') and player.job.name or player.PlayerData.job.name
        for _, v in pairs(Config.StressWhitelistJobs) do
            if jobName == v then
                return true
            end
        end
    end
    return false
end

function GetIdentifier(source)
    if Config.Framework == "ESX" or Config.Framework == "NewESX" then
        local xPlayer = Framework.GetPlayerFromId(tonumber(source))
        return xPlayer and xPlayer.getIdentifier() or "0"
    else
        local Player = Framework.Functions.GetPlayer(tonumber(source))
        return Player and Player.PlayerData.citizenid or "0"
    end
end
