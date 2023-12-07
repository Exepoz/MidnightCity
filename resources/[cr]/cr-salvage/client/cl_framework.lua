SCUtils = {}
local PlayerLoaded = ""
local ScrapyardBlip
if Config.Framework.Framework == "QBCore" then
    QBCore = nil
    QBCore = exports['qb-core']:GetCoreObject()
    PlayerLoaded = "QBCore:Client:OnPlayerLoaded"
elseif Config.Framework.Framework == "ESX" then
    ESX = exports['es_extended']:getSharedObject()
    PlayerLoaded = "esx:playerLoaded"
end

local function onEnter()
    TriggerEvent('cr-salvage:client:EnteringScrapyard')
end


local function onExit()
    TriggerEvent('cr-salvage:client:LeavingScrapyard')
end

local function InsideScrapyard()
    --if Config.Debug then print("Inside "..Lcl('ScrapyardBlipName')) end
end

if Config.Framework.PolyZone == "PolyZone" then
    ScrapyardArea = PolyZone:Create(Config.ScrapyardArea.PolyZoneArea, {name = Config.ScrapyardArea.label, debugPoly = Config.DebugPoly, minZ = Config.ScrapyardArea.minZ, maxZ = Config.ScrapyardArea.maxZ})
    ScrapyardArea:onPlayerInOut(function(isPointInside) if isPointInside then onEnter() else onExit() end end)
elseif Config.Framework.PolyZone == "oxlib" then
    lib.zones.poly({points = Config.ScrapyardArea.OxLibArea, thickness = 60, onEnter = onEnter, onExit = onExit, inside = InsideScrapyard, debug = Config.DebugPoly})
end

RegisterNetEvent(PlayerLoaded, function()
    Wait(5000)
    if not Config.Framework.Interaction.UseTarget then InteractionsDistanceCheck() end
    if Config.WorldWrecks['plane'].onSpawnEvent then
        CreatePedAtCoords('a_m_y_business_02', Config.FlightBox.HandInCoords)
        SetupFlightBoxTarget()
    end
    if Config.EmailDataBase then TriggerServerEvent('cr-salvage:server:EmailCheck') end
    if Config.SalvageYardBlip then
        ScrapyardBlip = AddBlipForCoord(Config.ScrapyardPed.Coords.xyz)
        SetBlipSprite(ScrapyardBlip, 527)
        SetBlipColour(ScrapyardBlip, 31)
        AddTextEntry('ScrapyardBlip', Lcl("ScrapyardBlipName"))
        BeginTextCommandSetBlipName('ScrapyardBlip')
        EndTextCommandSetBlipName(ScrapyardBlip)
        SetBlipScale(ScrapyardBlip, 0.7)
        SetBlipAsShortRange(ScrapyardBlip, true)
    end
    Wait(3000)
    if GlobalState.CRSalvage.WorldWreckActive then
        TriggerEvent('cr-salvage:client:SpawnWW', GlobalState.CRSalvage.WorlWreckType, GlobalState.CRSalvage.WorldWreckLocation)
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(100)
        SCUtils.SalvageDrawText(false)
        if not Config.Framework.Interaction.UseTarget then InteractionsDistanceCheck() end
        if Config.WorldWrecks['plane'].onSpawnEvent then
            CreatePedAtCoords('a_m_y_business_02', Config.FlightBox.HandInCoords)
            SetupFlightBoxTarget()
        end
        if Config.EmailDataBase then TriggerServerEvent('cr-salvage:server:EmailCheck') end
        if Config.SalvageYardBlip then
            ScrapyardBlip = AddBlipForCoord(Config.ScrapyardPed.Coords.xyz)
            SetBlipSprite(ScrapyardBlip, 527)
            SetBlipColour(ScrapyardBlip, 31)
            AddTextEntry('ScrapyardBlip', Lcl("ScrapyardBlipName"))
            BeginTextCommandSetBlipName('ScrapyardBlip')
            EndTextCommandSetBlipName(ScrapyardBlip)
            SetBlipScale(ScrapyardBlip, 0.7)
            SetBlipAsShortRange(ScrapyardBlip, true)
        end
    end
end)

