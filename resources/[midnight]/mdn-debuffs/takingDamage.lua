local weapons = {
	------------------------------------
	-- Melee						  --
	------------------------------------

	{ hash = GetHashKey("WEAPON_UNARMED"), class = 'unarmed'},

	------------------------------------
	-- Blunt						  --
	------------------------------------

	{ hash = GetHashKey("WEAPON_BAT"), class = 'blunt'},
	{ hash = GetHashKey("WEAPON_FLASHLIGHT"), class ='blunt'},
	{ hash = GetHashKey("WEAPON_GOLFCLUB"), class ='blunt'},
	{ hash = GetHashKey("WEAPON_HAMMER"), class ='blunt'},
	{ hash = GetHashKey("WEAPON_NIGHTSTICK"), class ='blunt'},
	{ hash = GetHashKey("WEAPON_WRENCH"), class ='blunt'},
	{ hash = GetHashKey("WEAPON_POOLCUE"), class ='blunt'},

	------------------------------------
	-- Сutting						  --
	------------------------------------

	{ hash = GetHashKey("WEAPON_DAGGER"), class = 'cutting'},
	{ hash = GetHashKey("WEAPON_BOTTLE"), class = 'cutting'},
	{ hash = GetHashKey("WEAPON_CROWBAR"), class = 'cutting'},
	{ hash = GetHashKey("WEAPON_HATCHET"), class = 'cutting'},
	{ hash = GetHashKey("WEAPON_KNUCKLE"), class = 'cutting'},
	{ hash = GetHashKey("WEAPON_KNIFE"), class = 'cutting'},
	{ hash = GetHashKey("WEAPON_MACHETE"), class = 'cutting'},
	{ hash = GetHashKey("WEAPON_SWITCHBLADE"), class = 'cutting'},
	{ hash = GetHashKey("WEAPON_BATTLEAXE"), class = 'cutting'},
	{ hash = GetHashKey("WEAPON_STONE_HATCHET"), class = 'cutting'},
	{ hash = GetHashKey("weapon_shiv"), class = 'cutting'},
	{ hash = GetHashKey("weapon_katana"), class = 'cutting'},
	{ hash = GetHashKey("weapon_bayonetknife"), class = 'cutting'},
	{ hash = GetHashKey("weapon_bluebfknife"), class = 'cutting'},
	{ hash = GetHashKey("weapon_bfknife"), class = 'cutting'},
	{ hash = GetHashKey("weapon_chbfknife"), class = 'cutting'},
	{ hash = GetHashKey("weapon_crimsonbfknife"), class = 'cutting'},
	{ hash = GetHashKey("weapon_fadebfknife"), class = 'cutting'},
	{ hash = GetHashKey("weapon_flipknife"), class = 'cutting'},
	{ hash = GetHashKey("weapon_forestbfknife"), class = 'cutting'},
	{ hash = GetHashKey("weapon_gutknife"), class = 'cutting'},
	{ hash = GetHashKey("weapon_huntsmanknife"), class = 'cutting'},
	{ hash = GetHashKey("weapon_karambitknife"), class = 'cutting'},
	{ hash = GetHashKey("weapon_safaribfknife"), class = 'cutting'},
	{ hash = GetHashKey("weapon_scorchedbfknife"), class = 'cutting'},
	{ hash = GetHashKey("weapon_slaughterbfknife"), class = 'cutting'},
	{ hash = GetHashKey("weapon_stainedrbfknife"), class = 'cutting'},
	{ hash = GetHashKey("weapon_urbanrbfknife"), class = 'cutting'},
	--[[ HEAVY IMPACT ]]
	{ hash = GetHashKey("weapon_sledgehammer"), class = 'blunt'},
	{ hash = GetHashKey("weapon_perforator"), class = 'blunt'},


	------------------------------------
	-- Small						  --
	------------------------------------

	-- (Pistol)
	{ hash = GetHashKey("WEAPON_PISTOL"), class = 'small'},
	{ hash = GetHashKey("WEAPON_PISTOL_MK2"), class = 'small'},
	{ hash = GetHashKey("WEAPON_COMBATPISTOL"), class = 'small'},
	{ hash = GetHashKey("WEAPON_APPISTOL"), class = 'small'},
	{ hash = GetHashKey("WEAPON_PISTOL50"), class = 'small'},
	{ hash = GetHashKey("WEAPON_SNSPISTOL"), class = 'small'},
	{ hash = GetHashKey("WEAPON_SNSPISTOL_MK2"), class = 'small'},
	{ hash = GetHashKey("WEAPON_HEAVYPISTOL"), class = 'small'},
	{ hash = GetHashKey("WEAPON_VINTAGEPISTOL"), class = 'small'},
	{ hash = GetHashKey("WEAPON_MARKSMANPISTOL"), class = 'small'},
	{ hash = GetHashKey("WEAPON_REVOLVER"), class = 'small'},
	{ hash = GetHashKey("WEAPON_REVOLVER_MK2"),class = 'small'},
	{ hash = GetHashKey("WEAPON_DOUBLEACTION"), class = 'small'},
	{ hash = GetHashKey("WEAPON_NAVYREVOLVER"), class = 'small'},
	{ hash = GetHashKey("WEAPON_CERAMICPISTOL"), class = 'small'},
	{ hash = GetHashKey("WEAPON_GADGETPISTOL"), class = 'small'},
	-- (Submachine Guns)
	{ hash = GetHashKey("WEAPON_MICROSMG"), class ='small'},
	{ hash = GetHashKey("WEAPON_SMG"), class ='small'},
	{ hash = GetHashKey("WEAPON_SMG_MK2"), class ='small'},
	{ hash = GetHashKey("WEAPON_ASSAULTSMG"), class ='small'},
	{ hash = GetHashKey("WEAPON_COMBATPDW"), class ='small'},
	{ hash = GetHashKey("WEAPON_MACHINEPISTOL"), class ='small'},
	{ hash = GetHashKey("WEAPON_MINISMG"), class ='small'},

	------------------------------------
	-- Medium						  --
	------------------------------------

	-- Assault Rifles
	{ hash = GetHashKey("WEAPON_ASSAULTRIFLE"), class ='medium'},
	{ hash = GetHashKey("WEAPON_ASSAULTRIFLE_MK2"), class ='medium'},
	{ hash = GetHashKey("WEAPON_CARBINERIFLE"), class ='medium'},
	{ hash = GetHashKey("WEAPON_CARBINERIFLE_MK2"), class ='medium'},
	{ hash = GetHashKey("WEAPON_ADVANCEDRIFLE"), class ='medium'},
	{ hash = GetHashKey("WEAPON_SPECIALCARBINE"), class ='medium'},
	{ hash = GetHashKey("WEAPON_SPECIALCARBINE_MK2"), class ='medium'},
	{ hash = GetHashKey("WEAPON_BULLPUPRIFLE"), class ='medium'},
	{ hash = GetHashKey("WEAPON_BULLPUPRIFLE_MK2"), class ='medium'},
	{ hash = GetHashKey("WEAPON_COMPACTRIFLE"), class ='medium'},
	-- Light Machine Guns
	{ hash = GetHashKey("WEAPON_MG"), class ='medium'},
	{ hash = GetHashKey("WEAPON_COMBATMG"), class ='medium' },
	{ hash = GetHashKey("WEAPON_COMBATMG_MK2"), class ='medium'},
	{ hash = GetHashKey("WEAPON_GUSENBERG"), class ='medium'},

	------------------------------------
	-- Heavy caliber				  --
	------------------------------------

	-- Sniper Rifles
	{ hash = GetHashKey("WEAPON_SNIPERRIFLE"), class = 'heavy'},
	{ hash = GetHashKey("WEAPON_HEAVYSNIPER"), class = 'heavy'},
	{ hash = GetHashKey("WEAPON_HEAVYSNIPER_MK2"), class = 'heavy'},
	{ hash = GetHashKey("WEAPON_MARKSMANRIFLE"), class = 'heavy'},
	{ hash = GetHashKey("WEAPON_MARKSMANRIFLE_MK2"), class = 'heavy'},

	------------------------------------
	-- Shot							  --
	------------------------------------
	-- Shotguns
	{ hash = GetHashKey("WEAPON_PUMPSHOTGUN"), class ='shot'},
	{ hash = GetHashKey("WEAPON_PUMPSHOTGUN_MK2"), class ='shot'},
	{ hash = GetHashKey("WEAPON_SAWNOFFSHOTGUN"), class ='shot'},
	{ hash = GetHashKey("WEAPON_ASSAULTSHOTGUN"), class ='shot'},
	{ hash = GetHashKey("WEAPON_BULLPUPSHOTGUN"), class ='shot'},
	{ hash = GetHashKey("WEAPON_MUSKET"), class ='shot'},
	{ hash = GetHashKey("WEAPON_HEAVYSHOTGUN"), class ='shot'},
	{ hash = GetHashKey("WEAPON_DBSHOTGUN"), class ='shot'},
	{ hash = GetHashKey("WEAPON_AUTOSHOTGUN"), class ='shot'},
	{ hash = GetHashKey("WEAPON_COMBATSHOTGUN"), class ='shot'}
}

