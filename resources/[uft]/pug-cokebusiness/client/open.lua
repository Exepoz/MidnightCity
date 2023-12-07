print'Pug DrugJob 1.0.7'

function DrugJobNotification(msg, type, length)
    if Framework == "ESX" then
		FWork.ShowNotification(msg)
	elseif Framework == "QBCore" then
    	FWork.Functions.Notify(msg, type, length)
	end
end

function DrugJobDrawText(Text)
    if Framework == "QBCore" then
		exports[Config.CoreName]:DrawText(Text, 'left')
	else
		FWork.TextUI(Text, "error")
	end
end

function DrugJobHideText()
	if Framework == "QBCore" then
		exports[Config.CoreName]:HideText()
	else
		FWork.HideUI()
	end
end
-- Change this to your dispatch script if needed
function CallPoliceForDrugPlaneTooHigh(model)
	if Config.DispatchScript == "ps-dispatch" then
    	exports[Config.DispatchScript]:PlaneTooHigh(Vehicle)
	else
		-- Put your dispatch code here if you are not using ps-dispatch
	end
end

-- Coke Business toggle item function bool is true or false to give or remove item (true = give, false = remove)
local function DrugJobToggleItem(bool, item, amount, info)
	return TriggerServerEvent("Pug:server:GiveDrugJobItems", bool, item, amount, info)
end

local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

CreateThread(function()
    if Config.UsePedToDoDrugRuns then
        -- PedCreation
        DrugPed = Config.DrugPed
        PugLoadModel(DrugPed)
        DrugPedMan = CreatePed(2, DrugPed, Config.PedLocation)
        SetPedFleeAttributes(DrugPedMan, 0, 0)
        SetPedDiesWhenInjured(DrugPedMan, false)
        SetPedKeepTask(DrugPedMan, true)
        SetBlockingOfNonTemporaryEvents(DrugPedMan, true)
        SetEntityInvincible(DrugPedMan, true)
        FreezeEntityPosition(DrugPedMan, true)
        TaskStartScenarioInPlace(DrugPedMan, "WORLD_HUMAN_CLIPBOARD", 0, true)
        -- End
        if Config.Target == "ox_target" then
            exports.ox_target:addLocalEntity(DrugPedMan, {
                {
                    name = 'DrugRun',
                    event = 'Pug:client:DrugRunMenu',
                    icon = "fa-solid fa-plane-departure",
                    label = "Take some flights?",
                }
            })
        else
            exports[Config.Target]:AddTargetEntity(DrugPedMan, {
                options = {
                    {
                        event = 'Pug:client:DrugRunMenu',
                        icon = "fa-solid fa-plane-departure",
                        label = "Take some flights?",
                    },
                },
                distance = 2.5
            })
        end
    end
end)

RegisterNetEvent("Pug:client:ShowDrugJobNotify", function(msg, type, length)
    DrugJobNotification(msg, type, length)
end)

RegisterNetEvent("Pug:Client:DrugLaptopMenuPolice", function()
    TaskGoStraightToCoord(PlayerPedId(),vector3(1087.14, -3194.19, -38.99), 1.0, -1, 0.0, 0.0)
    while #(GetEntityCoords(PlayerPedId()) - vector3(1087.14, -3194.19, -38.99)) >= 0.2 do Wait(100) end
    ClearPedTasksImmediately(PlayerPedId())
    TaskTurnPedToFaceCoord(PlayerPedId(), vector3(1084.64, -3194.28, -38.99), 1500)
    Wait(800)
    loadAnimDict("anim@heists@prison_heistig1_p1_guard_checks_bus")
    TaskPlayAnim(PlayerPedId(), "anim@heists@prison_heistig1_p1_guard_checks_bus", "loop", 2.0, 2.0, -1, 51, 0, false, false, false)
    if Config.Menu == "ox_lib" then
        local menu = {}
        menu[#menu+1] = {
            title = Config.LangT["ShutDownCokeLab"],
            icon = "fa-solid fa-lock",
            description = Config.LangT["ShutDownCokeLabDescription"],
            event = "Pug:client:ShudDownCokeLabForever",
        } 
        lib.registerContext({
            id =  Config.LangT["ShutDownCokeLab"],
            title =  Config.LangT["ShutDownCokeLab"],
            onExit = function()
                ClearPedTasks(PlayerPedId())
            end,
            options = menu
        })
        lib.showContext( Config.LangT["ShutDownCokeLab"])
    else
        local menu = {}
        menu[#menu+1] = {
            header = Config.LangT["ShutDownCokeLab"],
            icon = "fa-solid fa-lock",
            txt = Config.LangT["ShutDownCokeLabDescription"],
            params = {
                event = "Pug:client:ShudDownCokeLabForever",
            }
        } 
        exports[Config.Menu]:openMenu(menu)
    end
end)

