SD = SD or {}
SD.menu = SD.menu or {}

local properties = nil
local headerShown = false
local sendData = nil

-- Event Handler
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
    Wait(1000)
    if not lib then
        SendNUIMessage({
            action = "SET_STYLE",
            data = "default"
        })
    end
end)

-- Net Events
RegisterNetEvent('sd_bridge:onPlayerLoaded', function()
    SendNUIMessage({
        action = "SET_STYLE",
        data = "default"
    })
end)

RegisterNetEvent('sd_bridge:client:OpenMenuList', function(data)
    SD.menu.OpenMenuList(data)
end)

RegisterNetEvent('sd_bridge:client:CloseMenuList', function()
    SD.menu.CloseMenuList()
end)

-- NUI Callbacks
RegisterNUICallback("buttonSubmit", function(data, cb)
    SetNuiFocus(false)
    if properties ~= nil then
        properties:resolve(data.data)
        properties = nil
    end
    cb("ok")
end)

RegisterNUICallback("closeMenu", function(_, cb)
    SetNuiFocus(false)
    if properties ~= nil then
        properties:resolve(nil)
        properties = nil
    end
    cb("ok")
end)

RegisterNUICallback('clickedButton', function(option, cb)
    if headerShown then headerShown = false end
    PlaySoundFrontend(-1, 'Highlight_Cancel', 'DLC_HEIST_PLANNING_BOARD_SOUNDS', 1)
    SetNuiFocus(false)
    if sendData then
        local data = sendData[tonumber(option)]
        sendData = nil
        if data then
            if data.params.event then
                if data.params.isServer then
                    TriggerServerEvent(data.params.event, data.params.args)
                elseif data.params.isCommand then
                    ExecuteCommand(data.params.event)
                elseif data.params.isAction then
                    data.params.event(data.params.args)
                else
                    TriggerEvent(data.params.event, data.params.args)
                end
            end
        end
    end
    cb('ok')
end)

RegisterNUICallback('CloseMenuList', function(_, cb)
    headerShown = false
    sendData = nil
    SetNuiFocus(false)
    cb('ok')
    TriggerEvent("sd_bridge:client:menuClosed")
end)

function SD.menu.ShowInput(data)
    Wait(150)
    if not data then return end

    if lib ~= nil and Config.OxLibSettings.EnableMenus then
        local options = {
            allowCancel = true,
            rows = {
                {
                    type = "input",
                    label = data.label or "",
                    placeholder = data.placeholder or "",
                    default = data.default or "",
                    required = data.required or false,
                    disabled = data.disabled or false
                }
            }
        }
        local libResult = lib.inputDialog(data.header or "", options.rows, options)
        return {method = "lib", result = libResult}
    else
        if properties then return end
        properties = promise.new()
        SetNuiFocus(true, true)
        SendNUIMessage({ action = "OPEN_MENU", data = data })
        local nuiResult = Citizen.Await(properties)
        return {method = "nui", result = nuiResult}
    end
end

function SD.menu.OpenMenuList(data)
    if lib ~= nil and Config.OxLibSettings.EnableMenus then
        local contextData = {
            id = "menuList",
            title = "Menu List",
            canClose = true,
            options = {}
        }

        for i, item in ipairs(data) do
            local option = {
                title = item.header or "Unnamed", 
                description = item.txt or nil,   
                icon = item.icon or nil,
                onSelect = function()
                    if item.params.event then
                        TriggerEvent(item.params.event, item.params.args or {})
                    end
                end
            }

            table.insert(contextData.options, option)
        end

        lib.registerContext(contextData)

        -- Display the registered context menu
        lib.showContext("menuList")
    else
        if not data or not next(data) then return end
        SetNuiFocus(true, true)
        headerShown = false
        sendData = data
        SendNUIMessage({
            action = 'OPEN_MENULIST',
            data = table.clone(data)
        })
    end
end

function SD.menu.CloseMenuList()
    if lib ~= nil and Config.OxLibSettings.EnableMenus then
        lib.closeInputDialog()
    else
        sendData = nil
        headerShown = false
        SetNuiFocus(false)
        SendNUIMessage({
            action = 'CLOSE_MENU'
        })
    end
end

function SD.menu.ShowHeader(data)
    if not data or not next(data) then return end
    headerShown = true
    sendData = data
    SendNUIMessage({
        action = 'SHOW_HEADER',
        data = table.clone(data)
    })
end

-- Command and Keymapping
RegisterCommand('sd-playerfocus', function()
    if headerShown then
        SetNuiFocus(true, true)
    end
end)

RegisterKeyMapping('sd-playerFocus', 'Give Menu Focus', 'keyboard', 'LMENU')