--	--	--	-- --	--	--	-- --	--	--	-- --	--	--	--
-- WEAPON DAMAGE
--	--	--	-- --	--	--	-- --	--	--	-- --	--	--	--
local function dmg_unarmed(rand)
	if rand > 95 then
		bone()
	elseif rand > 90 then
		bleeding()
	elseif rand > 75 and not buffs.painkiller then
		pain(2500)
		SetPedToRagdoll(PlayerPedId(), 800, 800, 0, 0, 0, 0)
	elseif rand > 30 and not buffs.painkiller then
		pain(1000)
	end
end

local function dmg_blunt(rand)
	if rand > 90 then
		bone()
	elseif rand > 90 then
		heavybleeding()
	elseif rand > 80 then
		bleeding()
	elseif rand > 20 and not buffs.painkiller then
		pain(1000)
	end
end

local function dmg_cutting(rand)
	if rand > 80 then
		heavybleeding()
	elseif rand > 50 then
		bleeding()
	elseif rand > 10 and not buffs.painkiller then
		pain(1000)
	end
end

local function dmg_small(rand)
	if rand > 90 then
		bone()
		gunshot()
	elseif rand > 80 then
		heavybleeding()
		gunshot()
	elseif rand > 70 then
		bleeding()
	elseif rand > 15 and not buffs.painkiller then
		pain()
	end
