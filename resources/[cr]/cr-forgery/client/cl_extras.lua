local QBCore = exports['qb-core']:GetCoreObject()
FCUtils = {}

-- Client-Sided Notification Matrix
---@param notifType number - Notification Type (1 = Success, 2 = Info, 3 = Failure)
---@param message string - Message Sent
---@param title? string - Message Title (If Applicable)
function FCUtils.Notif(notifType, message, title)
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


-- DrawText Function
---@param bool boolean - true = Displays DrawText | False = Removes Current DrawText
---@param text? string - Message shown
function FCUtils.DrawText(bool, text)
	if bool then
        if not text then text = "" end
        if Config.Framework.DrawText == "oxlib" then lib.showTextUI(text)
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

function FCUtils.Input(title, submit, options)
    local p = promise.new()
    if Config.Framework.Input == 'ox' then
        local o, order, i, dialog = {}, {}, 1, nil
        for k, v in ipairs(options) do
            if v.type == 'text' then
                o[#o+1] = {type = 'input', label = v.text, required = true}
            elseif v.type == 'radio' then
                local oo = {}
                for a, b in ipairs(v.options) do oo[#oo+1] = {value = b.value, label = b.text} end
                o[#o+1] = {type = 'select', label = v.text, options = oo, required = true}
            end
            order[v.name] = i
            i = i+1
        end
        dialog = lib.inputDialog(title, o)
        p:resolve({dialog, order})
    elseif Config.Framework.Input == 'qb' then
        local dialog = exports['qb-input']:ShowInput({header = title, submitText = submit, inputs = options})
        p:resolve({dialog})
    end
    return p
end

-- Function to build menus
---@param title string - Name of the menu
---@param options table - table containing all of the options
function FCUtils.MakeMenu(title, options)
    local m = {}
    if Config.Framework.Menu == 'nh' then
        m = {{header = title, disabled = true}}
        for _, v in ipairs(options) do
            m[#m+1] = {
                header = v.header,
                context = v.desc,
                event  = "cr-forgery:client:ForgeCard",
                args = {v.license}
            }
        end
        m[#m+1] = { header = Lcl('input_close'), event  = "cr-forgery:client:Close"}
        TriggerEvent("nh-context:createMenu", m)
    elseif Config.Framework.Menu == 'qb' then
        m = {{header = title, isMenuHeader = true}}
        for _, v in ipairs(options) do
            m[#m+1] = {
                header = v.header,
                text = v.desc,
                params = {
                    event  = "cr-forgery:client:ForgeCard",
                    args = v.license
                },
            }
        end
        m[#m+1] = { header = Lcl('input_close'), event  = "qb-menu:client:closeMenu"}
        exports['qb-menu']:openMenu(m)
    elseif Config.Framework.Menu == 'ox' then
        local o = {}
        for _, v in ipairs(options) do
            o[#o+1] = {
                title = v.header,
                description = v.desc,
                onSelect = function() TriggerEvent("cr-forgery:client:ForgeCard", v.license) end,
            }
        end
        o[#o+1] = { title = Lcl('input_close'), onSelect = function() lib.hideContext() end }
        m = {id = 'forge_menu', title = title, options = o}
        lib.registerContext(m)
        lib.showContext('forge_menu')
    end
end

--- Function to check if player is wearing gloves or not
---@return boolean - Is the player wearing gloves?
function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
    local model = GetEntityModel(PlayerPedId())
    local retval = true

    if model == 'mp_m_freemode_01' then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

-- Targets & Interactions Thread
Citizen.CreateThread(function()
    if  Config.Framework.Interaction.UseTarget then

        local EnterOptions = {{name = "ForgeryEnter", type = "client", event = "cr-forgery:client:Enter", icon = "fas fa-user-secret", label = Lcl('interact_Enter')}}
        local LeaveOptions = {{name = "ForgeryLeave", type = "client", event = "cr-forgery:client:Leave", icon = "fas fa-user-secret", label = Lcl('interact_Leave')}}
        local ForgeOptions = {{name = "ForgeryForge", type = "client", event = "cr-forgery:client:IDForgery", icon = "fas fa-user-secret", label = Lcl('interact_Forge')}}

        if Config.Framework.Interaction.Target == 'qb-target' then
            exports['qb-target']:AddBoxZone("ForgeryEnter", Config.OutsideCoords.coords, 1.6, 1.1,
            {name = "ForgeryEnter", heading = Config.OutsideCoords.heading, debugPoly = Config.Debug, minZ=Config.OutsideCoords.coords.z-0.5, maxZ=Config.OutsideCoords.coords.z+1.0}, {options = EnterOptions, distance = 2.5})

            exports['qb-target']:AddBoxZone("ForgeryLeave", vector3(1173.54, -3196.63, -39.01), 1.5, 1.0,
            {name = "ForgeryLeave", heading = 89, debugPoly = Config.Debug, minZ=-40.00, maxZ=-38.00}, {options = LeaveOptions, distance = 2.5})

            exports['qb-target']:AddBoxZone("ForgeryForge", vector3(1169.52, -3196.85, -39.01), 0.4, 0.5,
            {name = "ForgeryForge", heading = 290, debugPoly = Config.Debug, minZ=-39.30, maxZ=-38.80}, {options = ForgeOptions, distance = 2.5})
        elseif Config.Framework.Interaction.Target == "oxtarget" then
            exports['ox_target']:addBoxZone({coords = Config.OutsideCoords.coords, size = vec3(1,2,1), rotation = Config.OutsideCoords.heading, debug = Config.Debug, options = EnterOptions})
            exports['ox_target']:addBoxZone({coords = vector3(1173.54, -3196.63, -39.01), size = vec3(1,2,1), rotation = 89, debug = Config.Debug, options = LeaveOptions})
            exports['ox_target']:addBoxZone({coords = vector3(1169.52, -3196.85, -39.01), size = vec3(1,1,1), rotation = 290, debug = Config.Debug, options = ForgeOptions})
        end

    else
        if Config.Framework.Interaction.OxLibDistanceCheck then
            local EnterPoint = lib.points.new(Config.OutsideCoords.coords, 1)
            function EnterPoint:onEnter() FCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('interact_Enter')) end
            function EnterPoint:onExit() FCUtils.DrawText(false) end
            function EnterPoint:nearby() if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then FCUtils.DrawText(false) TriggerEvent('cr-forgery:client:Enter') end end

            local ExitPoint = lib.points.new(Config.OutsideCoords.coords, 1)
            function ExitPoint:onEnter() FCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('interact_Leave')) end
            function ExitPoint:onExit() FCUtils.DrawText(false) end
            function ExitPoint:nearby() if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then FCUtils.DrawText(false) TriggerEvent('cr-forgery:client:Leave') end end

            local ForgePoint = lib.points.new(Config.OutsideCoords.coords, 1)
            function ForgePoint:onEnter() FCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('interact_Forge')) end
            function ForgePoint:onExit() FCUtils.DrawText(false) end
            function ForgePoint:nearby() if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then FCUtils.DrawText(false) TriggerEvent('cr-forgery:client:IDForgery') end end
        else
            local text = false
            local ped = PlayerPedId()
            local EnterCoords = vector3(-1324.18, -251.50, 42.33)
            local LeaveCoords = vector3(1174.0, -3196.63, -39.01)
            local ForgeCoords = vector3(1169.52, -3196.85, -39.01)

            while true do
                local wait = 10000
                local pcoords = GetEntityCoords(ped)
                local EnterDist = #(pcoords - EnterCoords)
                local LeaveDist = #(pcoords - LeaveCoords)
                local ForgeDist = #(pcoords - ForgeCoords)
                if EnterDist < 50 or ForgeDist < 20 then
                    wait = 1
                end
                if EnterDist <= 2 then
                    if not text then FCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('interact_Enter')) text = true end
                    if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then FCUtils.DrawText(false) TriggerEvent('cr-forgery:client:Enter') end
                elseif LeaveDist <= 1.5 then
                    if not text then FCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('interact_Leave')) text = true end
                    if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then FCUtils.DrawText(false) TriggerEvent('cr-forgery:client:Leave') end
                elseif ForgeDist <= 1.0 then
                    if not text then FCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('interact_Forge')) text = true end
                    if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then FCUtils.DrawText(false) TriggerEvent('cr-forgery:client:IDForgery') end

                else
                    if text then FCUtils.DrawText(false) text = false end
                end
                Wait(wait)
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(r)
    if r == GetCurrentResourceName() then
        if Config.Framework.Interaction.OxLibDistanceCheck or Config.Framework.Interaction.Target == "oxtarget" then return end
        exports['qb-target']:RemoveZone("ForgeryEnter")
        exports['qb-target']:RemoveZone("ForgeryLeave")
        exports['qb-target']:RemoveZone("ForgeryForge")
    end
end)