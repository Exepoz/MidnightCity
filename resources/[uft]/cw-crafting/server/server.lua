QBCore =  exports['qb-core']:GetCoreObject()
local useDebug = Config.Debug
function dump(o)
   if type(o) == 'table' then
   local s = '{ '
   for k,v in pairs(o) do
      if type(k) ~= 'number' then k = '"'..k..'"' end
      s = s .. '['..k..'] = ' .. dump(v) .. ','
   end
   return s .. '} '
   else
   return tostring(o)
   end
end

RegisterNetEvent('cw-crafting:server:craftItem', function(player, item, craftingAmount)
    print_table(item)
    local src = source
    local total = 0
    local Player = QBCore.Functions.GetPlayer(src)
    for material, amount in pairs(item.materials) do
        if not Player.Functions.RemoveItem(material, amount*craftingAmount) then return end
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[material], "remove", amount*craftingAmount)
    end
    if item.toMaterials ~= nil then
        for material, amount in pairs(item.toMaterials) do
            Player.Functions.AddItem(material, amount*craftingAmount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[material], "add", amount*craftingAmount)
        end
    else
        if item.amount ~= nil then
            total = item.amount * craftingAmount or craftingAmount
        else
            total = craftingAmount
        end
        Player.Functions.AddItem(item.name, total, item.metadata)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], "add", total)
    end
end)

local function updateBlueprints(citizenId, blueprints)
    return MySQL.Sync.execute('UPDATE players SET crafting_blueprints = ? WHERE citizenid = ?', {json.encode(blueprints), citizenId} )
end

local function fetchBlueprints(citizenId)
    local fetched = MySQL.Sync.fetchAll('SELECT crafting_blueprints FROM players WHERE citizenid = ?', {citizenId})[1].crafting_blueprints
    local decoded = json.decode(fetched)
    return decoded
end

local function removeBlueprint(citizenId, blueprint)
    local blueprints = fetchBlueprints(citizenId)
    if blueprints then
        for i, bp in pairs(blueprints) do
            if bp == blueprint then
                table.remove(blueprints, i)
                MySQL.Sync.execute('UPDATE players SET crafting_blueprints = ? WHERE citizenid = ?', {json.encode(blueprints), citizenId} )
                return true
            end
        end
    else
        return false
    end
end

local function addBlueprint(citizenId, blueprint)
    local blueprints = fetchBlueprints(citizenId)
    if blueprints ~= nil then
        if #blueprints > 0 then
            for i, bp in pairs(blueprints) do
                if bp == blueprint then
                    print('Character already has this blueprint')
                    return false
                end
            end
        end
        if Config.Debugcraft then
            print('add Blueprint success:', blueprint)
        end
        blueprints[#blueprints+1] = blueprint
        updateBlueprints(citizenId, blueprints)
        return true
    else
        return false
    end
end

local function handleAddBlueprintFromItem(source, blueprint)
    local Player = QBCore.Functions.GetPlayer(source)
    local citizenId = Player.PlayerData.citizenid
    local success = addBlueprint(citizenId, blueprint)
    if success then
        local blueprints = Player.Functions.GetItemsByName('blueprint')
        if Config.Inventory == 'qb' then
            local slot = nil
            for _, bpItem in ipairs(blueprints) do
                if Config.Debugcraft then
                   print(bpItem.info.value)
                end
                if bpItem.info.value == blueprint then
                    slot = bpItem.slot
                end
            end
            if slot then
                Player.Functions.RemoveItem('blueprint', 1, slot)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['blueprint'], "remove")
                addBlueprint(citizenId, blueprint)
            end
        else
            local slot = nil
            for _, bpItem in ipairs(blueprints) do

                   print(bpItem.metadata.value)

                if bpItem.metadata.value == blueprint then
                    slot = bpItem.slot
                end
            end
            if slot then
                Player.Functions.RemoveItem('blueprint', 1, slot)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['blueprint'], "remove")
                addBlueprint(citizenId, blueprint)
            end
        end
    else
        TriggerClientEvent('QBCore:Notify', source, "You already know this recipe", "error")
    end
end

local function getQBItem(item)
    local qbItem = QBCore.Shared.Items[item]
    if qbItem then
        return qbItem
    else
        print('Someone forgot to add the item')
    end
end