-- Email
--- If using npwd phone, the notification is a system message with an accept button.
function SCUtils.SalvageEmails()
    local PhoneType
    local sender
    local subject
    local message
    local buttomMessage = Lcl('email_button')
    local phone = Config.Framework.Phone
    local button = {}
    if phone == "qb" then
        PhoneType = 'qb-phone:server:sendNewMail'
        button = {buttonEvent = 'cr-salvage:client:GrabEmailBlip', buttonname = buttomMessage}
    elseif phone == "gks" then
        PhoneType = 'gksphone:NewMail'
        button = {buttonEvent = 'cr-salvage:client:GrabEmailBlip', buttonname = buttomMessage}
    elseif phone == "qs" then
        PhoneType = 'qs-smartphone:server:sendNewMail'
        button = {enabled = true, buttonEvent = 'cr-salvage:client:GrabEmailBlip'}
    end
	sender = Lcl('interact_pedname') subject = Lcl('email_subject')
	message = Lcl('email_message')
    if PhoneType then
        TriggerServerEvent(PhoneType, {
            sender = sender,
            subject = subject,
            message = message,
            button = button
        })
    elseif phone == "npwd" then
        exports["npwd"]:createSystemNotification({
            uniqId = "salvageEmail",
            content = Lcl('email_notification'),
            secondaryTitle = Lcl('email_subject'),
            keepOpen = true,
            duration = 5000,
            controls = true,
            onConfirm = function()
              TriggerEvent('cr-salvage:client:GrabEmailBlip')
            end,
          })
    end
end

-- DrawText Function
---@param bool boolean - true = Displays DrawText | False = Removes Current DrawText
---@param text? string - Message shown
function SCUtils.SalvageDrawText(bool, text)
	if bool then
        if Config.Framework.DrawText == "oxlib" and text then lib.showTextUI(text)
		elseif Config.Framework.DrawText == 'okok' then exports['okokTextUI']:Open(text, 'darkblue', 'right')
        elseif Config.Framework.DrawText == "PSUI" then exports['ps-ui']:DisplayText(text, "primary")
		elseif Config.Framework.Framework == 'QBCore' then exports['qb-core']:DrawText(text, 'right')
        elseif Config.Framework.Framework == "ESX" then exports['esx_textui']:TextUI(text)
		end
	else
        if Config.Framework.DrawText == "oxlib" then lib.hideTextUI()
		elseif Config.Framework.DrawText == 'okok' then exports['okokTextUI']:Close()
        elseif Config.Framework.DrawText == "PSUI" then exports['ps-ui']:HideText()
		elseif Config.Framework.Framework == 'QBCore' then exports['qb-core']:HideText()
        elseif Config.Framework.Framework == "ESX" then exports['esx_textui']:HideUI()
        end
	end
end

-- Item Check Function
---@param item string - Item Looked For
---@return boolean 
function SCUtils.HasItem(item)
    local hasItem
    local cb
    if Config.Framework.UseOxInv then
        local count = exports.ox_inventory:Search('count', item)
        if count >=1 then hasItem = true end
    elseif Config.Framework.Framework == "QBCore" then
        hasItem = QBCore.Functions.HasItem(item)
    elseif Config.Framework.Framework == "ESX" then
        cb = true
        ESX.TriggerServerCallback('cr-salvage:server:HasItem', function(HasItem)
            hasItem = HasItem
            cb = false
        end, item)
    else
        print(Lcl('debug_standalonefunction'))
    end
    while cb do Wait(0) end
    return hasItem
end

-- Show Missing Item (Only works for QBcore inventories (qb/lj-inventory))
---@param item string -Item Name for Item Displayed 
function SCUtils.MissingItem(item)
    if Config.Framework.Framework ~= "QBCore" then return end
    local data = {[1] = {name = QBCore.Shared.Items[item]["name"], image = QBCore.Shared.Items[item]["image"]}}
    Wait(250)
    TriggerEvent('inventory:client:requiredItems', data, true)
    Wait(2500)
    TriggerEvent('inventory:client:requiredItems', data, false)
end

