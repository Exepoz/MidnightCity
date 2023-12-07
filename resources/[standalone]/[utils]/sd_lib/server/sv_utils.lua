SD = SD or {}

-- Server Event to handle ox_doorlock or cd_doorlock doors.
RegisterNetEvent('sd_lib:doorToggle', function(data)
    local DoorIds = {}
    if data.type == 'ox' then
        for i, name in ipairs(data.doorNames) do
            DoorIds[i] = exports.ox_doorlock:getDoorFromName(name).id
        end

        local index = SD.utils.indexOf(data.doorNames, data.id)
        if index and DoorIds[index] then
            TriggerEvent('ox_doorlock:setState', DoorIds[index], data.locked and 1 or 0)
        end
    elseif data.type == 'cd' then
        TriggerClientEvent('cd_doorlock:SetDoorState_name', source, data.locked, data.id, data.location)
    end
end)

-- Server function to handle item data.
SD.utils.GetItemByName = function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    item = tostring(item):lower()

    local function GetFirstSlotByItem(items, itemName)
        if not items then return nil end
        for slot, item in pairs(items) do
            if item.name:lower() == itemName:lower() then
                return tonumber(slot)
            end
        end
        return nil
    end

    local slot = GetFirstSlotByItem(Player.PlayerData.items, item)
    return Player.PlayerData.items[slot]
end