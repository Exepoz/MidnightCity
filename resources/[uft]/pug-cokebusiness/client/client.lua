-- Locals
local PlaneToSpawnIndexes = {}
local WorkerPedMan = {}
local CokeLabDoor = {}
local CokeCutCard1 = {}
local CokeCutCard2 = {}
local sceneObjects = {}
local OriginalBoxesLoadedCounter
local PuttingInOrRemoveingDrugs
local DrugPlaneSpawnLocation
local DroppingOffPackages
local BoxesLoadedCounter
local RandomDropOffBoat
local DoingDrugHandoff
local DrugPlaneToSpawn
local LoadingPackages
local StartedDrugJob
local CokeLabData
local DrugPlane
local PlaneRuns
local DataLoop -- This needs to be updated when supplies are added, supplies are removed, product is finished, upgrades are added. 
-- Functions
function PugLoadModel(model)
    if HasModelLoaded(model) then return end
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(0)
	end
end
local function ReloadSKin(tped)
	for k, v in pairs(GetGamePool('CObject')) do
		if IsEntityAttachedToEntity(PlayerPedId(), v) or IsEntityAttachedToEntity(tped, v) then
			SetEntityAsMissionEntity(v, true, true)
			DeleteObject(v)
			DeleteEntity(v)
		end
	end
	TriggerEvent("Pug:ReloadGuns:sling")
end
local function Draw2DText(content, font, colour, scale, x, y)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(colour[1],colour[2],colour[3], 255)
    SetTextEntry("STRING")
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    AddTextComponentString(content)
    DrawText(x, y)
end
local function ResetAllStats()
    StartedDrugJob = false
    LoadingPackages = false
    RandomDropOffBoat = false
    DrugPlaneSpawnLocation = false
    OriginalBoxesLoadedCounter = 0 
    DroppingOffPackages = 0
    BoxesLoadedCounter = 0
    if DoesBlipExist(BoxPickupBlip) then
        RemoveBlip(BoxPickupBlip)
    end
    if DoesBlipExist(PlaneDropOffBlip) then
        RemoveBlip(PlaneDropOffBlip)
    end
    if DoesBlipExist(BoatDropOffBlip) then
        RemoveBlip(BoatDropOffBlip)
    end
    if DoesBlipExist(PlanePickupBlip) then
        RemoveBlip(PlanePickupBlip)
    end
    if DoesEntityExist(DrugBoatPedMan) then
        DeleteEntity(DrugBoatPedMan)
    end
    if DoingDrugHandoff then
        if DoesEntityExist(DropOffPlaneDrugPedMan) then
            if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(DropOffPlaneDrugPedMan)) >= 70.0 then
                DeleteEntity(DropOffPlaneDrugPedMan)
                if DoesEntityExist(DrugPlane) then
                    TriggerEvent("FullyDeleteDrugPlaneVehicle", DrugPlane)
                    DrugPlane = false
                end
            end
        else
            DeleteEntity(DropOffPlaneDrugPedMan)
        end
    else
        if DoesEntityExist(DropOffPlaneDrugPedMan) then
            DeleteEntity(DropOffPlaneDrugPedMan)
        end
        if DoesEntityExist(DrugPlane) then
            TriggerEvent("FullyDeleteDrugPlaneVehicle", DrugPlane)
            DrugPlane = false
        end
    end
end

local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

-- Play animation for both player and ped
local function SellDrugsAnimation(tped)
	SetPedTalk(tped)
	PlayAmbientSpeech1(tped, 'GENERIC_HI', 'SPEECH_PARAMS_STANDARD')
	obj = CreateObject(GetHashKey('hei_prop_heist_cash_pile'), 0, 0, 0, true)
	AttachEntityToEntity(obj, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  57005), 0.13, 0.02, 0.0, -90.0, 0, 0, 1, 1, 0, 1, 0, 1)
	obj2 = CreateObject(GetHashKey('prop_drug_package_02'), 0, 0, 0, true)
	AttachEntityToEntity(obj2, tped, GetPedBoneIndex(tped,  57005), 0.13, 0.02, 0.0, -90.0, 0, 0, 1, 1, 0, 1, 0, 1)
	loadAnimDict("mp_common")
	TaskPlayAnim(PlayerPedId(), "mp_common", "givetake2_a", 8.0, -8, -1, 0, 0, 0, 0, 0)    
	TaskPlayAnim(tped, "mp_common", "givetake2_a", 8.0, -8, -1, 0, 0, 0, 0, 0)    
	Wait(1000)
	AttachEntityToEntity(obj2, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  57005), 0.13, 0.02, 0.0, -90.0, 0, 0, 1, 1, 0, 1, 0, 1)
	AttachEntityToEntity(obj, tped, GetPedBoneIndex(tped,  57005), 0.13, 0.02, 0.0, -90.0, 0, 0, 1, 1, 0, 1, 0, 1)
	Wait(2300)
	DeleteEntity(obj)
	DeleteEntity(obj2)
	ReloadSKin(tped)
	PlayAmbientSpeech1(tped, 'GENERIC_THANKS', 'SPEECH_PARAMS_STANDARD')
end

local function PugGetClosestVehicle()
    local ped = PlayerPedId()
    local vehicles = GetGamePool('CVehicle')
    local closestDistance = -1
    local closestVehicle = -1
    local coords = GetEntityCoords(ped)
    for i = 1, #vehicles, 1 do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local distance = #(vehicleCoords - coords)

        if closestDistance == -1 or closestDistance > distance then
            closestVehicle = vehicles[i]
            closestDistance = distance
        end
    end
    return closestVehicle, closestDistance
end

local function HasItem(items, amount)
	local Player = nil
	if Framework == "QBCore" then
		local DoesHasItem = "nothing"
		Config.FrameworkFunctions.TriggerCallback("Pug:server:GetItemDrugRunning", function(HasItem)
			if HasItem then
				DoesHasItem = true
			else
				DoesHasItem = false
			end
		end, items, amount)
		while DoesHasItem == "nothing" do Wait(1) end
		return DoesHasItem
	else
		local DoesHasItem = "nothing"
		Config.FrameworkFunctions.TriggerCallback("Pug:serverESX:GetItemsDrugRunning", function(HasItem)
			if HasItem then
				DoesHasItem = true
			else
				DoesHasItem = false
			end
		end, items, amount)
		while DoesHasItem == "nothing" do Wait(1) end
		return DoesHasItem
	end
end

