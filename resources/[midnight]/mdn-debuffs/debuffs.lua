local blStack = 0

buffs = {
	godmode = false,
	painkiller = false,

	luck = false
}

debuffs = {
	pain = false,
	alcohol = false,
	bleeding = false,
	heavybleeding = false,
	bone = false,
	hot = false,
	cold = false,
	hangry = false,
	thirst = false
}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--	DEBUFFS
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
local constantPain = false
-- pain
function pain(ms)
	if not debuffs.pain and not buffs.godmode then
		debuffs.pain = true;
		if not ms then constantPain = true end
		SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
		ShakeGameplayCam('FAMILY5_DRUG_TRIP_SHAKE', 0.4);
		AnimpostfxPlay('Dont_tazeme_bro', 0, true)

		UpdateHUD("debuff_pain", debuffs.pain, ms)
	end
end
function painStop()
	if debuffs.pain then
		if buffs.godmode or buffs.painkiller or not debuffs.bleeding and not debuffs.heavybleeding and not debuffs.bone and not debuffs.gunshot then
			debuffs.pain = false;
			UpdateHUD("debuff_pain", debuffs.pain)

			if not debuffs.cold then
				SetPlayerHealthRechargeMultiplier(PlayerId(), 1.0)
			end
			if not debuffs.alcohol then
				ResetPedMovementClipset(PlayerPedId())
			end

			ShakeGameplayCam('FAMILY5_DRUG_TRIP_SHAKE', 0);
			AnimpostfxStop('Dont_tazeme_bro', 0, true)
			--AnimpostfxPlay('MP_Celeb_Lose_Out', 0, false)
		end
	end
end
function painClear()
	if debuffs.pain then
		if (buffs.painkiller or not debuffs.bleeding and not debuffs.heavybleeding) and not debuffs.bone and not debuffs.gunshot then
			constantPain = false
			Citizen.Wait(5000)
			painStop()
		end
	end
end

-- alcohol
function alcohol(ms)
	if not debuffs.alcohol and not buffs.godmode then
		debuffs.alcohol = true;
		local ped = PlayerPedId()

		SetPedToRagdoll(ped, 2500, 2500, 0, 0, 0, 0)
		DoScreenFadeOut(300)
		Citizen.Wait(600)

		SetTimecycleModifier("spectator5")
		SetPedAccuracy(ped, 0)
		SetPedIsDrunk(ped, true)
		SetPedMotionBlur(ped, true)

		Citizen.Wait(600)
		DoScreenFadeIn(300)
		UpdateHUD("debuff_alcohol", debuffs.alcohol, ms)
	end
end
function alcoholStop()
	if debuffs.alcohol then
		DoScreenFadeOut(500)
		Citizen.Wait(500)

		ClearTimecycleModifier()
		ResetPedMovementClipset(ped, 0)
		SetPedIsDrunk(ped, false)
		SetPedMotionBlur(ped, false)

		DoScreenFadeIn(400)
		debuffs.alcohol = false;
		UpdateHUD("debuff_alcohol", debuffs.alcohol)
	end
end

-- bleeding
function bleeding(ms)
	if not debuffs.bleeding and not debuffs.heavybleeding and not buffs.godmode then
		debuffs.bleeding = true;
		LocalPlayer.state:set('bleeding', true, true)
		UpdateHUD("debuff_bleeding", debuffs.bleeding, ms)
	end
end
function bleedingStop()
	if debuffs.bleeding then
		debuffs.bleeding = false;
		LocalPlayer.state:set('bleeding', false, true)
		UpdateHUD("debuff_bleeding", debuffs.bleeding)
		if not debuffs.heavybleeding then
			painClear()
		end
	end
end

-- heavybleeding
function heavybleeding(ms)
	if not debuffs.heavybleeding and not buffs.godmode then
		debuffs.heavybleeding = true;
		LocalPlayer.state:set('heavybleeding', true, true)
		if debuffs.bleeding then
			bleedingStop()
		end
		UpdateHUD("debuff_heavybleeding", debuffs.heavybleeding, ms)
	end
end
function heavybleedingStop()
	if debuffs.heavybleeding then
		debuffs.heavybleeding = false;
		LocalPlayer.state:set('heavybleeding', false, true)
		UpdateHUD("debuff_heavybleeding", debuffs.heavybleeding)
		painClear()
	end
end

-- bone fractures
function bone(ms)
	if not debuffs.bone and not buffs.godmode then
		debuffs.bone = true;
		UpdateHUD("debuff_bone", debuffs.bone, ms)

		if not debuffs.bleeding and not debuffs.heavybleeding then
			if math.random(2) == 1 then
				bleeding()
			else
				heavybleeding()
			end
		end
	end
end
function boneStop()
	debuffs.bone = false;
	UpdateHUD("debuff_bone", debuffs.bone)
	painClear()
end