local function giveBlueprintItem(source, blueprintValue)
    if Config.Inventory == 'qb' then
        local given = false
        local info = {}
    	local Player = QBCore.Functions.GetPlayer(source)
        info.value = blueprintValue
        info.bpLabel = QBCore.Shared.Items[blueprintValue].label
        if Player.Functions.AddItem('blueprint', 1, nil, info) then
            TriggerClientEvent('inventory:client:ItemBox', source, getQBItem('blueprint'), "add")
            given = true
        end
        return given
    elseif Config.Inventory == 'ox' then
        local carry = exports.ox_inventory:CanCarryItem(source, 'blueprint', 1)
        if carry then
            exports.ox_inventory:AddItem(source, 'blueprint', 1, {value = blueprintValue})
        else
            if useDebug then
               print("Can not carry. Dropping on ground")
            end
            local pped = GetPlayerPed(source)
            local coords = GetEntityCoords(pped)
            exports.ox_inventory:CustomDrop("drop-"..math.random(1,9999), {{'blueprint', 1, {value = blueprintValue}}}, coords)
        end
    end
end
exports("giveBlueprintItem", giveBlueprintItem)

local function filterByRarity(min, max)
    local tempBlueprints = {}
    for index, bp in pairs(Config.Blueprints) do
        local rarity = bp.rarity
        if rarity == nil then
           rarity = 1
        end
        if rarity >= min and rarity <= max then
            local i = #tempBlueprints+1
            tempBlueprints[i] = bp
            tempBlueprints[i].value = index
        end
    end
    if useDebug then
       print('sorted BPS', min, max)
       print(QBCore.Debug(tempBlueprints))
    end
    return tempBlueprints
end

