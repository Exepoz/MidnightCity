local QBCore = exports['qb-core']:GetCoreObject()

local firstname = nil
local lastname = nil
local birthday = nil
local gender = nil
local nationality = nil
local citizenid = nil
Config = Config or {}
Config.GenderOptions = {
    [1] = 'Female',
    [2] = 'Male',
}

-- Entering the forgery
RegisterNetEvent('cr-forgery:client:Enter', function()
    local Ped = PlayerPedId()
    if IsPedInAnyVehicle(Ped, false) then FCUtils.Notif(3, Lcl("notif_VehicleError"), Lcl("notif_Title")) return end
    DoScreenFadeOut(1000)
    Wait(1500)
    SetEntityCoords(Ped, 1173.54, -3196.63, -39.01)
    SetEntityHeading(Ped, 89.45)
    DoScreenFadeIn(1000)
end)

-- Leaving the Forgery
RegisterNetEvent('cr-forgery:client:Leave', function()
    local Ped = PlayerPedId()
    if IsPedInAnyVehicle(Ped, false) then FCUtils.Notif(3, Lcl("notif_VehicleError"), Lcl("notif_Title")) return end
    DoScreenFadeOut(1000)
    Wait(1500)
    SetEntityCoords(Ped, Config.OutsideCoords.coords)
    SetEntityHeading(Ped, Config.OutsideCoords.heading)
    DoScreenFadeIn(1000)
end)

-- Forging Menu Creation
RegisterNetEvent('cr-forgery:client:IDForgery', function()
    local licenses = {}
    for k, v in pairs(Config.Licences) do
        local o = {}
        local cost = v.ForgingCost > 0 and "$"..v.ForgingCost or Lcl('forgery_free')
        local items = ""
        if #v.RequiredItems > 0 then
            for _, values in pairs(v.RequiredItems) do
                if items ~= "" then items = items..", " end
                local msg = values.amount.." ".. QBCore.Shared.Items[values.item].label
                items = items..msg
            end
        else items = Lcl('forgery_none') end

        o.header = Lcl('forgery_forge', k)
        o.desc = Lcl('forgery_description', cost, items)
        o.license = k
        licenses[#licenses+1] = o
    end
    FCUtils.MakeMenu(Lcl('forgery_title'), licenses)
end)

RegisterNetEvent('cr-forgery:client:ForgeCard', function(data)
    QBCore.Functions.TriggerCallback('cr-forgery:server:CheckRequirements', function(HasReq)
        if not HasReq then return end

        local t = {header = Lcl('input_Forgery', data), submit = Lcl('input_ForgeCard')}
        local lic = Config.Licences[data]
        local options = {}

        if lic.ShownOptions['Name'] then
            options[#options+1] = {text = Lcl('input_FirstName'), name = "firstname", type = "text", isRequired = true}
            options[#options+1] = {text = Lcl('input_LastName'), name = "lastname", type = "text", isRequired = true}
        end

        if lic.ShownOptions['DOB'] then options[#options+1] = {text = Lcl('input_DOB'), name = "birthday", type = "text", isRequired = true} end
        if lic.ShownOptions['Gender'] then
            local o = {}
            for k, v in ipairs(Config.GenderOptions) do o[#o+1] = {value = k, text = v} end
            options[#options+1] = {text = Lcl('input_Gender'), name = "gender", type = "radio", options = o, isRequired = true }
        end
        if lic.ShownOptions['Nat'] then options[#options+1] = {text = Lcl('input_Nationality'), name = "nationality", type = "text", isRequired = true} end

        FCUtils.Input(Lcl('input_Forgery', data), Lcl('input_ForgeCard'), options):next(function(dialog)
            if not dialog[1] then return end
            citizenid = tostring(QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(5)):upper()

            firstname = (dialog[1]['firstname'] or dialog[1][dialog[2]['firstname']] or nil)
            lastname = (dialog[1]['lastname'] or dialog[1][dialog[2]['lastname']] or nil)
            birthday = (dialog[1]['birthday'] or dialog[1][dialog[2]['birthday']] or nil)
            gender = (dialog[1]['gender'] or dialog[1][dialog[2]['gender']] or nil)
            nationality = (dialog[1]['nationality'] or dialog[1][dialog[2]['nationality']] or nil)
            QBCore.Functions.Progressbar("forge_iddocs", Lcl('progbar_forging', data), (Config.ForgeTime*1000), false, true,
            { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
            { animDict = "mp_prison_break", anim = "hack_loop", flags = 17},
            {}, {}, function()
                ClearPedTasks(PlayerPedId())
                TriggerServerEvent("cr-forgery:server:ForgeCard", data, citizenid, firstname, lastname, birthday, gender, nationality)
                if Config.FingerPrintDropChanceSet then
                    if math.random(100) <= Config.FingerPrintDropChance and not IsWearingHandshoes() then TriggerServerEvent("evidence:server:CreateFingerDrop", GetEntityCoords(PlayerPedId())) end
                else
                    if not IsWearingHandshoes() then TriggerServerEvent("evidence:server:CreateFingerDrop", GetEntityCoords(PlayerPedId())) end
                end
            end, function() FCUtils.Notif(3, Lcl("notif_Cancelled"), Lcl("notif_Title")) end)
        end)

    end, data)
end, false)

function print_table(node)
    local cache, stack, output = {},{},{}
    local depth = 1
    local output_str = "{\n"

    while true do
        local size = 0
        for k,v in pairs(node) do
            size = size + 1
        end

        local cur_index = 1
        for k,v in pairs(node) do
            if (cache[node] == nil) or (cur_index >= cache[node]) then

                if (string.find(output_str,"}",output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str,"\n",output_str:len())) then
                    output_str = output_str .. "\n"
                end

                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output,output_str)
                output_str = ""

                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "["..tostring(k).."]"
                else
                    key = "['"..tostring(k).."']"
                end

                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = "..tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = {\n"
                    table.insert(stack,node)
                    table.insert(stack,v)
                    cache[node] = cur_index+1
                    break
                else
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = '"..tostring(v).."'"
                end

                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                end
            end

            cur_index = cur_index + 1
        end

        if (size == 0) then
            output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
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
    table.insert(output,output_str)
    output_str = table.concat(output)

    print(output_str)
end