end

local function dmg_medium(rand)
	if rand > 90 then
		bone()
		gunshot()
	elseif rand > 75 then
		heavybleeding()
		gunshot()
	elseif rand > 60 then
		bleeding()
	elseif rand > 10 and not buffs.painkiller then
		pain()
	end
end

local function dmg_heavy(rand)
	if rand > 75 then
		bone()
		gunshot()
	elseif rand > 60 then
		heavybleeding()
		gunshot()
	elseif rand > 50 then
		bleeding()
	elseif rand > 10 and not buffs.painkiller then
		pain()
	elseif not buffs.painkiller then
		pain(1000)
	end
end

local function dmg_shot(rand)
	if rand > 85 then
		bone()
		gunshot()
	elseif rand > 75 then
		heavybleeding()
		gunshot()
	elseif rand > 60 then
		bleeding()
	elseif rand > 10 and not buffs.painkiller then
		pain()
	elseif not buffs.painkiller then
		pain(1500)
	end
end

local function BeenDamagedWeapon(ped)
	for k, v in pairs(weapons) do
		if HasEntityBeenDamagedByWeapon(ped, v.hash, 0) then

			local rand = math.random(100);
			-- print('class: ' .. v.class .. ' ^ ' .. rand)

			if v.class == 'unarmed' then
				dmg_unarmed(rand)
			elseif v.class == 'blunt' then
				dmg_blunt(rand)
			elseif v.class == 'cutting' then
				dmg_cutting(rand)
			elseif v.class == 'small' then
				dmg_small(rand)
			elseif v.class == 'medium' then
				dmg_medium(rand)
			elseif v.class == 'heavy' then
				dmg_heavy(rand)
			elseif v.class == 'shot' then
				dmg_shot(rand)
			end

			ClearEntityLastDamageEntity(ped)
			-- ClearEntityLastWeaponDamage(playerPed)
			break
		end
    end
end

--	--	--	--
-- CRASHED
--	--	--	--
local isCrash = false
local oldDamage = 0
local oldSpeed = 0

local function crashFade()
	if not isCrash then
			isCrash = true
			Citizen.CreateThread(function()

			DoScreenFadeOut(100)
			while not IsScreenFadedOut() do
				Citizen.Wait(0)
			end

			Citizen.Wait(2000)
			local rand = math.random(100);

			if rand > 98 then -- 2%
				bone()
				heavybleeding()
				if not buffs.painkiller then pain(20000) end
				ApplyPedDamagePack(GetPlayerPed(-1), "Fall", 100, 100);
			elseif rand > 94 then -- 4 %
				bone()
				bleeding()
				if not buffs.painkiller then pain(17000) end
			elseif rand > 89 then -- 5%
				bone()
				if not buffs.painkiller then pain(15000) end
			elseif rand > 85 then -- 4%
				heavybleeding()
				if not buffs.painkiller then pain(5000) end
			elseif rand > 78 then -- 7%
				bleeding()
				if not buffs.painkiller then pain(3000) end
			elseif rand > 30 and not buffs.painkiller then -- 50%
				pain(3000)
			end

			DoScreenFadeIn(500)
			isCrash = false
		end)
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- TICKS -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50)
		if not buffs.godmode then
			local playerPed = PlayerPedId();
			local vehicle = GetVehiclePedIsIn(playerPed, false)
			if HasEntityBeenDamagedByAnyPed(playerPed) then
				BeenDamagedWeapon(playerPed)
			end
			if DoesEntityExist(vehicle) then
				if true then
					local currentDamage = GetVehicleBodyHealth(vehicle)
					local currentSpeed = GetEntitySpeed(vehicle) * 2.23
					if currentDamage ~= oldDamage  and not isCrash and (currentSpeed < oldSpeed) and (currentDamage < oldDamage) then
						-- print(currentSpeed < oldSpeed)
						-- print(currentDamage < oldDamage)
						if ((oldSpeed - currentSpeed) > 25) and ((oldDamage - currentDamage) > 15) then
							crashFade()
						end
					end
					oldDamage = currentDamage
					oldSpeed = currentSpeed
				end
			else
				oldDamage = 0
				oldSpeed = 0
			end
		end
	end
end)