-- Client-Sided Notification Matrix
---@param notifType number - Notification Type (1 = Success, 2 = Info, 3 = Failure)
---@param message string - Message Sent
---@param title string - Message Title (If Applicable)
function SCUtils.SalvageNotif(notifType, message, title)
    local notif = Config.Framework.Notifications
    local nType = ''
    local oxType = 'inform'
    if notifType == 1 then nType = "success" oxType = "success"
    elseif notifType == 2 then
        if notif == "qb" or notif == "tnj" then nType = "primary"
        elseif notif == "okok" or notif == "ESX" then nType = "info"
        elseif notif == "mythic" then nType = "inform" end
    elseif notifType == 3 then nType = "error" oxType = "error"
    end

	if notif == "okok" then exports['okokNotify']:Alert(title, message, 3000, nType)
	elseif notif == "mythic" then exports['mythic_notify']:DoHudText(nType, message)
	elseif notif == 'chat' then TriggerEvent('chatMessage', message)
	elseif notif == "tnj" then exports['tnj-notify']:Notify(message, nType, 3000)
    elseif notif == "oxlib" then lib.notify({title = title, description = message, type = oxType})
    elseif notif == 'qb' then QBCore.Functions.Notify(message, nType)
    elseif notif == "ESX" then ESX.ShowNotification(message, nType, 3000)
--luacheck: push ignore
	elseif notif == 'other' then
		--You can add any notification system here.
	end
--luacheck: pop
end

RegisterNetEvent('cr-salvage:client:SalvageNotify', function(notifType, message, title)
    SCUtils.SalvageNotif(notifType, message, title)
end)

RegisterNetEvent('cr-salvage:client:selectbuyamount', function(data, amount)
    local dialog = {}
    local wait
    local item
    if type(data) == "table" then item = data.item if data.amount then dialog.amount = data.amount end
    else item = data if amount then dialog.amount = amount end end
    if not dialog.amount then
        if Config.Framework.Input == "oxlib" then
            local label = Lcl('shop_selectamount')
            local txt = Lcl("shop_amount")
            local input = lib.inputDialog(label, {{ type = "number", label = txt, default = 1 }})
            if not input then SCUtils.SalvageNotif(3, Lcl('shop_invalidAmount'), Lcl('salvagetitle')) return end
            dialog.amount = input[1]
        elseif Config.Framework.Framework == "QBCore" then
            dialog = exports['qb-input']:ShowInput({ header = Lcl('shop_selectamount'), submitText = Lcl('shop_buy'),
                inputs = { { text = Lcl("shop_amount"), name = 'amount', type = 'number', isRequired = true }}
            })
        elseif Config.Framework.Framework == "ESX" then
            wait = true
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuDiag', { title = Lcl('shop_selectamount') },
            function(menuData, menu)
                dialog.amount = menuData.value
                wait = false
                menu.close()
            end, function(_, menu) menu.close() end)
        end
    end
    while wait and not dialog.amount do
        Wait(1)
    end
    if not dialog.amount then return end
    if tonumber(dialog.amount) > 0 then TriggerServerEvent('cr-salvage:server:buyItem', item, tonumber(dialog.amount))
    else SCUtils.SalvageNotif(3, Lcl('shop_invalidAmount'), Lcl('salvagetitle')) end
end)

