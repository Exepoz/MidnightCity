local SD = exports['sd_lib']:getLib()

-- Function to get the colour
local function GetProgressColor(pourcentage, inverted)
    if inverted then
        if pourcentage > 75 then return '#2a9d8f' end
        if pourcentage > 50 then return '#e9c46a' end
        if pourcentage > 30 then return '#f4a261' end
        if pourcentage > 0 then return '#e63946' end
    end
    if pourcentage > 75 then return '#e63946' end
    if pourcentage > 50 then return '#f4a261' end
    if pourcentage > 30 then return '#e9c46a' end
    if pourcentage > 0 then return '#2a9d8f' end
end

-- [[ BEE HOUSE ]]
RegisterNetEvent('sd-beekeeping:openBeeHouse', function(data)
    local oData = data
    TriggerEvent('sd-beekeeping:resetMaintenance', data.id)
    lib.callback('sd-beekeeping:getHiveData', false, function(hData)
        local hiveData = json.decode(hData.data)
        local hiveOptions = {}
        if hiveData then
            if Beekeeping.LockedToOwner then
                local owner = hData.citizenid
                local citizenid = SD.GetIdentifier()
                if not owner then
                    SD.ShowNotification(Lang:t('notifications.owner_error'), 'error')
                    return
                end
                if tostring(citizenid) ~= tostring(owner) then
                    SD.ShowNotification(Lang:t('notifications.noaccess'), 'error')
                    return
                end
            end

            hiveOptions = {
                {
                    title = Lang:t('houses.capturing'),
                    icon = 'fa-solid fa-spinner fa-spin',
                    progress = (hiveData.time / Beekeeping.House.CaptureTime) * 100,
                },
                {
                    title = Lang:t('houses.queens', {currentQueens = hiveData.queens, maxQueens = Beekeeping.House.MaxQueens}),
                    icon = GetInventoryIcon(Beekeeping.Items.QueenItem),
                    progress = (hiveData.queens / Beekeeping.House.MaxQueens) * 100,
                    colorScheme = GetProgressColor((hiveData.queens / Beekeeping.House.MaxQueens) * 100),
                    arrow = true,
                    onSelect = function()
                        if hiveData.queens <= 0 then TriggerEvent('sd-beekeeping:openBeeHouse', oData) SD.ShowNotification(Lang:t('notifications.not_enough_bees'), 'error') return end
                        WithdrawBeeDialog(data.id, 'queens', hiveData.queens, oData)
                    end
                },
                {
                    title = Lang:t('houses.workers', {currentWorkers = hiveData.workers, maxWorkers = Beekeeping.House.MaxWorkers}),
                    icon = GetInventoryIcon(Beekeeping.Items.WorkerItem),
                    progress = (hiveData.workers / Beekeeping.House.MaxWorkers) * 100,
                    colorScheme = GetProgressColor((hiveData.workers / Beekeeping.House.MaxWorkers) * 100),
                    arrow = true,
                    onSelect = function()
                        if hiveData.workers <= 0 then TriggerEvent('sd-beekeeping:openBeeHouse', oData) SD.ShowNotification(Lang:t('notifications.not_enough_bees'), 'error') return end
                        WithdrawBeeDialog(data.id, 'workers', hiveData.workers, oData)
                    end
                },
                {
                    title = Lang:t('houses.destroy'),
                    icon = 'fa-solid fa-trash',
                    onSelect = function()
                        OpenDeleteConfirmDialog(data.id, oData, 'house', Lang:t('houses.confirm_destroy'))
                    end
                },
                {
                    title = Lang:t('houses.refresh'),
                    icon = 'fa-solid fa-rotate',
                    event = 'sd-beekeeping:openBeeHouse',
                    args = oData,
                },
            }
        else
            hiveOptions = {{
                title = Lang:t('notifications.title'),
                description = Lang:t('notifications.house_error'),
                icon = 'fa-solid fa-ban'
            }}
        end

        lib.registerContext({
            id = 'sdbeekeeping_house_menu',
            title = Lang:t('houses.title'),
            options = hiveOptions,
        })

        lib.showContext('sdbeekeeping_house_menu')
    end, data.id)
end)

function WithdrawBeeDialog(id, type, max, originalData)
    lib.hideContext()
    local title
    if type == 'queens' then title = Lang:t('houses.withdraw_queens')
    elseif type == 'workers' then title = Lang:t('houses.withdraw_workers') end

    local input = lib.inputDialog(title, {
        {
            type = 'slider',
            min = 1,
            max = max,
            step = 1,
            icon = 'fa-solid fa-hashtag'
        }
    })

    if input then
        TriggerServerEvent('sd-beekeeping:withdrawBee', id, type, input[1])
        Wait(50)
        TriggerEvent('sd-beekeeping:openBeeHouse', originalData)
    end
end

function OpenDeleteConfirmDialog(id, originalData, type, header)
    lib.hideContext()
    local confirmed = lib.alertDialog({
        header = header,
        centered = true,
        cancel = true,
        size = 'md'
    })
    
    local event = 'sd-beekeeping:openBeeHouse'
    if type == 'hive' then event = 'sd-beekeeping:openBeeHive' end
    if confirmed == 'cancel' then TriggerEvent(event, originalData)
    elseif confirmed == 'confirm' then TriggerServerEvent('sd-beekeeping:removeStructure', id) end
end