local function randomizeBlueprint(blueprints)
    return blueprints[math.random(1, #blueprints)]
end

local function giveRandomBlueprint(source , rarity, failChance)
    local foundItem = nil
    local minRarity = 1
    local maxRarity = 1
    if type(rarity) == 'table' then
        if useDebug then
           print('table')
        end
        minRarity = rarity.min
        maxRarity = rarity.max
    else
        if useDebug then
           print('not table')
        end
        maxRarity = rarity
    end

    local chance = math.random(0,1000)

    if useDebug then
        print('Roll:', chance)
        print('failChance:', failChance)
    end
    if failChance <= chance then
        local blueprints = filterByRarity(minRarity,maxRarity)
        giveBlueprintItem(source, randomizeBlueprint(blueprints).value)
    else
        if useDebug then
           print('Roll Failed', failChance, chance)
        end
    end
end
exports("giveRandomBlueprint", giveRandomBlueprint) -- Use this to give blueprints from random loot

RegisterNetEvent('cw-crafting:server:giveBlueprint', function(value)
    giveBlueprintItem(source, value)
end)

RegisterNetEvent('cw-crafting:server:giveRandomBlueprint', function(source, rarity, failChance)
    if useDebug then
       print('srs', source)
    end

    giveRandomBlueprint(source, rarity , failChance)
end)

RegisterNetEvent('cw-crafting:server:removeBlueprint', function(citizenId,blueprint)
    removeBlueprint(citizenId, blueprint)
end)

RegisterNetEvent('cw-crafting:server:addBlueprint', function(citizenId,blueprint)
    addBlueprint(citizenId, blueprint)
end)

QBCore.Functions.CreateCallback('cw-crafting:server:getBlueprints', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local citizenId = Player.PlayerData.citizenid
    cb(fetchBlueprints(citizenId))
 end)

QBCore.Functions.CreateCallback('cw-crafting:server:getMaxCraftingAmount', function(source, cb, item)
    local Player = QBCore.Functions.GetPlayer(source)
    local materials = {}
    local canMake
    for k, v in pairs(item.materials) do
        materials[k] = 0
        local slots = Player.Functions.GetItemsByName(k)
        for k_, v_ in pairs(slots) do materials[k] = materials[k] + v_.amount end
        if not canMake then canMake = math.floor(materials[k]/v)
        else canMake = math.floor(materials[k]/v) < canMake and math.floor(materials[k]/v) or canMake end
    end
    cb(canMake)
end)


QBCore.Functions.CreateUseableItem("blueprint", function(source, item)
    if Config.BlueprintDudes then
        TriggerClientEvent('QBCore:Notify', source, "You need to find someone who can teach you this..", "error")
    else
        if useDebug then
           print('used blueprint')
        end
        TriggerClientEvent('cw-crafting:client:progressbar', source)
        local blueprint = nil
        if Config.Inventory == 'ox' then
            blueprint = item.metadata.value
        else
            blueprint = item.info.value
        end
        handleAddBlueprintFromItem(source, blueprint)
    end
end)

RegisterNetEvent('cw-crafting:server:addBlueprintFromLearning', function(blueprint)
    local src = source
    if useDebug then
        print('used blueprint')
    end
    TriggerClientEvent('cw-crafting:client:progressbar', src)
    handleAddBlueprintFromItem(src, blueprint.bpName)
end)

QBCore.Commands.Add('addblueprint', 'Give blueprint knowledge to player. (Admin Only)',{ { name = 'player id', help = 'the id of the player' }, { name = 'blueprint', help = 'name of blueprint' } }, true, function(source, args)
    print(args[1])
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local citizenId = Player.PlayerData.citizenid
    print('adding '..args[2].. ' to '..citizenId)
    addBlueprint(citizenId, args[2])
end, 'admin')

QBCore.Commands.Add('removeblueprint', 'Remove blueprint to player. (Admin Only)',{ { name = 'player id', help = 'the id of the player' }, { name = 'blueprint', help = 'name of blueprint' } }, true, function(source, args)
    print(args[1])
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local citizenId = Player.PlayerData.citizenid
    print('removing '..args[2].. ' to '..citizenId)
    removeBlueprint(citizenId, args[2])
end, 'admin')

QBCore.Commands.Add('giveblueprint', 'Give blueprint item to player. (Admin Only)',{ { name = 'player id', help = 'the id of the player' }, { name = 'blueprint', help = 'name of blueprint' } }, true, function(source, args)
    giveBlueprintItem(tonumber(args[1]), args[2])
end, 'admin')

QBCore.Commands.Add('cwdebugcrafting', 'toggle debug for crafting', {}, true, function(source, args)
    useDebug = not useDebug
    print('debug is now:', useDebug)
    TriggerClientEvent('cw-crafting:client:toggleDebug',source, useDebug)
end, 'admin')

QBCore.Commands.Add('testbp', 'test bps. (Admin Only)',{}, true, function(source)
    TriggerEvent('cw-crafting:server:giveRandomBlueprint',source)
    --TriggerEvent('cw-crafting:server:giveRandomBlueprint',source, 3, 50)
end, 'admin')

---print tables : debug
---@param node table
function print_table(node)
    local cache, stack, output = {}, {}, {}
    local depth = 1
    local output_str = "{\n"

    while true do
         local size = 0
         for k, v in pairs(node) do
              size = size + 1
         end

         local cur_index = 1
         for k, v in pairs(node) do
              if (cache[node] == nil) or (cur_index >= cache[node]) then

                   if (string.find(output_str, "}", output_str:len())) then
                        output_str = output_str .. ",\n"
                   elseif not (string.find(output_str, "\n", output_str:len())) then
                        output_str = output_str .. "\n"
                   end

                   -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                   table.insert(output, output_str)
                   output_str = ""

                   local key
                   if (type(k) == "number" or type(k) == "boolean") then
                        key = "[" .. tostring(k) .. "]"
                   else
                        key = "['" .. tostring(k) .. "']"
                   end

                   if (type(v) == "number" or type(v) == "boolean") then
                        output_str = output_str .. string.rep('\t', depth) .. key .. " = " .. tostring(v)
                   elseif (type(v) == "table") then
                        output_str = output_str .. string.rep('\t', depth) .. key .. " = {\n"
                        table.insert(stack, node)
                        table.insert(stack, v)
                        cache[node] = cur_index + 1
                        break
                   else
                        output_str = output_str .. string.rep('\t', depth) .. key .. " = '" .. tostring(v) .. "'"
                   end

                   if (cur_index == size) then
                        output_str = output_str .. "\n" .. string.rep('\t', depth - 1) .. "}"
                   else
                        output_str = output_str .. ","
                   end
              else
                   -- close the table
                   if (cur_index == size) then
                        output_str = output_str .. "\n" .. string.rep('\t', depth - 1) .. "}"
                   end
              end

              cur_index = cur_index + 1
         end

         if (size == 0) then
              output_str = output_str .. "\n" .. string.rep('\t', depth - 1) .. "}"
         end

         if (#stack > 0) then
              node = stack[#stack]
              stack[#stack] = nil
              depth = cache[node] == nil and depth + 1 or depth - 1
         else
              break
         end
    end

    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output, output_str)
    output_str = table.concat(output)

    print(output_str)
end