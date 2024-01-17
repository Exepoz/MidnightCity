local SD = exports['sd_lib']:getLib()

local ObjectList = {} -- Object, Model, Coords, IsRendered, SpawnRange
local OldObjectList = nil
local PlacingObject, LoadedObjects, PlacingItemObject, CurrentHiveType = false, false, nil, nil
local CurrentModel, CurrentObject, CurrentObjectType, CurrentObjectName, CurrentSpawnRange, CurrentCoords = nil, nil, nil, nil, nil, nil

local model_bee_house, model_bee_hive = nil, nil
model_bee_hive = Beekeeping.Props.bee_hive
model_bee_house = Beekeeping.Props.bee_house

local ObjectParams = {
    ['house'] = {
        object = model_bee_house,
        event = 'sd-beekeeping:openBeeHouse',
        icon = 'fa-solid fa-bug',
        label = Lang:t('target.open_bee_house'),
        SpawnRange = 100,
        defaultData = {
            workers = 0,
            queens = 0,
            time = 0,
        }
    },
    ['hive'] = {
        object = model_bee_hive,
        event = 'sd-beekeeping:openBeeHive',
        icon = 'fa-solid fa-bug',
        label = Lang:t('target.open_bee_hive'),
        SpawnRange = 100,
        defaultData = {
            haveQueen = false,
            haveWorker = false,
            honey = 0,
            wax = 0,
            time = 0,
        }
    },
}

local function CancelPlacement()
    DeleteObject(CurrentObject)
    PlacingObject = false
    CurrentObject = nil
    CurrentObjectType = nil
    CurrentObjectName = nil
    CurrentSpawnRange = nil
    CurrentCoords = nil
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        lib.callback('sd-beekeeping:objects:server:RequestObjects', false, function(incObjectList)
            ObjectList = incObjectList
        end)
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for k, v in pairs(ObjectList) do
            if v["IsRendered"] then
                DeleteObject(v["object"])
            end
        end
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    lib.callback('sd-beekeeping:objects:server:RequestObjects', false, function(incObjectList)
        ObjectList = incObjectList
    end)
end)

RegisterNetEvent('esx:playerLoaded', function()
    lib.callback('sd-beekeeping:objects:server:RequestObjects', false, function(incObjectList)
        ObjectList = incObjectList
    end)
end)

local function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

local function Button(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

local function setupScaleform(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    -- draw it once to set up layout
    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 0, 0)

    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()


    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, 73, true))
    ButtonMessage(Lang:t('scaleforms.cancel_button'))
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    Button(GetControlInstructionalButton(2, 176, true))
    ButtonMessage(Lang:t('scaleforms.place_button'))
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    Button(GetControlInstructionalButton(2, 16, true))
    Button(GetControlInstructionalButton(2, 15, true))
    ButtonMessage(Lang:t('scaleforms.rotate_button'))
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

local function RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

local function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
    local handle, hit, endCoords, surfaceNormal, materialHash, entityHit = GetShapeTestResultIncludingMaterial(StartShapeTestSweptSphere(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, 0.2, 339, PlayerPedId(), 4))
	return hit, endCoords, entityHit, materialHash
end

local function isInExclusionZone(playerCoords)
    for _, zone in pairs(Beekeeping.ExclusionZones) do
        if #(playerCoords - zone.coords) < zone.radius then
            return true
        end
    end
    return false
end

local function PlaceSpawnedObject(heading)
    if isInExclusionZone(GetEntityCoords(PlayerPedId())) then SD.ShowNotification(Lang:t('notifications.in_exclusion_zone'), 'error') return end
    local ObjectType = 'prop' --will be replaced with inputted prop type later, which will determine options/events
    local Options = { SpawnRange = tonumber(CurrentSpawnRange) }

    if ObjectParams[CurrentHiveType] ~= nil then
        Options = { event = ObjectParams[CurrentHiveType].event, icon = ObjectParams[CurrentHiveType].icon, label = ObjectParams[CurrentHiveType].label, SpawnRange = ObjectParams[CurrentHiveType].SpawnRange}
    end
    local finalCoords = vector4(CurrentCoords.x, CurrentCoords.y, CurrentCoords.z, heading)
    if PlacingItemObject then
        TriggerServerEvent("sd-beekeeping:server:removeItem", PlacingItemObject.name or PlacingItemObject, 1)
    end
    TriggerServerEvent("sd-beekeeping:objects:server:CreateNewObject", CurrentHiveType, finalCoords, Options, ObjectParams[CurrentHiveType].defaultData, CurrentOwner)
    DeleteObject(CurrentObject)
    PlacingObject = false
    CurrentObject = nil
    CurrentObjectType = nil
    CurrentObjectName = nil
    CurrentSpawnRange = nil
    CurrentCoords = nil
    CurrentModel = nil
    PlacingItemObject = nil
    CurrentOwner = nil
end

