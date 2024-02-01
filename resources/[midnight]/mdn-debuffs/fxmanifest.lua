fx_version 'bodacious'
game 'gta5'

author 'Lucky'
description 'Debuffs System'
version '2.1.0'

--[[

	Thx for support, write if there are problems

	Boosty (more scripts): https://boosty.to/sergeylucky
	Discrod: https://discord.gg/zb7DDq6B7j

--]]

ui_page('html/index.html')

client_scripts {
	'client.lua',
    'debuffs.lua',
	'takingDamage.lua',
    'test.lua'
}

files({
	'html/*',
	'html/assets/*',
	'html/assets/overlay/*'
})