-- [[ BEE HIVE ]]
RegisterNetEvent('sd-beekeeping:openBeeHive', function(data)
    local originalData = data
    TriggerEvent('sd-beekeeping:resetMaintenance', data.id)
    lib.callback('sd-beekeeping:getHiveData', false, function(hData)
        local hiveData = json.decode(hData.data)
        local hiveOptions = {}

        if hiveData then
            if Beekeeping.LockedToOwner then
                local owner = hData.citizenid
                local citizenid = SD.GetIdentifier()
                if not owner then
                    SD.ShowNotification(Lang:t('notifications.owner_error'), 'error')
                    return
                end
                if tostring(citizenid) ~= tostring(owner) then
                    SD.ShowNotification(Lang:t('notifications.noaccess'), 'error')
                    return
                end
            end

            hiveOptions[#hiveOptions+1] = {
                title = Lang:t('hives.producing'),
                icon = 'fa-solid fa-spinner fa-spin',
                progress = (hiveData.time / Beekeeping.Hives.HoneyTime) * 100
            }

            if not hiveData.haveQueen then
                hiveOptions[#hiveOptions+1] = {
                    title = Lang:t('hives.insert_queens', {needed = Beekeeping.Hives.NeededQueens}),
                    icon = GetInventoryIcon(Beekeeping.Items.QueenItem),
                    onSelect = function()
                        TriggerServerEvent('sd-beekeeping:insertQueen', data.id)
                    end
                }
            end

            if hiveData.haveQueen and not hiveData.haveWorker then
                hiveOptions[#hiveOptions+1] = {
                    title = Lang:t('hives.insert_workers', {needed = Beekeeping.Hives.NeededWorkers}),
                    icon = GetInventoryIcon(Beekeeping.Items.WorkerItem),
                    onSelect = function()
                        TriggerServerEvent('sd-beekeeping:insertWorker', data.id)
                    end
                }
            end

            if hiveData.haveQueen and hiveData.haveWorker then
                hiveOptions[#hiveOptions+1] = {
                    title = Lang:t('hives.honey_level', {currentHoney = hiveData.honey, maxHoney = Beekeeping.Hives.MaxHoney}),
                    icon = GetInventoryIcon(Beekeeping.Items.HoneyItem),
                    progress = (hiveData.honey / Beekeeping.Hives.MaxHoney) * 100,
                    colorScheme = GetProgressColor((hiveData.honey / Beekeeping.Hives.MaxHoney) * 100),
                    arrow = true,
                    onSelect = function()
                        if hiveData.honey <= 0 then TriggerEvent('sd-beekeeping:openBeeHive', originalData) SD.ShowNotification(Lang:t('notifications.not_enough_product'), 'error') return end
                        WithdrawProductDialog(data.id, 'honey', hiveData.honey, originalData)
                    end
                }
            end

            if hiveData.haveQueen and hiveData.haveWorker then
                hiveOptions[#hiveOptions+1] = {
                    title = Lang:t('hives.wax_level', {currentWax = hiveData.wax, maxWax = Beekeeping.Hives.MaxWax}),
                    icon = GetInventoryIcon(Beekeeping.Items.WaxItem),
                    progress = (hiveData.wax / Beekeeping.Hives.MaxWax) * 100,
                    colorScheme = GetProgressColor((hiveData.wax / Beekeeping.Hives.MaxWax) * 100),
                    arrow = true,
                    onSelect = function()
                        if hiveData.wax <= 0 then TriggerEvent('sd-beekeeping:openBeeHive', originalData) SD.ShowNotification(Lang:t('notifications.not_enough_product'), 'error') return end
                        WithdrawProductDialog(data.id, 'wax', hiveData.wax, originalData)
                    end
                }
            end

            hiveOptions[#hiveOptions+1] = {
                title = Lang:t('hives.destroy'),
                icon = 'fa-solid fa-trash',
                onSelect = function()
                    OpenDeleteConfirmDialog(data.id, originalData, 'hive', Lang:t('hives.confirm_destroy'))
                end
            }

            hiveOptions[#hiveOptions+1] = {
                title = Lang:t('hives.refresh'),
                icon = 'fa-solid fa-rotate',
                onSelect = function()
                    TriggerEvent('sd-beekeeping:openBeeHive', originalData)
                end
            }
        else
            hiveOptions = {{
                title = Lang:t('notifications.title'),
                description = Lang:t('notifications.hive_error'),
                icon = 'fa-solid fa-ban'
            }}
        end

        lib.registerContext({
            id = 'sdbeekeeping_hive_menu',
            title = Lang:t('hives.title'),
            options = hiveOptions,
        })

        lib.showContext('sdbeekeeping_hive_menu')
    end, data.id)
end)

function WithdrawProductDialog(id, type, max, originalData)
    lib.hideContext()
    local title
    if type == 'honey' then title = Lang:t('hives.withdraw_honey')
    elseif type == 'wax' then title = Lang:t('hives.withdraw_wax') end

    local input = lib.inputDialog(title, {
        {
            type = 'slider',
            min = 1,
            max = max,
            step = 1,
            icon = 'fa-solid fa-hashtag'
        }
    })

    if input then
        TriggerServerEvent('sd-beekeeping:withdrawProduct', id, type, input[1])
        Wait(50)
        TriggerEvent('sd-beekeeping:openBeeHive', originalData)
    end
end