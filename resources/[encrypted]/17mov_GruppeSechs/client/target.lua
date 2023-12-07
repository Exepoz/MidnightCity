local targetSystem

if Config.Framework == "QBCore" then
    targetSystem = "qb-target"
else
    targetSystem = "qtarget"
end

function SpawnStartingPed()
    local model = `s_m_m_strpreach_01`
    RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(50)
	end
    spawnedPed = CreatePed(0, model, vector4(-195.56, -835.39, 29.72, 295.0), false, true)
    FreezeEntityPosition(spawnedPed, true)
    SetBlockingOfNonTemporaryEvents(spawnedPed, true)
    SetEntityInvincible(spawnedPed, true)
    exports[targetSystem]:AddTargetEntity(spawnedPed, {
        options = {
            {
                event = "17mov_GruppeSechs:OpenMainMenu",
                icon = "fa-solid fa-handshake-simple",
                label = "Start Job",
                -- job = "RequiredJob",
                canInteract = function(entity)
                    return #(GetEntityCoords(PlayerPedId()) - vec3(-195.56, -835.39, 30.72)) < 5.0
                end
            },
        },
        distance = 2.5
    })
end

RegisterNetEvent("17mov_GruppeSechs:OpenMainMenu", function()
    OpenDutyMenu()
end)
