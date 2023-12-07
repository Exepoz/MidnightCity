local QBCore = exports['qb-core']:GetCoreObject()

local function EmergencyStringMatch(plate)
    local match = false
    if string.find(plate, 'AMBU') or string.find(plate, 'MCPD') then match = true end
    return match
end

local temp = {}
local function doCarPlates(src, bool)
    temp = {}
    local found = false
    -- OLD REGEX : '^[A-Z]{2}[0-9]{4}[A-Z]{2}$'
    local vehicles = CustomsSQL('oxmysql','fetchAll',"SELECT * FROM player_vehicles WHERE plate REGEXP '^MCPD'",{})
    for k,v in pairs(vehicles) do
        print(v.plate)
        if v.plate ~= nil then --and not EmergencyStringMatch(v.plate) then
            found = true

            local OwnerName = CustomsSQL('oxmysql','fetchAll',"SELECT name FROM players WHERE citizenid = ?",{v.citizenid})
            local trunk = CustomsSQL('oxmysql','fetchAll',"SELECT items FROM trunkitems WHERE plate = ?",{v.plate})
            local glovebox = CustomsSQL('oxmysql','fetchAll',"SELECT items FROM gloveboxitems WHERE plate = ?",{v.plate})
            local engineSound = CustomsSQL('oxmysql','fetchAll',"SELECT exhaust FROM an_engine WHERE plate = ?",{v.plate})
            local BOLO = CustomsSQL('oxmysql','fetchAll',"SELECT title FROM mdt_bolos WHERE plate = ?",{v.plate})
            local mdtVehInfo = CustomsSQL('oxmysql','fetchAll',"SELECT information FROM mdt_vehicleinfo WHERE plate = ?",{v.plate})
            local gunracks = CustomsSQL('oxmysql','fetchAll',"SELECT items FROM stashitems WHERE stash = ?",{"Gunrack_"..v.plate})

            trunk = trunk[1] and trunk[1].items or 'Nothing'
            glovebox = glovebox[1] and glovebox[1].items or 'Nothing'
            engineSound = engineSound[1] and engineSound[1].exhaust or 'Default'
            BOLO = BOLO[1] and BOLO[1].title or 'None'
            mdtVehInfo = mdtVehInfo[1] and mdtVehInfo[1].information or 'None'
            gunracks = gunracks[1] and gunracks[1].items or 'None'

            temp[v.plate] = {
                Owner = OwnerName[1].name,
                Vehicle = v.vehicle,
                Glovebox = glovebox,
                Trunk = trunk,
                EngineSound = engineSound,
                BOLO = BOLO,
                MDTInfo = mdtVehInfo,
                Gunrack = gunracks
            }
            print("Car Found! ("..v.plate..")")
            print_table(temp[v.plate])

            if glovebox ~= 'Nothing' and glovebox ~= '[]' then print("Items in the glovebox!") end
            if trunk ~= 'Nothing' and trunk ~= '[]' then print("Items in the trunk!") end
            if engineSound ~= 'Default' then print("Car has custom Engine Sound!") end
            if BOLO ~= 'None' then print("Car has a BOLO!") end
            if mdtVehInfo ~= 'None' then print("Car has MDT Info!") end
            if gunracks ~= 'None' then print("Car has items in the Gun Rack!") end

            if bool then
                local newPlate = exports['renzu_vehicleshop']:GenPlate('MCPD') --Argument is new plate prefix
                print("Updating Plate... "..newPlate)
                CustomsSQL('oxmysql','execute',"UPDATE player_vehicles SET plate = ? WHERE plate = ?",{newPlate, v.plate})
                CustomsSQL('oxmysql','execute',"UPDATE trunkitems SET plate = ? WHERE plate = ?",{newPlate, v.plate})
                CustomsSQL('oxmysql','execute',"UPDATE gloveboxitems SET plate = ? WHERE plate = ?",{newPlate, v.plate})
                CustomsSQL('oxmysql','execute',"UPDATE mdt_bolos SET plate = ? WHERE plate = ?",{newPlate, v.plate})
                CustomsSQL('oxmysql','execute',"UPDATE mdt_vehicleinfo SET plate = ? WHERE plate = ?",{newPlate, v.plate})
                CustomsSQL('oxmysql','execute',"UPDATE stashitems SET stash = ? WHERE stash = ?",{"Gunrack_"..newPlate, "Gunrack_"..v.plate})

                if engineSound ~= 'Default' then
                    TriggerEvent('an-engine:server:swapEngine', newPlate, engineSound)
                    TriggerClientEvent('engine:sound', -1, engineSound, string.gsub(newPlate, '^%s*(.-)%s*$', '%1'))
                end
                print('New Plate Set : '..newPlate)
            end
            print("------------------")
        end
    end
    if not found then print("No cars found, everything is all set!") end
