local QBCore = exports['qb-core']:GetCoreObject()
local Recipes = {}
local Blueprints = {}
local CurrentAmount = 1
local currentTableType = nil
local ItemNames = {}
local useDebug = Config.Debug
local isCrafting = false

local function getOxItems()
    if Config.Inventory == 'ox' then
        for items, datas in pairs(exports.ox_inventory:Items()) do
            ItemNames[items] = datas
        end
    end
end

AddEventHandler('onResourceStart', function(resource)
   if resource == GetCurrentResourceName() then
        getOxItems()
   end
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    getOxItems()
    if Config.Inventory == 'ox' then
        exports.ox_inventory:displayMetadata("value", "Blueprint")
    end
end)

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

local function validateJob(item)
    if item.jobs then
        local Player = QBCore.Functions.GetPlayerData()

        local playerHasJob = false
        local levelRequirement = nil
        local jobLevel = Player.job.grade.level
        local jobName = Player.job.name
        local jobType = Player.job.type

        for i, job in pairs(item.jobs) do
            if job.type and jobType then
                if job.type == jobType then
                    playerHasJob = true
                    levelRequirement = job.level
                    break;
                end
            else
                if job.name == jobName then
                    playerHasJob = true
                    levelRequirement = job.level
                    break;
                end
            end
        end

        if playerHasJob then
            if levelRequirement ~= nil then
                if jobLevel >= levelRequirement then
                    return true
                else
                    -- print('Does not have the correct level')
                    return false
                end
            else
                return false
            end
        else
            -- print('Does not have jobs', dump(item.jobs))
            return false
        end
    else
        -- print('No job requirement for', item.name )
        return nil
    end
end

local function validateBlueprints(item)
    if item.blueprint then
        for i, blueprint in pairs(Blueprints) do
            if blueprint == item.blueprint then return true end
        end
        return false
    else
        -- print('No blueprint requirement for', item.name)
        return nil
    end
end

local function validateAccess(item)
    local playerPassesJobReq = validateJob(item)
    local playerPassesBlueprintReq = validateBlueprints(item)

    if item.requireBlueprintAndJob == true then
        if useDebug then
            print(item.name.. ' requires both job and blueprint', playerPassesJobReq, playerPassesBlueprintReq)
        end
        return playerPassesJobReq and playerPassesBlueprintReq
    elseif item.blueprint ~= nil and item.jobs ~= nil then
        if useDebug then
           print(item.name.. ' can use either job or blueprint', playerPassesJobReq, playerPassesBlueprintReq)
        end
        return playerPassesJobReq or playerPassesBlueprintReq
    elseif item.blueprint ~= nil then
        if useDebug then
           print(item.name.. ' requires blueprint', playerPassesBlueprintReq)
        end
        return playerPassesBlueprintReq
    elseif item.jobs ~= nil then
        if useDebug then
           print(item.name.. ' requires job', playerPassesJobReq)
        end
        return playerPassesJobReq
    end
    if useDebug then
       print(item.name..' has no requirements')
    end
    return true
end

local function validateRights(item)
    local tables = {}
    if item.tables ~= nil then
        for i, table in pairs(item.tables) do
            tables[table] = table
        end
    else
        tables = { ['basic'] = 'basic' }
    end

    if (tables == nil or tables[currentTableType]) and tables[currentTableType] then -- no table reqirement and this is a basic table
        if useDebug then
            print('is basic table')
        end
        return validateAccess(item)
    end
    if useDebug then
        print('recipe did not match this table')
    end
    return false
end

local function canCraftItem(item)
    if useDebug then
       print('checking job')
    end
    if Config.Inventory == 'qb' then
        local craft = true
        for material, amount in pairs(item.materials) do
            if useDebug then
               print(amount*CurrentAmount, material)
            end
            local hasItem = QBCore.Functions.HasItem(material, amount*CurrentAmount)
            if useDebug then
               print('hasitem', hasItem)
            end
            if not hasItem then
                craft = false
            end
        end
        return craft
    elseif Config.Inventory == 'ox' then
        local craft = true
        for material, amount in pairs(item.materials) do
            local count = 0
            local recipe = exports.ox_inventory:Search('slots', material)
                for k, ingredients in pairs(recipe) do
                    if ingredients.metadata.degrade ~= nil then
                        if ingredients.metadata.degrade >= 1 then
                            count = count + ingredients.count
                        else
                            QBCore.Functions.Notify("Items are Bad Quality", 'error', 5000)
                        end
                    else
                        count = count + ingredients.count
                    end
                end
                if count < amount*CurrentAmount then
                    craft = false
                end
        end
        if not craft then return false end
        return true
    end
