local targetSystem

if Config.Framework == "QBCore" then
    targetSystem = "qb-target"
else
    targetSystem = "qtarget"
end

function SpawnStartingPed()
    local model = `a_m_m_eastsa_02`
    RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(50)
	end
    spawnedPed = CreatePed(0, model, vector4(168.74, -2222.71, 6.24, 88.95), false, true)
    FreezeEntityPosition(spawnedPed, true)
    SetBlockingOfNonTemporaryEvents(spawnedPed, true)
    SetEntityInvincible(spawnedPed, true)
    exports[targetSystem]:AddTargetEntity(spawnedPed, {
        options = {
            {
                event = "17mov_divers:OpenMainMenu",
                icon = "fa-solid fa-handshake-simple",
                label = "Start Job",
                -- job = "RequiredJob",
                canInteract = function(entity)
                    return #(GetEntityCoords(PlayerPedId()) - vec3(Config.Locations.DutyToggle.Coords[1].x, Config.Locations.DutyToggle.Coords[1].y, Config.Locations.DutyToggle.Coords[1].z)) < 5.0
                end
            },
        },
        distance = 2.5
    })

    exports[targetSystem]:AddTargetModel(Config.TreasureProp, {
        options = {
            {
                event = "17mov_divers:collectTreasure",
                icon = "fa-solid fa-toolbox",
                label = "Collect Treasure",
                -- job = "RequiredJob",
                canInteract = function(entity)
                    return #(GetEntityCoords(entity) - currentTreasure.coords) < 3.0
                end,
            },
        },
        distance = 3.5
    })
end

RegisterNetEvent("17mov_divers:OpenMainMenu", function()
    OpenDutyMenu()
end)

function AddTargetEntity(entity)
    exports[targetSystem]:AddTargetEntity(entity, {
        options = {
            {
                event = "17mov_divers:attachAnhor",
                icon = "fa-solid fa-anchor",
                label = "Drop/Lift Anchor",
                -- job = "RequiredJob",
            },
        },
        distance = 3.5
    })
end