end


RegisterCommand('doCarPlates', function (source, args, raw) local bool = args[1] == 'true' and true or false doCarPlates(source, bool) end, true)


local function cleanCarSQL(src, bool)
    temp = {}
    local found = false
    local vehicles = CustomsSQL('oxmysql','fetchAll',"SELECT * FROM player_vehicles",{})
    for k,v in pairs(vehicles) do
        if not QBCore.Shared.Vehicles[v.vehicle] then

            local OwnerName = CustomsSQL('oxmysql','fetchAll',"SELECT name FROM players WHERE citizenid = ?",{v.citizenid})
            local trunk = CustomsSQL('oxmysql','fetchAll',"SELECT items FROM trunkitems WHERE plate = ?",{v.plate})
            local glovebox = CustomsSQL('oxmysql','fetchAll',"SELECT items FROM gloveboxitems WHERE plate = ?",{v.plate})
            local engineSound = CustomsSQL('oxmysql','fetchAll',"SELECT exhaust FROM an_engine WHERE plate = ?",{v.plate})
            local BOLO = CustomsSQL('oxmysql','fetchAll',"SELECT title FROM mdt_bolos WHERE plate = ?",{v.plate})
            local mdtVehInfo = CustomsSQL('oxmysql','fetchAll',"SELECT information FROM mdt_vehicleinfo WHERE plate = ?",{v.plate})

            trunk = trunk[1] and trunk[1].items or 'Nothing'
            glovebox = glovebox[1] and glovebox[1].items or 'Nothing'
            engineSound = engineSound[1] and engineSound[1].exhaust or 'Default'
            BOLO = BOLO[1] and BOLO[1].title or 'None'
            mdtVehInfo = mdtVehInfo[1] and mdtVehInfo[1].information or 'None'

            temp[v.plate] = {Owner = OwnerName[1].name, Vehicle = v.vehicle, Glovebox = glovebox, Trunk = trunk, EngineSound = engineSound, BOLO = BOLO, MDTInfo = mdtVehInfo}
            print("Car Found! ("..v.plate..")")
            print_table(temp[v.plate])

            if glovebox ~= 'Nothing' and glovebox ~= '[]' then print("Items in the glovebox!") end
            if trunk ~= 'Nothing' and trunk ~= '[]' then print("Items in the trunk!") end
            if engineSound ~= 'Default' then print("Car has custom Engine Sound!") end
            if BOLO ~= 'None' then print("Car has a BOLO!") end
            if mdtVehInfo ~= 'None' then print("Car has MDT Info!") end

            -- if bool then
            --     local newPlate = exports['renzu_vehicleshop']:GenPlate()
            --     print("Updating Plate...")
            --     CustomsSQL('oxmysql','execute',"UPDATE player_vehicles SET plate = ? WHERE plate = ?",{newPlate, v.plate})
            --     CustomsSQL('oxmysql','execute',"UPDATE trunkitems SET plate = ? WHERE plate = ?",{newPlate, v.plate})
            --     CustomsSQL('oxmysql','execute',"UPDATE gloveboxitems SET plate = ? WHERE plate = ?",{newPlate, v.plate})
            --     CustomsSQL('oxmysql','execute',"UPDATE mdt_bolos SET plate = ? WHERE plate = ?",{newPlate, v.plate})
            --     CustomsSQL('oxmysql','execute',"UPDATE mdt_vehicleinfo SET plate = ? WHERE plate = ?",{newPlate, v.plate})

            --     if engineSound ~= 'Default' then
            --         TriggerEvent('an-engine:server:swapEngine', newPlate, engineSound)
            --         TriggerClientEvent('engine:sound', -1, engineSound, string.gsub(newPlate, '^%s*(.-)%s*$', '%1'))
            --     end
            --     print('New Plate Set : '..newPlate)
            -- end
            print("------------------")
        end
    end
    if not found then print("No cars found, everything is all set!") end
end


RegisterCommand('doSQLclean', function (source, args, raw) local bool = args[1] == 'true' and true or false cleanCarSQL(source, bool) end, true)
