local speedBuffer, velBuffer, pauseActive, isCarHud, stress, speedMultiplier  = {0.0,0.0}, {}, false, false, 0, Config.DefaultSpeedUnit == "kmh" and 2.23694 or 2.6
Framework = nil
Framework = GetFramework()
Citizen.Await(Framework)


Callback = Config.Framework == "ESX" or Config.Framework == "NewESX" and Framework.TriggerServerCallback or Framework.Functions.TriggerCallback

function getPlayerData()
   local framework = Config.Framework
   if framework == "ESX" or framework == "NewESX" then
       return Framework.GetPlayerData()
   else
       return Framework.Functions.GetPlayerData()
   end
end

Citizen.CreateThread(function()
if Config.RemoveStress["on_swimming"].enable then
   while true do
      Citizen.Wait(10000)
      if IsPedSwimming(playerPed) then
         local val = math.random(Config.RemoveStress["on_swimming"].min, Config.RemoveStress["on_swimming"].max)
         TriggerServerEvent('hud:server:RelieveStress', val)
      end
   end
end
end)

Citizen.CreateThread(function()
if Config.RemoveStress["on_running"].enable then
   while true do
      Citizen.Wait(10000)
      if IsPedRunning(playerPed) then
         local val = math.random(Config.RemoveStress["on_running"].min, Config.RemoveStress["on_running"].max)
         TriggerServerEvent('hud:server:RelieveStress', val)
      end
   end
end
end)

Citizen.CreateThread(function() -- Speeding
if Config.AddStress["on_fastdrive"].enable  then
   while true do
      local ped = PlayerPedId() -- corrected line
      if IsPedInAnyVehicle(ped, false) then
         local speed = GetEntitySpeed(GetVehiclePedIsIn(ped, false)) * 15
         local stressSpeed = 110
         if speed >= stressSpeed then
            TriggerServerEvent('hud:server:GainStress', math.random(Config.AddStress["on_fastdrive"].min, Config.AddStress["on_fastdrive"].max))
         end
      end
      Wait(10000)
   end
end
end)


CreateThread(function() -- Shooting
if Config.AddStress["on_shoot"].enable  then
   while true do
      local ped = playerPed
      local weapon = GetSelectedPedWeapon(ped)
      if weapon ~= `WEAPON_UNARMED` then
         if IsPedShooting(ped) then
            if math.random() < 0.15 and not IsWhitelistedWeaponStress(weapon) then
               TriggerServerEvent('hud:server:GainStress', math.random(Config.AddStress["on_shoot"].min, Config.AddStress["on_shoot"].max))
            end
         end
      else
         Wait(900)
      end
      Wait(8)
   end

end

end)

function IsWhitelistedWeaponStress(weapon)
   if weapon then
      for _, v in pairs(Config.WhitelistedWeaponStress) do
         if weapon == v then
            return true
         end
      end
   end
   return false
end

Citizen.CreateThread(function() -- Shooting
if Config.AddStress["on_shoot"].enable  then
   while true do
      local ped = PlayerPedId()
      local weapon = GetSelectedPedWeapon(ped)
      if weapon ~= GetHashKey('WEAPON_UNARMED') then
         if IsPedShooting(ped) then
            if math.random() < 0.15 and not IsWhitelistedWeaponStress(weapon) then
               TriggerServerEvent('hud:server:GainStress', math.random(Config.AddStress["on_shoot"].min, Config.AddStress["on_shoot"].max))
            end
         end
      else
         Wait(900)
      end
      Wait(8)
   end
end
end)