RegisterNetEvent('cr-salvage:client:talktoped', function(data)
    if Config.DrawText == 'qb' then exports['qb-core']:HideText()
    elseif Config.DrawText == 'okok' then exports['okokTextUI']:Close() end
    local email = 'interact_disableemailnotif'
    if LocalPlayer.state.cr_salvage_emails then email = 'interact_getemailnotif' end
    local ScrapyardPedMenu
    if Config.Framework.Menu == "oxlib" then
        lib.registerMenu({
            id = "talktopedmenu", title = Lcl('interact_pedname'), position = "top-right",
            options = {
                { label = Lcl('interact_scrapyardtutorial'), icon = 'far fa-question-circle', args = { ped = data.ped, page = 1 }},
                { label = Lcl('interact_scrapyardshop'), icon = "fas fa-dollar-sign", args = { ped = data.ped, page = 1 }},
                { label = Lcl(email), icon = "fas fa-envelope",},
                { label = Lcl('exit'), icon = 'fas fa-sign-out-alt', close = true}
            },
            canClose = true
        },
        function(selected, _, args)
            if selected == 1 then
                TriggerEvent('cr-salvage:client:tutorial', args)
            elseif selected == 2 then
                TriggerEvent('cr-salvage:client:buy', args)
            elseif selected == 3 then
                TriggerEvent('cr-salvage:client:emailnotification', args)
            end
        end)
        lib.showMenu('talktopedmenu')
    elseif Config.Framework.Menu == "nh-context" then
        ScrapyardPedMenu = {
            { header = Lcl('interact_pedname'), disabled = true},
            {
                header = Lcl('interact_scrapyardtutorial'),
                icon = 'far fa-question-circle',
                event = 'cr-salvage:client:tutorial', args = { 1 }
            },
            {
                header = Lcl('interact_scrapyardshop'),
                icon = "fas fa-dollar-sign",
                event = "cr-salvage:client:buy", args = { data, 1 }
            },
            {
                header = Lcl(email),
                icon = "fas fa-envelope",
                event = "cr-salvage:client:emailnotification"
            },
            {
                header = Lcl('exit'),
                icon = 'fas fa-sign-out-alt',
                event = 'nh-context:cancelMenu'
            }
        }
        TriggerEvent('nh-context:createMenu', ScrapyardPedMenu)
    elseif Config.Framework.Framework == 'QBCore' then
        ScrapyardPedMenu = {
            { header = Lcl('interact_pedname'), isMenuHeader = true},
            {
                header = Lcl('interact_scrapyardtutorial'),
                icon = 'far fa-question-circle',
                params = { event = 'cr-salvage:client:tutorial', args = { ped = data.ped, page = 1 } }
            },
            {
                header = Lcl('interact_scrapyardshop'),
                icon = "fas fa-dollar-sign",
                params = { event = "cr-salvage:client:buy", args = { ped = data.ped, page = 1 } }
            },
            {
                header = Lcl(email),
                icon = "fas fa-envelope",
                params = { event = "cr-salvage:client:emailnotification" }
            },
            {
                header = Lcl('exit'),
                icon = 'fas fa-sign-out-alt',
                params = { event = 'qb-menu:client:closeMenu' }
            }
        }
        exports['qb-menu']:openMenu(ScrapyardPedMenu)
    elseif Config.Framework.Framework == "ESX" then
        local elems = {
            {label = Lcl('interact_scrapyardtutorial'), value = 'tutorial'},
            {label = Lcl('interact_scrapyardshop'), value = 'shop'},
            {label = Lcl(email), value = 'email'},
            {label = Lcl('exit'), value = 'close'},
        }
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ScrapyardMenu', {
            title = Lcl('interact_pedname'),
            elements = elems
        }, function(menuData, menu)
            if menuData.current.value == 'tutorial' then
                TriggerEvent('cr-salvage:client:tutorial', {ped = data.ped, page = 1})
            elseif menuData.current.value == 'shop' then
                TriggerEvent('cr-salvage:client:buy', {ped = data.ped, page = 1})
            elseif menuData.current.value == 'email' then
                TriggerEvent('cr-salvage:client:emailnotification')
            elseif menuData.current.value == 'close' then
                menu.close()
            end
        end, function(_, menu) menu.close() end)
    else
        print(Lcl("debug_menuconfigerror"))
    end
end)

