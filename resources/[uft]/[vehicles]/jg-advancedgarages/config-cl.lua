local QBCore = exports['qb-core']:GetCoreObject()

--
-- Custom code for common events
--
function getEntryFromEnd(table, entry)
  local count = (table and #table or false)
  if (count) then
      return table[count-entry];
  end
  return false;
end

RegisterNetEvent("jg-advancedgarages:client:InsertVehicle:config", function(vehicle, vehicleDbData, garageType)
  -- PARAMS:
  -- vehicle: Current vehicle FiveM native data
  -- vehicleDbData: The row of the owned vehicle from the datbase
  -- type: is either "public", "gang" or "job"
  --print(QBCore.Shared.Gangs[vehicleDbData.citizenid].grades[#QBCore.Shared.Gangs[vehicleDbData.citizenid].grades+1-n])
  --print_table(QBCore.Shared.Gangs[vehicleDbData.citizenid].grades)
  --print_table(QBCore.Shared.Gangs[vehicleDbData.citizenid].grades[tostring(0)])

  -- Evidence
  TriggerEvent('evidence:client:parkVehicle', vehicle, vehicleDbData.plate, 1)

  -- Code placed in here will be run when the player inserts their vehicle (if the vehicle is owned; and passes all the checks)
end)

RegisterNetEvent("jg-advancedgarages:client:ImpoundVehicle:config", function(vehicle)
  -- PARAMS:
  -- vehicle: Current vehicle FiveM native data

  -- Code placed in here will be run just before the vehicle is set to impounded in the DB, and before the entity is deleted
end)

RegisterNetEvent("jg-advancedgarages:client:TakeOutVehicle:config", function(vehicle, vehicleDbData, garageType)
  -- PARAMS:
  -- vehicle: Vehicle FiveM native data
  -- vehicleDbData: The row of the owned vehicle from the datbase
  -- type: is either "public", "gang" or "job"

  -- Wheel Stancing
  if vehicleDbData.stance_value ~= nil then TriggerEvent('stancer:SyncStancer', json.decode(vehicleDbData.stance_value), vehicle) end
  -- Evidence
  TriggerEvent('evidence:client:takeOutVehicle', vehicle, vehicleDbData.plate, 0)

  local grades = {}
  if garageType == 'gang' and QBCore.Shared.Gangs[vehicleDbData.citizenid] then
    local paperHolder = vehicleDbData.gang_papers
    for k, v in pairs(QBCore.Shared.Gangs[vehicleDbData.citizenid].grades) do table.insert(grades, tonumber(k)) end
    table.sort(grades, function(a, b) return a > b end)
    --local boss = QBCore.Shared.Gangs[vehicleDbData.citizenid].grades[tostring(grades[1])]
    QBCore.Functions.TriggerCallback('garages:getGangMembers', function(members)
      if not members then return end
      local holderInGang = false
      local membersOptions = {}
      for k,v in pairs(members) do
        if v.CitizenId == paperHolder then holderInGang = true end
        membersOptions[#membersOptions+1] = {value = v.CitizenId, label = v.CharName..' | '..QBCore.Shared.Gangs[vehicleDbData.citizenid].grades[tostring(v.Grade.level)].name}
      end
      if not holderInGang then
        local input = lib.inputDialog('Select Vehicle Papers Holder', {
          {type = 'select', label = 'Chose Member', description = 'Chose the person legally responsible for this vehicle', options = membersOptions, required = true},
        })
        if not input or not input[1] then return end
        TriggerServerEvent('garages:server:setupPapers', vehicleDbData.plate, input[1])
      end
    end, vehicleDbData.citizenid)
  end

  -- Code placed in here will be run after a vehicle has been taken out of a garage
end)

RegisterNetEvent("jg-advancedgarages:client:TransferVehicle:config", function(plate, newOwnerPlayerId, vehicleModel)
  -- PARAMS:
  -- plate: Vehicle plate
  -- newOwnerPlayerId: new player ID
  -- vehicleModel: vehicle spawn code

  -- Code placed in here will be fired when a vehicle is transferred to another player via a public garage
end)

--
-- Blips
--
local blips, jobGarageBlips, gangGarageBlips = {}, {}, {}

local function createBlip(name, coords, blipId, blipColour, blipScale)
  local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
  SetBlipSprite(blip, blipId)
  SetBlipColour(blip, blipColour)
  SetBlipScale(blip, blipScale)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(name)
  EndTextCommandSetBlipName(blip)
  return blip
end

function createPublicPrivateGarageBlips()
  CreateThread(function()
    local identifier = Framework.Client.GetPlayerIdentifier()

    while not identifier do
      identifier = Framework.Client.GetPlayerIdentifier()
      Wait(100)
    end

    Framework.Client.TriggerCallback("jg-advancedgarages:server:get-private-garages", function(privateGarages)
      for id, garage in pairs(privateGarages) do
        Globals.Garages[garage.name] = {
          coords = vector3(garage.x, garage.y, garage.z),
          spawn = vector4(garage.x, garage.y, garage.z, garage.h),
          distance = garage.distance,
          type = garage.type,
          blip = {
            id = 357,
            color = 0,
            scale = 0.6,
          },
        }
      end

      if Config.GarageShowBlips then
        for _, blip in pairs(blips) do
          RemoveBlip(blip)
        end

        for id, garage in pairs(Globals.Garages) do
          if garage and not garage.hideBlip and not garage.job and not garage.gang then
            local blipName = Locale.garage
            if Config.GarageUniqueBlips then
              blipName = Locale.garage .. ": " .. id
            end
            if not garage.blip then
              garage.blip = {
                id = 357,
                color = 0,
                scale = 0.6
              }
            end
            local blip = createBlip(blipName, garage.coords, garage.blip.id, garage.blip.color, garage.blip.scale + 0.0)
            table.insert(blips, blip)
          end
        end
      end
    end, identifier)
  end)
end

function createJobGarageBlips()
  CreateThread(function()
    if Config.JobGarageShowBlips then
      for _, blip in pairs(jobGarageBlips) do
        RemoveBlip(blip)
      end

      for id, garage in pairs(Config.JobGarageLocations) do
        if not garage.hideBlip then
          if garage.job == Framework.Client.GetPlayerJob().name then
            local blipName = Locale.jobGarage
            if Config.JobGarageUniqueBlips then
              blipName = Locale.jobGarage .. ": " .. id
            end
            if not garage.blip then
              garage.blip = {
                id = 357,
                color = 0,
                scale = 0.6
              }
            end
            local blip = createBlip(blipName, garage.coords, garage.blip.id, garage.blip.color, garage.blip.scale + 0.0)
            table.insert(jobGarageBlips, blip)
          end
        end
      end
    end
  end)
end

function createGangGarageBlips()
  CreateThread(function()
    if Config.GangGarageShowBlips then
      for _, blip in pairs(gangGarageBlips) do
        RemoveBlip(blip)
      end

      for id, garage in pairs(Config.GangGarageLocations) do
        if not garage.hideBlip then
          if garage.gang == Framework.Client.GetPlayerGang().name then
            local blipName = Locale.gangGarage
            if Config.GangGarageUniqueBlips then
              blipName = Locale.gangGarage .. ": " .. id
            end
            if not garage.blip then
              garage.blip = {
                id = 357,
                color = 0,
                scale = 0.6
              }
            end
            local blip = createBlip(blipName, garage.coords, garage.blip.id, garage.blip.color, garage.blip.scale + 0.0)
            table.insert(gangGarageBlips, blip)
          end
        end
      end
    end
  end)
end

function createImpoundBlips()
  CreateThread(function()
    if Config.ImpoundShowBlips then
      for id, impound in pairs(Config.ImpoundLocations) do
        if not impound.hideBlip then
          local blipName = Locale.impound
          if Config.ImpoundUniqueBlips then
            blipName = Locale.impound .. ": " .. id
          end
          if not impound.blip then
            impound.blip = {
              id = 357,
              color = 0,
              scale = 0.6
            }
          end
          createBlip(blipName, impound.coords, impound.blip.id, impound.blip.color, impound.blip.scale + 0.0)
        end
      end
    end
  end)
end

createPublicPrivateGarageBlips()
createImpoundBlips()
createJobGarageBlips()
if Config.Framework == "QBCore" then
  createGangGarageBlips()
end

--
-- DrawText UI Prompts
--

local drawTextVisible, currentText
local sleep = 1000

function showDrawText(id, text)
  if drawTextVisible ~= id or currentText ~= text then
    drawTextVisible = id
    currentText = text
    Framework.Client.ShowTextUI(text)
  end
end

function hideDrawText(id)
  if drawTextVisible == id then
    drawTextVisible = nil
    Framework.Client.HideTextUI()
  end
end

local function toggleDrawText(id, coords, distance, openEvent, insertEvent, isImpound)
  local pos = GetEntityCoords(PlayerPedId())
  local dist = #(pos - coords)
  local distZ = math.abs(pos.z - coords.z)

  if dist < distance and distZ < 3 then
    if IsPedInAnyVehicle(PlayerPedId()) and not isImpound then
      sleep = 0
      showDrawText(id, Config.InsertVehiclePrompt)
      if IsControlJustPressed(0, Config.InsertVehicleKeyBind) then
        TriggerEvent("jg-advancedgarages:client:" .. insertEvent, id)
      end
    else
      sleep = 0
      showDrawText(id, isImpound and Config.OpenImpoundPrompt or Config.OpenGaragePrompt)
      if IsControlJustPressed(0, isImpound and Config.OpenImpoundKeyBind or Config.OpenGarageKeyBind) then
        TriggerEvent("jg-advancedgarages:client:" .. openEvent, id)
      end
    end
  else
    hideDrawText(id)
  end
end

local function createToggleThread(func)
  CreateThread(function()
    while true do
      sleep = 1000
      func()
      Wait(sleep)
    end
  end)
end

-- Public & Private garages
createToggleThread(function()
  for id, garage in pairs(Globals.Garages) do
    if garage and not garage.job and not garage.gang then
      toggleDrawText(id, garage.coords, garage.distance, "ShowGarage", "InsertVehicle", false)
    end
  end
end)

-- Job garages
createToggleThread(function()
  local playerJob = Framework.Client.GetPlayerJob().name

  for id, garage in pairs(Config.JobGarageLocations) do
    if garage.job == playerJob then
      if garage.vehiclesType == "personal" then
        toggleDrawText(id, garage.coords, garage.distance, "ShowGarage", "InsertVehicle", false)
      else
        toggleDrawText(id, garage.coords, garage.distance, "ShowJobGarage", "JobGarageInsertVehicle", false)
      end
    end
  end
end)

-- Gang garages
if Config.Framework == "QBCore" then
  createToggleThread(function()
    local playerGang = Framework.Client.GetPlayerGang().name

    for id, garage in pairs(Config.GangGarageLocations) do
      if garage.gang == playerGang then
        if garage.vehiclesType == "personal" then
          toggleDrawText(id, garage.coords, garage.distance, "ShowGarage", "InsertVehicle", false)
        else
          toggleDrawText(id, garage.coords, garage.distance, "ShowGangGarage", "GangGarageInsertVehicle", false)
        end
      end
    end
  end)
end

-- Impound
createToggleThread(function()
  for id, impound in pairs(Config.ImpoundLocations) do
    toggleDrawText(id, impound.coords, impound.distance, "ShowImpound", nil, true)
  end
end)

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
