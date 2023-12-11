local QBCore = exports['qb-core']:GetCoreObject()

--- Events

RegisterNetEvent('qb-hunting:server:removeBait', function()
   local src = source
   local Player = QBCore.Functions.GetPlayer(src)
   if not Player then return end

   if Config.Inventory == 'ox_inventory' then
      exports['ox_inventory']:RemoveItem(src, 'hunting_bait', 1)
   elseif Config.Inventory == 'qb' then
      Player.Functions.RemoveItem('hunting_bait', 1, false)
      TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['hunting_bait'], 'remove', 1)
   end
end)

RegisterNetEvent('qb-hunting:server:slaughterAnimal', function(netId)
   local src = source
   local Player = QBCore.Functions.GetPlayer(src)
   if not Player then return end

   local entity = NetworkGetEntityFromNetworkId(netId)

   if not DoesEntityExist(entity) then return end

   local animalCoords = GetEntityCoords(entity)
   local pedCoords = GetEntityCoords(GetPlayerPed(src))

   if HuntingZone:contains(animalCoords) and HuntingZone:contains(pedCoords) then

      local animal

      if GetEntityModel(entity) == `a_c_deer` then
         animal = 'deer'
      elseif GetEntityModel(entity) == `a_c_mtlion` then
         animal = 'mtlion'
      elseif GetEntityModel(entity) == `a_c_coyote` then
         animal = 'coyote'
      elseif GetEntityModel(entity) == `a_c_boar` then
         animal = 'boar'
      end

      if DoesEntityExist(entity) then
         DeleteEntity(entity)

         local weight = math.random(100)
         local tier
         
         if weight > 85 then -- 15%
            tier = 3

            -- Tier 3 Carcass
            if animal == 'deer' then
               if Config.Inventory == 'ox_inventory' then
                  exports['ox_inventory']:AddItem(src, 'carcass3', 1)
               elseif Config.Inventory == 'qb' then
                  Player.Functions.AddItem('carcass3', 1)
                  TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['carcass3'], 'add', 1)
               end
            else
               if Config.Inventory == 'ox_inventory' then
                  exports['ox_inventory']:AddItem(src, 'redcarcass3', 1)
               elseif Config.Inventory == 'qb' then
                  Player.Functions.AddItem('redcarcass3', 1)
                  TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['redcarcass3'], 'add', 1)
               end
            end
         elseif weight > 65 then -- 20%
            tier = 2

            -- Tier 2 Carcass
            if animal == 'deer' then
               if Config.Inventory == 'ox_inventory' then
                  exports['ox_inventory']:AddItem(src, 'carcass2', 1)
               elseif Config.Inventory == 'qb' then
                  Player.Functions.AddItem('carcass2', 1)
                  TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['carcass2'], 'add', 1)
               end
            else
               if Config.Inventory == 'ox_inventory' then
                  exports['ox_inventory']:AddItem(src, 'redcarcass2', 1)
               elseif Config.Inventory == 'qb' then
                  Player.Functions.AddItem('redcarcass2', 1)
                  TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['redcarcass2'], 'add', 1)
               end
            end
         else -- 65%
            tier = 1

            -- Tier 1 Carcass
            if animal == 'deer' then
               if Config.Inventory == 'ox_inventory' then
                  exports['ox_inventory']:AddItem(src, 'carcass', 1)
               elseif Config.Inventory == 'qb' then
                  Player.Functions.AddItem('carcass', 1)
                  TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['carcass'], 'add', 1)
               end
            else
               if Config.Inventory == 'ox_inventory' then
                  exports['ox_inventory']:AddItem(src, 'redcarcass', 1)
               elseif Config.Inventory == 'qb' then
                  Player.Functions.AddItem('redcarcass', 1)
                  TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['redcarcass'], 'add', 1)
               end
            end
         end

         if animal == 'deer' then
            if Config.Inventory == 'ox_inventory' then
               exports['ox_inventory']:AddItem(src, 'deerhide', 1)
            elseif Config.Inventory == 'qb' then
               Player.Functions.AddItem('deerhide', 1)
               TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['deerhide'], 'add', 1)
            end

            -- Deer Antlers
            if math.random(2) == 1 then -- Chance to get antlers 1 in 2
               if Config.Inventory == 'ox_inventory' then
                  exports['ox_inventory']:AddItem(src, 'antlers', 1)
               elseif Config.Inventory == 'qb' then
                  Player.Functions.AddItem('antlers', 1)
                  TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['antlers'], 'add', 1)
               end
            end
         elseif animal == 'mtlion' then
            if Config.Inventory == 'ox_inventory' then
               exports['ox_inventory']:AddItem(src, 'mtlionpelt', 1)
            elseif Config.Inventory == 'qb' then
               Player.Functions.AddItem('mtlionpelt', 1)
               TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['mtlionpelt'], 'add', 1)
            end

            -- Mtlion fang
            if math.random(30) == 1 then -- Chance to get fang 1 in 30
               if Config.Inventory == 'ox_inventory' then
                  exports['ox_inventory']:AddItem(src, 'mtlionfang', 1)
               elseif Config.Inventory == 'qb' then
                  Player.Functions.AddItem('mtlionfang', 1)
                  TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['mtlionfang'], 'add', 1)
               end
            end
         elseif animal == 'coyote' then
            if Config.Inventory == 'ox_inventory' then
               exports['ox_inventory']:AddItem(src, 'coyotepelt', 1)
            elseif Config.Inventory == 'qb' then
               Player.Functions.AddItem('coyotepelt', 1)
               TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['coyotepelt'], 'add', 1)
            end
         elseif animal == 'boar' then
            if Config.Inventory == 'ox_inventory' then
               exports['ox_inventory']:AddItem(src, 'boarmeat', 1)
            elseif Config.Inventory == 'qb' then
               Player.Functions.AddItem('boarmeat', 1)
               TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['boarmeat'], 'add', 1)
            end
         end
      end
   end
