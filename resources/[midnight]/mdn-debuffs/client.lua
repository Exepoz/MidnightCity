--[[
	Boosty (more scripts): https://boosty.to/sergeylucky
	Discrod: https://discord.gg/zb7DDq6B7j

	Use for activation from third-party resources

		TriggerEvent('debuffs:startEffect', "buff_pain", timeout)
		TriggerEvent('debuffs:stopEffect', "buff_pain")
--]]

local function fetchAll()
	return debuffs, buffs
end exports('fetchAll', fetchAll)

function UpdateHUD(action, value, timeout)
	SendNUIMessage({
		action = action,
		value = value,
		timeout = timeout
	})
end

RegisterNetEvent("debuffs:healAllEffects")
AddEventHandler("debuffs:healAllEffects", function()
	if debuffs.bone then
		boneStop()
	end
	if debuffs.heavybleeding then
		heavybleedingStop()
	end
	if debuffs.bleeding then
		bleedingStop()
	end
	if debuffs.pain then
		painStop()
	end
	if debuffs.gunshot then
		gunshotStop()
	end
	if debuffs.burnt then
		burntStop()
	end
	painkiller(300000)
	ShakeGameplayCam('FAMILY5_DRUG_TRIP_SHAKE', 0);
	AnimpostfxStop('Dont_tazeme_bro', 0, true)
end)

function stopAllEffects()
	if debuffs.bone then
		boneStop()
	end
	if debuffs.heavybleeding then
		heavybleedingStop()
	end
	if debuffs.bleeding then
		bleedingStop()
	end
	if debuffs.pain then
		painStop()
	end
	if debuffs.gunshot then
		gunshotStop()
	end
	if debuffs.burnt then
		burntStop()
	end
	if debuffs.alcohol then
		alcoholStop()
	end
	if debuffs.hot then
		hotStop()
	end
	if debuffs.cold then
		coldStop()
	end
	if debuffs.hangry then
		hangryStop()
	end
	if debuffs.thirst then
		thirstStop()
	end
	if buffs.luck then
		luckStop()
	end
	if buffs.greasy then
		greasyStop()
	end
	if buffs.sneaky then
		sneakyStop()
	end
	if buffs.easyhack then
		easyhackStop()
	end
	if buffs.fasthands then
		fasthandsStop()
	end
	-- 	painkillerStop()
	ShakeGameplayCam('FAMILY5_DRUG_TRIP_SHAKE', 0);
	AnimpostfxStop('Dont_tazeme_bro', 0, true)
end

RegisterNetEvent("debuffs:startEffect")
AddEventHandler("debuffs:startEffect", function(effect, timeout)
	if effect == "buff_painkiller" then
		painkiller(timeout)
	elseif effect == "debuff_pain" then
		pain(timeout)
	elseif effect == "debuff_alcohol" then
		alcohol(timeout)
	elseif effect == "debuff_bleeding" then
		bleeding(timeout)
	elseif effect == "debuff_heavybleeding" then
		heavybleeding(timeout)
	elseif effect == "debuff_bone" then
		bone(timeout)
	elseif effect == "debuff_gunshot" then
		gunshot(timeout)
	elseif effect == "debuff_burnt" then
		burnt(timeout)
	elseif effect == "debuff_hot" then
		hot(timeout)
	elseif effect == "debuff_cold" then
		cold(timeout)
	elseif effect == "debuff_hangry" then
		hangry(timeout)
	elseif effect == "debuff_thirst" then
		thirst(timeout)
	elseif effect == "buff_godmode" then
		godmode()
	elseif effect == "buff_luck" then
		luck()
	elseif effect == "buff_greasy" then
		greasy()
	elseif effect == "buff_sneaky" then
		sneaky()
	elseif effect == "buff_easyhack" then
		easyhack()
	elseif effect == "buff_fasthands" then
		fasthands()
	end
end)