RegisterNetEvent('cr-salvage:client:buyamount', function(data, name)
    if name then if name == Config.PowerSawItem or name == Config.SawBladePackItem then TriggerServerEvent('cr-salvage:server:buyItem', data, 1) return end end
    if type(data) == "table" then if data.name == Config.PowerSawItem or data.name == Config.SawBladePackItem then TriggerServerEvent('cr-salvage:server:buyItem', data.item, 1) return end end
    local ScrapyardShop
    if Config.Framework.Menu == "oxlib" then
        lib.registerMenu({
            id = "buyamountmenu", title = Lcl('shop_label'), position = "top-right",
            options = {
                { label = Lcl('shop_buyone'), icon = 'fas fa-dollar-sign', args = { item = data.item, amount = 1 }},
                { label = Lcl('shop_selectamount'), icon = "fas fa-list-ol", args = { item = data.item, }},
                { label = Lcl('goback'), icon = 'fas fa-arrow-left'}
            },
            canClose = true
        },
        function(selected, _, args)
            if selected == 1 or selected == 2 then
                TriggerEvent('cr-salvage:client:selectbuyamount', args)
            elseif selected == 3 then
                TriggerEvent('cr-salvage:client:buy')
            end
        end)
        lib.showMenu('buyamountmenu')
    elseif Config.Framework.Menu == "nh-context" then
        ScrapyardShop = {
            { header = Lcl('shop_label'), disabled = true },
            {
                header = Lcl('shop_buyone'),
                event = 'cr-salvage:client:selectbuyamount', args = {data, 1}
            },
            {
                header = Lcl('shop_selectamount'),
                event = 'cr-salvage:client:selectbuyamount', args = {data}
            },
            {
                header = Lcl('goback'),
                event = "cr-salvage:client:buy"
            }
        }
        TriggerEvent('nh-context:createMenu', ScrapyardShop)
    elseif Config.Framework.Framework == "QBCore" then
        ScrapyardShop = {
            { header = Lcl('shop_label'), isMenuHeader = true },
            {
                header = Lcl('shop_buyone'),
                icon = 'fas fa-dollar-sign',
                params = { event = 'cr-salvage:client:selectbuyamount', args = { item = data.item, amount = 1 } }
            },
            {
                header = Lcl('shop_selectamount'),
                icon = 'fas fa-list-ol',
                params = { event = 'cr-salvage:client:selectbuyamount', args = { item = data.item, } }
            },
            {
                header = Lcl('goback'),
                icon = "fas fa-arrow-left",
                params = { event = "cr-salvage:client:buy" }
            }
        }
        exports['qb-menu']:openMenu(ScrapyardShop)
    elseif Config.Framework.Framework == "ESX" then
        local elems = {
            {label = Lcl('shop_buyone'), value = 'buy'},
            {label = Lcl('shop_selectamount'), value = 'select'},
            {label = Lcl('goback'), value = 'close'},
        }
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ScrapyardMenu', {
            title = Lcl('shop_label'),
            elements = elems
        }, function(menuData, _)
            if menuData.current.value == 'buy' then
                TriggerEvent('cr-salvage:client:selectbuyamount', { item = data.item, amount = 1 })
            elseif menuData.current.value == 'select' then
                TriggerEvent('cr-salvage:client:selectbuyamount', { item = data.item, })
            elseif menuData.current.value == 'close' then
                TriggerEvent('cr-salvage:client:buy')
            end
        end, function(_, menu) menu.close() end)
    else
        print(Lcl("debug_menuconfigerror"))
    end
end)