local function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
	local nearbyEntities = {}
	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end
	for k, entity in pairs(entities) do
		local distance = #(coords - GetEntityCoords(entity))
		if distance <= maxDistance then
			nearbyEntities[#nearbyEntities+1] = isPlayerEntities and k or entity
		end
	end
	return nearbyEntities
end

local function GetVehiclesInArea(coords, maxDistance) -- Vehicle inspection in designated area
	return EnumerateEntitiesWithinDistance(GetGamePool('CVehicle'), false, coords, maxDistance) 
end

local function IsSpawnPointClear(coords, maxDistance) -- Check the spawn point to see if it's empty or not
	return #GetVehiclesInArea(coords, maxDistance) == 0 
end

local function CreatePickupBoxBlips(Coords)
    -- RADIUS BLIP SETUP
    -- BoxPickupBlip = AddBlipForRadius(Coords.x , Coords.y , Coords.z, 7.0)
    -- SetBlipColour(BoxPickupBlip, 1)
    -- SetBlipAlpha(BoxPickupBlip, 128)
    ---------------------
    -- BLIPSPRITE RADIUS EMULATE SETUP
    BoxPickupBlip = AddBlipForCoord(Coords.x, Coords.y, Coords.z)
    SetBlipSprite(BoxPickupBlip, Config.PickupBoxBlip.Type)
    SetBlipDisplay(BoxPickupBlip, 8)
    SetBlipScale(BoxPickupBlip, Config.PickupBoxBlip.Size)
    SetBlipAsShortRange(BoxPickupBlip, false)
    SetBlipAlpha(BoxPickupBlip, Config.PickupBoxBlip.Opacity)
    SetBlipColour(BoxPickupBlip, Config.PickupBoxBlip.Color)
    ----------------------
end

local function CreateBoatDropOffBlip(Coords)
    -- RADIUS BLIP SETUP
    -- BoatDropOffBlip = AddBlipForRadius(Coords.x , Coords.y , Coords.z, 30.0)
    -- SetBlipColour(BoatDropOffBlip, 1)
    -- SetBlipAlpha(BoatDropOffBlip, 128)
    -- SetBlipAsShortRange(BoatDropOffBlip, false)
    ---------------------
    -- BLIPSPRITE RADIUS EMULATE SETUP
    BoatDropOffBlip = AddBlipForCoord(Coords.x, Coords.y, Coords.z)
    SetBlipSprite(BoatDropOffBlip, Config.BoatDropOffBlip.Type)
    SetBlipDisplay(BoatDropOffBlip, 8)
    SetBlipScale(BoatDropOffBlip, Config.BoatDropOffBlip.Size)
    SetBlipAsShortRange(BoatDropOffBlip, false)
    SetBlipAlpha(BoatDropOffBlip, Config.BoatDropOffBlip.Opacity)
    SetBlipColour(BoatDropOffBlip, Config.BoatDropOffBlip.Color)
    ----------------------
end

local function CreatePlaneDropOffBlip(Coords)
    -- RADIUS BLIP SETUP
    -- BoatDropOffBlip = AddBlipForRadius(Coords.x , Coords.y , Coords.z, 30.0)
    -- SetBlipColour(BoatDropOffBlip, 1)
    -- SetBlipAlpha(BoatDropOffBlip, 128)
    -- SetBlipAsShortRange(BoatDropOffBlip, false)
    ---------------------
    -- BLIPSPRITE RADIUS EMULATE SETUP
    PlaneDropOffBlip = AddBlipForCoord(Coords.x, Coords.y, Coords.z)
    SetBlipSprite(PlaneDropOffBlip, Config.PlaneDropOffBlip.Type)
    SetBlipDisplay(PlaneDropOffBlip, 8)
    SetBlipScale(PlaneDropOffBlip, Config.PlaneDropOffBlip.Size)
    SetBlipAsShortRange(PlaneDropOffBlip, false)
    SetBlipAlpha(PlaneDropOffBlip, Config.PlaneDropOffBlip.Opacity)
    SetBlipColour(PlaneDropOffBlip, Config.PlaneDropOffBlip.Color)
    ----------------------
end

local function CreatePlanePickupBlip(Coords)
    -- RADIUS BLIP SETUP
    -- BoatDropOffBlip = AddBlipForRadius(Coords.x , Coords.y , Coords.z, 30.0)
    -- SetBlipColour(BoatDropOffBlip, 1)
    -- SetBlipAlpha(BoatDropOffBlip, 128)
    -- SetBlipAsShortRange(BoatDropOffBlip, false)
    ---------------------
    -- BLIPSPRITE RADIUS EMULATE SETUP
    PlanePickupBlip = AddBlipForCoord(Coords.x, Coords.y, Coords.z)
    SetBlipSprite(PlanePickupBlip, Config.PickupPlaneBlip.Type)
    SetBlipDisplay(PlanePickupBlip, 8)
    SetBlipScale(PlanePickupBlip, Config.PickupPlaneBlip.Size)
    SetBlipAsShortRange(PlanePickupBlip, false)
    SetBlipAlpha(PlanePickupBlip, Config.PickupPlaneBlip.Opacity)
    SetBlipColour(PlanePickupBlip, Config.PickupPlaneBlip.Color)
    ----------------------
end

local function SpawnDrugPlane()
    if DoesBlipExist(PlanePickupBlip) then
        RemoveBlip(PlanePickupBlip)
    end
	if DoesEntityExist(DrugPlane) then
	    SetVehicleHasBeenOwnedByPlayer(DrugPlane,false)
		SetEntityAsNoLongerNeeded(DrugPlane)
		DeleteEntity(DrugPlane)
    end
    local PlaneModel = GetHashKey(Config.DrugPlaneModel)
    if DrugPlaneToSpawn then
        PlaneModel = DrugPlaneToSpawn
    end
    PugLoadModel(PlaneModel)
    DrugPlane = CreateVehicle(PlaneModel, DrugPlaneSpawnLocation.PlaneLoc.x, DrugPlaneSpawnLocation.PlaneLoc.y, DrugPlaneSpawnLocation.PlaneLoc.z, DrugPlaneSpawnLocation.PlaneLoc.w, 100, true, false)
    while not DoesEntityExist(DrugPlane) do Wait(100) end
    SetVehicleHasBeenOwnedByPlayer(DrugPlane,true)
	local Plate = GetVehicleNumberPlateText(DrugPlane)
    if Config.FuelScript then
	    exports[Config.FuelScript]:SetFuel(DrugPlane, 100)
    else
        SetVehicleFuelLevel(DrugPlane, 100.0)
    end
    SetVehicleDoorsLocked(DrugPlane, 1)
    TriggerEvent(Config.VehilceKeysGivenToPlayerEvent, Plate)
    if DoesBlipExist(blip1) then
        RemoveBlip(blip1)
    end
    LoadingPackages = true
    CreateThread(function()
        local PlayerPed = PlayerPedId()
        local RandomBoxLocation = math.random(1, #DrugPlaneSpawnLocation.Boxes)
        local BoxPickupLocation = DrugPlaneSpawnLocation.Boxes[RandomBoxLocation]
        local DrawnText = false
        BoxesLoadedCounter = math.random(Config.BoxesToGrabMin, Config.BoxesToGrabMax)
        local Count = 0.0
        local BoxesLoaded = BoxesLoadedCounter
        DrugJobNotification(Config.LangT["LoadUp"].." "..BoxesLoadedCounter.." "..Config.LangT["BoxesIntoPlain"])
        CreatePickupBoxBlips(BoxPickupLocation)
        local PuttingBoxOnPlane = false
        while LoadingPackages do
            Wait(2)
            if LoadingPackages then
                if BoxesLoaded > 0 then
                    local Dist = #(vector3(DrugPlaneSpawnLocation.PlaneLoc.x,DrugPlaneSpawnLocation.PlaneLoc.y,DrugPlaneSpawnLocation.PlaneLoc.z) - GetEntityCoords(PlayerPed))
                    if Dist >= 70.0 then
                        LoadingPackages = false
                        StartedDrugJob = false
                        TriggerEvent("FullyDeleteDrugPlaneVehicle", DrugPlane)
                        DrugJobNotification(Config.LangT["YouLefTheDrugPlane"], "error")
                        PlaneRuns = PlaneRuns - 1
                        if PlaneRuns > 0 then
                            TriggerEvent("Pug:server:StartDrugRun")
                        end
                        break
                    end
                    -- PICKING BOX UP FROM BOX SHELF
                    if not IsEntityAttachedToEntity(PlayerPedId(), BoxInHand) then
                        local BoxPickDist = #(vector3(BoxPickupLocation.x,BoxPickupLocation.y,BoxPickupLocation.z) - GetEntityCoords(PlayerPed))
                        if BoxPickDist <= 8.0 then
                            if Config.MarkerBoxLocations.ShowDrawMarker then
                                DrawMarker(Config.MarkerBoxLocations.Type, BoxPickupLocation.x, BoxPickupLocation.y, BoxPickupLocation.z-1, 0.1, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerBoxLocations.Scale.x, Config.MarkerBoxLocations.Scale.y, Config.MarkerBoxLocations.Scale.z, Config.MarkerBoxLocations.Color.r, Config.MarkerBoxLocations.Color.g, Config.MarkerBoxLocations.Color.b, Config.MarkerBoxLocations.Color.a, false, true, 2, false, false, false, false)
                            end
                            if BoxPickDist <= 1.0 then
                                if not DrawnText then
                                    DrawnText = true
                                    DrugJobDrawText(Config.LangT["PickupBox"])
                                end
                                if IsControlJustPressed(0, 38) then
                                    DrawnText = false
                                    DrugJobHideText()
                                    if DoesBlipExist(BoxPickupBlip) then
                                        RemoveBlip(BoxPickupBlip)
                                    end
                                    SetEntityCoords(PlayerPed, vector3(BoxPickupLocation.x,BoxPickupLocation.y,BoxPickupLocation.z-1))
                                    SetEntityHeading(PlayerPed, BoxPickupLocation.w)
                                    loadAnimDict("anim@safehouse@beer")
                                    TaskPlayAnim(PlayerPed, "anim@safehouse@beer", "drink_beer_stage1", 8.0, -8.0, -1, 8, 0, false, false, false)
                                    Wait(1500)
                                    ClearPedTasks(PlayerPed)
                                    loadAnimDict("anim@heists@box_carry@")
                                    TaskPlayAnim(PlayerPed, "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
                                    BoxInHand = CreateObject(GetHashKey("hei_prop_heist_box"), GetEntityCoords(PlayerPed).x, GetEntityCoords(PlayerPed).y, GetEntityCoords(PlayerPed).z, true, true, true)  
                                    AttachEntityToEntity(BoxInHand, PlayerPed, GetPedBoneIndex(PlayerPed, 60309), 0.025, 0.08, 0.255, -145.0, 290.0, 0.0, true, true, false, true, 1, true)
                                    CreatePickupBoxBlips(GetEntityCoords(DrugPlane))
                                    PuttingBoxOnPlane = true
                                end
                            end
                        else
                            if DrawnText then
                                DrawnText = false
                                DrugJobHideText()
                            end
                        end
                    end
                    -- PUTTING BOX ONTO PLANE
                    if PuttingBoxOnPlane then
                        if DoesEntityExist(BoxInHand) then
                            if IsEntityAttachedToEntity(PlayerPedId(), BoxInHand) then
                                local PlaneDist = #(vector3(DrugPlaneSpawnLocation.PlaneLoc.x,DrugPlaneSpawnLocation.PlaneLoc.y,DrugPlaneSpawnLocation.PlaneLoc.z) - GetEntityCoords(PlayerPed))
                                -- if PlaneDist <= 3.0 then
                                if Count < 3 and #(GetEntityBonePosition_2(DrugPlane, PlaneToSpawnIndexes.bone1) - GetEntityCoords(PlayerPed)) <= 3.0 or Count >= 3 and #(GetEntityBonePosition_2(DrugPlane, PlaneToSpawnIndexes.bone2) - GetEntityCoords(PlayerPed)) <= 3.0 then
                                    if not DrawnText then
                                        DrawnText = true
                                        DrugJobDrawText(Config.LangT["LoadBoxToPlane"])
                                    end
                                    if IsControlJustPressed(0, 38) then
                                        if Count < 3 and #(GetEntityBonePosition_2(DrugPlane, PlaneToSpawnIndexes.bone1) - GetEntityCoords(PlayerPed)) <= 4.0 or Count >= 3 and #(GetEntityBonePosition_2(DrugPlane, PlaneToSpawnIndexes.bone2) - GetEntityCoords(PlayerPed)) <= 4.0 then
                                            BoxesLoaded = BoxesLoaded - 1
                                            DrawnText = false
                                            DrugJobHideText()
                                            if Count < 3 then
                                                TaskTurnPedToFaceCoord(PlayerPed, GetEntityBonePosition_2(DrugPlane, PlaneToSpawnIndexes.bone1), 1500)
                                            else
                                                TaskTurnPedToFaceCoord(PlayerPed, GetEntityBonePosition_2(DrugPlane, PlaneToSpawnIndexes.bone2), 1500)
                                            end
                                            if DoesBlipExist(BoxPickupBlip) then
                                                RemoveBlip(BoxPickupBlip)
                                            end
                                            Wait(700)
                                            ClearPedTasks(PlayerPed)
                                            loadAnimDict("anim@safehouse@beer")
                                            TaskPlayAnim(PlayerPed, "anim@safehouse@beer", "drink_beer_stage1", 8.0, -8.0, -1, 8, 0, false, false, false)
                                            Wait(800)
                                            TriggerServerEvent("InteractSound_SV:PlayOnSource", "Clothes1", 0.4)
                                            Wait(1200)
                                            ClearPedTasksImmediately(PlayerPed)
                                            if Count < 3 then
                                                AttachEntityToEntity(BoxInHand, DrugPlane, PlaneToSpawnIndexes.bone1, PlaneToSpawnIndexes.xaxis or Count, PlaneToSpawnIndexes.yaxis or Count, PlaneToSpawnIndexes.zaxis, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
                                            else
                                                AttachEntityToEntity(BoxInHand, DrugPlane, PlaneToSpawnIndexes.bone2, PlaneToSpawnIndexes.xaxis or Count-3, PlaneToSpawnIndexes.yaxis or Count-3, PlaneToSpawnIndexes.zaxis, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
                                            end
                                            Count = Count + 1
                                            RandomBoxLocation = math.random(1, #DrugPlaneSpawnLocation.Boxes)
                                            BoxPickupLocation = DrugPlaneSpawnLocation.Boxes[RandomBoxLocation]
                                            if BoxesLoaded > 0 then
                                                CreatePickupBoxBlips(BoxPickupLocation)
                                                DrugJobNotification(Config.LangT["LoadUp"].." "..BoxesLoaded.."/"..BoxesLoadedCounter.." "..Config.LangT["BoxesIntoPlain"])
                                            end
                                            PuttingBoxOnPlane = false
                                        else
                                            DrugJobNotification(Config.LangT["OtherSideOfPlane"], "error")
                                        end
                                    end
                                else
                                    if DrawnText then
                                        DrawnText = false
                                        DrugJobHideText()
                                    end
                                end
                            end
                        else
                            PuttingBoxOnPlane = false
                            DrawnText = false
                            DrugJobHideText()
                            if DoesBlipExist(BoxPickupBlip) then
                                RemoveBlip(BoxPickupBlip)
                            end
                            RandomBoxLocation = math.random(1, #DrugPlaneSpawnLocation.Boxes)
                            BoxPickupLocation = DrugPlaneSpawnLocation.Boxes[RandomBoxLocation]
                            if BoxesLoaded > 0 then
                                CreatePickupBoxBlips(BoxPickupLocation)
                                DrugJobNotification(Config.LangT["LoadUp"].." "..BoxesLoaded.."/"..BoxesLoadedCounter.." "..Config.LangT["BoxesIntoPlain"])
                            end
                        end
                    end
                else
                    LoadingPackages = false
                    DroppingOffPackages = true
                    DrugJobNotification(Config.LangT["FinishedLoadingPlane"], "success")
                    Wait(700)
                    DrugJobNotification(Config.LangT["HeadToPackageDropOffs"], "success")
                    -- BOAT SPAWNING
                    local RandomBoatSpawns = math.random(1, #DrugPlaneSpawnLocation.BoatsSpawns)
                    local BoatCoords = DrugPlaneSpawnLocation.BoatsSpawns[RandomBoatSpawns]
                    local RandomBoat = math.random(1, #Config.RandomBoatModel)
                    local model = Config.RandomBoatModel[RandomBoat]
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Wait(50)
                    end
                    RandomDropOffBoat = CreateVehicle(model, BoatCoords.x, BoatCoords.y, BoatCoords.z)
                    while not DoesEntityExist(RandomDropOffBoat) do Wait(100) end
                    -- Ped Creation
                    local RandomBoatPed = math.random(1, #Config.DrugBoatPedModel)
                    local BoatPedModel = Config.DrugBoatPedModel[RandomBoat]
                    DrugBoatPed = BoatPedModel
                    PugLoadModel(DrugBoatPed)
                    DrugBoatPedMan = CreatePed(2, DrugBoatPed, BoatCoords.x, BoatCoords.y, BoatCoords.z)
                    while not DoesEntityExist(DrugBoatPedMan) do Wait(100) end
                    SetPedFleeAttributes(DrugBoatPedMan, 0, 0)
                    SetPedDiesWhenInjured(DrugBoatPedMan, false)
                    SetBlockingOfNonTemporaryEvents(DrugBoatPedMan, true)
                    SetEntityInvincible(DrugBoatPedMan, true)
                    TaskWarpPedIntoVehicle(DrugBoatPedMan, RandomDropOffBoat, -1)
                    -- End
                    CreateBoatDropOffBlip(BoatCoords)
                    PlaySoundFrontend(-1, "FocusIn", "HintCamSounds", 1)
                    ----------------
                    TriggerEvent("Pug:client:DoingDropOffRun")
                    TriggerEvent("Pug:client:DeliverDrugPlanePackages")
                    TriggerEvent("Pug:client:CheckToCallPoliceLoop")
                    break
                end
            else
                break
            end
        end
    end)
end

-- Events
RegisterNetEvent("Pug:server:ChooseAmountDrugRuns", function()
    if Config.InputScript == "qb-input" or Config.InputScript == "ps-ui" then
        local input = exports[Config.InputScript]:ShowInput({
            header = Config.LangT["ChooseAmountOfRuns"],
            submitText = "Member",
            inputs = {
                {
                    type = 'number',
                    isRequired = true,
                    name = 'id',
                    text = Config.LangT["Amount"]
                }
            }
        })
        if not input then 
            DrugJobNotification(Config.LangT["NoInput"], 'error')
            TriggerEvent("Pug:Client:DrugLaptopMenu")
            return
        end
        if tonumber(input.id) <= Config.MaxPlaneRunsAtOne then
            PlaneRuns = tonumber(input.id)
            TriggerEvent("Pug:server:StartDrugRun")
        else
            DrugJobNotification(Config.LangT["CantDoThisMany"], "error")
            TriggerEvent("Pug:Client:DrugLaptopMenu")
        end
    else
        local input = lib.inputDialog(Config.LangT["ChooseAmountOfRuns"], {
            {
                type = 'number',
                name = "id",
                label = Config.LangT["Amount"]
            }
        })
        if not input then 
            DrugJobNotification(Config.LangT["NoInput"], 'error')
            TriggerEvent("Pug:Client:DrugLaptopMenu")
            return
        end
        if input[1] then
            if tonumber(input[1]) <= Config.MaxPlaneRunsAtOne then
                PlaneRuns = tonumber(input[1])
                TriggerEvent("Pug:server:StartDrugRun")
            else
                DrugJobNotification(Config.LangT["CantDoThisMany"], "error")
                TriggerEvent("Pug:Client:DrugLaptopMenu")
            end
        end
    end
end)
RegisterNetEvent("Pug:server:StartDrugRun", function()
    if not StartedDrugJob then
        Config.FrameworkFunctions.TriggerCallback('Pug:ServerCB:GetPlayerMoneyCount', function(HasMoney)
            if HasMoney then
                ClearPedTasks(PlayerPedId())
                PlaySoundFrontend(-1, "TENNIS_POINT_WON", "HUD_AWARDS", 1)
                TriggerServerEvent("Pug:server:DrugPlaneDepositeToggle")
                local sentalready = false
                StartedDrugJob = true
                DrugJobNotification(Config.LangT["StartedDrugRun"], "success")
                local RandomLoc = math.random(1,#Config.PickupPlaneLocations)
                local Location = Config.PickupPlaneLocations[RandomLoc].PlaneLoc
                DrugPlaneSpawnLocation = Config.PickupPlaneLocations[RandomLoc]
                CreatePlanePickupBlip(Location)
                CreateThread(function()
                    while StartedDrugJob do
                        Wait(1000)
                        if StartedDrugJob then
                            local Dist = #(vector3(Location.x,Location.y,Location.z) - GetEntityCoords(PlayerPedId()))
                            if Dist <= 30.0 then
                                if IsSpawnPointClear(vector3(Location.x,Location.y,Location.z), 5.5) then
                                    SpawnDrugPlane()
                                    TriggerEvent("Pug:client:CheckIfPlayerTooFarFromPlane")
                                    break
                                else
                                    if not sentalready then
                                        DrugJobNotification(Config.LangT["AreaNotClear"], "error")
                                        sentalready = true
                                        Wait(5000)
                                        sentalready = false
                                    end
                                end
                            end
                        else
                            break
                        end
                    end
                end)
            else
                DrugJobNotification(Config.LangT["NotEnoughMoney"], "error")
                ClearPedTasks(PlayerPedId())
            end
        end)
    else
        DrugJobNotification(Config.LangT["ActiveJobAlready"], "error")
        ClearPedTasks(PlayerPedId())
        TriggerEvent("Pug:Client:DrugLaptopMenu")
    end
end)

RegisterNetEvent("Pug:client:DoingDropOffRun", function()
    local ThisOriginalBoxesLoadedCounter = BoxesLoadedCounter
    while BoxesLoadedCounter > 0 do
        Wait(1000)
        if BoxesLoadedCounter > 0 then
            if BoxesLoadedCounter < ThisOriginalBoxesLoadedCounter then
                Wait(math.random(Config.WaitTimeForNewBoatDropoffMin, Config.WaitTimeForNewBoatDropoffMax))
                -- BOAT SPAWNING
                local RandomBoatSpawns = math.random(1, #DrugPlaneSpawnLocation.BoatsSpawns)
                local BoatCoords = DrugPlaneSpawnLocation.BoatsSpawns[RandomBoatSpawns]
                local RandomBoat = math.random(1, #Config.RandomBoatModel)
                local model = Config.RandomBoatModel[RandomBoat]
                RequestModel(model)
                while not HasModelLoaded(model) do
                    Wait(50)
                end
                RandomDropOffBoat = CreateVehicle(model, BoatCoords.x, BoatCoords.y, BoatCoords.z)
                while not DoesEntityExist(RandomDropOffBoat) do Wait(100) end
                -- Ped Creation
                local RandomBoatPed = math.random(1, #Config.DrugBoatPedModel)
                local BoatPedModel = Config.DrugBoatPedModel[RandomBoat]
                DrugBoatPed = BoatPedModel
                PugLoadModel(DrugBoatPed)
                DrugBoatPedMan = CreatePed(2, DrugBoatPed, BoatCoords.x, BoatCoords.y, BoatCoords.z)
                while not DoesEntityExist(DrugBoatPedMan) do Wait(100) end
                SetPedFleeAttributes(DrugBoatPedMan, 0, 0)
                SetPedDiesWhenInjured(DrugBoatPedMan, false)
                SetBlockingOfNonTemporaryEvents(DrugBoatPedMan, true)
                SetEntityInvincible(DrugBoatPedMan, true)
                -- End
                CreateBoatDropOffBlip(BoatCoords)
                PlaySoundFrontend(-1, "FocusIn", "HintCamSounds", 1)
                ----------------
                ThisOriginalBoxesLoadedCounter = ThisOriginalBoxesLoadedCounter - 1
            end
        else
            DroppingOffPackages = false
            Wait(math.random(1500, 3500))
            if StartedDrugJob then
                TriggerEvent("Pug:client:DropOffDrugPlane")
            end
            break
        end
    end
end)
RegisterNetEvent("Pug:client:CheckToCallPoliceLoop", function()
    local GaveNoteItem = false
    while StartedDrugJob do 
        Wait(100)
        if StartedDrugJob then
            local PlayerPed = PlayerPedId()
            if IsPedInAnyVehicle(PlayerPed) then
                local Vehicle = GetVehiclePedIsIn(PlayerPed)
                if GetVehicleClass(Vehicle) == 16 then
                    local Altitude = math.ceil(GetEntityCoords(PlayerPed).z * 0.5)
                    if Altitude >= Config.PlaneAltitudeToCallPolice then
                        DrugJobNotification(Config.LangT["PlaneHasGoneHigh"])
                        if not GaveNoteItem then
                            GaveNoteItem = true
                            Config.FrameworkFunctions.TriggerCallback('Pug:server:DoesOwnCokeLab', function(result)
                                if result then
                                    local LabCoords = json.decode(result.lablocation)
                                    local s1, s2 = GetStreetNameAtCoord(LabCoords.x, LabCoords.y, LabCoords.z)
                                    local street1 = GetStreetNameFromHashKey(s1)
                                    local street2 = GetStreetNameFromHashKey(s2)
                                    TriggerServerEvent("Pug:server:GivePlayerCodeItem", street1, street2, result.password)
                                end
                            end)
                        end
                        -- POLICE CALL
                        CallPoliceForDrugPlaneTooHigh(DrugPlaneToSpawn)
                        -- END OF POLICE CALL
                        Wait(30000)
                        if StartedDrugJob then
                            Wait(30000)
                        else
                            break
                        end
                    end
                else
                    Wait(1000)
                end
            else
                Wait(1000)
            end
        else
            break
        end
    end
end)

RegisterNetEvent("Pug:client:DeliverDrugPlanePackages", function()
    OriginalBoxesLoadedCounter = BoxesLoadedCounter
    while DroppingOffPackages do
        Wait(1)
        if DroppingOffPackages then
            if DoesEntityExist(RandomDropOffBoat) then
                local BoatCoords = GetEntityCoords(RandomDropOffBoat)
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                if #(vector3(BoatCoords.x,BoatCoords.y,BoatCoords.z+12.0) - PlayerCoords) <= 150.0 then
                    if Config.MarkerBoatLocations.ShowDrawMarker then
                        DrawMarker(Config.MarkerBoatLocations.Type, BoatCoords.x, BoatCoords.y, BoatCoords.z+12.0, 0.1, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerBoatLocations.Scale.x, Config.MarkerBoatLocations.Scale.y, Config.MarkerBoatLocations.Scale.z, Config.MarkerBoatLocations.Color.r, Config.MarkerBoatLocations.Color.g, Config.MarkerBoatLocations.Color.b, Config.MarkerBoatLocations.Color.a, false, true, 2, false, false, false, false)
                    end
                    if #(vector3(BoatCoords.x,BoatCoords.y,BoatCoords.z+12.0) - PlayerCoords) <= 10.0 then
                        if IsPedInAnyVehicle(PlayerPedId()) then
                            BoxesLoadedCounter = BoxesLoadedCounter - 1
                            SetEntityAsNoLongerNeeded(RandomDropOffBoat)
                            RandomDropOffBoat = nil
                            DrugJobNotification(BoxesLoadedCounter.."/"..OriginalBoxesLoadedCounter)
                            if DoesBlipExist(BoatDropOffBlip) then
                                RemoveBlip(BoatDropOffBlip)
                            end
                            for _, v in pairs(GetGamePool('CObject')) do
                                if IsEntityAttachedToEntity(GetVehiclePedIsIn(PlayerPedId()), v) then
                                    if GetEntityModel(v) == GetHashKey("hei_prop_heist_box") then
                                        SetEntityAsMissionEntity(v, true, true)
                                        DetachEntity(v, true, true)
                                        break
                                    end
                                end
                            end
                            -- Ped Yelling Effect 
                            local RandomBoatPed = math.random(1, #Config.DrugBoatPedModel)
                            local BoatPedModel = Config.DrugBoatPedModel[RandomBoatPed]
                            YellingEffectPed = BoatPedModel
                            PugLoadModel(YellingEffectPed)
                            YellingEffectPedMan = CreatePed(2, YellingEffectPed, GetEntityCoords(PlayerPedId()).x,GetEntityCoords(PlayerPedId()).y,GetEntityCoords(PlayerPedId()).z-2)
                            while not DoesEntityExist(YellingEffectPedMan) do Wait(100) end
                            SetEntityVisible(YellingEffectPedMan, false)
                            SetEntityCollision(YellingEffectPedMan, false, true)
                            PlayAmbientSpeech1(YellingEffectPedMan, 'GENERIC_THANKS', 'Speech_Params_Force_Megaphone')
                            Wait(1000)
                            if DoesEntityExist(YellingEffectPedMan) then
                                SetEntityAsNoLongerNeeded(YellingEffectPedMan)
                                DeleteEntity(YellingEffectPedMan)
                            end
                            -- End of pred yelling effect 
                            SetEntityAsNoLongerNeeded(DrugBoatPedMan)
                        end
                    end
                end
            end
        else
            break
        end
    end
end)

RegisterNetEvent("Pug:client:DropOffDrugPlane", function()
    local RandomPlaneDropOff = math.random(1, #Config.ReturnPlaneLocations)
    local RandomPlaneDropOffCoords = Config.ReturnPlaneLocations[RandomPlaneDropOff].PlaneLocation
    local DrawnText = false
    local sleep = 1000
    -- Ped Creation
    DropOffPlaneDrugPed = Config.DrugPed
    PugLoadModel(DropOffPlaneDrugPed)
    DropOffPlaneDrugPedMan = CreatePed(2, DropOffPlaneDrugPed, Config.ReturnPlaneLocations[RandomPlaneDropOff].PedLocation.x,Config.ReturnPlaneLocations[RandomPlaneDropOff].PedLocation.y,Config.ReturnPlaneLocations[RandomPlaneDropOff].PedLocation.z-1)
    while not DoesEntityExist(DropOffPlaneDrugPedMan) do Wait(100) end
    SetEntityHeading(DropOffPlaneDrugPedMan, Config.ReturnPlaneLocations[RandomPlaneDropOff].PedLocation.w)
    SetPedFleeAttributes(DropOffPlaneDrugPedMan, 0, 0)
    SetPedDiesWhenInjured(DropOffPlaneDrugPedMan, false)
    SetPedKeepTask(DropOffPlaneDrugPedMan, true)
    SetBlockingOfNonTemporaryEvents(DropOffPlaneDrugPedMan, true)
    SetEntityInvincible(DropOffPlaneDrugPedMan, true)
    FreezeEntityPosition(DropOffPlaneDrugPedMan, true)
    TaskStartScenarioInPlace(DropOffPlaneDrugPedMan, "WORLD_HUMAN_CLIPBOARD", 0, true)
    loadAnimDict("amb@world_human_leaning@male@wall@back@foot_up@idle_a")
    TaskPlayAnim(DropOffPlaneDrugPedMan, "amb@world_human_leaning@male@wall@back@foot_up@idle_a", "idle_a", 8.0, -8.0, -1, 8, 0, false, false, false)
    -- End
    CreatePlaneDropOffBlip(RandomPlaneDropOffCoords)
    PlaySoundFrontend(-1, "FocusIn", "HintCamSounds", 1)
    while StartedDrugJob do 
        Wait(2)
        if StartedDrugJob then
            if #(GetEntityCoords(DrugPlane) - vector3(RandomPlaneDropOffCoords.x, RandomPlaneDropOffCoords.y, RandomPlaneDropOffCoords.z)) <= 30.0 then 
                if DoesBlipExist(PlaneDropOffBlip) then
                    RemoveBlip(PlaneDropOffBlip)
                end
                if GetEntityHeading(DrugPlane) + 20 >= RandomPlaneDropOffCoords.w and GetEntityHeading(DrugPlane) - 20 <= RandomPlaneDropOffCoords.w then
                    if #(GetEntityCoords(DrugPlane) - vector3(RandomPlaneDropOffCoords.x, RandomPlaneDropOffCoords.y, RandomPlaneDropOffCoords.z)) <= 5.0 then 
                        DrawMarker(30,RandomPlaneDropOffCoords.x,RandomPlaneDropOffCoords.y,RandomPlaneDropOffCoords.z-0.6,0,0,0,90.0,RandomPlaneDropOffCoords.w,0.0,3.0,1.0,8.0,0,255,0,50,0,0,0,0)
                        if not DrawnText then
                            DrawnText = true
                            DrugJobDrawText(Config.LangT["ParkVehicle"])
                        end
                        if IsControlJustPressed(0, 38) then
                            DoingDrugHandoff = true
                            local PlayerPed = PlayerPedId()
                            DrugJobHideText()
                            TaskLeaveVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(PlayerPedId()), 1)
                            Wait(2500)
                            FreezeEntityPosition(DropOffPlaneDrugPedMan,false)
                            -- TaskGoStraightToCoord(DropOffPlaneDrugPedMan, GetEntityCoords(PlayerPed), 1.0, -1, 0.0, 0.0)
                            TaskGoToCoordAnyMeans(DropOffPlaneDrugPedMan, GetEntityCoords(PlayerPedId()), 1.0, 0, 0, 786603, 0xbf800000)
                            TaskGoToCoordAnyMeans(PlayerPedId(), GetEntityCoords(DropOffPlaneDrugPedMan), 1.0, 0, 0, 786603, 0xbf800000)
                            while #(GetEntityCoords(DropOffPlaneDrugPedMan) - GetEntityCoords(PlayerPed)) >= 1.4 do 
                                Wait(800)
                                if StartedDrugJob then
                                    TaskGoToCoordAnyMeans(DropOffPlaneDrugPedMan, GetEntityCoords(PlayerPedId()), 1.0, 0, 0, 786603, 0xbf800000)
                                    TaskGoToCoordAnyMeans(PlayerPedId(), GetEntityCoords(DropOffPlaneDrugPedMan), 1.0, 0, 0, 786603, 0xbf800000)
                                    -- TaskGoStraightToCoord(DropOffPlaneDrugPedMan, GetEntityCoords(PlayerPedId()), 1.0, -1, 0.0, 0.0)
                                    -- TaskGoStraightToCoord(PlayerPed, GetEntityCoords(DropOffPlaneDrugPedMan), 1.0, -1, 0.0, 0.0)
                                else
                                    break
                                end
                            end
                            ClearPedTasksImmediately(PlayerPed)
                            ClearPedTasksImmediately(DropOffPlaneDrugPedMan)
                            TaskTurnPedToFaceCoord(DropOffPlaneDrugPedMan, GetEntityCoords(PlayerPed), 1500)
                            TaskTurnPedToFaceCoord(PlayerPed, GetEntityCoords(DropOffPlaneDrugPedMan), 1500)
                            Wait(700)
                            SellDrugsAnimation(DropOffPlaneDrugPedMan)
                            TriggerServerEvent("Pug:server:DrugPlaneDepositeToggle", OriginalBoxesLoadedCounter)
                            TriggerServerEvent("Pug:server:GiveDrugRunDrugs")
                            SetPedAsNoLongerNeeded(DropOffPlaneDrugPedMan)
                            TriggerEvent("FullyDeleteDrugPlaneVehicle", DrugPlane)
                            Wait(8000)
                            DoingDrugHandoff = false
                            ResetAllStats()
                            PlaneRuns = PlaneRuns - 1
                            if PlaneRuns > 0 then
                                TriggerEvent("Pug:server:StartDrugRun")
                            end
                        end
                    else
                        if DrawnText then
                            DrawnText = false
                            DrugJobHideText()
                        end
                        DrawMarker(30,RandomPlaneDropOffCoords.x,RandomPlaneDropOffCoords.y,RandomPlaneDropOffCoords.z-0.6,0,0,0,90.0,RandomPlaneDropOffCoords.w,0.0,3.0,1.0,8.0,255,0,0,50,0,0,0,0)
                    end
                else
                    DrawMarker(30,RandomPlaneDropOffCoords.x,RandomPlaneDropOffCoords.y,RandomPlaneDropOffCoords.z-0.6,0,0,0,90.0,RandomPlaneDropOffCoords.w,0.0,3.0,1.0,8.0,255,0,0,50,0,0,0,0)
                end
            end
        else
            break
        end
    end
end)
RegisterNetEvent("Pug:client:DrugRunMenu", function()
    if Config.Menu == "ox_lib" then
        local menu = {
            {
                title = Config.LangT["DrugRunMenuOption"],
                description = Config.LangT["DrugRunMenuDescription"],
                icon = "fa-solid fa-pills",
                event = "Pug:server:StartDrugRun",
            },
        }
        lib.registerContext({
            id = 'DrugRunMenuHeader',
            title = Config.LangT["DrugRunMenuHeader"],
            options = menu
        })
        lib.showContext('DrugRunMenuHeader')
    else
        local menu = {
            {
                isMenuHeader = true,
                header = Config.LangT["DrugRunMenuHeader"],
                icon = "fa-solid fa-skull-crossbones",
                txt = "",
            },
            {
                header = Config.LangT["DrugRunMenuOption"],
                icon = "fa-solid fa-pills",
                text = Config.LangT["DrugRunMenuDescription"],
                params = {
                    event = "Pug:server:StartDrugRun",
                }
            },
        }
        exports[Config.Menu]:openMenu(menu)
    end
end)

RegisterNetEvent("Pug:client:CheckIfPlayerTooFarFromPlane", function()
    while StartedDrugJob do 
        Wait(1000)
        if StartedDrugJob then
            if GetVehicleEngineHealth(DrugPlane) < 5.0 then
                DrugJobNotification(Config.LangT["PlaneDestroyed"], "error")
                ResetAllStats()
                break
            end
            if #(GetEntityCoords(DrugPlane) - GetEntityCoords(PlayerPedId())) >= 70.0 then
                if not DoingDrugHandoff then
                    DrugJobNotification(Config.LangT["YouLefTheDrugPlane"], "error")
                end
                ResetAllStats()
                break
            end
        else
            ResetAllStats()
            break
        end
    end
end)

RegisterNetEvent("FullyDeleteDrugPlaneVehicle", function(vehicle)
    local entity = nil
    if vehicle then
        entity = vehicle
    else
        entity = PugGetClosestVehicle()
    end
    local ped = PlayerPedId()
    NetworkRequestControlOfEntity(entity)
    local timeout = 2000
    while timeout > 0 and not NetworkHasControlOfEntity(entity) do
        Wait(100)
        timeout = timeout - 100
    end
    SetEntityAsMissionEntity(entity, true, true)
    local timeout = 2000
    while timeout > 0 and not IsEntityAMissionEntity(entity) do
        Wait(100)
        timeout = timeout - 100
    end
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
    if ( DoesEntityExist( entity ) ) then 
        DeleteEntity(entity)
        if ( DoesEntityExist( entity ) ) then     
            return false
        else 
            return true
        end
    else 
        return true
    end 
end)

local CokeWorkerLocations = {
    -- Synced Scene loacations
--     [0] = {
--         ["0-1"] = vector4(1088.93, -3197.50, -38.99, 84.58),
--         ["0-2"] = vector4(1092.12, -3196.20, -38.99, 179.9),
--         ["0-3"] = vector4(1088.44, -3195.27, -38.99, 0.6),
--     },
--     [1] = {
--         ["1-1"] = vector4(1094.88, -3196.20, -38.99, 179.9),
--         ["1-2"] = vector4(1091.1, -3195.27, -38.99, 0.6),
--     },
--     [2] = {
--         ["2-1"] = vector4(1096.83, -3194.0, -38.99, 263.47),
--         ["2-2"] = vector4(1097.3, -3196.20, -38.99, 179.9),
--         ["2-3"] = vector4(1093.7, -3195.27, -38.99, 0.6),
--     },
--     [3] = {
--         ["3-1"] = vector4(1096.83, -3194.0, -38.99, 263.47),
--     },
    [0] = {
        ["0-1"] = vector4(1088.8, -3195.86, -38.99, 269.12),
        ["0-2"] = vector4(1090.55, -3196.56, -38.99, 2.71),
        ["0-3"] = vector4(1090.32, -3194.93, -38.99, 182.15),
    },
    [1] = {
        ["1-1"] = vector4(1092.89, -3194.93, -38.99, 188.26),
        ["1-2"] = vector4(1092.97, -3196.57, -38.99, 2.04),
    },
    [2] = {
        ["2-1"] = vector4(1095.5, -3196.57, -38.99, 359.45),
        ["2-2"] = vector4(1095.26, -3194.88, -38.99, 182.36),
        ["2-3"] = vector4(1096.98, -3195.65, -38.99, 87.36),
    },
    [3] = {
        ["3-1"] = vector4(1096.83, -3194.0, -38.99, 263.47), -- NETWORKED PED
        ["3-2"] = vector4(1094.91, -3192.91, -38.99, 1.27),
        ["3-3"] = vector4(1093.57, -3199.02, -38.99, 180.61),
        ["3-4"] = vector4(1087.14, -3198.21, -38.99, 93.51),
    },
}
CreateThread(function()
    -- TriggerEvent("Pug:client:CreateWorkerPedsDefaultLab")
end)
RegisterNetEvent("Pug:client:CreateWorkerPedsDefaultLab", function(bool)
    for k, _ in pairs(CokeWorkerLocations) do
        if CokeLabData.upgrades >= k and not bool then
            if k < 3 then
                for j, v in pairs(CokeWorkerLocations[k]) do
                    local bool2 = false
                    if j == "0-1" or j == "2-1" then
                        bool2 = true
                    end
                    local RandomModle = math.random(1, #Config.CokeWorkerModles)
                    local WorkerPedModel = Config.CokeWorkerModles[RandomModle]
                    PugLoadModel(WorkerPedModel)
                    WorkerPedMan[j] = CreatePed(1, WorkerPedModel, vector4(v.x, v.y, v.z-1, v.w))
                    while not DoesEntityExist(WorkerPedMan[j]) do Wait(100) end
                    SetPedFleeAttributes(WorkerPedMan[j], 0, 0)
                    SetPedDiesWhenInjured(WorkerPedMan[j], false)
                    SetPedKeepTask(WorkerPedMan[j], true)
                    SetBlockingOfNonTemporaryEvents(WorkerPedMan[j], true)
                    SetEntityInvincible(WorkerPedMan[j], true)
                    FreezeEntityPosition(WorkerPedMan[j], true) 
                    -- TriggerEvent("Pug:client:DoCokeCutAnimation", WorkerPedMan[j], bool2)
                    local RandomAnim = math.random(0, 5)
                    local VA = "_v"..tostring(RandomAnim).."_"
                    if RandomAnim == 0 then
                        VA = "_"
                    end
                    local animDict, animName = "anim@amb@business@coc@coc_unpack_cut_left@", "coke_cut"..VA.."coccutter"
                    loadAnimDict(animDict)
                    TaskPlayAnim(WorkerPedMan[j], animDict, animName, 2.0, 2.0, -1, 51, 0, false, false, false)
                    PugLoadModel("prop_cs_credit_card")
                    CokeCutCard1[j] = CreateObjectNoOffset(GetHashKey("prop_cs_credit_card"), vector3(v.x, v.y, v.z-1))
                    while not DoesEntityExist(CokeCutCard1[j]) do Wait(100) end
                    AttachEntityToEntity(CokeCutCard1[j], WorkerPedMan[j], GetPedBoneIndex(WorkerPedMan[j],  57005), 0.13, 0.01, -0.02, -30.0, 1.0, 90.0, 1, 1, 0, 1, 0, 1)
                    CokeCutCard2[j] = CreateObjectNoOffset(GetHashKey("prop_cs_credit_card"), vector3(v.x, v.y, v.z-1))
                    while not DoesEntityExist(CokeCutCard2[j]) do Wait(100) end
                    AttachEntityToEntity(CokeCutCard2[j], WorkerPedMan[j], GetPedBoneIndex(WorkerPedMan[j], 0xEE4F), 0.25, 0.02, -0.05, -90.0, 1.0, 90.0, 1, 1, 0, 1, 0, 1) -- object is attached to left hand 
                    if j == "0-1" then
                        local ClipBoardModel = "s_m_m_ammucountry"
                        PugLoadModel(ClipBoardModel)
                        ClipBoardMan = CreatePed(1, ClipBoardModel, vector4(1088.91, -3194.3, -40.0, 213.49))
                        while not DoesEntityExist(ClipBoardMan) do Wait(100) end
                        SetPedFleeAttributes(ClipBoardMan, 0, 0)
                        SetPedDiesWhenInjured(ClipBoardMan, false)
                        SetPedKeepTask(ClipBoardMan, true)
                        SetBlockingOfNonTemporaryEvents(ClipBoardMan, true)
                        SetEntityInvincible(ClipBoardMan, true)
                        FreezeEntityPosition(ClipBoardMan, true) 
                        TaskStartScenarioInPlace(ClipBoardMan, 'WORLD_HUMAN_CLIPBOARD', 0, true)
                        -- SecurityGuard
                        local SecurityGuardModel = "ig_fbisuit_01"
                        PugLoadModel(SecurityGuardModel)
                        SecurityGuardMan = CreatePed(1, SecurityGuardModel, vector4(1090.22, -3191.38, -40.0, 2.6))
                        while not DoesEntityExist(SecurityGuardMan) do Wait(100) end
                        SetPedFleeAttributes(SecurityGuardMan, 0, 0)
                        SetPedDiesWhenInjured(SecurityGuardMan, false)
                        SetPedKeepTask(SecurityGuardMan, true)
                        SetBlockingOfNonTemporaryEvents(SecurityGuardMan, true)
                        SetEntityInvincible(SecurityGuardMan, true)
                        FreezeEntityPosition(SecurityGuardMan, true) 
                        TaskStartScenarioInPlace(SecurityGuardMan, 'WORLD_HUMAN_GUARD_STAND', 0, true)
                    end
                end
            else
                Wait(1000)
                local DontSpawnNewtworkedPed = false
                for _, player in ipairs(GetActivePlayers()) do
                    if GetPlayerPed(-1) == GetPlayerPed(player) then
                    else
                        local OtherPed = GetPlayerPed(player)
                        if #(vector3(1094.67, -3194.82, -38.99) - GetEntityCoords(OtherPed)) <= 25 then
                            DontSpawnNewtworkedPed = true
                        end
                    end
                end
                Wait(100)
                if not DontSpawnNewtworkedPed then
                    for j, v in pairs(CokeWorkerLocations[k]) do
                        if j == "3-1" then
                            local RandomModle = math.random(1, #Config.CokeWorkerModlesMale)
                            local WorkerPedModel = Config.CokeWorkerModlesMale[RandomModle]
                            PugLoadModel(WorkerPedModel)
                            WorkerPedMan[j] = CreatePed(1, WorkerPedModel, vector4(v.x, v.y, v.z-1, v.w), true)
                            while not DoesEntityExist(WorkerPedMan[j]) do Wait(100) end
                            SetPedFleeAttributes(WorkerPedMan[j], 0, 0)
                            SetPedDiesWhenInjured(WorkerPedMan[j], false)
                            SetPedKeepTask(WorkerPedMan[j], true)
                            SetBlockingOfNonTemporaryEvents(WorkerPedMan[j], true)
                            SetEntityInvincible(WorkerPedMan[j], true)
                            FreezeEntityPosition(WorkerPedMan[j], true) 
                            Wait(200)
                            TriggerEvent("Pug:client:DoCokeCutPressAnimation", WorkerPedMan[j])
                            PugLoadModel("bkr_prop_coke_fullmetalbowl_02")
                            CokeCutCard1[j] = CreateObjectNoOffset(GetHashKey("bkr_prop_coke_fullmetalbowl_02"), vector3(1100.35, -3199.30, -39.2))
                        else
                            local RandomModle = math.random(1, #Config.CokeWorkerModlesMale)
                            local WorkerPedModel = Config.CokeWorkerModlesMale[RandomModle]
                            PugLoadModel(WorkerPedModel)
                            WorkerPedMan[j] = CreatePed(1, WorkerPedModel, vector4(v.x, v.y, v.z-1, v.w))
                            while not DoesEntityExist(WorkerPedMan[j]) do Wait(100) end
                            SetPedFleeAttributes(WorkerPedMan[j], 0, 0)
                            SetPedDiesWhenInjured(WorkerPedMan[j], false)
                            SetPedKeepTask(WorkerPedMan[j], true)
                            SetBlockingOfNonTemporaryEvents(WorkerPedMan[j], true)
                            SetEntityInvincible(WorkerPedMan[j], true)
                            FreezeEntityPosition(WorkerPedMan[j], true) 
                            local animDict, animName = "random@train_tracks", "idle_e"
                            if j == "3-2" then
                                animDict, animName = "anim@amb@carmeet@checkout_car@male_c@idles", "idle_a"
                            elseif j == "3-4" then
                                animDict, animName = "mp_fbi_heist", "loop"
                            end
                            loadAnimDict(animDict)
                            TaskPlayAnim(WorkerPedMan[j], animDict, animName, 2.0, 2.0, -1, 51, 0, false, false, false)
                        end
                    end
                end
            end
        elseif bool then
            if tonumber(CokeLabData.upgrades) == k then
                if k < 3 then
                    for j, v in pairs(CokeWorkerLocations[k]) do
                        local bool2 = false
                        if j == "0-1" or j == "2-1" then
                            bool2 = true
                        end
                        local RandomModle = math.random(1, #Config.CokeWorkerModles)
                        local WorkerPedModel = Config.CokeWorkerModles[RandomModle]
                        PugLoadModel(WorkerPedModel)
                        WorkerPedMan[j] = CreatePed(1, WorkerPedModel, vector4(1088.57, -3187.5, -39.99, 181.12))
                        while not DoesEntityExist(WorkerPedMan[j]) do Wait(100) end
                        TaskGoToCoordAnyMeans(WorkerPedMan[j], vector3(1088.76, -3192.14, -38.99), 1.0, 0, 0, 786603, 0xbf800000)
                        SetEntityInvincible(WorkerPedMan[j], true)
                        SetPedFleeAttributes(WorkerPedMan[j], 0, 0)
                        SetPedDiesWhenInjured(WorkerPedMan[j], false)
                        SetPedKeepTask(WorkerPedMan[j], true)
                        SetBlockingOfNonTemporaryEvents(WorkerPedMan[j], true)
                        Wait(3000)
                        TaskGoToCoordAnyMeans(WorkerPedMan[j], vector3(v.x, v.y, v.z-1), 1.0, 0, 0, 786603, 0xbf800000)
                        while #(GetEntityCoords(WorkerPedMan[j]) - vector3(v.x, v.y, v.z-1)) >= 2.4 do Wait(100) if CokeLabData ~= nil then  else break end end
                        ClearPedTasksImmediately(WorkerPedMan[j])
                        SetEntityCoords(WorkerPedMan[j], vector4(v.x, v.y, v.z-1, v.w))
                        SetEntityHeading(WorkerPedMan[j], v.w)
                        FreezeEntityPosition(WorkerPedMan[j], true) 
                        -- TriggerEvent("Pug:client:DoCokeCutAnimation", WorkerPedMan[j], bool2)
                        local RandomAnim = math.random(0, 5)
                        local VA = "_v"..tostring(RandomAnim).."_"
                        if RandomAnim == 0 then
                            VA = "_"
                        end
                        local animDict, animName = "anim@amb@business@coc@coc_unpack_cut_left@", "coke_cut"..VA.."coccutter"
                        loadAnimDict(animDict)
                        TaskPlayAnim(WorkerPedMan[j], animDict, animName, 2.0, 2.0, -1, 51, 0, false, false, false)
                        PugLoadModel("prop_cs_credit_card")
                        CokeCutCard1[j] = CreateObjectNoOffset(GetHashKey("prop_cs_credit_card"), vector3(v.x, v.y, v.z-1))
                        while not DoesEntityExist(CokeCutCard1[j]) do Wait(100) end
                        AttachEntityToEntity(CokeCutCard1[j], WorkerPedMan[j], GetPedBoneIndex(WorkerPedMan[j],  57005), 0.13, 0.01, -0.02, -30.0, 1.0, 90.0, 1, 1, 0, 1, 0, 1)
                        CokeCutCard2[j] = CreateObjectNoOffset(GetHashKey("prop_cs_credit_card"), vector3(v.x, v.y, v.z-1))
                        while not DoesEntityExist(CokeCutCard2[j]) do Wait(100) end
                        AttachEntityToEntity(CokeCutCard2[j], WorkerPedMan[j], GetPedBoneIndex(WorkerPedMan[j], 0xEE4F), 0.25, 0.02, -0.05, -90.0, 1.0, 90.0, 1, 1, 0, 1, 0, 1) -- object is attached to left hand 
                    end
                    break
                else
                    Wait(1000)
                    local DontSpawnNewtworkedPed = false
                    for _, player in ipairs(GetActivePlayers()) do
                        if GetPlayerPed(-1) == GetPlayerPed(player) then
                        else
                            local OtherPed = GetPlayerPed(player)
                            if #(vector3(1094.67, -3194.82, -38.99) - GetEntityCoords(OtherPed)) <= 25 then
                                DontSpawnNewtworkedPed = true
                            end
                        end
                    end
                    Wait(100)
                    if not DontSpawnNewtworkedPed then
                        for j, v in pairs(CokeWorkerLocations[k]) do
                            if j == "3-1" then
                                local RandomModle = math.random(1, #Config.CokeWorkerModlesMale)
                                local WorkerPedModel = Config.CokeWorkerModlesMale[RandomModle]
                                PugLoadModel(WorkerPedModel)
                                WorkerPedMan[j] = CreatePed(1, WorkerPedModel, vector4(1088.57, -3187.5, -39.99, 181.12), true)
                                while not DoesEntityExist(WorkerPedMan[j]) do Wait(100) end
                                SetEntityInvincible(WorkerPedMan[j], true)
                                SetPedFleeAttributes(WorkerPedMan[j], 0, 0)
                                SetPedDiesWhenInjured(WorkerPedMan[j], false)
                                SetPedKeepTask(WorkerPedMan[j], true)
                                SetBlockingOfNonTemporaryEvents(WorkerPedMan[j], true)
                                TaskGoToCoordAnyMeans(WorkerPedMan[j], vector3(1088.76, -3192.14, -38.99), 1.0, 0, 0, 786603, 0xbf800000)
                                Wait(3000)
                                TaskGoToCoordAnyMeans(WorkerPedMan[j], vector3(1100.43, -3198.46, -38.99), 1.0, 0, 0, 786603, 0xbf800000)
                                while #(GetEntityCoords(WorkerPedMan[j]) - vector3(1100.43, -3198.46, -38.99)) >= 1.4 do Wait(100) if CokeLabData ~= nil then  else break end end
                                ClearPedTasksImmediately(WorkerPedMan[j])
                                FreezeEntityPosition(WorkerPedMan[j], true) 
                                Wait(200)
                                TriggerEvent("Pug:client:DoCokeCutPressAnimation", WorkerPedMan[j])
                                PugLoadModel("bkr_prop_coke_fullmetalbowl_02")
                                CokeCutCard1[j] = CreateObjectNoOffset(GetHashKey("bkr_prop_coke_fullmetalbowl_02"), vector3(1100.35, -3199.30, -39.2))
                            else
                                local RandomModle = math.random(1, #Config.CokeWorkerModlesMale)
                                local WorkerPedModel = Config.CokeWorkerModlesMale[RandomModle]
                                PugLoadModel(WorkerPedModel)
                                WorkerPedMan[j] = CreatePed(1, WorkerPedModel, vector4(1088.57, -3187.5, -39.99, 181.12))
                                while not DoesEntityExist(WorkerPedMan[j]) do Wait(100) end
                                TaskGoToCoordAnyMeans(WorkerPedMan[j], vector3(1088.76, -3192.14, -38.99), 1.0, 0, 0, 786603, 0xbf800000)
                                Wait(3000)
                                TaskGoToCoordAnyMeans(WorkerPedMan[j], vector3(v.x, v.y, v.z-1), 1.0, 0, 0, 786603, 0xbf800000)
                                SetEntityInvincible(WorkerPedMan[j], true)
                                SetPedFleeAttributes(WorkerPedMan[j], 0, 0)
                                SetPedDiesWhenInjured(WorkerPedMan[j], false)
                                SetPedKeepTask(WorkerPedMan[j], true)
                                SetBlockingOfNonTemporaryEvents(WorkerPedMan[j], true)
                                while #(GetEntityCoords(WorkerPedMan[j]) - vector3(v.x, v.y, v.z-1)) >= 2.4 do Wait(100) if CokeLabData ~= nil then  else break end end
                                ClearPedTasksImmediately(WorkerPedMan[j])
                                SetEntityCoords(WorkerPedMan[j], vector4(v.x, v.y, v.z-1, v.w))
                                SetEntityHeading(WorkerPedMan[j], v.w)
                                FreezeEntityPosition(WorkerPedMan[j], true) 
                                local animDict, animName = "random@train_tracks", "idle_e"
                                if j == "3-2" then
                                    animDict, animName = "anim@amb@carmeet@checkout_car@male_c@idles", "idle_a"
                                elseif j == "3-4" then
                                    animDict, animName = "mp_fbi_heist", "loop"
                                end
                                loadAnimDict(animDict)
                                TaskPlayAnim(WorkerPedMan[j], animDict, animName, 2.0, 2.0, -1, 51, 0, false, false, false)
                            end
                        end
                    end
                    break
                end
            end
        end
    end
end)

local function RemoveAllInsidePropsAndPeds()
    for k, _ in pairs(CokeWorkerLocations) do
        for j, _ in pairs(CokeWorkerLocations[k]) do
            if DoesEntityExist(WorkerPedMan[j]) then
                DeleteEntity(WorkerPedMan[j])
                WorkerPedMan[j] = nil
            end
            if DoesEntityExist(CokeCutCard1[j]) then
                DeleteEntity(CokeCutCard1[j])
                CokeCutCard1[j] = nil
            end
            if DoesEntityExist(CokeCutCard2[j]) then
                DeleteEntity(CokeCutCard2[j])
                CokeCutCard2[j] = nil
            end
            if DoesEntityExist(ClipBoardMan) then
                DeleteEntity(ClipBoardMan)
                ClipBoardMan = nil
            end
            if DoesEntityExist(SecurityGuardMan) then
                DeleteEntity(SecurityGuardMan)
                SecurityGuardMan = nil
            end
            for i=1, #sceneObjects, 1 do
                if DoesEntityExist(sceneObjects[i]) then
                    TriggerEvent("FullyDeleteDrugPlaneVehicle", sceneObjects[i])
                end
            end
        end
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        -- Wprker peds object props removal
        if sceneObjects ~= nil then
            FreezeEntityPosition(PlayerPedId(), false)
            for i=1, #sceneObjects, 1 do
                if DoesEntityExist(sceneObjects[i]) then
                    TriggerEvent("FullyDeleteDrugPlaneVehicle", sceneObjects[i])
                end
            end
        end
        -- Wprker peds removal
        for k, _ in pairs(CokeWorkerLocations) do
            for j, _ in pairs(CokeWorkerLocations[k]) do
                if DoesEntityExist(WorkerPedMan[j]) then
                    DeleteEntity(WorkerPedMan[j])
                    WorkerPedMan[j] = nil
                end
                if DoesEntityExist(CokeCutCard1[j]) then
                    DeleteEntity(CokeCutCard1[j])
                    CokeCutCard1[j] = nil
                end
                if DoesEntityExist(CokeCutCard2[j]) then
                    DeleteEntity(CokeCutCard2[j])
                    CokeCutCard2[j] = nil
                end
                if DoesEntityExist(ClipBoardMan) then
                    DeleteEntity(ClipBoardMan)
                    ClipBoardMan = nil
                end
                if DoesEntityExist(SecurityGuardMan) then
                    DeleteEntity(SecurityGuardMan)
                    SecurityGuardMan = nil
                end
            end
        end
        -- Targets removal
        if Config.Target == "ox_target" then
            if DrugSupplies ~= nil then
                exports.ox_target:removeZone(DrugSupplies)
            end
            if DrugLaptop ~= nil then
                exports.ox_target:removeZone(DrugLaptop)
            end
        else
            exports[Config.Target]:RemoveZone("DrugSupplies")
            exports[Config.Target]:RemoveZone("DrugLaptop")
        end
        -- Remove door zones
        for k, v in pairs(Config.CokeLabDoors) do
            if Config.Target == "ox_target" then
                if CokeLabDoor[k] ~= nil then
                    exports.ox_target:removeZone(CokeLabDoor[k])
                end
            else
                exports[Config.Target]:RemoveZone("CokeLabDoor"..k)
            end
        end
	end
end)
RegisterNetEvent("Pug:DrugJob:ReloadSkin", function()
	for k, v in pairs(GetGamePool('CObject')) do
		if IsEntityAttachedToEntity(PlayerPedId(), v) then
			SetEntityAsMissionEntity(v, true, true)
			DeleteObject(v)
			DeleteEntity(v)
		end
	end
	TriggerEvent("Pug:ReloadGuns:sling")
end)

RegisterNetEvent("Pug:client:DoCokeCutPressAnimation", function(PlayerPed)
    local animDict, animName = "anim@amb@business@coc@coc_packing_hi@", "full_cycle_v3_pressoperator"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(10)
    end
    local ped = PlayerPed
    local targetPosition = vector3(1087.74, -3197.76, -38.99)
    SetEntityCoords(ped, targetPosition)
    Wait(1)
    FreezeEntityPosition(ped, true)
    local scenePos, sceneRot = vector3(1093.58, -3196.60, -40.0), vector3(0.0, 0.0, 0.08) -- Other one to the right is local scenePos, sceneRot = vector3(1089.3, -3191.1, -39.99), vector3(0.0, 0.0, -90.08)
    while true do -- Infinite loop
        Wait(1)
        if DoesEntityExist(ped) then
            local netScene = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, false, false, 1065353216, 0, 1.3)
            NetworkAddPedToSynchronisedScene(ped, netScene, animDict, animName, 1.5, -4.0, 1, 16, 1148846080, 0)
            PugLoadModel("bkr_prop_coke_dollCast")
            PugLoadModel("bkr_prop_coke_press_01b")
            PugLoadModel("bkr_prop_coke_fullscoop_01a")
            PugLoadModel("bkr_prop_coke_dollmould")
            PugLoadModel("bkr_prop_coke_dollboxfolded")
            PugLoadModel("bkr_prop_coke_doll")
            objects = {
                {
                    hash = `bkr_prop_coke_dollCast`,
                    animName = "full_cycle_v3_dollCast^3" -- DollCast 4
                },
                -- {
                --     hash = `bkr_prop_coke_press_01b`, -- COKE PRESS
                --     animName = "full_cycle_v3_cokePress"
                -- },
                {
                    hash = `bkr_prop_coke_fullscoop_01a`, -- SCOOOP 
                    animName = "full_cycle_v3_scoop"
                },
                {
                    hash = `bkr_prop_coke_dollmould`, -- DOLL MOULD
                    animName = "full_cycle_v3_dollmould"
                },
                {
                    hash = `bkr_prop_coke_dollboxfolded`, -- GRAB FOLDED BOX
                    animName = "full_cycle_v3_FoldedBox"
                },
                {
                    hash = `bkr_prop_coke_doll`, -- FINISHED COKE DOLL
                    animName = "full_cycle_v3_cocdoll"
                },
                -- {
                --     hash = `bkr_prop_coke_fullmetalbowl_02`, -- COKE BOWL POWDER
                --     animName = "full_cycle_v3_cocbowl"
                -- },
                -- {
                --     hash = `bkr_prop_coke_boxedDoll`, -- bad
                --     animName = "full_cycle_v3_boxedDoll"
                -- },
            }
            for i=1, #objects, 1 do
                local obj = CreateObjectNoOffset(objects[i].hash, targetPosition, true, true, true)
                while not DoesEntityExist(obj) do Wait(100) end
                NetworkAddEntityToSynchronisedScene(obj, netScene, animDict, objects[i].animName, 4.0, -8.0, 1)
                sceneObjects[#sceneObjects+1] = obj
            end
            NetworkStartSynchronisedScene(netScene)
            Wait(44*1000)
            NetworkStopSynchronisedScene(netScene)
            for i=1, #sceneObjects, 1 do
                if DoesEntityExist(sceneObjects[i]) then
                    TriggerEvent("FullyDeleteDrugPlaneVehicle", sceneObjects[i])
                end
            end
        else
            for i = 1, #sceneObjects, 1 do
                if DoesEntityExist(sceneObjects[i]) then
                    TriggerEvent("FullyDeleteDrugPlaneVehicle", sceneObjects[i])
                end
            end
            break
        end
    end
    RemoveAnimDict(animDict)
    FreezeEntityPosition(ped, false)
end)

RegisterNetEvent("Pug:client:DoCokeCutAnimation", function(PlayerPed, bool)
    local RandomAnim = math.random(0, 5)
    local VA = "_v"..tostring(RandomAnim).."_"
    if RandomAnim == 0 then
        VA = "_"
    end
    local animDict, animName = "anim@amb@business@coc@coc_unpack_cut_left@", "coke_cut"..VA.."coccutter"
    local PropAnimBakingSoda = "coke_cut"..VA.."bakingsoda"
    local PropAnimCard = "coke_cut"..VA.."creditcard"
    if bool then
        PropAnimBakingSoda = "cut_tired_bakingsoda"
        PropAnimCard = "cut_tired_creditcard"
        animDict, animName = "anim@amb@business@coc@coc_unpack_cut_left@", "cut_tired_coccutter"
    end
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(10)
    end
    local ped = PlayerPed
    local targetPosition = GetEntityCoords(ped)
    SetEntityCoords(ped, targetPosition)
    Wait(1)
    local animDuration = GetAnimDuration(animDict, animName) * 500
    local scenePos, sceneRot = vec3(GetEntityCoords(ped).x, GetEntityCoords(ped).y, GetEntityCoords(ped).z-1.65), vec3(GetEntityRotation(ped))
    local sceneObjects = {}
    while true do
        Wait(1)
        if DoesEntityExist(ped) then
            local netScene = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, false, false, 1065353216, 0, 1.3)
            NetworkAddPedToSynchronisedScene(ped, netScene, animDict, animName, 1.5, -4.0, 1, 16, 1148846080, 0)
            local objects = {
                {
                    hash = `bkr_prop_coke_bakingsoda_o`,
                    animName = PropAnimBakingSoda
                },
                {
                    hash = `prop_cs_credit_card`,
                    animName = PropAnimCard
                },
                {
                    hash = `prop_cs_credit_card`,
                    animName = PropAnimCard.."^1"
                },
            }
            for i = 1, #objects, 1 do
                local obj = CreateObjectNoOffset(objects[i].hash, targetPosition, true, true, true)
                while not DoesEntityExist(obj) do Wait(100) end
                -- Wait(20)
                NetworkAddEntityToSynchronisedScene(obj, netScene, animDict, objects[i].animName, 4.0, -8.0, 1)
                sceneObjects[#sceneObjects+1] = obj
            end
            NetworkStartSynchronisedScene(netScene)
            Wait(animDuration)
            -- NetworkStopSynchronisedScene(netScene)
            for i = 1, #sceneObjects, 1 do
                DeleteObject(sceneObjects[i])
            end
        else
            for i = 1, #sceneObjects, 1 do
                DeleteObject(sceneObjects[i])
            end
            break
        end
    end
    RemoveAnimDict(animDict)
end)

-- COKE LAB OWNING STUFF
CreateThread(function()
    for k, v in pairs(Config.CokeLabDoors) do
        if Config.Target == "ox_target" then
            CokeLabDoor[k] = exports.ox_target:addBoxZone({
                coords = vector3(v.x, v.y, v.z),
                size = vector3(1,1, 2),
                rotation = v.w,
                debug = Config.Debug,
                options = {
                    {
                        name= "CokeLabDoor",
                        type = "client",
                        event = "Pug:Client:CokeLabDoorMenu",
                        icon = "fas fa-user-secret",
                        label = Config.LangT["CokeDoorText"],
                        distance = 1.5
                    }
                }
            })
        else
            exports[Config.Target]:AddBoxZone("CokeLabDoor"..k, vector3(v.x, v.y, v.z-1), 1, 1, {
                name="CokeLabDoor"..k,
                heading=v.w,
                debugPoly = Config.Debug,
                minZ= v.z-1,
                maxZ= v.z+1,
            }, {
                options = {
                    {
                        type = "client",
                        event = "Pug:Client:CokeLabDoorMenu",
                        icon = "fas fa-user-secret",
                        label = Config.LangT["CokeDoorText"],
                        distance = 2.0
                    }
                },
                distance = 1.5
            })
        end
    end
    local ExitCoords = vector3(1088.64, -3187.46, -38.99)
    if Config.Target == "ox_target" then
        CokeLabDoorExit = exports.ox_target:addBoxZone({
            coords = ExitCoords,
            size = vector3(1,1, 2),
            rotation = ExitCoords.w,
            debug = Config.Debug,
            options = {
                {
                    name= "CokeLabDoorLeave",
                    type = "client",
                    event = "Pug:Client:LeaveCokeLab",
                    icon = "fas fa-user-secret",
                    label = Config.LangT["LeaveCokeLab"],
                    distance = 1.5
                }
            }
        })
    else
        exports[Config.Target]:AddBoxZone("CokeLabDoorLeave", vector3(ExitCoords.x, ExitCoords.y, ExitCoords.z-1), 1, 1, {
            name="CokeLabDoorLeave",
            heading= ExitCoords.w,
            debugPoly = Config.Debug,
            minZ= ExitCoords.z-1,
            maxZ= ExitCoords.z+1,
        }, {
            options = {
                {
                    type = "client",
                    event = "Pug:Client:LeaveCokeLab",
                    icon = "fas fa-user-secret",
                    label = Config.LangT["LeaveCokeLab"],
                    distance = 1.5
                }
            },
            distance = 1.5
        })
    end
end)

RegisterNetEvent("Pug:Client:CokeLabDoorMenu", function()
    if Config.Menu == "ox_lib" then
        local menu = {}
        local FunctionRan = false
        Config.FrameworkFunctions.TriggerCallback('Pug:server:GetCokeDoorData', function(result)
            if result then
                if result.Owner then
                    menu[#menu+1] = {
                        title = Config.LangT["EnterLab"],
                        icon = "fa-solid fa-pills",
                        description = " ",
                        event = "Pug:client:EnterCokeLab",
                        args = result.AllData,
                    }
                else
                    menu[#menu+1] = {
                        title = Config.LangT["EnterPassword"],
                        icon = "fa-solid fa-pills",
                        description = Config.LangT["EnterPasswordDescription"],
                        event = "Pug:client:EnterCokeLabPassword",
                    }
                end
                FunctionRan = true
            else
                menu[#menu+1] = {
                    title = Config.LangT["BuyCokeLab"],
                    icon = "fa-solid fa-pills",
                    description = "$"..Config.CokeLabCost.." to purchase a laboratory",
                    event = "Pug:client:PurchaseCokeLaboratory",
                }
                FunctionRan = true
            end
        end)
        while not FunctionRan do Wait(100) end
        lib.registerContext({
            id = 'CokeDoorText',
            title = Config.LangT["CokeDoorText"],
            options = menu
        })
        lib.showContext('CokeDoorText')
    else
        local menu = {
            {
                isMenuHeader = true,
                header = Config.LangT["CokeDoorText"],
                icon = "fa-solid fa-skull-crossbones",
                txt = Config.LangT["CokeDoorDescription"],
            },
        }
        local FunctionRan = false
        Config.FrameworkFunctions.TriggerCallback('Pug:server:GetCokeDoorData', function(result)
            if result then
                if result.Owner then
                    menu[#menu+1] = {
                        header = Config.LangT["EnterLab"],
                        icon = "fa-solid fa-pills",
                        text = " ",
                        params = {
                            event = "Pug:client:EnterCokeLab",
                            args = result.AllData,
                        }
                    }
                else
                    menu[#menu+1] = {
                        header = Config.LangT["EnterPassword"],
                        icon = "fa-solid fa-pills",
                        text = Config.LangT["EnterPasswordDescription"],
                        params = {
                            event = "Pug:client:EnterCokeLabPassword",
                        }
                    }
                end
                FunctionRan = true
            else
                menu[#menu+1] = {
                    header = Config.LangT["BuyCokeLab"],
                    icon = "fa-solid fa-pills",
                    text = "$"..Config.CokeLabCost.." to purchase a laboratory",
                    params = {
                        event = "Pug:client:PurchaseCokeLaboratory",
                    }
                }
                FunctionRan = true
            end
        end)
        while not FunctionRan do Wait(100) end
        exports[Config.Menu]:openMenu(menu)
    end
end)

RegisterNetEvent("Pug:client:PurchaseCokeLaboratory", function()
    local DoorCoords = false
    local MyCoords = GetEntityCoords(PlayerPedId())
    for k, v in pairs(Config.CokeLabDoors) do
        if #(vector3(v.x, v.y, v.z) - MyCoords) <= 1.5 then
            DoorCoords = vector4(v.x, v.y, v.z, v.w)
        end
    end
    Wait(100)
    if DoorCoords then
        TriggerServerEvent("Pug:Server:PurchaseCokeLaboratory", DoorCoords)
    else
        DrugJobNotification(Config.LangT["GetCloserToTheDoor"], "error")
    end
end)

RegisterNetEvent("Pug:client:EnterCokeLab", function(Data, Bool, Bool2)
    CokeLabData = Data
    DrugPlaneToSpawn = tostring(CokeLabData.plane)
    for k, v in pairs(Config.CokePlanes) do
        if v.model == DrugPlaneToSpawn then
            PlaneToSpawnIndexes = Config.CokePlanes[k]
            break
        end
    end
    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do Wait(100) end
    StartPlayerTeleport(PlayerId(), 1088.67, -3187.52, -38.99, 182.53, true, true, true)
    while IsPlayerTeleportActive() do Wait(100) end
    Wait(700)
    DoScreenFadeIn(1000)
    TriggerEvent("Pug:client:CreateWorkerPedsDefaultLab")
    if Bool then
        if Bool2 then
            TriggerEvent("Pug:client:CreateCokeLabShutDownTargets")
        end
    else
        TriggerEvent("Pug:client:CreateAllCokeLabTargets")
    end
    TriggerServerEvent("Pug:server:TogglePlayerCokeLabBucket", tonumber(CokeLabData.bucketid))
    CreateThread(function()
        while true do
            Wait(1)
            if CokeLabData then
                if #(GetEntityCoords(PlayerPedId()) - vector3(1094.9, -3196.66, -38.99)) <= 30.0 then
                    Draw2DText(string.upper(Config.LangT["Supplies"])..": ~g~ "..CokeLabData.supplies.." ~w~", 4, {255, 255, 255}, 0.4, 0.900, 0.838)
                    Draw2DText(string.upper(Config.LangT["Product"])..": ~b~ "..CokeLabData.product.." ~w~", 4, {255, 255, 255}, 0.4, 0.900, 0.863)
                else
                    TriggerEvent("Pug:Client:LeaveCokeLab")
                    break
                end
            else
                break
            end
        end
    end)
end)

RegisterNetEvent("Pug:Client:LeaveCokeLab", function()
    if CokeLabData ~= nil then
        local location = json.decode(CokeLabData.lablocation)
        CokeLabData = nil
        DoScreenFadeOut(1000)
        while not IsScreenFadedOut() do Wait(100) end
        RemoveAllInsidePropsAndPeds()
        -- Targets removal
        if Config.Target == "ox_target" then
            if DrugSupplies ~= nil then
                exports.ox_target:removeZone(DrugSupplies)
            end
            if DrugLaptop ~= nil then
                exports.ox_target:removeZone(DrugLaptop)
            end
        else
            exports[Config.Target]:RemoveZone("DrugSupplies")
            exports[Config.Target]:RemoveZone("DrugLaptop")
        end
        StartPlayerTeleport(PlayerId(), location.x, location.y, location.z, location.w, true, true, true)
        while IsPlayerTeleportActive() do Wait(100) end
        Wait(700)
        DoScreenFadeIn(1000)
    else
        DoScreenFadeOut(1000)
        while not IsScreenFadedOut() do Wait(100) end
        Config.FrameworkFunctions.TriggerCallback('Pug:server:DoesOwnCokeLab', function(result)
            if result then
                local location = json.decode(result.lablocation)
                StartPlayerTeleport(PlayerId(), location.x, location.y, location.z, location.w, true, true, true)
                while IsPlayerTeleportActive() do Wait(100) end
                Wait(700)
                DoScreenFadeIn(1000)
            else
                StartPlayerTeleport(PlayerId(), 967.85, -1829.45, 31.24, 355.53, true, true, true)
                while IsPlayerTeleportActive() do Wait(100) end
                Wait(700)
                DoScreenFadeIn(1000)
            end
        end)
        CokeLabData = nil
    end
    TriggerServerEvent("Pug:server:TogglePlayerCokeLabBucket")
end)
RegisterNetEvent("Pug:cleint:UpdateCokeLabPeds", function(Data)
    if CokeLabData then
        TriggerEvent("Pug:client:CreateWorkerPedsDefaultLab", true)
        Wait(2000)
        CokeLabData = Data
        DrugPlaneToSpawn = tostring(CokeLabData.plane)
        for k, v in pairs(Config.CokePlanes) do
            if v.model == DrugPlaneToSpawn then
                PlaneToSpawnIndexes = Config.CokePlanes[k]
                break
            end
        end
    end
end)
RegisterNetEvent("Pug:client:RemoveAllInsideCokeData", function()
    RemoveAllInsidePropsAndPeds()
    -- Targets removal
    if Config.Target == "ox_target" then
        if DrugSupplies ~= nil then
            exports.ox_target:removeZone(DrugSupplies)
        end
        if DrugLaptop ~= nil then
            exports.ox_target:removeZone(DrugLaptop)
        end
    else
        exports[Config.Target]:RemoveZone("DrugSupplies")
        exports[Config.Target]:RemoveZone("DrugLaptop")
    end
end)
RegisterNetEvent("Pug:client:CreateAllCokeLabTargets", function()
    -- Drug stash and supplies targets
    if Config.Target == "ox_target" then
		DrugSupplies = exports.ox_target:addBoxZone({
			coords = vector3(1090.06, -3199.77, -39.65),
			size = vector3(1, 4, 2),
			rotation = 270,
			debug = Config.Debug,
			options = {
				{
					name= "DrugSupplies",
					type = "client",
					event = "Pug:Client:DrugSuppliesMenu",
					icon = "fas fa-user-secret",
					label = Config.LangT["Supplies"],
					distance = 1.5
				}
			}
		})
        DrugLaptop = exports.ox_target:addBoxZone({
			coords = vector3(1086.46, -3194.26, -39.65),
			size = vector3(1, 2, 2),
			rotation = 0,
			debug = Config.Debug,
			options = {
				{
					name= "DrugLaptop",
					type = "client",
					event = "Pug:Client:DrugLaptopMenu",
					icon = "fas fa-user-secret",
					label = Config.LangT["Laptop"],
					distance = 1.5
				}
			}
		})
	else
		exports[Config.Target]:AddBoxZone("DrugSupplies", vector3(1090.06, -3199.77, -39.99), 1, 2, {
            name="DrugSupplies",
            heading=0,
            debugPoly=Config.Debug,
            minZ=-39.99,
            maxZ=-37.79,
		}, {
			options = {
				{
					type = "client",
					event = "Pug:Client:DrugSuppliesMenu",
					icon = "fas fa-user-secret",
					label = Config.LangT["Supplies"],
					distance = 1.5
				}
			},
			distance = 2.0
		})
        exports[Config.Target]:AddBoxZone("DrugLaptop", vector3(1086.46, -3194.26, -39.65), 0.4, 1, {
            name="DrugLaptop",
            heading=0,
            debugPoly=Config.Debug,
            minZ=-39.99,
            maxZ=-38.79,
		}, {
			options = {
				{
					type = "client",
					event = "Pug:Client:DrugLaptopMenu",
					icon = "fas fa-user-secret",
					label = Config.LangT["Laptop"],
					distance = 1.5
				}
			},
			distance = 2.0
		})
	end
    -- End
end)
RegisterNetEvent("Pug:client:CreateCokeLabShutDownTargets", function()
    -- Drug stash and supplies targets
    if Config.Target == "ox_target" then
		DrugSupplies = exports.ox_target:addBoxZone({
			coords = vector3(971.09, -2986.75, -39.65),
			size = vector3(1, 4, 2),
			rotation = 270,
			debug = Config.Debug,
			options = {
				{
					name= "DrugSupplies",
					type = "client",
					event = "Pug:Client:DrugSuppliesMenu",
					icon = "fas fa-user-secret",
					label = Config.LangT["Supplies"],
					distance = 1.5
				}
			}
		})
        DrugLaptop = exports.ox_target:addBoxZone({
			coords = vector3(1086.46, -3194.26, -39.65),
			size = vector3(1, 2, 2),
			rotation = 0,
			debug = Config.Debug,
			options = {
				{
					name= "DrugLaptop",
					type = "client",
					event = "Pug:Client:DrugLaptopMenuPolice",
					icon = "fas fa-user-secret",
					label = Config.LangT["Laptop"],
					distance = 1.5
				}
			}
		})
	else
		exports[Config.Target]:AddBoxZone("DrugSupplies", vector3(1090.06, -3199.77, -39.99), 1, 2, {
            name="DrugSupplies",
            heading=0,
            debugPoly=Config.Debug,
            minZ=-39.99,
            maxZ=-37.79,
		}, {
			options = {
				{
					type = "client",
					event = "Pug:Client:DrugSuppliesMenu",
					icon = "fas fa-user-secret",
					label = Config.LangT["Supplies"],
					distance = 1.5
				}
			},
			distance = 2.0
		})
        exports[Config.Target]:AddBoxZone("DrugLaptop", vector3(1086.46, -3194.26, -39.65), 0.4, 1, {
            name="DrugLaptop",
            heading=0,
            debugPoly=Config.Debug,
            minZ=-39.99,
            maxZ=-38.79,
		}, {
			options = {
				{
					type = "client",
					event = "Pug:Client:DrugLaptopMenuPolice",
					icon = "fas fa-user-secret",
					label = Config.LangT["Laptop"],
					distance = 1.5
				}
			},
			distance = 2.0
		})
	end
    -- End
end)
RegisterNetEvent("Pug:Client:DrugLaptopMenu", function()
    if not IsEntityPlayingAnim(PlayerPedId(), "anim@heists@prison_heistig1_p1_guard_checks_bus", "loop", 3) then
        TaskGoStraightToCoord(PlayerPedId(),vector3(1087.14, -3194.19, -38.99), 1.0, -1, 0.0, 0.0)
        while #(GetEntityCoords(PlayerPedId()) - vector3(1087.14, -3194.19, -38.99)) >= 0.2 do Wait(100) end
        ClearPedTasksImmediately(PlayerPedId())
        TaskTurnPedToFaceCoord(PlayerPedId(), vector3(1084.64, -3194.28, -38.99), 1500)
        Wait(800)
        loadAnimDict("anim@heists@prison_heistig1_p1_guard_checks_bus")
        TaskPlayAnim(PlayerPedId(), "anim@heists@prison_heistig1_p1_guard_checks_bus", "loop", 2.0, 2.0, -1, 51, 0, false, false, false)
    end
    if Config.Menu == "ox_lib" then
        local menu = {}
        local menu = {}
        local drugsToProcess = Config.AmountOfDrugsToProcess
        local TimeDrugsTakeToProcessText = Config.LangT["CurrentprocessTime"]..tostring(Config.TimeDrugsTakeToProcess) .. Config.LangT["MinutesAndprocess"] .. drugsToProcess.." "..Config.LangT["Product"]
        if CokeLabData.upgrades == 1 then
            local productPercentIncrease = Config.ProductPercentIncreaseUpgrade1
            processedDrugs2 = math.ceil(drugsToProcess + (drugsToProcess * productPercentIncrease))
            TimeDrugsTakeToProcessText = Config.LangT["CurrentprocessTime"]..tostring(math.ceil(60000 * Config.TimeDrugsTakeToProcess - (60000 * Config.TimeDrugsTakeToProcess) * Config.TimePercentIncreaseUpgrade1) / 60000).. Config.LangT["MinutesAndprocess"] .. processedDrugs2.." "..Config.LangT["Product"]
        elseif CokeLabData.upgrades == 2 then
            local productPercentIncrease = Config.ProductPercentIncreaseUpgrade2
            processedDrugs2 = math.ceil(drugsToProcess + (drugsToProcess * productPercentIncrease))
            TimeDrugsTakeToProcessText = Config.LangT["CurrentprocessTime"]..tostring(math.ceil(60000 * Config.TimeDrugsTakeToProcess - (60000 * Config.TimeDrugsTakeToProcess) * Config.TimePercentIncreaseUpgrade2) / 60000) .. Config.LangT["MinutesAndprocess"] .. processedDrugs2.." "..Config.LangT["Product"]
        elseif CokeLabData.upgrades >= 3 then
            local productPercentIncrease = Config.ProductPercentIncreaseUpgrade3
            processedDrugs2 = math.ceil(drugsToProcess + (drugsToProcess * productPercentIncrease))
            TimeDrugsTakeToProcessText = Config.LangT["CurrentprocessTime"]..tostring(math.ceil(60000 * Config.TimeDrugsTakeToProcess - (60000 * Config.TimeDrugsTakeToProcess) * Config.TimePercentIncreaseUpgrade3) / 60000) .. Config.LangT["MinutesAndprocess"] .. processedDrugs2.." "..Config.LangT["Product"]
        end
        local SuppliesRequiredToUpgradeText = " "
        if tonumber(CokeLabData.upgrades) == 0 then
            SuppliesRequiredToUpgradeText = Config.UpgradeCokeLabRequirement1.." "..Config.LangT["SuppliesRequired"]
        elseif tonumber(CokeLabData.upgrades) == 1 then
            SuppliesRequiredToUpgradeText = Config.UpgradeCokeLabRequirement2.." "..Config.LangT["SuppliesRequired"]
        elseif tonumber(CokeLabData.upgrades) == 2 then 
            SuppliesRequiredToUpgradeText = Config.UpgradeCokeLabRequirement3.." "..Config.LangT["SuppliesRequired"]
        end
        local HireWorkersText = tonumber(CokeLabData.upgrades) .."/3"
        local ExtraTitleText =  " $"..Config.UpgradeCokeLabCost * (tonumber(CokeLabData.upgrades) + 1) .." & ".. SuppliesRequiredToUpgradeText
        if tonumber(CokeLabData.upgrades) >= 3 then
            HireWorkersText =  Config.LangT["MaxedOut"] .. " ".. TimeDrugsTakeToProcessText
            ExtraTitleText =  " "
        end
        menu[#menu+1] = {
            title = Config.LangT["PickupSupplies"] .. " $"..Config.DrugPlaneDeposit,
            icon = "fa-solid fa-pills",
            description = tonumber(CokeLabData.supplies).."x "..Config.LangT["PickupSuppliesDescription"],
            event = "Pug:server:ChooseAmountDrugRuns",
        } 
        menu[#menu+1] = {
            title = Config.LangT["ChangePassword"],
            icon = "fa-solid fa-lock",
            description = Config.LangT["CurrentPassword"]..tonumber(CokeLabData.password),
            event = "Pug:client:ChangecokeLabPassword",
        }
        menu[#menu+1] = {
            title = Config.LangT["HireWorkers"] .." ".. HireWorkersText,
            icon = "fa-solid fa-wrench",
            description = ExtraTitleText.." | ".. TimeDrugsTakeToProcessText,
            event = "Pug:client:UpgradeCokeLab",
        } 
        menu[#menu+1] = {
            title = Config.LangT["ManageMembers"],
            icon = "fa-solid fa-lock",
            description = tonumber(#json.decode(CokeLabData.access)).."/"..tonumber(CokeLabData.membercap).." " .. Config.LangT["ManageMembersDescription"],
            event = "Pug:client:ManageMembersCokeLab",
        }
        menu[#menu+1] = {
            title = Config.LangT["UpgradePlane"],
            icon = "fa-solid fa-plane",
            description = Config.LangT["SelectOrUpgradePlane"] .. DrugPlaneToSpawn,
            event = "Pug:client:ManagePlanesMenu",
        }
        lib.registerContext({
            id = Config.LangT["Laptop"],
            title = Config.LangT["Laptop"],
            onExit = function()
                ClearPedTasks(PlayerPedId())
            end,
            options = menu
        })
        lib.showContext(Config.LangT["Laptop"])
    else
        local menu = {}
        local drugsToProcess = Config.AmountOfDrugsToProcess
        local TimeDrugsTakeToProcessText = Config.LangT["CurrentprocessTime"]..tostring(Config.TimeDrugsTakeToProcess) .. Config.LangT["MinutesAndprocess"] .. drugsToProcess.." "..Config.LangT["Product"]
        if CokeLabData.upgrades == 1 then
            local productPercentIncrease = Config.ProductPercentIncreaseUpgrade1
            processedDrugs2 = math.ceil(drugsToProcess + (drugsToProcess * productPercentIncrease))
            TimeDrugsTakeToProcessText = Config.LangT["CurrentprocessTime"]..tostring(math.ceil(60000 * Config.TimeDrugsTakeToProcess - (60000 * Config.TimeDrugsTakeToProcess) * Config.TimePercentIncreaseUpgrade1) / 60000).. Config.LangT["MinutesAndprocess"] .. processedDrugs2.." "..Config.LangT["Product"]
        elseif CokeLabData.upgrades == 2 then
            local productPercentIncrease = Config.ProductPercentIncreaseUpgrade2
            processedDrugs2 = math.ceil(drugsToProcess + (drugsToProcess * productPercentIncrease))
            TimeDrugsTakeToProcessText = Config.LangT["CurrentprocessTime"]..tostring(math.ceil(60000 * Config.TimeDrugsTakeToProcess - (60000 * Config.TimeDrugsTakeToProcess) * Config.TimePercentIncreaseUpgrade2) / 60000) .. Config.LangT["MinutesAndprocess"] .. processedDrugs2.." "..Config.LangT["Product"]
        elseif CokeLabData.upgrades >= 3 then
            local productPercentIncrease = Config.ProductPercentIncreaseUpgrade3
            processedDrugs2 = math.ceil(drugsToProcess + (drugsToProcess * productPercentIncrease))
            TimeDrugsTakeToProcessText = Config.LangT["CurrentprocessTime"]..tostring(math.ceil(60000 * Config.TimeDrugsTakeToProcess - (60000 * Config.TimeDrugsTakeToProcess) * Config.TimePercentIncreaseUpgrade3) / 60000) .. Config.LangT["MinutesAndprocess"] .. processedDrugs2.." "..Config.LangT["Product"]
        end
        local SuppliesRequiredToUpgradeText = " "
        if tonumber(CokeLabData.upgrades) == 0 then
            SuppliesRequiredToUpgradeText = Config.UpgradeCokeLabRequirement1.." "..Config.LangT["SuppliesRequired"]
        elseif tonumber(CokeLabData.upgrades) == 1 then
            SuppliesRequiredToUpgradeText = Config.UpgradeCokeLabRequirement2.." "..Config.LangT["SuppliesRequired"]
        elseif tonumber(CokeLabData.upgrades) == 2 then 
            SuppliesRequiredToUpgradeText = Config.UpgradeCokeLabRequirement3.." "..Config.LangT["SuppliesRequired"]
        end
        local HireWorkersText = tonumber(CokeLabData.upgrades) .."/3"
        local ExtraTitleText =  " $"..Config.UpgradeCokeLabCost * (tonumber(CokeLabData.upgrades) + 1) .." & ".. SuppliesRequiredToUpgradeText
        if tonumber(CokeLabData.upgrades) >= 3 then
            HireWorkersText =  Config.LangT["MaxedOut"] .. " ".. TimeDrugsTakeToProcessText
            ExtraTitleText =  " "
        end
        menu[#menu+1] = {
            header = Config.LangT["CokeLab"],
            icon = "fa-solid fa-laptop",
            txt = TimeDrugsTakeToProcessText,
            isMenuHeader = true,
            params = {
                event = "Pug:Client:CloseMenuCokeBusiness",
            }
        } 
        menu[#menu+1] = {
            header = Config.LangT["PickupSupplies"] .. " $"..Config.DrugPlaneDeposit,
            icon = "fa-solid fa-pills",
            txt = tonumber(CokeLabData.supplies).."x "..Config.LangT["PickupSuppliesDescription"],
            params = {
                event = "Pug:server:ChooseAmountDrugRuns",
            }
        } 
        menu[#menu+1] = {
            header = Config.LangT["ChangePassword"],
            icon = "fa-solid fa-lock",
            txt = Config.LangT["CurrentPassword"]..tonumber(CokeLabData.password),
            params = {
                event = "Pug:client:ChangecokeLabPassword",
            }
        }
        menu[#menu+1] = {
            header = Config.LangT["HireWorkers"] .." ".. HireWorkersText,
            icon = "fa-solid fa-wrench",
            txt = ExtraTitleText,
            params = {
                event = "Pug:client:UpgradeCokeLab",
            }
        } 
        menu[#menu+1] = {
            header = Config.LangT["ManageMembers"],
            icon = "fa-solid fa-lock",
            txt = tonumber(#json.decode(CokeLabData.access)).."/"..tonumber(CokeLabData.membercap)..Config.LangT["ManageMembersDescription"],
            params = {
                event = "Pug:client:ManageMembersCokeLab",
            }
        }
        menu[#menu+1] = {
            header = Config.LangT["UpgradePlane"],
            icon = "fa-solid fa-plane",
            txt = Config.LangT["SelectOrUpgradePlane"] .. DrugPlaneToSpawn,
            params = {
                event = "Pug:client:ManagePlanesMenu",
            }
        }
        menu[#menu+1] = {
            header = Config.LangT["CloseMenu"],
            txt = " ",
            params = {
                event = "Pug:Client:CloseMenuCokeBusiness",
            }
        }
        exports[Config.Menu]:openMenu(menu)
        Wait(1000)
        while true do
            Wait(1)
            if IsControlJustPressed(1, 51) or IsControlJustPressed(1, 177) or not IsEntityPlayingAnim(PlayerPedId(), "anim@heists@prison_heistig1_p1_guard_checks_bus", "loop", 3) or not IsNuiFocused() then
                if not IsNuiFocused() then
                    Wait(700)
                    if not IsNuiFocused() then
                        ClearPedTasks(PlayerPedId())
                    end
                end
                break
            end
        end
    end
end)
RegisterNetEvent("Pug:client:ManagePlanesMenu", function(Data)
    if Config.Menu == "ox_lib" then
        local menu = {}
        -- Selectable planes
        for _, v in pairs(Config.CokePlanes) do
            menu[#menu+1] = {
                title = Config.LangT["ChoosePlane"],
                icon = "fa-solid fa-plane",
                description = v.model,
                event = "Pug:client:ChooseCokePlane",
                args = v.model
            }
            if tostring(v.model) == tostring(CokeLabData.plane) then
                break
            end
        end
        menu[#menu+1] = {
            title = Config.LangT["UpgradePlanes"],
            -- icon = "fa-solid fa-plane",
            description = " ",
            event = "Pug:client:ManagePlanesMenu",
        }
        -- Upgrade plane option
        local DisabledMenu = true
        for k, _ in pairs(Config.CokePlanes) do
            local UpgradePlaneText = Config.LangT["PurchasePlane"] ..Config.CokePlanes[k].price
            if k > 0 then
                if Config.CokePlanes[k-1].model == tostring(CokeLabData.plane) or (k == #Config.CokePlanes and not tostring(CokeLabData.plane) == Config.CokePlanes[k].model) then
                    DisabledMenu = false
                else
                    DisabledMenu = true
                    if k < #Config.CokePlanes then
                        UpgradePlaneText = Config.LangT["Owned"]
                    end
                end
            else
                UpgradePlaneText = Config.LangT["Owned"]
            end
            if Config.CokePlanes[k].model == tostring(CokeLabData.plane) or (k == #Config.CokePlanes and not tostring(CokeLabData.plane) == Config.CokePlanes[k].model) then
                UpgradePlaneText = Config.LangT["Owned"]
            end
            local UpgradablePlane = Config.LangT["MaxedOut"]
            if k < #Config.CokePlanes then
                UpgradablePlane = Config.CokePlanes[k].model
            end
            if k == 0 then
                if UpgradePlaneText == Config.LangT["Owned"] then
                else
                    UpgradePlaneText = UpgradePlaneText.." | "..Config.UpgradeCokeLabRequirement1.." "..Config.LangT["SuppliesRequired"]
                end
            elseif k == 1 then
                if UpgradePlaneText == Config.LangT["Owned"] then
                else
                    UpgradePlaneText = UpgradePlaneText.." | "..Config.UpgradeCokeLabRequirement2.." "..Config.LangT["SuppliesRequired"]
                end
            elseif k == 2 then 
                if UpgradePlaneText == Config.LangT["Owned"] then
                else
                    UpgradePlaneText = UpgradePlaneText.." | "..Config.UpgradeCokeLabRequirement3.." "..Config.LangT["SuppliesRequired"]
                end
            end
            menu[#menu+1] = {
                title = Config.CokePlanes[k].model,
                icon = "fa-solid fa-plane",
                description = UpgradePlaneText,
                disabled = DisabledMenu,
                event = "Pug:client:UpgradeCokePlane",
                args = k
            }
        end
        menu[#menu+1] = {
            title = Config.LangT["Back"],
            event = "Pug:Client:DrugLaptopMenu",
        }
        lib.registerContext({
            id = Config.LangT["UpgradePlane"],
            title = Config.LangT["UpgradePlane"],
            onExit = function()
                ClearPedTasks(PlayerPedId())
            end,
            options = menu
        })
        lib.showContext(Config.LangT["UpgradePlane"])
    else
        local menu = {}
        menu[#menu+1] = {
            header = Config.LangT["UpgradePlane"],
            icon = "fa-solid fa-plane",
            txt = Config.LangT["SelectOrUpgradePlane"] .. DrugPlaneToSpawn,
            params = {
                event = "Pug:Client:DrugLaptopMenu",
            }
        }
        -- Selectable planes
        for _, v in pairs(Config.CokePlanes) do
            menu[#menu+1] = {
                header = Config.LangT["ChoosePlane"],
                icon = "fa-solid fa-plane",
                txt = v.model,
                params = {
                    event = "Pug:client:ChooseCokePlane",
                    args = v.model
                }
            }
            if tostring(v.model) == tostring(CokeLabData.plane) then
                break
            end
        end
        menu[#menu+1] = {
            header = Config.LangT["UpgradePlanes"],
            -- icon = "fa-solid fa-plane",
            txt = " ",
            params = {
                event = "Pug:client:ManagePlanesMenu",
            }
        }
        -- Upgrade plane option
        local DisabledMenu = true
        for k, _ in pairs(Config.CokePlanes) do
            local UpgradePlaneText = Config.LangT["PurchasePlane"] ..Config.CokePlanes[k].price
            if k > 0 then
                if Config.CokePlanes[k-1].model == tostring(CokeLabData.plane) or (k == #Config.CokePlanes and not tostring(CokeLabData.plane) == Config.CokePlanes[k].model) then
                    DisabledMenu = false
                else
                    DisabledMenu = true
                    if k < #Config.CokePlanes then
                        UpgradePlaneText = Config.LangT["Owned"]
                    end
                end
            else
                UpgradePlaneText = Config.LangT["Owned"]
            end
            if Config.CokePlanes[k].model == tostring(CokeLabData.plane) or (k == #Config.CokePlanes and not tostring(CokeLabData.plane) == Config.CokePlanes[k].model) then
                UpgradePlaneText = Config.LangT["Owned"]
            end
            local UpgradablePlane = Config.LangT["MaxedOut"]
            if k < #Config.CokePlanes then
                UpgradablePlane = Config.CokePlanes[k].model
            end
            if k == 0 then
                if UpgradePlaneText == Config.LangT["Owned"] then
                else
                    UpgradePlaneText = UpgradePlaneText.." | "..Config.UpgradeCokeLabRequirement1.." "..Config.LangT["SuppliesRequired"]
                end
            elseif k == 1 then
                if UpgradePlaneText == Config.LangT["Owned"] then
                else
                    UpgradePlaneText = UpgradePlaneText.." | "..Config.UpgradeCokeLabRequirement2.." "..Config.LangT["SuppliesRequired"]
                end
            elseif k == 2 then 
                if UpgradePlaneText == Config.LangT["Owned"] then
                else
                    UpgradePlaneText = UpgradePlaneText.." | "..Config.UpgradeCokeLabRequirement3.." "..Config.LangT["SuppliesRequired"]
                end
            end
            menu[#menu+1] = {
                header = Config.CokePlanes[k].model,
                icon = "fa-solid fa-plane",
                txt = UpgradePlaneText,
                disabled = DisabledMenu,
                params = {
                    event = "Pug:client:UpgradeCokePlane",
                    args = k
                }
            }
        end
        menu[#menu+1] = {
            header = Config.LangT["Back"],
            params = {
                event = "Pug:Client:DrugLaptopMenu",
            }
        }
        exports[Config.Menu]:openMenu(menu)
    end
end)
RegisterNetEvent("Pug:client:ChooseCokePlane", function(SelectedPlane)
    DrugPlaneToSpawn = tostring(SelectedPlane)
    for k, v in pairs(Config.CokePlanes) do
        if v.model == DrugPlaneToSpawn then
            PlaneToSpawnIndexes = Config.CokePlanes[k]
            break
        end
    end
    DrugJobNotification(DrugPlaneToSpawn.." "..Config.LangT["SelectedPlane"], 'success')
    TriggerEvent("Pug:Client:DrugLaptopMenu")
end)
RegisterNetEvent("Pug:client:UpgradeCokePlane", function(Data)
    if Data > 0 then
        if Config.CokePlanes[Data-1].model == tostring(CokeLabData.plane) or (Data == #Config.CokePlanes and not tostring(CokeLabData.plane) == Config.CokePlanes[Data].model) then
            for k, _ in pairs(Config.CokePlanes) do
                if k > 0 then
                    if Config.CokePlanes[Data].model == tostring(CokeLabData.plane) then
                        DrugJobNotification(Config.LangT["AlreadyHaveThisPlane"], 'error')
                        TriggerEvent("Pug:client:ManagePlanesMenu")
                        return
                    end
                end
            end
            if tonumber(Data) == 0 then
                if tonumber(CokeLabData.supplies) < Config.UpgradeCokeLabRequirement1 then
                    DrugJobNotification(Config.LangT["YouNeed"].. " ".. Config.UpgradeCokeLabRequirement1.." "..Config.LangT["SuppliesNeeded"], 'error')
                    TriggerEvent("Pug:client:ManagePlanesMenu")
                    return
                end
            elseif tonumber(Data) == 1 then
                if tonumber(CokeLabData.supplies) < Config.UpgradeCokeLabRequirement2 then
                    DrugJobNotification(Config.LangT["YouNeed"].. " ".. Config.UpgradeCokeLabRequirement2.." "..Config.LangT["SuppliesNeeded"], 'error')
                    TriggerEvent("Pug:client:ManagePlanesMenu")
                    return
                end
            elseif tonumber(Data) == 2 then 
                if tonumber(CokeLabData.supplies) < Config.UpgradeCokeLabRequirement3 then
                    DrugJobNotification(Config.LangT["YouNeed"].. " ".. Config.UpgradeCokeLabRequirement3.." "..Config.LangT["SuppliesNeeded"], 'error')
                    TriggerEvent("Pug:client:ManagePlanesMenu")
                    return
                end
            end
            TriggerServerEvent("Pug:server:UpgradeCokePlane", Data)
        else
            if Config.CokePlanes[Data].model == tostring(CokeLabData.plane) then
                DrugJobNotification(Config.LangT["AlreadyHaveThisPlane"], 'error')
                TriggerEvent("Pug:client:ManagePlanesMenu")
            else
                DrugJobNotification(Config.LangT["NeedToUpgadeFirst"], 'error')
                TriggerEvent("Pug:client:ManagePlanesMenu")
            end
        end
    else
        DrugJobNotification(Config.LangT["CanNotDoThis"], 'error')
        TriggerEvent("Pug:client:ManagePlanesMenu")
    end
end)
RegisterNetEvent("Pug:client:ManageMembersCokeLab", function()
	local MemberCount = tonumber(#json.decode(CokeLabData.access))
	local Price = Config.UpgradeCokeLabMembersCost * tonumber(CokeLabData.membercap)
	local UpgradeText = Config.LangT["+1For"]..Price
	if tonumber(CokeLabData.membercap) >= Config.MaxMembers then
		UpgradeText = Config.LangT["MaxedOut"]
	end
	if Config.Menu == "ox_lib" then
		local menu = {
			{
				title = Config.LangT["AddAMember"],
				description = Config.LangT["CurrentCapacity"]..MemberCount..'/'..tonumber(CokeLabData.membercap) .. ' | Max ('..Config.MaxMembers..')',
				icon = "fa-solid fa-users",
				event = "Pug:client:AddCokeLabMember",
			},
			{
				title = Config.LangT["UpgradeMemberSlots"],
				description = UpgradeText,
				icon = "fa-solid fa-user-plus",
				event = "Pug:client:UpgradeCokeLabMember",
			},
		}
		Config.FrameworkFunctions.TriggerCallback("Pug:serverCB:GetCokeLabMembersNames", function(data)
			if data ~= nil then
				for k, v in pairs(data) do
					menu[#menu+1] = {
						title = v.name,
						icon = "fas fa-user-secret",
						description = Config.LangT["KickMember"]..Config.KickMemberPrice..')' ,
						event = "Pug:Client:RemoveCokeLabMemmber",
						args = {
							name = v.name,
							cid = v.cid,
						}
					}
				end
			end
			menu[#menu+1] = {
				title = Config.LangT["Back"],
				event = "Pug:Client:DrugLaptopMenu",
			}
			lib.registerContext({
				id = 'ManageMembers',
				title = Config.LangT["ManageMembers"],
                onExit = function()
                    TriggerEvent("Pug:Client:DrugLaptopMenu")
                end,
				options = menu
			})
			lib.showContext('ManageMembers')
		end)
	else
		local menu = {
			{
				header = Config.LangT["ManageCokeLab"],
                params = {
				    event = "Pug:Client:DrugLaptopMenu",
                }
			},
			{
				header = Config.LangT["AddAMember"],
				txt = Config.LangT["CurrentCapacity"]..MemberCount..'/'..tonumber(CokeLabData.membercap) .. ' | Max ('..Config.MaxMembers..')',
				icon = "fa-solid fa-users",
				params = {
                    event = "Pug:client:AddCokeLabMember",
                }
			},
			{
				header = Config.LangT["UpgradeMemberSlots"],
				txt = UpgradeText,
				icon = "fa-solid fa-user-plus",
                params = {
				    event = "Pug:client:UpgradeCokeLabMember",
                }
			},
		}
		Config.FrameworkFunctions.TriggerCallback("Pug:serverCB:GetCokeLabMembersNames", function(data)
			if data ~= nil then
				for k, v in pairs(data) do
					menu[#menu+1] = {
						header = v.name,
						icon = "fas fa-user-secret",
						txt = Config.LangT["KickMember"]..Config.KickMemberPrice..')' ,
                        params = {
                            event = "Pug:Client:RemoveCokeLabMemmber",
                            args = {
                                name = v.name,
                                cid = v.cid,
                            }
                        }
					}
				end
			end
			menu[#menu+1] = {
				header = Config.LangT["Back"],
                params = {
				    event = "Pug:Client:DrugLaptopMenu",
                }
			}
			exports[Config.Menu]:openMenu(menu)
		end)
	end
end)
RegisterNetEvent("Pug:Client:RemoveCokeLabMemmber", function(data)
	if Config.Menu == "ox_lib" then
		local menu = {
			{
				title = Config.LangT["AreYouSureYouWantToRemove"].. data.name..Config.LangT["ForMoney"]..Config.KickMemberPrice ..'?',
				event = "Pug:client:ManageMembersCokeLab",
			},
			{
				title = Config.LangT["Yes"],
				icon = "fas fa-user-secret",
				event = "Pug:Client:FinallyRemoveCokeLabMemmber",
				args = data
			},
			{
				title =  Config.LangT["No"],
				icon = "fas fa-user-secret",
				event = "Pug:client:ManageMembersCokeLab",
			},
		}
		lib.registerContext({
			id = 'AreYouSureYouWantToRemove',
			title = Config.LangT["AreYouSureYouWantToRemove"],
			options = menu
		})
		lib.showContext('AreYouSureYouWantToRemove')
	else
		local menu = {
			{
				header = Config.LangT["AreYouSureYouWantToRemove"].. data.name..Config.LangT["ForMoney"]..Config.KickMemberPrice ..'?',
				params = {
					event = "Pug:client:ManageMembersCokeLab",
				}
			},
			{
				header = Config.LangT["Yes"],
				icon = "fas fa-user-secret",
				params = {
					event = "Pug:Client:FinallyRemoveCokeLabMemmber",
					args = data
				}
			},
			{
				header =  Config.LangT["No"],
				icon = "fas fa-user-secret",
				params = {
					event = "Pug:client:ManageMembersCokeLab",
				}
			},
		}
		exports[Config.Menu]:openMenu(menu)
	end
end)
RegisterNetEvent("Pug:Client:FinallyRemoveCokeLabMemmber", function(Data)
    TriggerServerEvent("Pug:Server:RemoveCokeLabMember", Data)
end)
RegisterNetEvent("Pug:client:ShudDownCokeLabForever", function()
    if Config.UseProgressBar then
        if Framework == "ESX" then
            FWork.Progressbar(Config.LangT["ShuttingDownCokeLab"], Config.TimeItTakesToShutDownCokeLab * 60000, {FreezePlayer = true, onFinish = function()
                TriggerServerEvent("Pug:server:ShudDownCokeLabForever", CokeLabData)
                DrugJobNotification(Config.LangT["SuccessShutDownLab"], 'error')
            end, onCancel = function()
                ClearPedTasks(PlayerPedId())
            end})
        else
            FWork.Functions.Progressbar("ShuttingDownCokeLab", Config.LangT["ShuttingDownCokeLab"], Config.TimeItTakesToShutDownCokeLab * 60000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                TriggerServerEvent("Pug:server:ShudDownCokeLabForever", CokeLabData)
                DrugJobNotification(Config.LangT["SuccessShutDownLab"], 'error')
            end, function()
                ClearPedTasks(PlayerPedId())
            end)
        end
    else
        local WaitTime = math.ceil((Config.TimeItTakesToShutDownCokeLab * 60000) / 4)
        FreezeEntityPosition(PlayerPedId(), true)
        DrugJobNotification(math.ceil((Config.TimeItTakesToShutDownCokeLab * 60 / 1) / 60) ..Config.LangT["ToGo"], 'error')
        loadAnimDict("anim@heists@prison_heistig1_p1_guard_checks_bus")
        TaskPlayAnim(PlayerPedId(), "anim@heists@prison_heistig1_p1_guard_checks_bus", "loop", 2.0, 2.0, -1, 51, 0, false, false, false)
        Wait(WaitTime)
        DrugJobNotification(math.ceil((Config.TimeItTakesToShutDownCokeLab * 60 / 2) / 60) ..Config.LangT["ToGo"], 'error')
        loadAnimDict("anim@heists@prison_heistig1_p1_guard_checks_bus")
        TaskPlayAnim(PlayerPedId(), "anim@heists@prison_heistig1_p1_guard_checks_bus", "loop", 2.0, 2.0, -1, 51, 0, false, false, false)
        Wait(WaitTime)
        DrugJobNotification(math.ceil((Config.TimeItTakesToShutDownCokeLab * 60 / 3) / 60) ..Config.LangT["ToGo"], 'error')
        loadAnimDict("anim@heists@prison_heistig1_p1_guard_checks_bus")
        TaskPlayAnim(PlayerPedId(), "anim@heists@prison_heistig1_p1_guard_checks_bus", "loop", 2.0, 2.0, -1, 51, 0, false, false, false)
        Wait(WaitTime)
        DrugJobNotification(math.ceil((Config.TimeItTakesToShutDownCokeLab * 60 / 4) / 60) ..Config.LangT["ToGo"], 'error')
        loadAnimDict("anim@heists@prison_heistig1_p1_guard_checks_bus")
        TaskPlayAnim(PlayerPedId(), "anim@heists@prison_heistig1_p1_guard_checks_bus", "loop", 2.0, 2.0, -1, 51, 0, false, false, false)
        Wait(WaitTime)
        FreezeEntityPosition(PlayerPedId(), false)
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent("Pug:client:ShudDownCokeLabForever", CokeLabData)
        DrugJobNotification(Config.LangT["SuccessShutDownLab"], 'error')
    end
end)
RegisterNetEvent("Pug:client:EnterCokeLabPassword", function()
    if Config.InputScript == "qb-input" or Config.InputScript == "ps-ui" then
        local input = exports[Config.InputScript]:ShowInput({
            header = Config.LangT["EnterPassword"],
            submitText = "Submit",
            inputs = {
                {
                    type = 'number',
                    isRequired = true,
                    name = 'id',
                    text = Config.LangT["EnterPassword"]
                }
            }
        })
        if not input then 
            DrugJobNotification(Config.LangT["NoPassword"], 'error')
            TriggerEvent("Pug:Client:CokeLabDoorMenu")
            return
        end
        if input.id then
            TriggerServerEvent("Pug:Server:EnterCokeLabPassword", tonumber(input.id))
        end
    else
        local input = lib.inputDialog(Config.LangT["EnterPassword"], {
            {
                type = 'number',
                name = "id",
                label = Config.LangT["EnterPassword"]
            }
        })
        if not input then 
            DrugJobNotification(Config.LangT["NoPassword"], 'error')
            TriggerEvent("Pug:Client:CokeLabDoorMenu")
            return
        end
        if input[1] then
            TriggerServerEvent("Pug:Server:EnterCokeLabPassword", tonumber(input[1]))
        end
    end
end)
RegisterNetEvent("Pug:client:AddCokeLabMember", function()
    local MemberCount = tonumber(#json.decode(CokeLabData.access))
    if tonumber(CokeLabData.membercap) > tonumber(MemberCount) then
        if Config.InputScript == "qb-input" or Config.InputScript == "ps-ui" then
            local input = exports[Config.InputScript]:ShowInput({
                header = Config.LangT["AddMember"],
                submitText = "Submit",
                inputs = {
                    {
                        type = 'number',
                        isRequired = true,
                        name = 'id',
                        text = Config.LangT["PlayersId"]
                    }
                }
            })
            if not input then 
                DrugJobNotification(Config.LangT["NoID"], 'error')
                TriggerEvent("Pug:client:ManageMembersCokeLab")
                return
            end
            if input.id then
                TriggerServerEvent("Pug:server:AddMemberToCokeLab", tonumber(input.id))
            end
        else
            local input = lib.inputDialog(Config.LangT["AddMember"], {
                {
                    type = 'number',
                    name = "id",
                    label = Config.LangT["PlayersId"]
                }
            })
            if not input then 
                DrugJobNotification(Config.LangT["NoID"], 'error')
                TriggerEvent("Pug:client:ManageMembersCokeLab")
                return
            end
            if input[1] then
                TriggerServerEvent("Pug:server:AddMemberToCokeLab", tonumber(input[1]))
            end
        end
    else
        DrugJobNotification(Config.LangT["MaxMembers"]..tonumber(MemberCount), 'error')
		TriggerEvent("Pug:client:ManageMembersCokeLab")
    end
end)
RegisterNetEvent("Pug:client:ChangecokeLabPassword", function()
	if Config.InputScript == "qb-input" or Config.InputScript == "ps-ui" then
		local input = exports[Config.InputScript]:ShowInput({
			header = Config.LangT["ChangePassword"],
			submitText = "Submit",
			inputs = {
				{
					type = 'number',
					isRequired = true,
					name = 'id',
					text = Config.LangT["CurrentPassword"]..tonumber(CokeLabData.password)
				}
			}
		})
		if not input then 
			DrugJobNotification(Config.LangT["NoPassword"], 'error')
			Wait(200)
			TriggerEvent("Pug:Client:DrugLaptopMenu")
			return
		end
		if input.id then
			TriggerServerEvent("Pug:server:ChangeCokeLabPassword", tonumber(input.id))
		end
	else
		local input = lib.inputDialog(Config.LangT["ChangePassword"], {
			{
				type = 'number',
				name = "id",
				label = Config.LangT["CurrentPassword"]..tonumber(CokeLabData.password)
			}
		})
		if not input then 
			DrugJobNotification(Config.LangT["NoPassword"], 'error')
			Wait(200)
			TriggerEvent("Pug:Client:DrugLaptopMenu")
			return
		end
		if input[1] then
			TriggerServerEvent("Pug:server:ChangeCokeLabPassword", tonumber(input[1]))
		end
	end
end)

RegisterNetEvent("Pug:client:UpgradeCokeLabMember", function()
    TriggerServerEvent("Pug:Server:UpgradeCokeLabMember")
end)

RegisterNetEvent("Pug:client:UpgradeCokeLab", function()
    if tonumber(CokeLabData.upgrades) == 0 then
        if tonumber(CokeLabData.supplies) < Config.UpgradeCokeLabRequirement1 then
            DrugJobNotification(Config.LangT["YouNeed"].. " ".. Config.UpgradeCokeLabRequirement1.." "..Config.LangT["SuppliesNeeded"], 'error')
            TriggerEvent("Pug:Client:DrugLaptopMenu")
            return
        end
    elseif tonumber(CokeLabData.upgrades) == 1 then
        if tonumber(CokeLabData.supplies) < Config.UpgradeCokeLabRequirement2 then
            DrugJobNotification(Config.LangT["YouNeed"].. " ".. Config.UpgradeCokeLabRequirement2.." "..Config.LangT["SuppliesNeeded"], 'error')
            TriggerEvent("Pug:Client:DrugLaptopMenu")
            return
        end
    elseif tonumber(CokeLabData.upgrades) == 2 then 
        if tonumber(CokeLabData.supplies) < Config.UpgradeCokeLabRequirement3 then
            DrugJobNotification(Config.LangT["YouNeed"].. " ".. Config.UpgradeCokeLabRequirement3.." "..Config.LangT["SuppliesNeeded"], 'error')
            TriggerEvent("Pug:Client:DrugLaptopMenu")
            return
        end
    end
    if tonumber(CokeLabData.upgrades) < 3 then
        TriggerServerEvent("Pug:Server:UpgradeCokeLab")
    else
        DrugJobNotification(Config.LangT["MaxedOut"], 'error')
        TriggerEvent("Pug:Client:DrugLaptopMenu")
    end
end)

RegisterNetEvent("Pug:Client:DrugSuppliesMenu", function()
    if not PuttingInOrRemoveingDrugs then
        TaskGoStraightToCoord(PlayerPedId(),vector3(1089.96, -3199.05, -38.99), 1.0, -1, 0.0, 0.0)
        while #(GetEntityCoords(PlayerPedId()) - vector3(1089.96, -3199.05, -38.99)) >= 0.2 do Wait(100) end
        ClearPedTasksImmediately(PlayerPedId())
        TaskTurnPedToFaceCoord(PlayerPedId(), vector3(1089.96, -3200.55, -39.01), 1500)
        Wait(800)
        TaskStartScenarioInPlace(PlayerPedId(), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', -1, true)
        if Config.Menu == "ox_lib" then
            local menu = {
                {
                    title = Config.LangT["AddSupplies"],
                    icon = "fa-solid fa-table-cells-large",
                    description = tonumber(CokeLabData.supplies).."x "..Config.LangT["Supplies"],
                    event = "Pug:client:AddSuppliesToLab",
                },
                {
                    title = Config.LangT["CollectProduct"],
                    icon = "fa-solid fa-pills",
                    description = tonumber(CokeLabData.product).."x "..Config.LangT["Product"],
                    event = "Pug:client:collectProductFromLab",
                },
            }
            lib.registerContext({
                id = Config.LangT["Supplies"],
                title = Config.LangT["Supplies"],
                onExit = function()
                    ClearPedTasks(PlayerPedId())
                end,
                options = menu
            })
            lib.showContext(Config.LangT["Supplies"])
        else
            local menu = {
                {
                    header = Config.LangT["Supplies"],
                    txt = " ",
                    params = {
                        event = " ",
                    }
                },
                {
                    header = Config.LangT["AddSupplies"],
                    icon = "fa-solid fa-table-cells-large",
                    txt = tonumber(CokeLabData.supplies).."x "..Config.LangT["Supplies"],
                    params = {
                        event = "Pug:client:AddSuppliesToLab",
                    }
                },
                {
                    header = Config.LangT["CollectProduct"],
                    icon = "fa-solid fa-pills",
                    txt = tonumber(CokeLabData.product).."x "..Config.LangT["Product"],
                    params = {
                        event = "Pug:client:collectProductFromLab",
                    }
                },
                {
                    header = Config.LangT["CloseMenu"],
                    txt = " ",
                    params = {
                        event = "Pug:Client:CloseMenuCokeBusiness",
                    }
                },
            }
            exports[Config.Menu]:openMenu(menu)
            Wait(1000)
            while true do
                Wait(2)
                if IsControlJustPressed(1, 51) or IsControlJustPressed(1, 177) or not IsPedUsingScenario(PlayerPedId(), "CODE_HUMAN_MEDIC_TEND_TO_DEAD") or not IsNuiFocused() then
                    if not IsNuiFocused() then
                        Wait(700)
                        if not IsNuiFocused() then
                            ClearPedTasks(PlayerPedId())
                        end
                    end
                    break
                end
            end
        end
    else
        DrugJobNotification(Config.LangT["AlreadyAddingOrRemovingProduct"], 'error')
    end
end)
RegisterNetEvent("Pug:Client:CloseMenuCokeBusiness", function()
    ClearPedTasks(PlayerPedId())
end)
RegisterNetEvent("Pug:client:AddSuppliesToLab", function()
    if not PuttingInOrRemoveingDrugs then
        PuttingInOrRemoveingDrugs = true
        if Config.InputScript == "qb-input" or Config.InputScript == "ps-ui" then
            local input = exports[Config.InputScript]:ShowInput({
                header = Config.LangT["AddSupplies"],
                submitText = "Member",
                inputs = {
                    {
                        type = 'number',
                        isRequired = true,
                        name = 'id',
                        text = Config.LangT["SuppliesAmount"]
                    }
                }
            })
            if not input then 
                DrugJobNotification(Config.LangT["NoInput"], 'error')
                PuttingInOrRemoveingDrugs = false
                TriggerEvent("Pug:Client:DrugSuppliesMenu")
                return
            end
            if input.id then
                if HasItem(Config.ProductSupplies, tonumber(input.id)) then
                    ClearPedTasks(PlayerPedId())
                    Wait(3000)
                    ClearPedTasksImmediately(PlayerPedId())
                    TaskTurnPedToFaceCoord(PlayerPedId(), vector3(1089.96, -3200.55, -39.01), 1500)
                    Wait(1200)
                    TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_SMOKING', -1, true)
                    Wait(1300)
                    ClearPedTasks(PlayerPedId())
                    loadAnimDict("mp_arresting")
                    TaskPlayAnim(PlayerPedId(), "mp_arresting" ,"a_uncuff" ,8.0, -8.0, -1, 1, 0, false, false, false)
                    Wait(4700)
                    ClearPedTasks(PlayerPedId())
                    TriggerServerEvent("Pug:server:AddSuppliesToLab", tonumber(input.id))
                    PuttingInOrRemoveingDrugs = false
                    TriggerEvent("Pug:Client:DrugSuppliesMenu")
                else
                    DrugJobNotification(Config.LangT["NotEnough"], 'error')
                    PuttingInOrRemoveingDrugs = false
                    TriggerEvent("Pug:Client:DrugSuppliesMenu")
                end
            end
        else
            local input = lib.inputDialog(Config.LangT["AddSupplies"], {
                {
                    type = 'number',
                    name = "id",
                    label = Config.LangT["SuppliesAmount"]
                }
            })
            if not input then 
                DrugJobNotification(Config.LangT["NoInput"], 'error')
                PuttingInOrRemoveingDrugs = false
                TriggerEvent("Pug:Client:DrugSuppliesMenu")
                return
            end
            if input[1] then
                if HasItem(Config.ProductSupplies, tonumber(input[1])) then
                    ClearPedTasks(PlayerPedId())
                    Wait(3000)
                    ClearPedTasksImmediately(PlayerPedId())
                    TaskTurnPedToFaceCoord(PlayerPedId(), vector3(1089.96, -3200.55, -39.01), 1500)
                    Wait(1200)
                    TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_SMOKING', -1, true)
                    Wait(1300)
                    ClearPedTasks(PlayerPedId())
                    loadAnimDict("mp_arresting")
                    TaskPlayAnim(PlayerPedId(), "mp_arresting" ,"a_uncuff" ,8.0, -8.0, -1, 1, 0, false, false, false)
                    Wait(4700)
                    ClearPedTasks(PlayerPedId())
                    TriggerServerEvent("Pug:server:AddSuppliesToLab", tonumber(input[1]))
                    PuttingInOrRemoveingDrugs = false
                    TriggerEvent("Pug:Client:DrugSuppliesMenu")
                else
                    DrugJobNotification(Config.LangT["NotEnough"], 'error')
                    PuttingInOrRemoveingDrugs = false
                    TriggerEvent("Pug:Client:DrugSuppliesMenu")
                end
            end
        end
    else
        DrugJobNotification(Config.LangT["AlreadyAddingOrRemovingProduct"], 'error')
    end
end)

RegisterNetEvent("Pug:client:collectProductFromLab", function()
    if not PuttingInOrRemoveingDrugs then
        PuttingInOrRemoveingDrugs = true
        if Config.InputScript == "qb-input" or Config.InputScript == "ps-ui" then
            local input = exports[Config.InputScript]:ShowInput({
                header = Config.LangT["CollectProduct"],
                submitText = "Member",
                inputs = {
                    {
                        type = 'number',
                        isRequired = true,
                        name = 'id',
                        text = tonumber(CokeLabData.product).."x "..Config.LangT["Product"]
                    }
                }
            })
            if not input then 
                DrugJobNotification(Config.LangT["NoInput"], 'error')
                PuttingInOrRemoveingDrugs = false
                TriggerEvent("Pug:Client:DrugSuppliesMenu")
                return
            end
            if input.id then
                if tonumber(CokeLabData.product) >= tonumber(input.id) then
                    ClearPedTasks(PlayerPedId())
                    Wait(3000)
                    ClearPedTasksImmediately(PlayerPedId())
                    TaskTurnPedToFaceCoord(PlayerPedId(), vector3(1089.96, -3200.55, -39.01), 1500)
                    Wait(1200)
                    ClearPedTasks(PlayerPedId())
                    loadAnimDict("anim@am_hold_up@male")
                    TaskPlayAnim(PlayerPedId(), "anim@am_hold_up@male" ,"shoplift_mid" ,8.0, -8.0, -1, 1, 0, false, false, false)
                    Wait(1200)
                    ClearPedTasks(PlayerPedId())
                    TriggerServerEvent("Pug:server:RemoveProductFromLab", tonumber(input.id))
                    PuttingInOrRemoveingDrugs = false
                    TriggerEvent("Pug:Client:DrugSuppliesMenu")
                else
                    DrugJobNotification(Config.LangT["NotEnough"], 'error')
                    PuttingInOrRemoveingDrugs = false
                    TriggerEvent("Pug:Client:DrugSuppliesMenu")
                end
            end
        else
            local input = lib.inputDialog(Config.LangT["CollectProduct"], {
                {
                    type = 'number',
                    name = "id",
                    label = tonumber(CokeLabData.product).."x "..Config.LangT["Product"]
                }
            })
            if not input then 
                DrugJobNotification(Config.LangT["NoInput"], 'error')
                PuttingInOrRemoveingDrugs = false
                TriggerEvent("Pug:Client:DrugSuppliesMenu")
                return
            end
            if input[1] then
                if tonumber(CokeLabData.product) >= tonumber(input[1]) then
                    ClearPedTasks(PlayerPedId())
                    Wait(3000)
                    ClearPedTasksImmediately(PlayerPedId())
                    TaskTurnPedToFaceCoord(PlayerPedId(), vector3(1089.96, -3200.55, -39.01), 1500)
                    Wait(1200)
                    ClearPedTasks(PlayerPedId())
                    loadAnimDict("anim@am_hold_up@male")
                    TaskPlayAnim(PlayerPedId(), "anim@am_hold_up@male" ,"shoplift_mid" ,8.0, -8.0, -1, 1, 0, false, false, false)
                    Wait(1200)
                    ClearPedTasks(PlayerPedId())
                    TriggerServerEvent("Pug:server:RemoveProductFromLab", tonumber(input[1]))
                    PuttingInOrRemoveingDrugs = false
                    TriggerEvent("Pug:Client:DrugSuppliesMenu")
                else
                    DrugJobNotification(Config.LangT["NotEnough"], 'error')
                    PuttingInOrRemoveingDrugs = false
                    TriggerEvent("Pug:Client:DrugSuppliesMenu")
                end
            end
        end
    else
        DrugJobNotification(Config.LangT["AlreadyAddingOrRemovingProduct"], 'error')
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    Wait(2000)
    if GetResourceState('bob74_ipl') == 'started' then
        -- Getting the object to interact with
        BikerCocaine = exports['bob74_ipl']:GetBikerCocaineObject()
        -- Setting the style
        BikerCocaine.Style.Set(BikerCocaine.Style.upgrade)
        -- Setting the security
        BikerCocaine.Security.Set(BikerCocaine.Security.upgrade)
        -- Enabling details
        BikerCocaine.Details.Enable({BikerCocaine.Details.cokeBasic1, BikerCocaine.Details.cokeBasic2, BikerCocaine.Details.cokeBasic3}, true)     
        -- Refreshing the interior to the see the result
        RefreshInterior(BikerCocaine.interiorId)
    end
    Config.FrameworkFunctions.TriggerCallback('Pug:server:DoesOwnCokeLab', function(result)
        if result then
            TriggerEvent("Pug:cleint:RunLoopIfOwnCokeLab",result)
            if Config.ShowBlipOfOwnedCokeLab then
                local location = json.decode(result.lablocation)
                PersonalCokeLabBlip = AddBlipForCoord(location.x, location.y, location.z)
                SetBlipSprite(PersonalCokeLabBlip, Config.PersonalCokeLabBlip.Type)
                SetBlipDisplay(PersonalCokeLabBlip, 4)
                SetBlipScale(PersonalCokeLabBlip, Config.PersonalCokeLabBlip.Size)
                SetBlipAsShortRange(PersonalCokeLabBlip, true)
                SetBlipAlpha(PersonalCokeLabBlip, Config.PersonalCokeLabBlip.Opacity)
                SetBlipColour(PersonalCokeLabBlip, Config.PersonalCokeLabBlip.Color)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(Config.LangT["CokeLab"])
                EndTextCommandSetBlipName(PersonalCokeLabBlip)
            end
        end
    end)
end)
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    Wait(2000)
    if GetResourceState('bob74_ipl') == 'started' then
        -- Getting the object to interact with
        BikerCocaine = exports['bob74_ipl']:GetBikerCocaineObject()
        -- Setting the style
        BikerCocaine.Style.Set(BikerCocaine.Style.upgrade)
        -- Setting the security
        BikerCocaine.Security.Set(BikerCocaine.Security.upgrade)
        -- Enabling details
        BikerCocaine.Details.Enable({BikerCocaine.Details.cokeBasic1, BikerCocaine.Details.cokeBasic2, BikerCocaine.Details.cokeBasic3}, true)     
        -- Refreshing the interior to the see the result
        RefreshInterior(BikerCocaine.interiorId)
    end
    Config.FrameworkFunctions.TriggerCallback('Pug:server:DoesOwnCokeLab', function(result)
        if result then
            TriggerEvent("Pug:cleint:RunLoopIfOwnCokeLab",result)
            if Config.ShowBlipOfOwnedCokeLab then
                local location = json.decode(result.lablocation)
                PersonalCokeLabBlip = AddBlipForCoord(location.x, location.y, location.z)
                SetBlipSprite(PersonalCokeLabBlip, Config.PersonalCokeLabBlip.Type)
                SetBlipDisplay(PersonalCokeLabBlip, 4)
                SetBlipScale(PersonalCokeLabBlip, Config.PersonalCokeLabBlip.Size)
                SetBlipAsShortRange(PersonalCokeLabBlip, true)
                SetBlipAlpha(PersonalCokeLabBlip, Config.PersonalCokeLabBlip.Opacity)
                SetBlipColour(PersonalCokeLabBlip, Config.PersonalCokeLabBlip.Color)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(Config.LangT["CokeLab"])
                EndTextCommandSetBlipName(PersonalCokeLabBlip)
            end
        end
    end)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        if GetResourceState('bob74_ipl') == 'started' then
            -- Getting the object to interact with
            BikerCocaine = exports['bob74_ipl']:GetBikerCocaineObject()
            -- Setting the style
            BikerCocaine.Style.Set(BikerCocaine.Style.upgrade)
            -- Setting the security
            BikerCocaine.Security.Set(BikerCocaine.Security.upgrade)
            -- Enabling details
            BikerCocaine.Details.Enable({BikerCocaine.Details.cokeBasic1, BikerCocaine.Details.cokeBasic2, BikerCocaine.Details.cokeBasic3}, true)     
            -- Refreshing the interior to the see the result
            RefreshInterior(BikerCocaine.interiorId)
        end
        Wait(2000)
        local LoggedInState
        if Framework == "QBCore" then
            LoggedInState = LocalPlayer.state['isLoggedIn']
        else
            LoggedInState = FWork.PlayerLoaded
        end
        if LoggedInState then
            Config.FrameworkFunctions.TriggerCallback('Pug:server:DoesOwnCokeLab', function(result)
                if result then
                    TriggerEvent("Pug:cleint:RunLoopIfOwnCokeLab",result)
                    if Config.ShowBlipOfOwnedCokeLab then
                        local location = json.decode(result.lablocation)
                        PersonalCokeLabBlip = AddBlipForCoord(location.x, location.y, location.z)
                        SetBlipSprite(PersonalCokeLabBlip, Config.PersonalCokeLabBlip.Type)
                        SetBlipDisplay(PersonalCokeLabBlip, 4)
                        SetBlipScale(PersonalCokeLabBlip, Config.PersonalCokeLabBlip.Size)
                        SetBlipAsShortRange(PersonalCokeLabBlip, true)
                        SetBlipAlpha(PersonalCokeLabBlip, Config.PersonalCokeLabBlip.Opacity)
                        SetBlipColour(PersonalCokeLabBlip, Config.PersonalCokeLabBlip.Color)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString(Config.LangT["CokeLab"])
                        EndTextCommandSetBlipName(PersonalCokeLabBlip)
                    end
                end
            end)
        end
    end
end)

RegisterNetEvent('Pug:cleint:RunLoopIfOwnCokeLab', function(AllDataLoop)
    local sleep
    DataLoop = AllDataLoop
    if DataLoop.upgrades == 0 then
        sleep = 60000 * Config.TimeDrugsTakeToProcess
    elseif DataLoop.upgrades == 1 then
        sleep = math.ceil(60000 * Config.TimeDrugsTakeToProcess - (60000 * Config.TimeDrugsTakeToProcess) * Config.TimePercentIncreaseUpgrade1)
    elseif DataLoop.upgrades == 2 then
        sleep = math.ceil(60000 * Config.TimeDrugsTakeToProcess - (60000 * Config.TimeDrugsTakeToProcess) * Config.TimePercentIncreaseUpgrade2)
    else
        sleep = math.ceil(60000 * Config.TimeDrugsTakeToProcess - (60000 * Config.TimeDrugsTakeToProcess) * Config.TimePercentIncreaseUpgrade3)
    end
    while true do
        Wait(sleep)
        local LoggedInState
        if Framework == "QBCore" then
            LoggedInState = LocalPlayer.state['isLoggedIn']
        else
            LoggedInState = FWork.PlayerLoaded
        end
        if LoggedInState then
            if DataLoop.upgrades == 0 then
                sleep = 60000 * Config.TimeDrugsTakeToProcess
            elseif DataLoop.upgrades == 1 then
                sleep = math.ceil(60000 * Config.TimeDrugsTakeToProcess - (60000 * Config.TimeDrugsTakeToProcess) * Config.TimePercentIncreaseUpgrade1)
            elseif DataLoop.upgrades == 2 then
                sleep = math.ceil(60000 * Config.TimeDrugsTakeToProcess - (60000 * Config.TimeDrugsTakeToProcess) * Config.TimePercentIncreaseUpgrade2)
            else
                sleep = math.ceil(60000 * Config.TimeDrugsTakeToProcess - (60000 * Config.TimeDrugsTakeToProcess) * Config.TimePercentIncreaseUpgrade3)
            end
            TriggerServerEvent("Pug:server:UpdateDrugProductProcessed")
        else
            -- Targets removal
            if Config.Target == "ox_target" then
                if DrugSupplies ~= nil then
                    exports.ox_target:removeZone(DrugSupplies)
                end
                if DrugLaptop ~= nil then
                    exports.ox_target:removeZone(DrugLaptop)
                end
            else
                exports[Config.Target]:RemoveZone("DrugSupplies")
                exports[Config.Target]:RemoveZone("DrugLaptop")
            end
            break
        end
    end
end)

RegisterNetEvent('Pug:cleint:UpdateAllLabInfo', function(Data)
    DataLoop = Data
    if CokeLabData then -- if they are in the cokelab update there data.
        CokeLabData = Data
        DrugPlaneToSpawn = tostring(CokeLabData.plane)
        for k, v in pairs(Config.CokePlanes) do
            if v.model == DrugPlaneToSpawn then
                PlaneToSpawnIndexes = Config.CokePlanes[k]
                break
            end
        end
        -- If i do props on the sHelf i should update them here.
    end
end)
-- END