local function CreateSpawnedObject(data)
    local object = ObjectParams[data.hive_type].object
    CurrentObjectType = ObjectParams[data.hive_type].object
    CurrentHiveType = data.hive_type
    CurrentSpawnRange = ObjectParams[data.hive_type] and ObjectParams[data.hive_type] ~= nil or data.distance or 15
    CurrentOwner = data.citizenid
    
    SD.utils.LoadModel(object)
    CurrentModel = object
    CurrentObject = CreateObject(object, 1.0, 1.0, 1.0, true, true, false)
    local heading = 0.0
    SetEntityHeading(CurrentObject, 0)
    
    SetEntityAlpha(CurrentObject, 200)
    SetEntityDrawOutline(CurrentObject, true)
    SetEntityCollision(CurrentObject, false, false)
    FreezeEntityPosition(CurrentObject, true)

    CreateThread(function()
        local form = setupScaleform("instructional_buttons")
        while PlacingObject do
            local hit, coords, entity, material = RayCastGamePlayCamera(7.0)
            CurrentCoords = coords

            DrawScaleformMovieFullscreen(form, 255, 255, 255, 255, 0)

            if hit then
                local _, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z + 10.0, 0)
                local adjustedZ = groundZ + 0.7

                SetEntityCoords(CurrentObject, coords.x, coords.y, adjustedZ)
            end
            
            -- Rotate object
            if IsControlJustPressed(0, 15) then
                heading = heading + 5
                if heading > 360 then heading = 0.0 end
            end
    
            if IsControlJustPressed(0, 14) then
                heading = heading - 5
                if heading < 0 then heading = 360.0 end
            end
            
            -- Cancel placement
            if IsControlJustPressed(0, 73) then
                CancelPlacement()
            end

            SetEntityHeading(CurrentObject, heading)

            -- Place object
            if IsControlJustPressed(0, 176) then
                if lib.table.contains(Beekeeping.Grounds, material) then
                    PlaceSpawnedObject(heading)
                else
                    SD.ShowNotification(Lang:t('notifications.incorrect_ground'), 'error')
                end
            end
            
            Wait(1)
        end
    end)
end

RegisterNetEvent("sd-beekeeping:objects:client:UpdateObjectList", function(NewObjectList)
    ObjectList = NewObjectList
end)

CreateThread(function()
	while true do
        for k, v in pairs(ObjectList) do
            local data = v["options"]
            local objectCoords = v["coords"]
            local playerCoords = GetEntityCoords(PlayerPedId())
            local dist = #(playerCoords - vector3(objectCoords["x"], objectCoords["y"], objectCoords["z"]))
            if dist < data["SpawnRange"] and v["IsRendered"] == nil then
                local objectModel = ObjectParams[v['hive_type']].object
                local object = CreateObject(objectModel, objectCoords["x"], objectCoords["y"], objectCoords["z"], false, false, false)
                SetEntityHeading(object, objectCoords["w"])
                SetEntityAlpha(object, 0)
                PlaceObjectOnGroundProperly(object)
                FreezeEntityPosition(object, true)
                v["IsRendered"] = true
                v["object"] = object

                for i = 0, 255, 51 do
                    Wait(50)
                    SetEntityAlpha(v["object"], i, false)
                end

                SD.utils.LoadPtfxAsset('core')
                UseParticleFxAssetNextCall('core')
                StartParticleFxLoopedAtCoord('ent_amb_fly_swarm', objectCoords["x"], objectCoords["y"], objectCoords["z"], 0.0, 0.0, 0.0, 1.5, 0.0, 0.0, 0.0, 0)

                if ObjectParams[v.hive_type] ~= nil and ObjectParams[v.hive_type].event ~= nil then
                    SD.target.AddTargetEntity(object, {
                        --debugPoly=true,
                        options = {
                            {
                                name = "object_spawner_"..object,
                                event = ObjectParams[v.hive_type].event,
                                icon = ObjectParams[v.hive_type].icon,
                                label = ObjectParams[v.hive_type].label,
                                id = v.id
                            },
                        },
                        distance = 1.5
                    })
                end
            end
            
            if dist >= data["SpawnRange"] and v["IsRendered"] then
                if DoesEntityExist(v["object"]) then 
                    for i = 255, 0, -51 do
                        Wait(50)
                        SetEntityAlpha(v["object"], i, false)
                    end
                    DeleteObject(v["object"])
                    v["object"] = nil
                    v["IsRendered"] = nil
                end
            end
        end
        Wait(1500)
	end
end)

RegisterNetEvent("sd-beekeeping:objects:client:AddObject", function(object)
    ObjectList[object.id] = object
end)

RegisterNetEvent('sd-beekeeping:objects:client:receiveObjectDelete', function(id)
    if ObjectList[id]["IsRendered"] then
        if DoesEntityExist(ObjectList[id]["object"]) then 
            for i = 255, 0, -51 do
                Wait(50)
                SetEntityAlpha(ObjectList[id]["object"], i, false)
            end
            DeleteObject(ObjectList[id]["object"])
        end
    end
    ObjectList[id] = nil
end)

RegisterNetEvent('sd-beekeeping:objects:client:SpawnObject', function(data)
    if not PlacingObject then
        
        -- Check if the player is in an exclusion zone
        if isInExclusionZone(GetEntityCoords(PlayerPedId())) then SD.ShowNotification(Lang:t('notifications.in_exclusion_zone'), 'error') return end

        lib.callback('sd-beekeeping:server:CheckHiveCount', data, function(hasReachedMax)
            if hasReachedMax then SD.ShowNotification(Lang:t('notifications.max_limit_reached'), 'error') return end

            PlacingObject = true
            PlacingItemObject = data.item
            CreateSpawnedObject(data)
        end, data)
    else
        SD.ShowNotification(Lang:t('notifications.already_placing'), 'error')
    end
end)