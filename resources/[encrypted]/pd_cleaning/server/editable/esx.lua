if Config.framework == 'esx' then
    ESX = nil

    if Config.useNewESXExport then
        ESX = exports["es_extended"]:getSharedObject()
    else
        Citizen.CreateThread(function()
            while ESX == nil do
                TriggerEvent('esx:getSharedObject', function(obj)
                    ESX = obj
                end)
                Citizen.Wait(0)
            end
        end)
    end

    function HasItem(player, item)
        local xPlayer = ESX.GetPlayerFromId(player)

        return xPlayer.getInventoryItem(item).count >= 1
    end

    function IsPolice(player)
        local xPlayer = ESX.GetPlayerFromId(player)
        if not xPlayer then
            return false
        end
        local job = xPlayer.getJob()

        return Contains(Config.policeJobNames, job.name)
    end

    function IsCleaner()
        local xPlayer = ESX.GetPlayerFromId(player)
        if not xPlayer then
            return false
        end
        local job = xPlayer.getJob()

        return Contains(Config.cleanerJob.jobNames, job.name)
    end

    function GetPoliceCount()
        local currentOfficers = 0
        for _, playerId in ipairs(GetPlayers()) do
            playerId = tonumber(playerId)
            if IsPolice(playerId) then
                currentOfficers = currentOfficers + 1
            end
        end
        return currentOfficers
    end

    function AddMoney(player, amount)
        local xPlayer = ESX.GetPlayerFromId(player)
        if not xPlayer then
            return false
        end

        xPlayer.addAccountMoney(Config.payout_account, amount)
    end

    function GetValuable(player, itemHash)
        local selectedItem = nil
        local xPlayer = ESX.GetPlayerFromId(player)

        for k in pairs(Config.valuableItems) do
            local model = Config.valuableItems[k].model
            if GetHashKey(model) == itemHash then
                selectedItem = Config.valuableItems[k]
            end
        end
        
        if selectedItem ~= nil then
            if xPlayer.canCarryItem(selectedItem.item, 1) then
                xPlayer.addInventoryItem(selectedItem.item, 1)
                SendNotification(L('You have stolen ~y~') .. selectedItem.label)
            else
                SendNotification(L('You do not have space for ~y~') .. selectedItem.label)
            end
        end
    end

    function GetIdentifier(player)
        local identifier = ESX.GetPlayerFromId(player).identifier

        return identifier
    end

    function SellValuables(player, itemTable)
        local xPlayer = ESX.GetPlayerFromId(player)
        local item = itemTable

        local itemCount = xPlayer.getInventoryItem(item.item).count or 0
        if itemCount > 0 then
            xPlayer.removeInventoryItem(item.item, itemCount)
            xPlayer.addAccountMoney(Config.sellLocations[1].useAccount, item.price * itemCount)
            xPlayer.showNotification(L('You have sold ') .. L('~g~') .. itemCount .. L('x ') .. item.label .. L('~w~') .. L('for') .. L(' ~g~') .. item.price * itemCount .. L('$'))
        end
    end
end