-- bone fractures
function gunshot(ms)
	if not debuffs.gunshot and not buffs.godmode then
		debuffs.gunshot = true;
		UpdateHUD("debuff_gunshot", debuffs.gunshot, ms)

		if not debuffs.bleeding and not debuffs.heavybleeding then
			if math.random(2) == 1 then
				bleeding()
			else
				heavybleeding()
			end
		end
	end
end
function gunshotStop()
	debuffs.gunshot = false;
	UpdateHUD("debuff_gunshot", debuffs.gunshot)
end

-- bone fractures
function burnt(ms)
	if not debuffs.burnt and not buffs.godmode then
		debuffs.burnt = true;
		UpdateHUD("debuff_burnt", debuffs.burnt, ms)

		--if not debuffs.pain then pain(60000) end
	end
end
function burntStop()
	debuffs.burnt = false;
	UpdateHUD("debuff_burnt", debuffs.burnt)
	painClear()
end

-- HOT
function hot(ms)
	if not debuffs.hot and not buffs.godmode then
		if debuffs.cold then
			coldStop()
		end
		debuffs.hot = true;
		UpdateHUD("debuff_hot", debuffs.hot, ms)
	end
end
function hotStop()
	if debuffs.hot then
		debuffs.hot = false;
		UpdateHUD("debuff_hot", debuffs.hot, ms)
	end
end

-- Cold
function cold(ms)
	if not debuffs.cold and not buffs.godmode then
		if debuffs.hot then
			hotStop()
		end
		debuffs.cold = true;
		SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
		UpdateHUD("debuff_cold", debuffs.cold, ms)
	end
end
function coldStop()
	if debuffs.cold then
		debuffs.cold = false;
		UpdateHUD("debuff_cold", debuffs.cold, ms)

		if not debuffs.bleeding and not debuffs.heavybleeding then
			SetPlayerHealthRechargeMultiplier(PlayerId(), 1.0)
		end
	end
end

-- hangry
function hangry(ms)
	if not debuffs.hangry and not buffs.godmode then
		debuffs.hangry = true;
		UpdateHUD("debuff_hangry", debuffs.hangry, ms)
	end
end
function hangryStop()
	if debuffs.hangry then
		debuffs.hangry = false;
		UpdateHUD("debuff_hangry", debuffs.hangry)
	end
end

-- thirst
function thirst(ms)
	if not debuffs.thirst and not buffs.godmode then
		debuffs.thirst = true;
		UpdateHUD("debuff_thirst", debuffs.thirst, ms)
	end
end
function thirstStop()
	if debuffs.thirst then
		debuffs.thirst = false;
		UpdateHUD("debuff_thirst", debuffs.thirst)
	end
end


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--	BUFFS
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- godmode
function godmode(ms)
	if not buffs.godmode then
		buffs.godmode = true;
		UpdateHUD("buff_godmode", buffs.godmode, ms)
		stopAllEffects()
	end
end
function godmodeStop()
	if buffs.godmode then
		buffs.godmode = false;
		UpdateHUD("buff_godmode", buffs.godmode)
	end
end

-- painKiller
function painkiller(ms)
	if not buffs.painkiller then
		buffs.painkiller = true;
		PlayAnim(GetPlayerPed(-1), "mp_player_int_uppersmoke", "mp_player_int_smoke_enter", 48)

		local timeout = tonumber(ms) or 30000

		Citizen.Wait(3000)
		painStop()
		UpdateHUD("buff_painkiller", buffs.painkiller, timeout)
		if constantPain then Wait(timeout) pain() end
	end
end
function painkillerStop()
	if buffs.painkiller then
		buffs.painkiller = false;
		UpdateHUD("buff_painkiller", buffs.painkiller)
		if constantPain then pain() end
	end
end


-- luck
function luck(ms)
	if not buffs.luck then
		buffs.luck = true;
		-- LocalPlayer.state:set('foodBuff', 'luck', true)
		--PlayAnim(GetPlayerPed(-1), "mp_player_int_uppersmoke", "mp_player_int_smoke_enter", 48)

		local timeout = tonumber(ms) or 300000
		UpdateHUD("buff_luck", buffs.luck, timeout)
	end
end
function luckStop()
	if buffs.luck then
		buffs.luck = false;
		UpdateHUD("buff_luck", buffs.luck)
		LocalPlayer.state:set('foodBuff', nil, true)
	end
end

-- greasy
function greasy(ms)
	if not buffs.luck then
		buffs.greasy = true;
		--PlayAnim(GetPlayerPed(-1), "mp_player_int_uppersmoke", "mp_player_int_smoke_enter", 48)

		local timeout = tonumber(ms) or 300000
		UpdateHUD("buff_greasy", buffs.greasy, timeout)
	end