end)

RegisterNetEvent('qb-hunting:server:sellItems', function()
   local src = source
   local Player = QBCore.Functions.GetPlayer(src)
   if not Player then return end

   local coords = GetEntityCoords(GetPlayerPed(src))
   if #(coords - Config.Sell.xyz) > 10 then
       exports['qb-core']:ExploitBan(src, 'Hunting-Sell-Items')
       return 
   end

   local payout = 0

   if Config.Inventory == 'ox_inventory' then
      local inventoryItems = exports['ox_inventory']:GetInventoryItems(src)
      for slot, item in pairs(inventoryItems) do
         if Config.Prices[item.name] then
            payout += (Config.Prices[item.name] * item.count)

            exports['ox_inventory']:RemoveItem(src, item.name, item.count, nil, item.slot)
         end
      end
   elseif Config.Inventory == 'qb' then
      for slot, item in pairs(Player.PlayerData.items) do
         if Config.Prices[item.name] then
            payout += (Config.Prices[item.name] * item.amount)
            
            Player.Functions.RemoveItem(item.name, item.amount, slot)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], 'remove', item.amount)
         end
      end
   end

   if payout > 0 then
      Player.Functions.AddMoney('cash', payout)

      Utils.Notify(src, Locales['notify_sold'], 'success', 2500)

      if Config.Log == 'qb' then
         TriggerEvent('qb-log:server:CreateLog', 'hunting', 'Hunting payout', 'red', '**'.. Player.PlayerData.source .. '** (citizenid: *'..Player.PlayerData.citizenid..'* | id: *'..src..'*) received: **'..payout..' $** for selling hunting items.')
      elseif Config.Log == 'ox' then
         lib.logger(Player.PlayerData.name, 'Hunting Reward', Player.PlayerData.name .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. src .. ')' .. ' Received ' .. payout .. ' for selling hunting items.')
      end
   else
      Utils.Notify(src, Locales['notify_nothing'], 'error', 2500)
   end
end)

--- Items

QBCore.Functions.CreateUseableItem('hunting_bait', function(source, item)
   TriggerClientEvent('qb-hunting:client:PlaceBait', source)
end)
