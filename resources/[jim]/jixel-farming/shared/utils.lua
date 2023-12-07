function PickThing(event, ...)
    local args = {...}
    if Config.ScriptOptions.Minigame.Enabled then
        MiniGame(event, args)
    else
        TriggerEvent(event, args)
    end 
end

function MiniGame(event,args)
    exports["ps-ui"]:Circle(function(success)
        if success then
            TriggerEvent(event, args)
            triggerNotify(nil, Loc[Config.CoreOptions.Lan].success["minigame_success"], "success")
        else
            triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["minigame_fail"], "error")
        end
    end, Config.ScriptOptions.Minigame.MinigameCircles, Config.ScriptOptions.Minigame.MinigameTime)
end

function MarkerDraw(data)
    DrawMarker(data.markerType or 0, data.x or 0, data.y or 0, data.z or 0, data.dirX or 0, data.dirY or 0, data.dirZ or 0, data.rotX or 0, data.rotY or 0, data.rotZ or 0, data.scaleX or 1.0, data.scaleY or 1.0, data.scaleZ or 1.0, data.red or 255, data.green or 0, data.blue or 0, data.alpha or 100, data.bobbing or false, data.faceCamera or false, data.p19 or 2, data.rotate or false, data.textureDict or nil, data.textureName or nil, data.drawOnEntities or false)
end

function toggleCanWheat()
	canWheat = not canWheat
	if not canWheat then
		CreateThread(function()
			local setTimer = (WheatZone.WheatWait * 60000)
			while setTimer >= 0 do
				setTimer -= 100
				if setTimer <= 0 then canWheat = true end
				Wait(100)
			end
		end)
	end
end

function TryPickWheat()
	TriggerServerEvent("jixel-farming:client:TryPickWheat")
end

function GetCoordZ(x, y, ignorePrint)
    local groundCheckHeights = { 1, 5.0, 10.0, 15.0, 20.0, 25.0, 30.0, 35.0, 36.0, 40.0, 315.0, 320.0 }
    for i, height in ipairs(groundCheckHeights) do
        local foundGround, z = GetGroundZFor_3dCoord(x, y, height)
        if foundGround then
		if Config.DebugOptions.Debug and not ignorePrint then print(string.format("Found ground at height %.2f", height)) end
            return z
        end
    end
    if Config.DebugOptions.Debug then print(string.format("Could not find ground, returning default height(5.9): x:%s, y:%s", x,y)) end
    return 5.9
end

function getBucket(amount)
    local ped = PlayerPedId()
    RequestAnimDict("anim@heists@box_carry@")
    Wait(100)
    local milkprop = CreateObject(GetHashKey("prop_bucket_01a"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(milkprop, ped, GetPedBoneIndex(PlayerPedId(), 60309), 0.12, 0, 0.30, -145.0, 100.0, 0.0, true, true, false, true, 1, true)
    TaskPlayAnim(ped, "anim@heists@box_carry@", "idle", 2.0, 2.0, 5000, 51, 0, false, false, false)
    Wait(5000)
    DeleteObject(milkprop)
    TriggerServerEvent('jixel-farming:server:getcowbucket', amount)
end

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(true)
    SetTextColour(255, 255, 255, 215)
    BeginTextCommandDisplayText("STRING")
    SetTextCentre(true)
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(x,y,z, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    local factor = string.len(text) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function keyGen()
	local charset = {
		"q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","z","x","c","v","b","n","m",
		"Q","W","E","R","T","Y","U","I","O","P","A","S","D","F","G","H","J","K","L","Z","X","C","V","B","N","M",
		"1","2","3","4","5","6","7","8","9","0"
	}
	local GeneratedID = ""
	for i = 1, 12 do GeneratedID = GeneratedID..charset[math.random(1, #charset)] end
	return GeneratedID
end