RegisterNetEvent("debuffs:stopEffect")
AddEventHandler("debuffs:stopEffect", function(effect, timeout)
	if effect == "buff_painkiller" then
		painkillerStop()
	elseif effect == "debuff_pain" then
		painStop()
	elseif effect == "debuff_alcohol" then
		alcoholStop()
	elseif effect == "debuff_bleeding" then
		bleedingStop()
	elseif effect == "debuff_heavybleeding" then
		heavybleedingStop()
	elseif effect == "debuff_bone" then
		boneStop()
	elseif effect == "debuff_gunshot" then
		gunshotStop()
	elseif effect == "debuff_burnt" then
		burntStop()
	elseif effect == "debuff_hot" then
		hotStop()
	elseif effect == "debuff_cold" then
		coldStop()
	elseif effect == "debuff_hangry" then
		hangryStop()
	elseif effect == "debuff_thirst" then
		thirstStop()
	elseif effect == "buff_godmode" then
		godmodeStop()
	elseif effect == "buff_luck" then
		luckStop()
	elseif effect == "buff_greasy" then
		greasyStop()
	elseif effect == "buff_sneaky" then
		sneakyStop()
	elseif effect == "buff_easyhack" then
		easyhackStop()
	elseif effect == "buff_fasthands" then
		fasthandsStop()
	end
end)

RegisterNUICallback('cb:stopEffect', function(data)
	if data.effect == "buff_painkiller" then
		painkillerStop()
	elseif data.effect == "debuff_pain" then
		painStop()
	elseif data.effect == "debuff_alcohol" then
		alcoholStop()
	elseif data.effect == "debuff_bleeding" then
		bleedingStop()
	elseif data.effect == "debuff_heavybleeding" then
		heavybleedingStop()
	elseif data.effect == "debuff_bone" then
		boneStop()
	elseif data.effect == "debuff_gunshot" then
		gunshotStop()
	elseif data.effect == "debuff_burnt" then
		burntStop()
	elseif data.effect == "debuff_hot" then
		hotStop()
	elseif data.effect == "debuff_cold" then
		coldStop()
	elseif data.effect == "debuff_hangry" then
		hangryStop()
	elseif data.effect == "debuff_thirst" then
		thirstStop()
	elseif data.effect == "buff_godmode" then
		godmodeStop()
	elseif data.effect == "buff_luck" then
		luckStop()
	elseif data.effect == "buff_greasy" then
		greasyStop()
	elseif data.effect == "buff_sneaky" then
		sneakyStop()
	elseif data.effect == "buff_easyhack" then
		easyhackStop()
	elseif data.effect == "buff_fasthands" then
		fasthandsStop()
	end
end)

-- ANIMATION
function PlayAnim(ped, animDict, animName, flag)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(100)
	end
	TaskPlayAnim(ped, animDict, animName, 1.0, -1.0, -1, flag, 0.0, false, false, false)
end

-- Walk style
function setWalking(ped, anim)
	RequestAnimSet(anim)
	while not HasAnimSetLoaded(anim) do
		Citizen.Wait(0)
	end
	SetPedMovementClipset(ped, anim, true)
end

-- ADD Decals
function SetDecal(decalType, targetedCoord, opacity)
	decal = AddDecal(decalType, targetedCoord.x, targetedCoord.y, targetedCoord.z, 0.0, 0.0, -1.0, func_p5(0.0, 1.0, 0.0),
		1.0, 1.0, --[[ width, height ]]
		0.196, 0.0, 0.0,    --[[ rgb ]]
		opacity, -1.0, --[[ opacity, timeout ]]
		0, 0, 0)
end

function func_p5(x, y, z)
    local fVar1;
    local fVar0 = math.sqrt(x * x + y * y + z * z)
    local vParam0
    if (fVar0 ~= 0.0) then
        fVar1 = (1.0 / fVar0);
        vParam0 = vector3(x, y, z) * vector3(fVar1, fVar1, fVar1)
    end

    return vParam0 or vector3(0.0, 0.0, 0.0);
end