RegisterNetEvent('cr-salvage:client:buy', function()
    local ScrapyardShop
    if Config.Framework.Menu == "oxlib" then
        local options = {}
        for k, v in pairs(GlobalState.CRSalvage.ShopItems) do
            local text = Lcl('shop_itemdescription', v.price, v.stock)
            options[#options+1] = {label = v.itemlabel, description = text, args = { item = k, name = v.name } }
        end
        options[#options+1] = {label = Lcl('exit'), icon = 'fas fa-sign-out-alt', close = true}
        lib.registerMenu({
            id = "buymenu", title = Lcl('shop_label'), position = "top-right",
            options = options,
            canClose = true
        },
        function(selected, _, args)
            if selected ~= #options then
                TriggerEvent('cr-salvage:client:buyamount', args)
            end
        end)
        lib.showMenu('buymenu')
    elseif Config.Framework.Menu == "nh-context" then
        ScrapyardShop = {{ header = Lcl('shop_label'), disabled = true }}
        for k, v in pairs(GlobalState.CRSalvage.ShopItems) do
            local text = Lcl('shop_itemdescription', v.price, v.stock)
            ScrapyardShop[#ScrapyardShop+1] = { header = v.itemlabel, context = text, event = 'cr-salvage:client:buyamount', args = { k, v.name } }
        end
        ScrapyardShop[#ScrapyardShop+1] = { header = Lcl('exit'), event = 'nh-context:cancelMenu' }
        TriggerEvent('nh-context:createMenu', ScrapyardShop)
    elseif Config.Framework.Framework == "QBCore" then
        ScrapyardShop = {{ header = "<img src=https://i.imgur.com/WeHwUhM.png width=200.0rem>", isMenuHeader = true }}
        for k, v in pairs(GlobalState.CRSalvage.ShopItems) do
            local text = Lcl('shop_itemdescription', v.price, v.stock)
            ScrapyardShop[#ScrapyardShop+1] = { header = v.itemlabel, txt = text, icon = v.name, params = { event = 'cr-salvage:client:buyamount', args = { item = k, name = v.name }}}
        end
        ScrapyardShop[#ScrapyardShop+1] = {header = Lcl('exit'), icon = 'fas fa-sign-out-alt', params = { event = 'qb-menu:client:closeMenu' }}
        exports['qb-menu']:openMenu(ScrapyardShop)
    elseif Config.Framework.Framework == "ESX" then
        local elems = {}
        for k, v in pairs(GlobalState.CRSalvage.ShopItems) do
            local text = v.itemlabel.." ("..Lcl('shop_itemdescription', v.price, v.stock)..")"
            elems[#elems+1] = {label = text, value = "item", args = { item = k, name = v.name }}
        end
        elems[#elems+1] = {label = Lcl('exit'), value = "close"}
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'BuyMenu', {
            title = Lcl('shop_label'),
            elements = elems
        }, function(menuData, menu)
            if menuData.current.value == 'close' then
                menu.close()
            elseif menuData.current.value == 'item' then
                TriggerEvent('cr-salvage:client:buyamount', menuData.current.args)
            end
        end, function(_, menu) menu.close() end)
    else
        print(Lcl("debug_menuconfigerror"))
    end
end)

RegisterNetEvent('cr-salvage:client:tutorial', function(data)
    if Config.Framework.Menu == "oxlib" then
        if data.page == 0 then data.page = 1 end
        if data.page == 6 then return end
        lib.registerMenu({
            id = "tutorialmenu", title = Lcl('tutorial_title'), position = "top-right",
            options = {
                { label = Lcl('tutorial_'..tostring(data.page)), args = { page = data.page + 1 }, description = Lcl('tutorial_clicktocontinue')},
                { label = Lcl('goback'), icon = 'fa-solid fa-rotate-left', args = { page = data.page - 1 }},
                { label = Lcl('exit'), icon = 'fas fa-sign-out-alt', close = true}
            },
            canClose = true
        },
        function(selected, _, args)
            if selected ~= 3 then
                TriggerEvent('cr-salvage:client:tutorial', args)
            end
        end)
        lib.showMenu('tutorialmenu')
    elseif Config.Framework.Menu == "nh-context" then
        if type(data) == "table" then data = data.page end
        if data == 0 then data = 1 end
        if data == 6 then return end
        local ScrapyardTutorial = {
            { header = Lcl('tutorial_title'), disabled = true },
            {
                header = Lcl('tutorial_'..tostring(data)), context = Lcl('tutorial_clicktocontinue'),
                event = 'cr-salvage:client:tutorial', args = { data + 1 }
            },
        }
        if data > 1 then
            ScrapyardTutorial[#ScrapyardTutorial+1] = {
                header = Lcl('goback'),
                event = 'cr-salvage:client:tutorial', args = { data - 1 }
            }
        end
        ScrapyardTutorial[#ScrapyardTutorial+1] = {
                header = Lcl('exit'),
                event = 'nh-context:cancelMenu'
            }
        TriggerEvent('nh-context:createMenu', ScrapyardTutorial)
    elseif Config.Framework.Framework == "QBCore" then
        if data.page == 0 then data.page = 1 end
        if data.page == 6 then return end
        local ScrapyardTutorial = {
            { header = Lcl('tutorial_title'), isMenuHeader = true },
            {
                header = Lcl('tutorial_'..tostring(data.page)), txt = Lcl('tutorial_clicktocontinue'),
                params = { event = 'cr-salvage:client:tutorial', args = { page = data.page + 1 } }
            },
        }
        if data.page > 1 then
            ScrapyardTutorial[#ScrapyardTutorial+1] = {
                header = Lcl('goback'),
                params = { event = 'cr-salvage:client:tutorial', args = { page = data.page - 1 } }
            }
        end
        ScrapyardTutorial[#ScrapyardTutorial+1] = {
                header = Lcl('exit'),
                params = { event = 'qb-menu:client:closeMenu' }
            }
        exports['qb-menu']:openMenu(ScrapyardTutorial)
    elseif Config.Framework.Framework == "ESX" then
        if data.page == 0 then data.page = 1 end
        if data.page == 6 then return end
        local elems = {
            {label = Lcl('tutorial_'..tostring(data.page)), value = 'page'},
            {label = Lcl('goback'), value = 'back'},
            {label = Lcl('exit'), value = 'close'},
        }
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ScrapyardTutorial', {
            title = Lcl('tutorial_title'),
            elements = elems
        }, function(menuData, menu)
            if menuData.current.value == 'page' then
                TriggerEvent('cr-salvage:client:tutorial', { page = data.page + 1 })
            elseif menuData.current.value == 'back' then
                TriggerEvent('cr-salvage:client:tutorial', { page = data.page - 1 })
            elseif menuData.current.value == 'close' then
                menu.close()
            end
        end, function(_, menu) menu.close() end)
    else
        print(Lcl("debug_menuconfigerror"))
    end
end)