-- This is for if you want to add more planes that players can upgrade too
-- You wil need to put the correct bone index data here. This is only for developing. 
-- The way i work on this is i change bone1 and bone2 and axis's under Config.CokePlanes and restart the script over and over and over trying to match up the box on the wing properly.
CreateThread(function()
    -- CREATE PLANE FOR TESTING
    -- local PlayerPed = PlayerPedId()
    -- local PlaneModel = "seabreeze" -- MAKE THE PLANE MODEL YOU WANT TO TEST HERE
    -- for k, v in pairs(Config.CokePlanes) do
    --     if v.model == PlaneModel then 
    --         PlaneToSpawnIndexes = Config.CokePlanes[k]
    --     end
    -- end
    -- PugLoadModel(GetHashKey(PlaneModel))
    -- DrugPlane = CreateVehicle(GetHashKey(PlaneModel),  GetEntityCoords(PlayerPed).x, GetEntityCoords(PlayerPed).y+5, GetEntityCoords(PlayerPed).z, 100, true, false)
    -- while not DoesEntityExist(DrugPlane) do Wait(100) end
    
    -- UNHASH THIS TO TEST THE FOUND LOCATIONS OF THE BOX
    -- local Count = 0.0
    -- while true do
    --     if Count < 6 then
    --         Wait(800)
    --         print(Count)
    --         BoxInHand = CreateObject(GetHashKey("hei_prop_heist_box"), GetEntityCoords(PlayerPed).x, GetEntityCoords(PlayerPed).y, GetEntityCoords(PlayerPed).z, true, true, true)
    --         if Count < 3 then
    --             AttachEntityToEntity(BoxInHand, DrugPlane, PlaneToSpawnIndexes.bone1, PlaneToSpawnIndexes.xaxis or Count, PlaneToSpawnIndexes.yaxis or Count, PlaneToSpawnIndexes.zaxis, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    --         else
    --             AttachEntityToEntity(BoxInHand, DrugPlane, PlaneToSpawnIndexes.bone2, PlaneToSpawnIndexes.xaxis or Count-3, PlaneToSpawnIndexes.yaxis or Count-3, PlaneToSpawnIndexes.zaxis, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    --         end
    --         Count = Count + 1
    --     else
    --         break
    --     end
    -- end

    -- UNHASH THIS TO TRY AND FIND A GOOD BOX LOCATION
    -- local FindingPosCount = 1
    -- local Count = 0.0
    -- while true do
    --     Wait(800)
    --     FindingPosCount = FindingPosCount + 1
    --     print(FindingPosCount)
    --     BoxInHand = CreateObject(GetHashKey("hei_prop_heist_box"), GetEntityCoords(PlayerPed).x, GetEntityCoords(PlayerPed).y, GetEntityCoords(PlayerPed).z, true, true, true)
    --     AttachEntityToEntity(BoxInHand, DrugPlane, FindingPosCount, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    -- end
end)