Citizen.CreateThread(function()
while true do
   local ped = PlayerPedId()
   if tonumber(stress) >= 100 then
      local ShakeIntensity = GetShakeIntensity(stress)
      local FallRepeat = math.random(2, 4)
      local RagdollTimeout = (FallRepeat * 1750)
      ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
      SetFlash(0, 0, 500, 3000, 500)

      if not IsPedRagdoll(ped) and IsPedOnFoot(ped) and not IsPedSwimming(ped) then
         SetPedToRagdollWithFall(ped, RagdollTimeout, RagdollTimeout, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
      end

      Wait(500)
      for i=1, FallRepeat, 1 do
         Wait(750)
         DoScreenFadeOut(200)
         Wait(1000)
         DoScreenFadeIn(200)
         ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
         SetFlash(0, 0, 200, 750, 200)
      end
   end

   if stress >= 50 then
      local ShakeIntensity = GetShakeIntensity(stress)
      ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
      SetFlash(0, 0, 500, 2500, 500)
   end
   Wait(GetEffectInterval(stress))
end
end)


function GetShakeIntensity(stresslevel)
   local retval = 0.05
   local Intensity = {
      ["shake"] = {
         [1] = {
            min = 50,
            max = 60,
            intensity = 0.12,
         },
         [2] = {
            min = 60,
            max = 70,
            intensity = 0.17,
         },
         [3] = {
            min = 70,
            max = 80,
            intensity = 0.22,
         },
         [4] = {
            min = 80,
            max = 90,
            intensity = 0.28,
         },
         [5] = {
            min = 90,
            max = 100,
            intensity = 0.32,
         },
      }
   }
   for k, v in pairs(Intensity['shake']) do
      if stresslevel >= v.min and stresslevel <= v.max then
         retval = v.intensity
         break
      end
   end
   return retval
end

function GetEffectInterval(stresslevel)
   local EffectInterval = {
      [1] = {
         min = 50,
         max = 60,
         timeout = math.random(14000, 15000)
      },
      [2] = {
         min = 60,
         max = 70,
         timeout = math.random(12000, 13000)
      },
      [3] = {
         min = 70,
         max = 80,
         timeout = math.random(10000, 11000)
      },
      [4] = {
         min = 80,
         max = 90,
         timeout = math.random(8000, 9000)
      },
      [5] = {
         min = 90,
         max = 100,
         timeout = math.random(6000, 7000)
      }
   }
   local retval = 10000
   for k, v in pairs(EffectInterval) do
      if stresslevel >= v.min and stresslevel <= v.max then
         retval = v.timeout
         break
      end
   end
   return retval
end

RegisterNetEvent('hud:client:UpdateStress', function(newStress) -- Add this event with adding stress elsewhere
stress = newStress
SendNUIMessage({
   action = 'STRESS',
   stress = math.ceil(newStress),
})
end)

RegisterNetEvent('esx_basicneeds:onEat')
AddEventHandler('esx_basicneeds:onEat', function()
if Config.RemoveStress["on_eat"].enable then
   local val = math.random(Config.RemoveStress["on_eat"].min, Config.RemoveStress["on_eat"].max)
   TriggerServerEvent('hud:server:RelieveStress', val)
end
end)

RegisterNetEvent('consumables:client:Eat')
AddEventHandler('consumables:client:Eat', function()
if Config.RemoveStress["on_eat"].enable then
   local val = math.random(Config.RemoveStress["on_eat"].min, Config.RemoveStress["on_eat"].max)
   TriggerServerEvent('hud:server:RelieveStress', val)
end
end)


RegisterNetEvent('consumables:client:Drink')
AddEventHandler('consumables:client:Drink', function()
if Config.RemoveStress["on_drink"].enable then
   local val = math.random(Config.RemoveStress["on_drink"].min, Config.RemoveStress["on_drink"].max)
   TriggerServerEvent('hud:server:RelieveStress', val)
end
end)
RegisterNetEvent('consumables:client:DrinkAlcohol')
AddEventHandler('consumables:client:DrinkAlcohol', function()
if Config.RemoveStress["on_drink"].enable then
   local val = math.random(Config.RemoveStress["on_drink"].min, Config.RemoveStress["on_drink"].max)
   TriggerServerEvent('hud:server:RelieveStress', val)
end
end)

RegisterNetEvent('devcore_needs:client:StartEat')
AddEventHandler('devcore_needs:client:StartEat', function()
if Config.RemoveStress["on_eat"].enable then
   local val = math.random(Config.RemoveStress["on_eat"].min, Config.RemoveStress["on_eat"].max)
   TriggerServerEvent('hud:server:RelieveStress', val)
end
end)
RegisterNetEvent('devcore_needs:client:DrinkShot')
AddEventHandler('devcore_needs:client:DrinkShot', function()
if Config.RemoveStress["on_drink"].enable then
   local val = math.random(Config.RemoveStress["on_drink"].min, Config.RemoveStress["on_drink"].max)
   TriggerServerEvent('hud:server:RelieveStress', val)
end
end)

RegisterNetEvent('devcore_needs:client:StartDrink')
AddEventHandler('devcore_needs:client:StartDrink', function()
if Config.RemoveStress["on_drink"].enable then
   local val = math.random(Config.RemoveStress["on_drink"].min, Config.RemoveStress["on_drink"].max)
   TriggerServerEvent('hud:server:RelieveStress', val)
end
end)

RegisterNetEvent('esx_optionalneeds:onDrink')
AddEventHandler('esx_optionalneeds:onDrink', function()
if Config.RemoveStress["on_drink"].enable then
   local val = math.random(Config.RemoveStress["on_drink"].min, Config.RemoveStress["on_drink"].max)
   TriggerServerEvent('hud:server:RelieveStress', val)
end
end)


RegisterNetEvent('esx_basicneeds:onDrink')
AddEventHandler('esx_basicneeds:onDrink', function()
if Config.RemoveStress["on_drink"].enable then
   local val = math.random(Config.RemoveStress["on_drink"].min, Config.RemoveStress["on_drink"].max)
   TriggerServerEvent('hud:server:RelieveStress', val)
end
end)

AddEventHandler('esx:onPlayerDeath', function()
TriggerServerEvent('hud:server:RelieveStress', 10000)
end)

RegisterNetEvent('hospital:client:RespawnAtHospital')
AddEventHandler('hospital:client:RespawnAtHospital', function()
TriggerServerEvent('hud:server:RelieveStress', 10000)
end)

Citizen.CreateThread(function()
if Config.RemoveStress["on_swimming"].enable then
   while true do
      Citizen.Wait(10000)
      if IsPedSwimming(playerPed) then
         local val = math.random(Config.RemoveStress["on_swimming"].min, Config.RemoveStress["on_swimming"].max)
         TriggerServerEvent('hud:server:RelieveStress', val)
      end
   end
end
end)

Citizen.CreateThread(function()
if Config.RemoveStress["on_running"].enable then
   while true do
      Citizen.Wait(10000)
      if IsPedRunning(playerPed) then
         local val = math.random(Config.RemoveStress["on_running"].min, Config.RemoveStress["on_running"].max)
         TriggerServerEvent('hud:server:RelieveStress', val)
      end
   end
end
end)


RegisterCommand("Notification", function() -- Test Command
-- TriggerEvent("HudNotification", 'succes', 'EYES STORE', 'In the city center, there is a vehicle. Do you want to remove this vehicle, the vehicle can only be taken from the towed ones!')
exports['es-argushud']:Notification('succes', 'Succes', 'Success description are there in few cute words for our dear players, enjoy')
Citizen.Wait(1000)
exports['es-argushud']:Notification('error', 'Error', 'Success description are there in few cute words for our dear players, enjoy')
Citizen.Wait(2000)
exports['es-argushud']:Notification('warning', 'Warning', 'Success description are there in few cute words for our dear players, enjoy')
end)

RegisterCommand("Question", function()
exports['es-argushud']:Question('Are you sure?', 'Success description are there in few cute words for our dear players, enjoy')
end)

RegisterNetEvent('HudNotification') -- Trigger ==> Export
AddEventHandler('HudNotification', function(Type, Header,Message)
   exports['es-argushud']:Notification(Type, Header, Message)
--   exports['es-argushud']:Notification('succes', 'EYES STORE', 'In the city center, there is a vehicle. Do you want to remove this vehicle, the vehicle can only be taken from the towed ones!')
end)

exports('Notification', function(Type, Header,Message)
SendNUIMessage({
   action = "GET_NOTIFICATION",
   ntype = Type,
   nheader = Header,
   nmsg = Message
})
end)

exports('Question', function(Header,Message)
if not isQuestion then
   isQuestion = true
   SendNUIMessage({action = 'GET_QUESTION', qheader = Header, qmsg = Message, qstats = true})
   while isQuestion do
      if IsControlJustPressed(0,246) then
         SendNUIMessage({action = 'GET_QUESTION', qstats = false})
         isQuestion = false
         return 'Y'
      end
      if IsControlJustPressed(0,249) then
         SendNUIMessage({action = 'GET_QUESTION', qstats = false})
         isQuestion = false
         return 'N'
      end
      Citizen.Wait(4)
   end
else
   return
end
end)


local lastAmmo = nil
local lastMaxAmmo = nil
local displayAmmo = false
local currentWeaponName = ""

local weapons = {
--Melee
{ label = "Dagger", name = "dagger", hash = "0x92A27487" },
{ label = "Bat", name = "bat", hash = "0x958A4A8F" },
{ label = "Bottle", name = "bottle", hash = "0xF9E6AA4B" },
{ label = "Crowbar", name = "crowbar", hash = "0x84BD7BFD" },
{ label = "Unarmed", name = "unarmed", hash = "0xA2719263" },
{ label = "Flashlight", name = "flashlight", hash = "0x8BB05FD7" },
{ label = "Golfclub", name = "golfclub", hash = "0x440E4788" },
{ label = "Hammer", name = "hammer", hash = "0x4E875F73" },
{ label = "Hatchet", name = "hatchet", hash = "0xF9DCBF2D" },
{ label = "Knuckle", name = "knuckle", hash = "0xD8DF3C3C" },
{ label = "Knife", name = "knife", hash = "0x99B507EA" },
{ label = "Machete", name = "machete", hash = "0xDD5DF8D9" },
{ label = "Switchblade", name = "switchblade", hash = "0xDFE37640" },
{ label = "Nightstick", name = "nightstick", hash = "0x678B81B1" },
{ label = "Wrench", name = "wrench", hash = "0x19044EE0" },
{ label = "Battleaxe", name = "battleaxe", hash = "0xCD274149" },
{ label = "Poolcue", name = "poolcue", hash = "0x94117305" },
{ label = "Stone Hatchet", name = "stone_hatchet", hash = "0x3813FC08" },

-- Pistols
{ label = "Pistol", name = "pistol", hash = "0x1B06D571" },
{ label = "Pistol MK2", name = "pistol_mk2", hash = "0xBFE256D4" },
{ label = "Combat Pistol", name = "combatpistol", hash = "0x5EF9FEC4" },
{ label = "AP Pistol", name = "appistol", hash = "0x22D8FE39" },
{ label = "Stun Gun", name = "stungun", hash = "0x3656C8C1" },
{ label = "Pistol .50", name = "pistol50", hash = "0x99AEEB3B" },
{ label = "SNS Pistol", name = "snspistol", hash = "0xBFD21232" },
{ label = "SNS Pistol MK2", name = "snspistol_mk2", hash = "0x88374054" },
{ label = "Heavy Pistol", name = "heavypistol", hash = "0xD205520E" },
{ label = "Vintage Pistol", name = "vintagepistol", hash = "0x83839C4" },
{ label = "Flare Gun", name = "flaregun", hash = "0x47757124" },
{ label = "Marksman Pistol", name = "marksmanpistol", hash = "0xDC4DB296" },
{ label = "Revolver", name = "revolver", hash = "0xC1B3C3D1" },
{ label = "Revolver MK2", name = "revolver_mk2", hash = "0xCB96392F" },
{ label = "Double Action", name = "doubleaction", hash = "0x97EA20B8" },
{ label = "Ray Pistol", name = "raypistol", hash = "0xAF3696A1" },
{ label = "Ceramic Pistol", name = "ceramicpistol", hash = "0x2B5EF5EC" },
{ label = "Navy Revolver", name = "navyrevolver", hash = "0x917F6C8C" },
{ label = "Perico Pistol", name = "gadgetpistol", hash = "0x57A4368C" },

--SMGs
{ label = "Micro SMG", name = "microsmg", hash = "0x13532244" },
{ label = "SMG", name = "smg", hash = "0x2BE6766B" },
{ label = "SMG Mk II", name = "smg_mk2", hash = "0x78A97CD0" },
{ label = "Assault SMG", name = "assaultsmg", hash = "0xEFE7E2DF" },
{ label = "Combat PDW", name = "combatpdw", hash = "0x0A3D4D34" },
{ label = "Machine Pistol", name = "machinepistol", hash = "0xDB1AA450" },
{ label = "Mini SMG", name = "minismg", hash = "0xBD248B55" },
{ label = "Unholy Hellbringer", name = "raycarbine", hash = "0x476BF155" },

--Shotguns
{ label = "Pump Shotgun", name = "pumpshotgun", hash = "0x1D073A89" },
{ label = "Pump Shotgun Mk II", name = "pumpshotgun_mk2", hash = "0x555AF99A" },
{ label = "Sawed-Off Shotgun", name = "sawnoffshotgun", hash = "0x7846A318" },
{ label = "Assault Shotgun", name = "assaultshotgun", hash = "0xE284C527" },
{ label = "Bullpup Shotgun", name = "bullpupshotgun", hash = "0x9D61E50F" },
{ label = "Musket", name = "musket", hash = "0xA89CB99E" },
{ label = "Heavy Shotgun", name = "heavyshotgun", hash = "0x3AABBBAA" },
{ label = "Double Barrel Shotgun", name = "dbshotgun", hash = "0xEF951FBB" },
{ label = "Sweeper Shotgun", name = "autoshotgun", hash = "0x12E82D3D" },
{ label = "Combat Shotgun", name = "combatshotgun", hash = "0x5A96BA4" },

--Rifles
{ label = "Assault Rifle", name = "assaultrifle", hash = "0xBFEFFF6D" },
{ label = "Assault RiflE", name = "assaultrifle_mk2", hash = "0x394F415C" },
{ label = "Carbine Rifle", name = "carbinerifle", hash = "0x83BF0278" },
{ label = "Carbine Rifle", name = "carbinerifle_mk2", hash = "0xFAD1F1C9" },
{ label = "Advanced Rifle", name = "advancedrifle", hash = "0xAF113F99" },
{ label = "Special Carbine", name = "specialcarbine", hash = "0xC0A3098D" },
{ label = "Special Carbine Mk II", name = "specialcarbine_mk2", hash = "0x969C3D67" },
{ label = "Bullpup Rifle", name = "bullpuprifle", hash = "0x7F229F94" },
{ label = "Bullpup Rifle Mk II", name = "bullpuprifle_mk2", hash = "0x84D6FAFD" },
{ label = "Compact Rifle", name = "compactrifle", hash = "0x624FE830" },
{ label = "Military Rifle", name = "militaryrifle", hash = "0x9D1F17E6" },
{ label = "Heavy Rifle", name = "heavyrifle", hash = "0xC78D71B4" },
{ label = "Tactical Rifle", name = "tacticalrifle", hash = "0xD1D5F52B" },

--LMGs
{ label = "MG", name = "mg", hash = "0x9D07F764" },
{ label = "Combat MG", name = "combatmg", hash = "0x7FD62962" },
{ label = "Combat MG Mk II", name = "combatmg_mk2", hash = "0xDBBD7280" },
{ label = "Gusenberg Sweeper", name = "gusenberg", hash = "0x61012683" },

--Snipers
{ label = "Sniper Rifle", name = "sniperrifle", hash = "0x05FC3C11" },
{ label = "Heavy Sniper", name = "heavysniper", hash = "0x0C472FE2" },
{ label = "Heavy Sniper Mk II", name = "heavysniper_mk2", hash = "0xA914799" },
{ label = "Marksman Rifle", name = "marksmanrifle", hash = "0xC734385A" },
{ label = "Marksman Rifle Mk II", name = "marksmanrifle_mk2", hash = "0x6A6C02E0" },
{ label = "Precision Rifle", name = "precisionrifle", hash = "0x6E7DDDEC" },

--Heavy Weapons
{ label = "RPG", name = "rpg", hash = "0xB1CA77B1" },
{ label = "Grenade Launcher", name = "grenadelauncher", hash = "0xA284510B" },
{ label = "Grenade Launcher Smoke", name = "grenadelauncher_smoke", hash = "0x4DD2DC56" },
{ label = "Minigun", name = "minigun", hash = "0x42BF8A85" },
{ label = "Firework Launcher", name = "firework", hash = "0x7F7497E5" },
{ label = "Railgun", name = "railgun", hash = "0x6D544C99" },
{ label = "Homing Launcher", name = "hominglauncher", hash = "0x63AB0442" },
{ label = "Compact Grenade Launcher", name = "compactlauncher", hash = "0x0781FE4A" },
{ label = "Widowmaker", name = "rayminigun", hash = "0xB62D1F67" },
{ label = "Compact EMP Launcher", name = "emplauncher", hash = "0xDB26713A" },

--Throwables
{ label = "Grenade", name = "grenade", hash = "0x93E220BD" },
{ label = "BZ Gas", name = "bzgas", hash = "0xA0973D5E" },
{ label = "Molotov Cocktail", name = "molotov", hash = "0x24B17070" },
{ label = "Sticky Bomb", name = "stickybomb", hash = "0x2C3731D9" },
{ label = "Proximity Mines", name = "proxmine", hash = "0xAB564B93" },
{ label = "Snowballs", name = "snowball", hash = "0x787F0BB" },
{ label = "Pipe Bombs", name = "pipebomb", hash = "0xBA45E8B8" },
{ label = "Baseball", name = "ball", hash = "0x23C9F95C" },
{ label = "Tear Gas", name = "smokegrenade", hash = "0xFDBC8A50" },
{ label = "Flare", name = "flare", hash = "0x497FACC3" },

--Miscellaneous
{ label = "Jerry Can", name = "petrolcan", hash = "0x34A67B97" },
{ label = "Parachute", name = "parachute", hash = "0xFBAB5776" },
{ label = "Fire Extinguisher", name = "fireextinguisher", hash = "0x060EC506" },
{ label = "Hazardous Jerry Can", name = "hazardcan", hash = "0xBA536372" },
{ label = "Fertilizer Can", name = "fertilizercan", hash = "0x184140A1" },
}


local function getWeaponNameFromHash(hash)
   for _, weapon in ipairs(weapons) do
      if hash == GetHashKey('weapon_' .. weapon.name) then
         return weapon.name
      end
   end
   return ""
end

local function getWeaponNameFromLabel(hash)
   for _, weapon in ipairs(weapons) do
      if hash == GetHashKey('weapon_' .. weapon.name) then
         return weapon.label
      end
   end
   return ""
end

Citizen.CreateThread(function()
   local lastAmmo = nil
   local lastMaxAmmo = nil
   local displayAmmo = false
   while true do
       Citizen.Wait(200)
       local playerPed = PlayerPedId()
       local _, weaponHash = GetCurrentPedWeapon(playerPed)
       local currentWeaponName = getWeaponNameFromHash(weaponHash) -- Update this to your function for getting weapon name from hash
       local currentWeaponLabel = getWeaponNameFromLabel(weaponHash) -- Update this to your function for getting weapon label from hash

       if IsPedArmed(playerPed, 7) then
           SendNUIMessage({
               action = 'GET_WEAPON',
               name = currentWeaponLabel,
               img = currentWeaponName,
               stats = true
           })
           local _, ammoClip = GetAmmoInClip(playerPed, weaponHash)
           local ammoTotal = GetAmmoInPedWeapon(playerPed, weaponHash)
           local ammoRemaining = ammoTotal - ammoClip
           if not displayAmmo then
               displayAmmo = true
           end
           if IsControlPressed(0, 24) or lastAmmo ~= ammoClip or lastMaxAmmo ~= ammoTotal then
               SendNUIMessage({
                   action = 'GET_AMMO',
                   ammo = ammoClip .. '/' .. ammoRemaining,
               })
               lastAmmo = ammoClip
               lastMaxAmmo = ammoTotal
               Citizen.Wait(100)
           end
       else
           SendNUIMessage({
               action = 'GET_WEAPON',
               name = currentWeaponName,
               img = currentWeaponName,
               stats = false
           })
           displayAmmo = false
       end
   end
end)





RegisterCommand(Config.Hud, function()
SendNUIMessage({ action = 'MENU' })
SetDisplay(true, true)
end)

local display = false

function SetDisplay(bool)
   display = bool
   SetNuiFocus(bool, bool)
end

RegisterNUICallback(
"exit",
function(data)
   SetDisplay(false)
end
)


local LastSpeed, LastRpm, LastEngine, LastSignal, LastLight
local LastFuel = 0
Citizen.CreateThread(function()
while true do
   Citizen.Wait(50)
   local ped = PlayerPedId()
   local vehicle = GetVehiclePedIsIn(ped, false)
   if IsPedInVehicle(ped, vehicle, true) and not pauseActive then
      local engineHealth = GetVehicleEngineHealth(vehicle)
      local vehicleHealth = GetEntityHealth(vehicle)
      local LightVal, LightLights, LightHighlights = GetVehicleLightsState(vehicle)
      local Light = (LightLights == 1 or LightHighlights == 1)
      local Speed, Rpm, Fuel, Engine, Signal = GetEntitySpeed(vehicle), GetVehicleCurrentRpm(vehicle), getFuelLevel(vehicle), GetIsVehicleEngineRunning(vehicle), GetVehicleIndicatorLights(vehicle)

      if engineHealth <= 400 or vehicleHealth <= 700 then
         SetVehicleEngineTorqueMultiplier(vehicle, engineHealth <= 300 and 0.09 or 0.4)
         SetVehicleIndicatorLights(vehicle, 0, true)
         SetVehicleIndicatorLights(vehicle, 1, true)

         if engineHealth <= 300 or vehicleHealth <= 700 then
            SetVehicleEngineHealth(vehicle, 150.0)
            SetVehicleBodyHealth(vehicle, 0.0)
            SetVehicleUndriveable(vehicle, true)
            SetVehicleDoorOpen(vehicle, 4, 0, 0)
         end
      end
      SendNUIMessage({
         action = 'SETCARHUD',
         variable = true
      })
      local Speed = GetEntitySpeed(vehicle)
      if LastSpeed ~= Speed or LastRpm ~= Rpm or LastFuel ~= Fuel or LastEngine ~= Engine or LastSignal ~= Signal or LastLight ~= Light then
         SendNUIMessage({
            action = 'CARHUD',
            speed = math.floor(Speed * speedMultiplier),
            rpm = math.ceil(GetVehicleCurrentRpm(vehicle) * 78),
            fuel = math.floor(Config.GetVehFuel(vehicle)) * 1.7,
            engine = engineHealth,
            state = Light,
            seatbelt = getSeatbeltStatus(),
            gear = GetVehicleCurrentGear(vehicle),
            type = Config.DefaultSpeedUnit
         })
         LastSpeed, LastRpm, LastFuel, LastEngine, LastSignal, LastLight = Speed, Rpm, Fuel, Engine, Signal, Light
      end
   else
      SendNUIMessage({ action = 'SETCARHUD', variable = false })
      Citizen.Wait(500)
   end
end
end)


local lastFuelUpdate = 0
function getFuelLevel(vehicle)
    local updateTick = GetGameTimer()
    if (updateTick - lastFuelUpdate) > 2000 then
        lastFuelUpdate = updateTick
        LastFuel = math.floor(Config.GetVehFuel(vehicle))
    end
    return LastFuel
end

Citizen.CreateThread(function()
while true do
   Citizen.Wait(1)
   HideHudComponentThisFrame(6) -- VEHICLE_NAME
   HideHudComponentThisFrame(7) -- AREA_NAME
   HideHudComponentThisFrame(8) -- VEHICLE_CLASS
   HideHudComponentThisFrame(9) -- STREET_NAME
   HideHudComponentThisFrame(3) -- CASH
   HideHudComponentThisFrame(4) -- MP_CASH
   DisplayAmmoThisFrame(false)
end
end)

RegisterNetEvent("QBCore:Player:SetPlayerData")
AddEventHandler("QBCore:Player:SetPlayerData", function(data)
   SendNUIMessage({ action = 'ECONOMY', cash = data.money.cash, bank = data.money.bank, black = data.money.crypto })
end)

RegisterNetEvent("QBCore:Client:OnJobUpdate")
AddEventHandler("QBCore:Client:OnJobUpdate", function(data)
SendNUIMessage({action = 'GET_JOB',job = data.grade.name, grade = data.label})
end)


Citizen.CreateThread(function()
   while true do
       Citizen.Wait(1000)
       local playerPed = PlayerPedId()
       local playerData = getPlayerData()
       local armorData = Config.Framework == "ESX" or Config.Framework == "NewESX" and GetPedArmour(playerPed) or math.ceil(playerData.metadata["armor"])
       SendNUIMessage({ action = 'ARMOR', armor = armorData })
       Citizen.Wait(2500)
   end
end)



local seatbeltOn = false
local speedBuffer = {nil, nil}
local velBuffer = {nil, nil}

function Fwv(entity)
   local hr = GetEntityHeading(entity) + 90.0
   if hr < 0.0 then hr = 360.0 + hr end
   hr = hr * 0.0174533
   return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end

RegisterKeyMapping('seatbelt', 'Toggle Seatbelt', 'keyboard', Config.SeatbeltControl)

RegisterCommand('seatbelt', function()
   local playerPed = PlayerPedId()
   if IsPedInAnyVehicle(playerPed, false) then
      local class = GetVehicleClass(GetVehiclePedIsUsing(playerPed))
      if class ~= 8 and class ~= 13 and class ~= 14 then
         if seatbeltOn then
            -- If you want, you can put a notification belt removed information:
         else
            -- If you want, you can put a notification belt buckled information:
         end
         seatbeltOn = not seatbeltOn
      end
   end
end, false)

Citizen.CreateThread(function()
   while true do
      local playerPed = PlayerPedId()
      local Veh = GetVehiclePedIsIn(playerPed, false)
      local isCarHud = true -- Replace as per your context.

      if isCarHud then
         if seatbeltOn then DisableControlAction(0, 75) end
         speedBuffer[2] = speedBuffer[1]
         speedBuffer[1] = GetEntitySpeed(Veh)

         velBuffer[2] = velBuffer[1]
         velBuffer[1] = GetEntityVelocity(Veh)

         if speedBuffer[2] and GetEntitySpeedVector(Veh, true).y > 1.0  and speedBuffer[1] > 15 and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.255) then
            if not seatbeltOn then
               local co = GetEntityCoords(playerPed)
               local fw = Fwv(playerPed)
               SetEntityCoords(playerPed, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
               SetEntityVelocity(playerPed, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
               Wait(500)
               SetPedToRagdoll(playerPed, 1000, 1000, 0, 0, 0, 0)
               seatbeltOn = false
            end
         end
      else
         Wait(3000)
      end
      Wait(0)
   end
end)



function getSeatbeltStatus()
      return seatbeltOn
end


Citizen.CreateThread(function()
while true do
   Citizen.Wait(650)
   if IsPauseMenuActive() and not pauseActive then
      pauseActive = true
      SendNUIMessage({
         action = 'EXIT',
         args = false
      })
   end
   if not IsPauseMenuActive() and pauseActive then
      pauseActive = false
      SendNUIMessage({
         action = 'EXIT',
         args = true
      })
   end
end
end)

Citizen.CreateThread(function()
while true do
   Citizen.Wait(150)
   local microphoneColor = NetworkIsPlayerTalking(PlayerId()) and "purple" or "#FFFFFF"
   SendNUIMessage({
      action = "MICROPHONE",
      variable = microphoneColor
   })
   SendNUIMessage({
      action = 'PLAYERS',
      players = "ID:" .. GetPlayerServerId(PlayerId())
   })
end
end)




if Config.Framework == "ESX" or Config.Framework == "NewESX" then
   Citizen.CreateThread(function()
      Framework = GetFramework()
        Framework.PlayerData = getPlayerData()
      end)

      Citizen.CreateThread(function()
        Framework.PlayerData = getPlayerData()
        while Framework.GetPlayerData().job == nil do
            Citizen.Wait(0)
            Framework.PlayerData = getPlayerData()
        end
      end)

   RegisterNetEvent('esx:setAccountMoney', function(account)
      Callback('Player', function(cash, bank, black)
         SendNUIMessage({
            action = 'ECONOMY',
            cash = cash,
            bank = bank,
            black = black
         })
      end)
   end)


    RegisterNetEvent('esx:setJob')
    AddEventHandler('esx:setJob', function(job)
      Framework.PlayerData.job = job
      SendNUIMessage({
         action = "GET_JOB",
         job = Framework.PlayerData.job.label,
         grade = Framework.PlayerData.job.grade_name})
    end)

   Framework.PlayerData = Framework.GetPlayerData()
   RegisterNetEvent('HudPlayerLoad')
   AddEventHandler('HudPlayerLoad', function(source)
   Citizen.Wait(2000)


   Callback('Player', function(cash, bank, black)
   SendNUIMessage({
      action = 'ECONOMY',
      cash = cash,
      bank = bank,
      black = black
   })
   end)

   AddEventHandler('esx_status:onTick', function(data)
   local hunger, thirst
   for i = 1, #data do
      if data[i].name == 'thirst' then
         thirst = math.floor(data[i].percent)
      elseif data[i].name == 'hunger' then
         hunger = math.floor(data[i].percent)
      end
   end
   SendNUIMessage({
      action = 'STATUS',
      hunger = hunger,
      thirst = thirst
   })
   end)


   local Player = Framework.GetPlayerData()

   SendNUIMessage({
      action = "GET_JOB",
      job = Framework.PlayerData.job.label,
      grade = Framework.PlayerData.job.grade_name})
   end)



   Citizen.CreateThread(function()
   while true do
      Citizen.Wait(1000)
      local playerPed = PlayerPedId()
      local health = GetEntityHealth(playerPed)

      -- if lastHealth ~= health then
         local val = health-100
         if GetEntityModel(playerPed) == `mp_f_freemode_01` then val = (health+25)-100 end
         SendNUIMessage({
            action = 'HEALTH',
            health = GetEntityHealth(playerPed) - 100
         })
         lastHealth = health
      -- end
   end
   end)

   RegisterNetEvent("esx_status:onTick")
   AddEventHandler("esx_status:onTick", function(data)
   for _,v in pairs(data) do
      if v.name == "hunger" then
         SendNUIMessage({
            action = "HUNGER",
            hunger = v.percent
         })
      elseif v.name == "THİRST" then
         SendNUIMessage({
            action = "thirst",
            thirst = v.percent
         })
      end
   end
   end)

   RegisterNetEvent('esx_status:update')
   AddEventHandler('esx_status:update', function(data)
   for _,v in pairs(data) do
      if v.name == "HUNGER" then
         SendNUIMessage({
            action = "hunger",
            thirst = v.pencent
         })
      elseif v.name == "THİRST" then
         SendNUIMessage({
            action = "thirst",
            thirst = v.pencent
         })
      end
   end
   end)





elseif Config.Framework == 'QBCore' or Config.Framework == 'OLDQBCore' then

   RegisterNetEvent('HudPlayerLoad')
   AddEventHandler('HudPlayerLoad', function(source)
   Citizen.Wait(2000)

   local Player = getPlayerData()

   Citizen.CreateThread(function()
   local hunger = math.ceil(Player.metadata["hunger"])
   local thirst = math.ceil(Player.metadata["thirst"])
   SendNUIMessage({
      action = "STATUS",
      hunger = hunger,
      thirst = thirst
   })
   end)

   print(json.encode(Player.job))

   SendNUIMessage({
      action = "GET_JOB",
      job = Player.job.grade.name,
      grade = Player.job.label
   })
   end)

   RegisterNetEvent('hud:client:UpdateNeeds', function(newHunger, newThirst)
      local hunger = math.ceil(newHunger)
      local thirst = math.ceil(newThirst)

      if hunger > 100 then
         hunger = 100
      end

      if thirst > 100 then
         thirst = 100
      end

      SendNUIMessage({
         action = "STATUS",
         hunger = hunger,
         thirst = thirst
      })
   end)


   Callback('Player', function(cash, bank, black)
   Citizen.Wait(2000)
   SendNUIMessage({ action = 'ECONOMY', cash = cash, bank = bank, black = black })
   end)


   RegisterNUICallback("UpStats",function(data, cb) cb({hunger = math.ceil(Framework.Functions.GetPlayerData().metadata["hunger"]), thirst = math.ceil(Framework.Functions.GetPlayerData().metadata["thirst"])}) end)

   Citizen.CreateThread(function()
   while true do
      Citizen.Wait(1000)
      local playerPed = PlayerPedId()
      local health = GetEntityHealth(playerPed)

      if lastHealth ~= health then
         local val = health-100
         if GetEntityModel(playerPed) == `mp_f_freemode_01` then val = (health+25)-100 end
         SendNUIMessage({
            action = 'HEALTH',
            health = GetEntityHealth(playerPed) - 100
         })
         lastHealth = health
      end
   end
   end)

end





Citizen.CreateThread(function()
local wait, LastOxygen
while true do
   local Player = PlayerId()
   local newoxygen = GetPlayerSprintStaminaRemaining(Player)
   if IsPedInAnyVehicle(PlayerPed) then wait = 2100 end
   if LastOxygen ~= newoxygen then
      wait = 125
      if IsEntityInWater(PlayerPed) then
         oxygen = GetPlayerUnderwaterTimeRemaining(Player) * 10
      else
         oxygen = 100 - GetPlayerSprintStaminaRemaining(Player)
      end
      LastOxygen = newoxygen
      SendNUIMessage({
         action = 'GET_STAMINA',
         stamina = math.ceil(oxygen),
      })
   else
      wait = 1850
   end
   Citizen.Wait(wait)
end
end)

--
local particles = {}
local vehicles2 = {}
local particles2 = {}
--


local vehiclePlate = nil

Citizen.CreateThread(function()
while true do
   Citizen.Wait(100)
   local ped = PlayerPedId()
   local vehicle = GetVehiclePedIsIn(ped, false)
   local plate = GetVehicleNumberPlateText(vehicle)
   if vehicle ~= 0 and plate ~= nil and plate == vehiclePlate then
      CurrentNossValue = NitroVeh[plate]
      SendNUIMessage({
         action = 'UPDATE_NOSS',
         noss = math.ceil(CurrentNossValue * 1.7)
      })
   else
      SendNUIMessage({
         action = 'UPDATE_NOSS',
         noss = 0
      })
   end
end
end)

RegisterNetEvent('SetupNitro')
AddEventHandler('SetupNitro', function()
local Vehicle = GetVehicleInDirection()
vehiclePlate = GetVehicleNumberPlateText(Vehicle)
exports['es-argushud']:Question('Nitros', 'Hey dude! Do you still want me to install the nitro that will make this car a monster?')

if exports['es-argushud']:Question('Nitros', 'nitrous Would you like to load the item named into your vehicle? very fast dude ?') == 'Y' then
   exports['es-argushud']:Notification('succes', 'Succes', 'Injected into a 100% pressurized nitro car, be careful!')

   if IsPedSittingInAnyVehicle(PlayerPed) then
      -- Soon
   else
      if Vehicle ~= nil and DoesEntityExist(Vehicle) and IsPedOnFoot(PlayerPed) then
         TaskStartScenarioInPlace(PlayerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
         Citizen.SetTimeout(5500, function()
         ClearPedTasksImmediately(PlayerPed)
         TriggerServerEvent('RemoveNitroItem', GetVehicleNumberPlateText(Vehicle))
         end)
      else
         -- Soon
      end
   end
else
   exports['es-argushud']:Notification('error', 'Error', "I canceled this because you didn't want it, man!")
   return
end
end)


RegisterNetEvent('UpdateData')
AddEventHandler('UpdateData', function(Get)
NitroVeh = Get
end)




function GetVehicleInDirection()
   PlayerPed = PlayerPedId()
   local playerCoords = GetEntityCoords(PlayerPed)
   local inDirection  = GetOffsetFromEntityInWorldCoords(PlayerPed, 0.0, 5.0, 0.0)
   local rayHandle    = StartShapeTestRay(playerCoords, inDirection, 10, PlayerPed, 0)
   local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

   if hit == 1 and GetEntityType(entityHit) == 2 then
      return entityHit
   end

   return nil
end


RegisterKeyMapping('nitros', 'Toggle Nitro', 'keyboard', Config.NitroControl)

local isPressing = false
RegisterCommand('nitros', function()
local playerPed = PlayerPedId()
local vehicle = GetVehiclePedIsIn(playerPed, false)
local plate = GetVehicleNumberPlateText(vehicle)

if vehicle == 0 or NitroVeh[plate] == nil or tonumber(NitroVeh[plate]) <= 0 then
   return
end

isPressing = not isPressing
SetVehicleNitroBoostEnabled(vehicle, isPressing)
SetVehicleLightTrailEnabled(vehicle, isPressing)
SetVehicleNitroPurgeEnabled(vehicle, isPressing)
SetVehicleEnginePowerMultiplier(vehicle, isPressing and 55.0 or 1.0)

if isPressing then
   Citizen.CreateThread(function()
   while isPressing and GetPedInVehicleSeat(vehicle, -1) == playerPed do
      Citizen.Wait(400)
      NitroVeh[plate] = math.max(0, NitroVeh[plate] - Config.RemoveNitroOnpress)
      if tonumber(NitroVeh[plate]) <= 0 then
         isPressing = false
         SetVehicleNitroBoostEnabled(vehicle, false)
         SetVehicleLightTrailEnabled(vehicle, false)
         SetVehicleNitroPurgeEnabled(vehicle, false)
         SetVehicleEnginePowerMultiplier(vehicle, 1.0)
         TriggerServerEvent('UpdateNitro', plate, NitroVeh[plate])
         break
      end
   end
   end)
else
   TriggerServerEvent('UpdateNitro', plate, NitroVeh[plate])
end
end)


function CreateVehicleExhaustBackfire(vehicle, scale)
   local exhaustNames = {
      "exhaust",    "exhaust_2",  "exhaust_3",  "exhaust_4",
      "exhaust_5",  "exhaust_6",  "exhaust_7",  "exhaust_8",
      "exhaust_9",  "exhaust_10", "exhaust_11", "exhaust_12",
      "exhaust_13", "exhaust_14", "exhaust_15", "exhaust_16"
   }

   for _, exhaustName in ipairs(exhaustNames) do
      local boneIndex = GetEntityBoneIndexByName(vehicle, exhaustName)

      if boneIndex ~= -1 then
         local pos = GetWorldPositionOfEntityBone(vehicle, boneIndex)
         local off = GetOffsetFromEntityGivenWorldCoords(vehicle, pos.x, pos.y, pos.z)

         UseParticleFxAssetNextCall('core')
         StartParticleFxNonLoopedOnEntity('veh_backfire', vehicle, off.x, off.y, off.z, 0.0, 0.0, 0.0, scale, false, false, false)
      end
   end
end

function CreateVehiclePurgeSpray(vehicle, xOffset, yOffset, zOffset, xRot, yRot, zRot, scale)
   UseParticleFxAssetNextCall('core')
   return StartParticleFxLoopedOnEntity('ent_sht_steam', vehicle, xOffset, yOffset, zOffset, xRot, yRot, zRot, scale, false, false, false)
end

function CreateVehicleLightTrail(vehicle, bone, scale)
   UseParticleFxAssetNextCall('core')
   local ptfx = StartParticleFxLoopedOnEntityBone('veh_light_red_trail', vehicle, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, bone, scale, false, false, false)
   SetParticleFxLoopedEvolution(ptfx, "speed", 1.0, false)
   return ptfx
end

function StopVehicleLightTrail(ptfx, duration)
   Citizen.CreateThread(function()
   local startTime = GetGameTimer()
   local endTime = GetGameTimer() + duration
   while GetGameTimer() < endTime do
      Citizen.Wait(0)
      local now = GetGameTimer()
      local scale = (endTime - now) / duration
      SetParticleFxLoopedScale(ptfx, scale)
      SetParticleFxLoopedAlpha(ptfx, scale)
   end
   StopParticleFxLooped(ptfx)
   end)
end

function IsVehicleLightTrailEnabled(vehicle)
   return vehicles2[vehicle] == true
end

function SetVehicleLightTrailEnabled(vehicle, enabled)
   if IsVehicleLightTrailEnabled(vehicle) == enabled then
      return
   end

   if enabled then
      local ptfxs = {}

      local leftTrail = CreateVehicleLightTrail(vehicle, GetEntityBoneIndexByName(vehicle, "taillight_l"), 1.0)
      local rightTrail = CreateVehicleLightTrail(vehicle, GetEntityBoneIndexByName(vehicle, "taillight_r"), 1.0)

      table.insert(ptfxs, leftTrail)
      table.insert(ptfxs, rightTrail)

      vehicles2[vehicle] = true
      particles2[vehicle] = ptfxs
   else
      if particles2[vehicle] and #particles2[vehicle] > 0 then
         for _, particleId in ipairs(particles2[vehicle]) do
            StopVehicleLightTrail(particleId, 500)
         end
      end

      vehicles2[vehicle] = nil
      particles2[vehicle] = nil
   end
end
function SetVehicleNitroBoostEnabled(vehicle, enabled)


   if IsPedInVehicle(PlayerPedId(), vehicle) then
      SetNitroBoostScreenEffectsEnabled(enabled)
   end

   SetVehicleBoostActive(vehicle, enabled)
end
function IsVehicleNitroPurgeEnabled(vehicle)
   return NitroVeh[vehicle] == true
end
function SetVehicleNitroPurgeEnabled(vehicle, enabled)
   if IsVehicleNitroPurgeEnabled(vehicle) == enabled then
      return
   end
   if enabled then
      local bone = GetEntityBoneIndexByName(vehicle, 'bonnet')
      local pos = GetWorldPositionOfEntityBone(vehicle, bone)
      local off = GetOffsetFromEntityGivenWorldCoords(vehicle, pos.x, pos.y, pos.z)
      local ptfxs = {}

      for i=0,3 do
         local leftPurge = CreateVehiclePurgeSpray(vehicle, off.x - 0.5, off.y + 0.05, off.z, 40.0, -20.0, 0.0, 0.5)
         local rightPurge = CreateVehiclePurgeSpray(vehicle, off.x + 0.5, off.y + 0.05, off.z, 40.0, 20.0, 0.0, 0.5)

         table.insert(ptfxs, leftPurge)
         table.insert(ptfxs, rightPurge)
      end

      NitroVeh[vehicle] = true
      particles[vehicle] = ptfxs
   else
      if particles[vehicle] and #particles[vehicle] > 0 then
         for _, particleId in ipairs(particles[vehicle]) do
            StopParticleFxLooped(particleId)
         end
      end

      NitroVeh[vehicle] = nil
      particles[vehicle] = nil
   end
end
function SetNitroBoostScreenEffectsEnabled(enabled)
   if enabled then
      StartScreenEffect('RaceTurbo', 0, false)
      SetTimecycleModifier('rply_motionblur')
      ShakeGameplayCam('SKY_DIVING_SHAKE', 0.30)
      TriggerServerEvent("InteractSound_SV:PlayOnSource", "nitro", 0.5)
   else
      StopScreenEffect('RaceTurbo')
      StopGameplayCamShaking(true)
      SetTransitionTimecycleModifier('default', 0.35)
   end
end

RegisterNUICallback("GetMap",function(type)
   if type.map == 'rounded' then
   local defaultAspectRatio = 1920/1080 -- Don't change this.
   local resolutionX, resolutionY = GetActiveScreenResolution()
   local aspectRatio = resolutionX/resolutionY
   local minimapOffset = 0
   if aspectRatio ~= defaultAspectRatio then
      minimapOffset = ((defaultAspectRatio-aspectRatio)/3.6)-0.008
   end

   RequestStreamedTextureDict("squaremap", false)
   while not HasStreamedTextureDictLoaded("squaremap") do
      Wait(150)
   end

   SetMinimapClipType(0)
   AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "squaremap", "radarmasksm")
   AddReplaceTexture("platform:/textures/graphics", "radarmask1g", "squaremap", "radarmasksm")
   SetMinimapComponentPosition("minimap", "L", "B", 0.0 + minimapOffset, -0.047, 0.1638, 0.183)
   SetMinimapComponentPosition("minimap_mask", "L", "B", 0.0 + minimapOffset, 0.0, 0.128, 0.20)
   SetMinimapComponentPosition('minimap_blur', 'L', 'B', 0.012 + minimapOffset, 0.064, 0.257, 0.325)

   SetBlipAlpha(GetNorthRadarBlip(), 0)
   SetRadarBigmapEnabled(true, false)
   SetMinimapClipType(0)
   Wait(0)
   SetRadarBigmapEnabled(false, false)

   else
   local defaultAspectRatio = 1920/1080 -- Don't change this.
   local resolutionX, resolutionY = GetActiveScreenResolution()
   local aspectRatio = resolutionX/resolutionY
   local minimapOffset = 0
   if aspectRatio > defaultAspectRatio then
       minimapOffset = ((defaultAspectRatio-aspectRatio)/3.6)-0.008
   end
   RequestStreamedTextureDict("circlemap", false)
   while not HasStreamedTextureDictLoaded("circlemap") do
       Wait(150)
   end
   SetMinimapClipType(1)
   AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")
   AddReplaceTexture("platform:/textures/graphics", "radarmask1g", "circlemap", "radarmasksm")
   -- -0.0100 = nav symbol and icons left
   -- 0.180 = nav symbol and icons stretched
   -- 0.258 = nav symbol and icons raised up
   SetMinimapComponentPosition("minimap", "L", "B", 0.00999 + minimapOffset, -0.090 - minimapOffset, 0.15, 0.170);
   SetMinimapComponentPosition("minimap_mask", "L", "B", 0.2125 + minimapOffset, -0.050 - minimapOffset, 0.065, 0.20);
   SetMinimapComponentPosition('minimap_blur', 'L', 'B', 0.027 + minimapOffset, -0.025 - minimapOffset, 0.190, 0.290);
   SetBlipAlpha(GetNorthRadarBlip(), 0)
   SetMinimapClipType(1)
   SetRadarBigmapEnabled(true, false)
   Wait(0)
   SetRadarBigmapEnabled(false, false)
   end
end)

Citizen.CreateThread(function()
local minimap = RequestScaleformMovie("minimap")
SetRadarBigmapEnabled(true, false)
Wait(0)
SetRadarBigmapEnabled(false, false)
end)

Citizen.CreateThread(function()
Citizen.Wait(100)
while true do
   local sleepThread = 500
   local radarEnabled = IsRadarEnabled()
   if not IsPedInAnyVehicle(PlayerPedId()) and radarEnabled then
      DisplayRadar(false)
   elseif IsPedInAnyVehicle(PlayerPedId()) and not radarEnabled then
      DisplayRadar(true)
   end
   Citizen.Wait(sleepThread)
end

end)

-- Minimap update
CreateThread(function()
while true do
   SetRadarBigmapEnabled(false, false)
   SetRadarZoom(1000)
   SetBigmapActive(false, false)
   Wait(4)
end
end)
