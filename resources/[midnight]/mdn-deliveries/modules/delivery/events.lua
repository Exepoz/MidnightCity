local Midnight = exports['mdn-nighttime']:GetMidnightCore()

AddEventHandler("delivery:start_delivery", function(data)
    if data.job =='fence' then
        if not Midnight.Functions.IsNightTime() then
            QBCore.Functions.Notify('You can only do this at night...') return
        else
            data = lib.table.merge(data, KloudDev.Locations['fence'])
            SpawnedEntities.Ped[data.pedID] = data.entity
        end
    end
    _G.DeliveryData = data
    local input = lib.inputDialog('Chose Amount to Deliver', {{
                            type = 'select', label = 'Deliveries', description = 'Pay increases the more deliveries you do at a time.', required = true,
                            options = {
                                {value = '1', label = '1 Delivery'},
                                {value = '3', label = '3 Deliveries'},
                                {value = '5', label = '5 Deliveries'},
                            }
                        }})

    if not input then _G.DeliveryData = {} return end

    _G.DeliveryAmount = tonumber(input[1])

    if data.job ~= 'fence' then
        local current_stock = lib.callback.await("delivery:callback:get_current_stock", false, data)
        if current_stock < _G.DeliveryAmount then
            _G.DeliveryAmount = 0
            _G.DeliveryData = {}
            Notify(locale("no_stock"), "error")
            return
        end
    end

    local can_start = lib.callback.await("delivery:callback:can_start", false, data, _G.DeliveryAmount)
    if not can_start then
        _G.DeliveryAmount = 0
        _G.DeliveryData = {}
    return end

    _G.Busy = true
    local bag
    for i = 1, _G.DeliveryAmount do
        bag = CreateBag(SpawnedEntities.Ped[data.pedID], data.bag_model)
        PlayAnim(SpawnedEntities.Ped[data.pedID], "mp_common", "givetake1_b", 1600, true)
        PlayAnim(cache.ped, "mp_common", "givetake1_a", 1600, true)

        SetTimeout(1600, function()
            DeleteProp(bag)
            ClearPedTasks(cache.ped)
            ClearPedTasks(SpawnedEntities.Ped[data.pedID])
            if i == _G.DeliveryAmount then
                bag = CreateBag(cache.ped, data.bag_model)
            end
        end)

        Wait(2000)
    end

    if not Progress(2000, locale("requesting")) then
        _G.DeliveryAmount = 0
        _G.DeliveryData = {}
        return
    end
    DeleteProp(bag)
    _G.Busy = false
    TriggerServerEvent("delivery:server:start_delivery", data, _G.DeliveryAmount)
    StartDelivery(data)
    Notify(locale("delivery_started"), "success")
end)

AddEventHandler("delivery:client:bag_anim", function(hash)
    local dict = "move_weapon@jerrycan@generic"
    local clip = "idle"
    SpawnedEntities.Delivery_Prop[1] = CreateBag(cache.ped, hash)
    while true do
        Wait(500)
        if not _G.OnGoing then return end

        if IsPedInAnyVehicle(cache.ped, true) then
            ClearPedTasks(cache.ped)
            DeleteProp(SpawnedEntities.Delivery_Prop[1])
            SpawnedEntities.Delivery_Prop[1] = nil
        end

        if not IsEntityPlayingAnim(cache.ped, dict, clip, 3) and not IsPedInAnyVehicle(cache.ped, true) and not _G.Busy and not IsPedFalling(cache.ped) then
            PlayAnim(cache.ped, dict, clip, -1, true)
            if not SpawnedEntities.Delivery_Prop[1] then
                SpawnedEntities.Delivery_Prop[1] = CreateBag(cache.ped, hash)
            end
        end
    end
end)