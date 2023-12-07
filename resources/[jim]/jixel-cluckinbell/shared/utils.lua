
function EmoteStart(data)
	local emoteMenu = Config.EmoteMenu if nil then error("Emote Menu not set in Config") return end
	if data.emoteName then
        if emoteMenu == "rp" then
            exports["rpemotes"]:EmoteCommandStart(data.emoteName, data.textureVariation or 0)
        elseif emoteMenu == "dp" then
            TriggerEvent('animations:client:EmoteCommandStart', {data.emoteName})
        elseif emoteMenu == "scully" then
            exports.scully_emotemenu:playEmoteByCommand(data.emoteName)
        elseif emoteMenu ==  "default" then
            ExecuteCommand("e "..data.emoteName.."")
        end
		if Config.PrintDebug then
			local emoteName = data.emoteName
			print("^5Debug^7: ^3Playing:^7 ^4"..emoteName.." ^5with ^7EmoteMenu: ^4"..json.encode(emoteMenu).." ")
		end
	elseif data.emoteName == nil then
        print("^3Error^7: ^2Script can't find Emote Name in Emote Menu- ^1" .. json.encode((data.emoteName)) .. "^7")
    end
end


function EmoteCancel()
	local emoteMenu = Config.CoreOptions.EmoteMenu
    if emoteMenu == "rp" then
        exports["rpemotes"]:EmoteCancel(forceCancel)
    elseif emoteMenu == "dp" then
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    elseif emoteMenu == "scully" then
		exports.scully_emotemenu:cancelEmote()
    elseif emoteMenu == "debug" then
        ExecuteCommand("e c")
    end
	if Config.PrintDebug then
		print("^5Debug^7: ^Canelling:^7 ^4 Emote ^5with ^7EmoteMenu: ^4"..json.encode(emoteMenu).." ")
	end
end

function triggerNotify(title, icon, message, type, src)
	if Config.Notify == "okok" then
		if not src then	exports['okokNotify']:Alert(title, message, 6000, type)
		else TriggerClientEvent('okokNotify:Alert', src, title, message, 6000, type) end
	elseif Config.Notify == "qb" then
		if not src then	TriggerEvent("QBCore:Notify", message, type)
		else TriggerClientEvent("QBCore:Notify", src, message, type) end
	elseif Config.Notify == "t" then
		if not src then exports['t-notify']:Custom({title = title, style = type, message = message, sound = true})
		else TriggerClientEvent('t-notify:client:Custom', src, { style = type, duration = 6000, title = title, message = message, sound = true, custom = true}) end
	elseif Config.Notify == "infinity" then
		if not src then TriggerEvent('infinity-notify:sendNotify', message, type)
		else TriggerClientEvent('infinity-notify:sendNotify', src, message, type) end
	elseif Config.Notify == "rr" then
		if not src then exports.rr_uilib:Notify({msg = message, type = type, style = "dark", duration = 6000, position = "top-right", })
		else TriggerClientEvent("rr_uilib:Notify", src, {msg = message, type = type, style = "dark", duration = 6000, position = "top-right", }) end
	elseif Config.Notify == "ox" then
		if not src then	exports.ox_lib:notify({title = title, description = message, type = type or "success"})
		else TriggerClientEvent('ox_lib:notify', src, { type = type or "success", title = title, description = message }) end
	elseif Config.Notify == "um" then
        if not src then exports['um-notify']:N(icon, message, type)
        else TriggerClientEvent('um-notify:client:n', src, icon, message, type) end
    elseif Config.Notify == "jixel" then
		if not src then exports['jixel-notify']:J(icon, message, type)
        else TriggerClientEvent('jixel-notify:client:j', src, icon, message, type) end
	end
end