end

local function craftItem(item, amount)
    if canCraftItem(item) then
        -- do emote here
        local craftTime = Config.DefaultCraftingTime*amount
        if item.craftingTime then
            craftTime = item.craftingTime*amount
        end
        local totalAmount = 1
        if item.amount then
            totalAmount = item.amount*amount
        end
        isCrafting = true
        TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
        QBCore.Functions.Progressbar("crafting", "Crafting", craftTime , false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
            TriggerServerEvent('cw-crafting:server:craftItem', PlayerPedId(), item, amount)
           --[[  print('item name', item.name) ]]
            if Config.Inventory == 'qb' then
                QBCore.Functions.Notify('You have crafted '..totalAmount..' '.. QBCore.Shared.Items[item.name].label, "success")
            else
                QBCore.Functions.Notify('You have crafted '..totalAmount..' '.. ItemNames[item.name].label, "success")
            end
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            isCrafting = false
        end, function() -- Cancel
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            isCrafting = false
            QBCore.Functions.Notify(Lang:t('error.canceled'), "error")
        end)
        return true
    else
        QBCore.Functions.Notify('You dont have the required items', "error", 2500)
    end
    return false
end

local function getRecipes()
    if useDebug then
       print('generating recipes for table', currentTableType)
    end
    Recipes = {}
    if useDebug then
       print('Amount of recipes: ', #Config.Recipes)
    end

    for recipe, item in pairs(Config.Recipes) do
        local canCraft = validateRights(item)
        if canCraft then
            local materialsNameMap = {}
            local toMaterialsNameMap = {}
            if Config.Inventory == 'qb' then
                item.data = QBCore.Shared.Items[item.name]
                if item.materials then
                    if useDebug then
                        print('Material used:')
                    end
                    for mat, amount in pairs(item.materials) do
                        if useDebug then
                            print(mat, amount)
                        end
                        materialsNameMap[mat] = QBCore.Shared.Items[mat].label
                    end
                end
                if item.toMaterials ~= nil then
                    if useDebug then
                       print('Materials given')
                    end
                    for mat, amount in pairs(item.toMaterials) do
                        if useDebug then
                            print(mat, amount)
                        end
                        toMaterialsNameMap[mat] = QBCore.Shared.Items[mat].label
                    end
                end
                if useDebug then
                    print('===============')
                end
            elseif Config.Inventory == 'ox' then
                if useDebug then
                   print('name', item.materials)
                end
                item.data = ItemNames[item.name]
                if item.materials then
                    for mat, amount in pairs(item.materials) do
                        materialsNameMap[mat] = ItemNames[mat].label
                    end
                end
                if item.toMaterials ~= nil then
                    for mat, amount in pairs(item.toMaterials) do
                        toMaterialsNameMap[mat] = ItemNames[mat].label
                    end
                end

            end
            if item.data == nil then
                print('!!! CW CRAFTING WARNING !!!')
                print('Item is probably missing from your items.lua: ', item.name)
            end
            item.materialsNameMap = materialsNameMap
            item.toMaterialsNameMap = toMaterialsNameMap
            item.type = item.type

            Recipes[recipe] = item
            if item.craftTime == nil then
                Recipes[recipe].craftTime = Config.DefaultCraftingTime
            end
            if useDebug then
                print('Has access to', item.name)
            end
        else
            if useDebug then
                print('Did not have access to', item.name)
            end
        end
        if useDebug then
            print("====================")
        end

    end
    return Recipes
end

RegisterCommand('nuiFocus', function(src, args)
    if args[1] == 'true' then SetNuiFocus(true, true)
    elseif args[1] == 'false' then SetNuiFocus(false, false) end
end)

local function handleCrafting(args)
    QBCore.Functions.TriggerCallback('cw-crafting:server:getMaxCraftingAmount', function(amount)
        if amount <= 0 then QBCore.Functions.Notify('You don\'t have enough materials to craft this!') lib.showContext('craftingCategory_'..args.category) return end
        local input = lib.inputDialog(args.data.label.." crafting", {{type = 'slider', label = 'Select Crafting Amount (Makes '..args.amount..' per)', default = 1, min = 1, max = amount, required = true}})
        if not input or not input[1] or not type(input[1]) == 'number' then return end
        print(type(input[1]))
        CurrentAmount = math.floor(input[1])
        craftItem(args, input[1])
    end, args)
end

local function setCraftingOpen(bool, i)
    local citizenId = QBCore.Functions.GetPlayerData().citizenid
    QBCore.Functions.TriggerCallback('cw-crafting:server:getBlueprints', function(bps)
        Blueprints = bps
        if useDebug then
            print('Crafting was opened')
        end
        --SetNuiFocus(bool, bool)
        if bool then
            currentTableType = i;
        else
            currentTableType = nil;
        end
        local recipes = getRecipes()
        print_table(recipes)
        local categories = {}
        for k, v in pairs(recipes) do
            if not v.category then v.category = "General" end
            if not categories[v.category] then categories[v.category] = {} end
            categories[v.category][k] = v
        end
        local options = {}
        for k, v in pairs(categories) do
            options[#options+1] = {title = k, onSelect = function()
                local o = {}
                for k_, v_ in pairs(v) do
                    if not v_.craftingTime then v_.craftingTime = 1000 end
                    if not v_.amount then v_.amount = 1 end
                    if v_.type == 'breakdown' then
                        local m = {}
                        for k__, v__ in pairs(v_.toMaterials) do
                            m[#m+1] = {label = v_.toMaterialsNameMap[k__], value = v__}
                        end
                        o[#o+1] = {
                            title = "Breakdown "..QBCore.Shared.Items[v_.name].label,
                            description = 'Needs '..v_.amount.." "..QBCore.Shared.Items[v_.name].label.." | Takes "..math.floor(v_.craftingTime/1000) .." sec. | Makes...",
                            image = "nui://ps-inventory/html/images/"..QBCore.Shared.Items[v_.name].image,
                            --icon = "nui://ps-inventory/html/images/"..QBCore.Shared.Items[v_.name].image,
                            onSelect = handleCrafting,
                            arrow = true,
                            args = v_,
                            metadata = m
                        }
                    else
                        local m = {}
                        for k__, v__ in pairs(v_.materials) do
                            m[#m+1] = {label = v_.materialsNameMap[k__], value = v__}
                        end
                        o[#o+1] = {
                            title = QBCore.Shared.Items[v_.name].label,
                            description = 'Makes : '..v_.amount.." | Takes "..math.floor(v_.craftingTime/1000) .." sec. | Needs...",
                            arrow = true,
                            image = "nui://ps-inventory/html/images/"..QBCore.Shared.Items[v_.name].image,
                            --icon = "nui://ps-inventory/html/images/"..QBCore.Shared.Items[v_.name].image,
                            onSelect = handleCrafting,
                            args = v_,
                            metadata = m
                        }
                    end
                end
                lib.registerContext({id = 'craftingCategory_'..k, title = k, options = o, menu = 'craftingMenu'})
                lib.showContext('craftingCategory_'..k)
            end}
        end
        lib.registerContext({id = 'craftingMenu', title = Config.CraftingTables[i].title, options = options })
        lib.showContext('craftingMenu')


        -- SendNUIMessage({
        --     action = "cwCrafting",
        --     toggle = bool
        -- })
    end)
end exports('setCraftingOpen', setCraftingOpen)

local function benchpermissions(jobTypes)
    local Player = QBCore.Functions.GetPlayerData()
    if jobTypes[Player.job.type] ~= nil then return true else return false end
end

RegisterNUICallback('attemptCrafting', function(recipe, cb)
    if isCrafting then
        QBCore.Functions.Notify("You're already crafting something", "error")
    else
        local Player = QBCore.Functions.GetPlayerData()
        local currentRecipe = Config.Recipes[recipe.currentRecipe]
        CurrentAmount = recipe.craftingAmount
        if useDebug then
            print(recipe.currentRecipe, dump(currentRecipe))
        end
        local success = craftItem(currentRecipe)
        cb(success)
    end
    cb(false)
end)

RegisterNUICallback('getRecipes', function(data, cb)
    if useDebug then
       print('Fetching recipes')
    end
    getRecipes()
    cb(Recipes)
end)


RegisterNUICallback('closeCrafting', function(_, cb)
    if useDebug then
        print('Closing crafting')
    end
    setCraftingOpen(false)
    cb('ok')
end)

RegisterNUICallback('getInventory', function(_, cb)
    cb(Config.Inventory)
end)

RegisterCommand('openCrafting', function(source, args)
if useDebug then
    print('Open crafting')
end
setCraftingOpen(true, args[1])
end)


local function createTable(type, benchType)
    local options = {}
    options[1] = {
        type = 'client',
        label = benchType.title,
        icon = "fas fa-wrench",
        action = function()
            setCraftingOpen(true, type)
        end,
        canInteract = function()
            if benchType.jobType ~= nil then
                return benchpermissions(benchType.jobType)
            else
                return true
            end
        end,
    }

    for j, benchProp in pairs(benchType.objects) do
        exports['qb-target']:AddTargetModel(benchProp, {
            options = options,
            distance = 2.0
        })
    end
    if benchType.locations then
        for j, benchLoc in pairs(benchType.locations) do
            exports['qb-target']:AddBoxZone('crafting-'..benchType.title..'-'..j, benchLoc, 1.5, 1.5, {
                name = 'crafting-'..benchType.title..'-'..j,
                heading = 0,
                debugPoly = useDebug,
                minZ = benchLoc.z - 0.5,
                maxZ = benchLoc.z + 0.5,
            }, {
                options = options,
                distance = 2.0
            })
        end
    end
    if benchType.spawnTable then
        for j, bench in pairs(benchType.spawnTable) do
            local benchEntity = CreateObject(bench.prop, bench.coords.x, bench.coords.y, bench.coords.z, false,  false, true)
            SetEntityHeading(benchEntity, bench.coords.w)
            FreezeEntityPosition(benchEntity, true)
            PlaceObjectOnGroundProperly(benchEntity)

            exports['qb-target']:AddTargetEntity(benchEntity, {
                options = options,
                distance = 2.0
            })
        end
    end
end exports("createTable", createTable)

CreateThread(function()
    for i, benchType in pairs(Config.CraftingTables) do
        createTable(i, benchType)
    end
end)

-- RegisterCommand('testcraft', function(_, args)
-- 	craftItem(Config.Recipes[args[1]])
-- end)


RegisterNetEvent('cw-crafting:client:toggleDebug', function(debug)
   print('Setting debug to',debug)
   useDebug = debug
end)

RegisterNetEvent('cw-crafting:client:progressbar', function()
    exports['rpemotes']:EmoteCommandStart('readblueprint')
    QBCore.Functions.Progressbar('learnbp', 'Studying text on blueprint', 5000, false, false, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        exports['rpemotes']:EmoteCancel()
        return true
        --Stuff goes here
    end,{})
end)

local function getAllBlueprints()
    local blueprints = {}
    local blueprintItem = 'blueprint'
    local PlayerData = QBCore.Functions.GetPlayerData()
    for i,item in pairs(PlayerData.items) do
        if item.name == blueprintItem then
            blueprints[item.info.value] = item
        end
    end
    return blueprints
end

local function hasBlueprint(input)
    if Config.Inventory == 'qb' then
        local bps = getAllBlueprints()
        for i,bp in pairs(bps) do
            if bp.info.value == input then
                return true
            end
        end
        return false
    elseif Config.Inventory == 'ox' then
        local blueprintItem = 'blueprint'

        local items = exports.ox_inventory:Search('count', blueprintItem, { value = input } )
        return items > 0
    end
end

local function generateBlueprintOptions(dude)
    local options = {}
    for name, blueprint in pairs(Config.Blueprints) do
        local dudeHasBlueprint = true
        if blueprint.type and dude.type and blueprint.type ~= dude.type then
            dudeHasBlueprint = false
        end
        if dudeHasBlueprint then
            options[#options+1] = {
                type = "server",
                event = "cw-crafting:server:addBlueprintFromLearning",
                bpName = name,
                icon = "fas fa-graduation-cap",
                gang = dude.gang,
                label = "Learn "..name,
                canInteract = function()
                    return hasBlueprint(name)
                end
            }
        end
    end
    return options
end

if Config.BlueprintDudes then
    CreateThread(function()
        for i, dude in pairs(Config.BlueprintDudes) do
            local animation
            if dude.animation then
                animation = dude.animation
            else
                animation = "WORLD_HUMAN_STAND_IMPATIENT"
            end

            QBCore.Functions.LoadModel(dude.model)
            local currentDude = CreatePed(0, dude.model, dude.coords.x, dude.coords.y, dude.coords.z-1.0, dude.coords.w, false, false)
            TaskStartScenarioInPlace(currentDude,  animation)
            FreezeEntityPosition(currentDude, true)
            SetEntityInvincible(currentDude, true)
            SetBlockingOfNonTemporaryEvents(currentDude, true)

            if Config.UseSundownUtils then
                exports['sundown-utils']:addPedToBanlist(currentDude)
            end

            local options = generateBlueprintOptions(dude)
            exports['qb-target']:AddTargetEntity(currentDude, {
                options = options,
                distance = 2.0
            })
        end
    end)
end

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