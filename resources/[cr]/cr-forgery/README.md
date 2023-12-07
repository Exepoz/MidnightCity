# Features
* Simple Identification Forgery System
* "Craft" or "Purchase" Identification Cards
* Waters, Weapon, Fishing, Hunting, Drivers, and ID Cards
* Intricate Notifications
* Logging System Included
* Highly Configurable System
* Every card created contains `info.forged = true`, which let's you differentiate between real and fake cards.

# Dependencies
- [bob74_ipl](https://github.com/Bob74/bob74_ipl)
- [qb-input](https://github.com/qbcore-framework/qb-input)
- [qb-menu](https://github.com/qbcore-framework/qb-menu)
- [qb-target](https://github.com/berkiebb/qb-target)

# Inventory Image Credits

Thank You OG Panda#6041 for providing us with some fantastic Fishing, Hunting, and Waters License PNG's! :)

# Installation #

# qb-core/shared/items.lua

```
	['fishinglicense'] = {    ['name'] = 'fishinglicense',    ['label'] = 'Fishing License',    ['weight'] = 0,    ['type'] = 'item',    ['image'] = 'fishinglicense.png',    ['unique'] = true,    ['useable'] = true,    ['shouldClose'] = false,    ['combinable'] = nil,    ['description'] = 'Permit to show you can Fish'},
    ['huntinglicense'] = {    ['name'] = 'huntinglicense',    ['label'] = 'Hunting License',    ['weight'] = 0,    ['type'] = 'item',    ['image'] = 'huntinglicense.png',    ['unique'] = true,    ['useable'] = true,    ['shouldClose'] = false,    ['combinable'] = nil,    ['description'] = 'Permit to show you can Hunt'},
    ['waterslicense'] = {    ['name'] = 'waterslicense',    ['label'] = 'Waters License',    ['weight'] = 0,    ['type'] = 'item',    ['image'] = 'waterslicense.png',    ['unique'] = true,    ['useable'] = true,    ['shouldClose'] = false,    ['combinable'] = nil,    ['description'] = 'Permit to show you can Drive a Boat'},
```

# qb-inventory/server/main.lua | Add the following below the GiveItem QBCore.Commands(id_card & driver_license section specifically)

```
				elseif itemData["name"] == "driver_license" then
					info.citizenid = Player.PlayerData.citizenid
					info.firstname = Player.PlayerData.charinfo.firstname
					info.lastname = Player.PlayerData.charinfo.lastname
					info.birthdate = Player.PlayerData.charinfo.birthdate
					info.gender = Player.PlayerData.charinfo.gender
					info.nationality = Player.PlayerData.charinfo.nationality
					info.type = "Class C Driver License"
				elseif itemData["name"] == "weaponlicense" then
					info.citizenid = Player.PlayerData.citizenid
					info.firstname = Player.PlayerData.charinfo.firstname
					info.lastname = Player.PlayerData.charinfo.lastname
					info.birthdate = Player.PlayerData.charinfo.birthdate
					info.gender = Player.PlayerData.charinfo.gender
					info.nationality = Player.PlayerData.charinfo.nationality
					info.type = "Class One Weapon License"
				elseif itemData["name"] == "huntinglicense" then
					info.citizenid = Player.PlayerData.citizenid
					info.firstname = Player.PlayerData.charinfo.firstname
					info.lastname = Player.PlayerData.charinfo.lastname
					info.birthdate = Player.PlayerData.charinfo.birthdate
					info.gender = Player.PlayerData.charinfo.gender
					info.nationality = Player.PlayerData.charinfo.nationality
					info.type = "Hunting License"
				elseif itemData["name"] == "fishinglicense" then
					info.citizenid = Player.PlayerData.citizenid
					info.firstname = Player.PlayerData.charinfo.firstname
					info.lastname = Player.PlayerData.charinfo.lastname
					info.birthdate = Player.PlayerData.charinfo.birthdate
					info.gender = Player.PlayerData.charinfo.gender
					info.nationality = Player.PlayerData.charinfo.nationality
					info.type = "Deep Sea Fishing License"
				elseif itemData["name"] == "waterslicense" then
					info.citizenid = Player.PlayerData.citizenid
					info.firstname = Player.PlayerData.charinfo.firstname
					info.lastname = Player.PlayerData.charinfo.lastname
					info.birthdate = Player.PlayerData.charinfo.birthdate
					info.gender = Player.PlayerData.charinfo.gender
					info.nationality = Player.PlayerData.charinfo.nationality
					info.type = "Waters License"
```

Image: https://gyazo.com/bf02611912b052caa9739081a491244e

# qb-inventory/server/main.lua | Change the `driver_license` CreateUseableItem Function to

```
QBCore.Functions.CreateUseableItem("driver_license", function(source, item)
	for k, v in pairs(QBCore.Functions.GetPlayers()) do
		local PlayerPed = GetPlayerPed(source)
		local TargetPed = GetPlayerPed(v)
		local dist = #(GetEntityCoords(PlayerPed) - GetEntityCoords(TargetPed))
		if dist < 3.0 then
			TriggerClientEvent('chat:addMessage', v,  {
					template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Civilian ID:</strong> {1} <strong>First Name:</strong> {2} <br><strong>Last Name:</strong> {3} <br><strong>Birth Date:</strong> {4} <br><strong>Licenses:</strong> {5}</div></div>',
					args = {
						"Drivers License",
						item.info.citizenid,
						item.info.firstname,
						item.info.lastname,
						item.info.birthdate,
						item.info.type
					}
				}
			)
		end
	end
end)
```

Image: https://gyazo.com/f9494cd58b29ff9e5a74eb15fc10d842

# qb-inventory/server/main.lua | Add the following below the `id_card` CreateUseableItem Function

```
QBCore.Functions.CreateUseableItem("weaponlicense", function(source, item)
	for k, v in pairs(QBCore.Functions.GetPlayers()) do
		local PlayerPed = GetPlayerPed(source)
		local TargetPed = GetPlayerPed(v)
		local dist = #(GetEntityCoords(PlayerPed) - GetEntityCoords(TargetPed))
		if dist < 3.0 then
			TriggerClientEvent('chat:addMessage', v,  {
					template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Civilian ID:</strong> {1} <strong>First Name:</strong> {2} <br><strong>Last Name:</strong> {3} <br><strong>Birth Date:</strong> {4} <br><strong>Licenses:</strong> {5}</div></div>',
					args = {
						"Weapon License",
						item.info.citizenid,
						item.info.firstname,
						item.info.lastname,
						item.info.birthdate,
						item.info.type
					}
				}
			)
		end
	end
end)

QBCore.Functions.CreateUseableItem("huntinglicense", function(source, item)
	for k, v in pairs(QBCore.Functions.GetPlayers()) do
		local PlayerPed = GetPlayerPed(source)
		local TargetPed = GetPlayerPed(v)
		local dist = #(GetEntityCoords(PlayerPed) - GetEntityCoords(TargetPed))
		if dist < 3.0 then
			TriggerClientEvent('chat:addMessage', v,  {
					template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Civilian ID:</strong> {1} <strong>First Name:</strong> {2} <br><strong>Last Name:</strong> {3} <br><strong>Birth Date:</strong> {4} <br><strong>Licenses:</strong> {5}</div></div>',
					args = {
						"Hunting License",
						item.info.citizenid,
						item.info.firstname,
						item.info.lastname,
						item.info.birthdate,
						item.info.type
					}
				}
			)
		end
	end
end)

QBCore.Functions.CreateUseableItem("fishinglicense", function(source, item)
	for k, v in pairs(QBCore.Functions.GetPlayers()) do
		local PlayerPed = GetPlayerPed(source)
		local TargetPed = GetPlayerPed(v)
		local dist = #(GetEntityCoords(PlayerPed) - GetEntityCoords(TargetPed))
		if dist < 3.0 then
			TriggerClientEvent('chat:addMessage', v,  {
					template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Civilian ID:</strong> {1} <strong>First Name:</strong> {2} <br><strong>Last Name:</strong> {3} <br><strong>Birth Date:</strong> {4} <br><strong>Licenses:</strong> {5}</div></div>',
					args = {
						"Fishing License",
						item.info.citizenid,
						item.info.firstname,
						item.info.lastname,
						item.info.birthdate,
						item.info.type
					}
				}
			)
		end
	end
end)

QBCore.Functions.CreateUseableItem("waterslicense", function(source, item)
	for k, v in pairs(QBCore.Functions.GetPlayers()) do
		local PlayerPed = GetPlayerPed(source)
		local TargetPed = GetPlayerPed(v)
		local dist = #(GetEntityCoords(PlayerPed) - GetEntityCoords(TargetPed))
		if dist < 3.0 then
			TriggerClientEvent('chat:addMessage', v,  {
					template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Civilian ID:</strong> {1} <strong>First Name:</strong> {2} <br><strong>Last Name:</strong> {3} <br><strong>Birth Date:</strong> {4} <br><strong>Licenses:</strong> {5}</div></div>',
					args = {
						"Waters License",
						item.info.citizenid,
						item.info.firstname,
						item.info.lastname,
						item.info.birthdate,
						item.info.type
					}
				}
			)
		end
	end
end)
```

# qb/lj-inventory/html/js/app.js | Around line 450 replace the given License Lines with the entire snippet below

```
        } else if (itemData.name == "driver_license") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html(
                "<p><strong>CSN: </strong><span>" +
                itemData.info.citizenid +
                "<p><strong>First Name: </strong><span>" +
                itemData.info.firstname +
                "</span></p><p><strong>Last Name: </strong><span>" +
                itemData.info.lastname +
                "</span></p><p><strong>Birth Date: </strong><span>" +
                itemData.info.birthdate +
                "</span></p><p><strong>Gender: </strong><span>" +
                gender +
                "</span></p><p><strong>Nationality: </strong><span>" +
                itemData.info.nationality +
                "</span></p><p><strong>Licenses: </strong><span>" +
                itemData.info.type +
                "</span></p><p style=\"font-size:11px\"><b>Weight: </b>" + itemData.weight + " | <b>Amount: </b> " + itemData.amount + " | <b>Quality: </b> " + "<a style=\"font-size:11px;color:green\">" + Math.floor(itemData.info.quality) + "</a>"
            );
        } else if (itemData.name == "weaponlicense") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html(
                "<p><strong>CSN: </strong><span>" +
                itemData.info.citizenid +
                "<p><strong>First Name: </strong><span>" +
                itemData.info.firstname +
                "</span></p><p><strong>Last Name: </strong><span>" +
                itemData.info.lastname +
                "</span></p><p><strong>Birth Date: </strong><span>" +
                itemData.info.birthdate +
				"</span></p><p><strong>Gender: </strong><span>" +
                gender +
                "</span></p><p><strong>Nationality: </strong><span>" +
                itemData.info.nationality +
                "</span></p><p><strong>Licenses: </strong><span>" +
                itemData.info.type +
                "</span></p><p style=\"font-size:11px\"><b>Weight: </b>" + itemData.weight + " | <b>Amount: </b> " + itemData.amount + " | <b>Quality: </b> " + "<a style=\"font-size:11px;color:green\">" + Math.floor(itemData.info.quality) + "</a>"
            );
        } else if (itemData.name == "waterslicense") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html(
                "<p><strong>CSN: </strong><span>" +
                itemData.info.citizenid +
                "<p><strong>First Name: </strong><span>" +
                itemData.info.firstname +
                "</span></p><p><strong>Last Name: </strong><span>" +
                itemData.info.lastname +
                "</span></p><p><strong>Birth Date: </strong><span>" +
                itemData.info.birthdate +
				"</span></p><p><strong>Gender: </strong><span>" +
                gender +
                "</span></p><p><strong>Nationality: </strong><span>" +
                itemData.info.nationality +
                "</span></p><p><strong>Licenses: </strong><span>" +
                itemData.info.type +
                "</span></p><p style=\"font-size:11px\"><b>Weight: </b>" + itemData.weight + " | <b>Amount: </b> " + itemData.amount + " | <b>Quality: </b> " + "<a style=\"font-size:11px;color:green\">" + Math.floor(itemData.info.quality) + "</a>"
            );
        } else if (itemData.name == "huntinglicense") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html(
                "<p><strong>CSN: </strong><span>" +
                itemData.info.citizenid +
                "<p><strong>First Name: </strong><span>" +
                itemData.info.firstname +
                "</span></p><p><strong>Last Name: </strong><span>" +
                itemData.info.lastname +
                "</span></p><p><strong>Birth Date: </strong><span>" +
                itemData.info.birthdate +
				"</span></p><p><strong>Gender: </strong><span>" +
                gender +
                "</span></p><p><strong>Nationality: </strong><span>" +
                itemData.info.nationality +
                "</span></p><p><strong>Licenses: </strong><span>" +
                itemData.info.type +
                "</span></p><p style=\"font-size:11px\"><b>Weight: </b>" + itemData.weight + " | <b>Amount: </b> " + itemData.amount + " | <b>Quality: </b> " + "<a style=\"font-size:11px;color:green\">" + Math.floor(itemData.info.quality) + "</a>"
            );
        } else if (itemData.name == "fishinglicense") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html(
                "<p><strong>CSN: </strong><span>" +
                itemData.info.citizenid +
                "<p><strong>First Name: </strong><span>" +
                itemData.info.firstname +
                "</span></p><p><strong>Last Name: </strong><span>" +
                itemData.info.lastname +
                "</span></p><p><strong>Birth Date: </strong><span>" +
                itemData.info.birthdate +
				"</span></p><p><strong>Gender: </strong><span>" +
                gender +
                "</span></p><p><strong>Nationality: </strong><span>" +
                itemData.info.nationality +
                "</span></p><p><strong>Licenses: </strong><span>" +
                itemData.info.type +
                "</span></p><p style=\"font-size:11px\"><b>Weight: </b>" + itemData.weight + " | <b>Amount: </b> " + itemData.amount + " | <b>Quality: </b> " + "<a style=\"font-size:11px;color:green\">" + Math.floor(itemData.info.quality) + "</a>"
            );
```
# qb-multicharacter/server/main.lua | Replace the following snippet below for the GiveStarterItems Function

 - Simply replace the below snippet within the Function

```
        if v.item == "id_card" then
            info.citizenid = Player.PlayerData.citizenid
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.gender = Player.PlayerData.charinfo.gender
            info.nationality = Player.PlayerData.charinfo.nationality
        elseif v.item == "driver_license" then
            info.citizenid = Player.PlayerData.citizenid
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
			info.gender = Player.PlayerData.charinfo.gender
            info.nationality = Player.PlayerData.charinfo.nationality
            info.type = "Class C Driver License"
        end
```

# qb-cityhall/server/main.lua | Replace the Following "GiveStarterItems" Function with the Below Snippet
```
function GiveStarterItems(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    for k, v in pairs(QBCore.Shared.StarterItems) do
        local info = {}
        if v.item == "id_card" then
            info.citizenid = Player.PlayerData.citizenid
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.gender = Player.PlayerData.charinfo.gender
            info.nationality = Player.PlayerData.charinfo.nationality
        elseif v.item == "driver_license" then
            info.citizenid = Player.PlayerData.citizenid
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.gender = Player.PlayerData.charinfo.gender
            info.nationality = Player.PlayerData.charinfo.nationality
            info.type = "Class C Driver License"
        end
        Player.Functions.AddItem(v.item, 1, false, info)
    end
end
```

# qb-cityhall/server/main.lua | Replace the Following Event with the below Snippet
```
RegisterNetEvent('qb-cityhall:server:requestId', function(identityData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local info = {}
    if identityData.item == "id_card" then
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.nationality = Player.PlayerData.charinfo.nationality
    elseif identityData.item == "driver_license" then
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.nationality = Player.PlayerData.charinfo.nationality
        info.type = "Class C Driver License"
    elseif identityData.item == "weaponlicense" then
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.nationality = Player.PlayerData.charinfo.nationality
        info.type = "Class One Weapon License"
    elseif identityData.item == "huntinglicense" then
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.nationality = Player.PlayerData.charinfo.nationality
        info.type = "Hunting License"
    elseif identityData.item == "fishinglicense" then
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.nationality = Player.PlayerData.charinfo.nationality
        info.type = "Deep Sea Fishing License"
    elseif identityData.item == "waterslicense" then
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.nationality = Player.PlayerData.charinfo.nationality
        info.type = "Waters License"
    end
    Player.Functions.AddItem(identityData.item, 1, nil, info)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[identityData.item], 'add')
    Player.Functions.RemoveMoney("cash", 50)
end)
```

# qb-cityhall/client/main.lua | Replace the "local idTypes" with the below Snippet
```
local idTypes = {
    ["id_card"] = {
        label = Lang:t('info.id_card'),
        item = "id_card"
    },
    ["driver_license"] = {
        label = Lang:t('info.driver_license'),
        item = "driver_license"
    },
    ["weaponlicense"] = {
        label = Lang:t('info.weaponlicense'),
        item = "weaponlicense"
    },
    ["waterslicense"] = {
        label = Lang:t('info.waterslicense'),
        item = "waterslicense"
    },
    ["fishinglicense"] = {
        label = Lang:t('info.fishinglicense'),
        item = "fishinglicense"
    },
    ["huntinglicense"] = {
        label = Lang:t('info.huntinglicense'),
        item = "huntinglicense"
    },
}
```

# qb-cityhall/locales/en.lua | Add the Following below "weaponlicense"
```
        fishinglicense = 'Deep Sea Fishing License',
        huntinglicense = 'Hunting License',
        waterslicense = 'Waters License',
```

# qb-smallresources/server/logs.lua | Add the following within ```local Webhooks {}```

```
    ['identificationforgery'] = 'YOUR_WEBHOOK_HERE',
```

# FOR CUSTOM CARDS / CARDS FROM OTHER RESOURCES
* The cards need to be following the same templates as original cards.
* You can add as many cards as you would like by following the instruction aboves, but changing the item names by any cards you would like.
* Do not follow the "GiveStarterItem" snipet if you do not want the cards to be given upon character creation
* Add a new entry in the Config.Licences by following the instructions below : 

```
    ["Drivers License"] = {                    <-- The Name here will be displayed on different UIs and Menus (ie. "Forge 'Drivers License' ")
        Available = true,                       -- True = Can be crafted | False = Can't be crafted
        Pay = true,                             -- True = Requires Payment | False = No Payment Required
        MoneyType = "cash",                     -- If payment is required, money type used to forge a card ("cash, crypto, bank, or any custom currency")
        Cost = 35000,                           -- If payment is required, Cost of making the card.
        Item = true,                            -- True = Requires items to craft | False = No items required to craft a card.
        RequiredItems = {                       -- List of items required to craft a card.
                                                -- You can add as many items as wanted by following the template
                                                -- [ITEM_NUMBER] = {item = "ITEM_HASH", amount = "AMOUNT_REQUIRED"}
        [1] = {item = "plastic", amount = 2},
        [2] = {item = "dye", amount = 1}
        },
        Card = "driver_license",                --Card Item Given ("item hash")
        Description = "CLASS G DRIVER LICENSE"  -- Card Description
    },
```