end
function greasyStop()
	if buffs.greasy then
		buffs.greasy = false;
		UpdateHUD("buff_greasy", buffs.greasy)
		LocalPlayer.state:set('foodBuff', nil, true)
		LocalPlayer.state:set('greasyUncuffed', nil, true)
	end
end


-- sneaky
function sneaky(ms)
	if not buffs.sneaky then
		buffs.sneaky = true;
		local timeout = tonumber(ms) or 300000
		UpdateHUD("buff_sneaky", buffs.sneaky, timeout)
	end
end
function sneakyStop()
	if buffs.sneaky then
		buffs.sneaky = false;
		UpdateHUD("buff_sneaky", buffs.sneaky)
		LocalPlayer.state:set('foodBuff', nil, true)
	end
end


-- easyhack
function easyhack(ms)
	if not buffs.easyhack then
		buffs.easyhack = true;
		local timeout = tonumber(ms) or 300000
		UpdateHUD("buff_easyhack", buffs.easyhack, timeout)
	end
end
function easyhackStop()
	if buffs.easyhack then
		buffs.easyhack = false;
		UpdateHUD("buff_easyhack", buffs.easyhack)
		LocalPlayer.state:set('foodBuff', nil, true)
	end
end

-- fasthands
function fasthands(ms)
	if not buffs.fasthands then
		buffs.fasthands = true;
		local timeout = tonumber(ms) or 300000
		UpdateHUD("buff_fasthands", buffs.fasthands, timeout)
	end
end
function fasthandsStop()
	if buffs.fasthands then
		buffs.fasthands = false;
		UpdateHUD("buff_fasthands", buffs.fasthands)
		LocalPlayer.state:set('foodBuff', nil, true)
		TriggerEvent("progressbar:client:toggleFaster", false)
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- TICKS -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		local playerPed = PlayerPedId();

		-- GOD FOR TEST ---------------------------------------------------------------------------------
		-- SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
		-------------------------------------------------------------------------------------------------

		if not IsEntityDead(playerPed) then
			if debuffs.bleeding or debuffs.heavybleeding then
				constantPain = true
				if not debuffs.pain and not buffs.painkiller then
					pain()
				end
			end
			if debuffs.bone then
				constantPain = true
				if not debuffs.pain then
					pain()
				end
				DisableControlAction(0,21,true) -- disable sprint
				DisableControlAction(0,22,true) -- disable SPACEBAR

				-- if IsPedInAnyVehicle(playerPed, false) then
				-- 	DisableControlAction(0,71,true) -- disable SPACEBAR
				-- 	DisableControlAction(0,72,true)
				-- end
			end
			if debuffs.gunshot and not debuffs.bleeding and not debuffs.heavybleeding then
				if not debuffs.pain and not buffs.painkiller then pain() end
				if not debuffs.bleeding and math.random(5000) <= 10 then bleeding() end
			end

			if debuffs.burnt and not buffs.painkiller then
				if not debuffs.pain and math.random(5000) <= 10 then SetEntityHealth(playerPed,  GetEntityHealth(playerPed) - 2) pain(5000) end
			end


			-- Walking Sets
			if debuffs.pain then
				setWalking(playerPed, "move_m@injured")
			elseif debuffs.alcohol then
				setWalking(playerPed, "MOVE_M@DRUNK@SLIGHTLYDRUNK")
				--SetPedMovementClipset(ped, "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
			end
			if not debuffs.bleeding and not debuffs.heavybleeding and not debuffs.bone and not debuffs.gunshot then constantPain = false end
		end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
		local playerPed = PlayerPedId();

		if IsEntityOnFire(playerPed) then
			if not debuffs.burnt and math.random(10) == 1 then
				burnt()
			end
		end

		if not IsEntityDead(playerPed) then
			-- bleeding, bone
			if debuffs.bleeding then
				blStack = blStack + 1
				SetDecal(1010, GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 0.0, -1.0), 0.5)
				if blStack >= 6 then SetEntityHealth(playerPed,  GetEntityHealth(playerPed) - 1) blStack = 0 end
			elseif debuffs.heavybleeding then
				blStack = blStack + 1
				SetDecal(1010, GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 0.0, -1.0), 1.0)
				if blStack >= 3 then SetEntityHealth(playerPed,  GetEntityHealth(playerPed) - 1) blStack = 0 end
			else
				blStack = 0
			end
			-- Cold, Hot
			if debuffs.hot then
				-- example
				-- needs water - TriggerEvent('needs', "water", -10)
			elseif debuffs.cold  then
				SetEntityHealth(playerPed,  GetEntityHealth(playerPed) - 1)
			end
			-- Thirst
			if debuffs.thirst then
				SetEntityHealth(playerPed,  GetEntityHealth(playerPed) - 1)
			end
			-- Hangry
			if debuffs.hangry then
				SetEntityHealth(playerPed,  GetEntityHealth(playerPed) - 1)
			end
		end
    end
end)