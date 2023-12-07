Hello and Thank you for purchasing!

This script supports multiple MLOS - at the most 4 running at the same time. I've only found three free MLOs

Discord Server: https://discord.gg/jixelpatterns / https://discord.gg/kA6rGzwtrX

## FREE -
Kamrad Mapping - https://gta5mod.net/gta-5-mods/maps/cluckin-bell-shop-free-mlo/
Diluente - https://forum.cfx.re/t/mlo-free-mini-cluckin-bell/4816116
DPSGTA - https://forum.cfx.re/t/release-cluckin-bell/1045080
## PAID -
GNSTUDIO - https://fivem.gnstud.io/package/5354683
SweToon - https://forum.cfx.re/t/mlo-paid-davis-cluckin-bell-interior/4811638
AMBITIONEERS - https://forum.cfx.re/t/mlo-cluckin-bell/4923492

## Installation

To add new locations copy one of the locations in the Locations folder and then then change the appropritate targets. We will not be able to help you with MLOs we do not own.

1. Copy all items in the `install` > `items.lua`

and paste them in your `QB-Core` / `shared` / `items.lua`
(they should automatically convert for ox_inventory)

2. Copy images from the `install` > `images` folder

paste them into your `ps-inventory/html/images` or
`qb-inventory/html/images` or
`ox_inventory/web/images`

3. Copy this into your `QBCore` / `Shared` / `jobs.lua`

## Jobs in qb-core > shared > jobs.lua

Under the QBShared.Jobs in jobs.lua

	['cluckinbell'] = {
		label = 'Cluckin Bell',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = { name = 'Recruit', payment = 50 },
			['1'] = { name = 'Novice', payment = 75 },
			['2'] = { name = 'Experienced', payment = 100 },
			['3'] = { name = 'Assistant Manager', payment = 125 },
			['4'] = { name = 'Manager', isboss = true, payment = 150 },
            ['4'] = { name = 'Owner', isboss = true, payment = 170 },
        },
	},

4. Add the animations provided in the customanims.md to your emote menu of choice they are currently formattted for dp/rp emotes

## TOYS

You will have to set up your own toys. I left in one example toy This is how you would set it up in your items.lua - there is no limit to how many toys you can have.

	["cluckinbell-bell"] = {["name"] = "cluckinbell-bell", ["label"] = "Cluckin Bell Bell", ["weight"] = 500, ["type"] = "item", ["image"] = "cb_cluckinbell-bell.png", ["unique"] = false, ["useable"] = true, ["shouldClose"] = false, ["combinable"] = nil, ["description"] = "A ringing Cluckin Bell bell."},
	["cluckinbell-figure"] = {["name"] = "cluckinbell-figure", ["label"] = "Cluckin Bell Figure", ["weight"] = 500, ["type"] = "item", ["image"] = "cb_cluckinbell-figure.png", ["unique"] = false, ["useable"] = true, ["shouldClose"] = false, ["combinable"] = nil, ["description"] = "A small Cluckin Bell figure."},
	["cluckinbell-plushie1"] = {["name"] = "cluckinbell-plushie1", ["label"] = "Cluckin Bell Plushie 1", ["weight"] = 500, ["type"] = "item", ["image"] = "cb_cluckinbell-plushie1.png", ["unique"] = false, ["useable"] = true, ["shouldClose"] = false, ["combinable"] = nil, ["description"] = "A cute Cluckin Bell plushie."},
	["cluckinbell-plushie2"] = {["name"] = "cluckinbell-plushie2", ["label"] = "Cluckin Bell Plushie 2", ["weight"] = 500, ["type"] = "item", ["image"] = "cb_cluckinbell-plushie2.png", ["unique"] = false, ["useable"] = true, ["shouldClose"] = false, ["combinable"] = nil, ["description"] = "Another adorable Cluckin Bell plushie."},
	["cluckinbell-plushie3"] = {["name"] = "cluckinbell-plushie3", ["label"] = "Cluckin Bell Plushie 3", ["weight"] = 500, ["type"] = "item", ["image"] = "cb_cluckinbell-plushie3.png", ["unique"] = false, ["useable"] = true, ["shouldClose"] = false, ["combinable"] = nil, ["description"] = "Yet another charming Cluckin Bell plushie."},
	["cluckinbell-plushie4"] = {["name"] = "cluckinbell-plushie4", ["label"] = "Cluckin Bell Plushie 4", ["weight"] = 500, ["type"] = "item", ["image"] = "cb_cluckinbell-plushie4.png", ["unique"] = false, ["useable"] = true, ["shouldClose"] = false, ["combinable"] = nil, ["description"] = "One more lovable Cluckin Bell plushie."}

## QB-Management:
    If you're using QB-Management do the following:
	- Update to the latest github version
	- Make sure the job "cluckinbell" has been added to the database
	- The menu's targets should be accessible to bosses from the clock in spot

##  Menu

I've provided a PSD in the install folder for your convenience to help with making a menu.

here is the font used:
https://www.dafont.com/cocogoose.font

To change up the menu you can find the event in client.lua on line 427

Currently it is set to a universal image between all stores
Change Config.MenuImg  to Location.Img for a universal store image per store
OR Target.Img for seperate images per target


if Target.Menu then
	for i, desk in ipairs(Target.Menu) do
		if Config.Debug then print("^4"..locationName.."^7 Registering Menu at ^4"..desk.coords.."") end
		if desk then
		local targetName = locationName.."CBMenu"..i
		Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, desk.coords, 0.6, 0.6,
			{ name = targetName, heading = desk.heading, debugPoly = Config.Debug, minZ = desk.coords.z-0.5, maxZ = desk.coords.z+1, },
			{ options = {
				{ event = "jixel-cluckinbell:showMenu", Config.MenuImg}
			}, distance = 2.0, })
		end
	end
end

there is also an insert option in the pos targets on line 259

if pos.menu then
	print("^4"..locationName.."^7 Registering POS Menu at ^4"..pos.coords.." "..json.encode(pos.menu).." ")
	table.insert(options, {
		event = "jixel-cluckinbell:showMenu",
		type = "client",
		icon = "fas fa-hamburger",
		label = Loc[Config.Lan].target["open_menu"],
		img = Config.MenuImg,
	})
end

so if any of your config.Location options have menu = true then they will display the preset menu image

if you changet it to pos.menuImg you will have to put links in manually for each location like so
you could variable it to be Config.MenuLoc1

Menu = {
	{ coords = vec3(1,2,3), prop = true, propcoords = "", menu = true, menuImg = "imgurlinkhere",}
}


It is also a useable menu currently - and you can create more by going to the server.lua line 61 and adding it like so

`	QBCore.Functions.CreateUseableItem("cluckmenu", function(source, item) TriggerClientEvent('jixel-cluckinbell:showMenu', source, Config.MenuImg) end)`

change Config.Img like before depending on what you want