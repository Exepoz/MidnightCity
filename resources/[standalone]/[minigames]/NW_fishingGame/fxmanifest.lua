fx_version 'cerulean'

game 'gta5'
lua54 'yes'

version '1.0.0'
author 'Demigod'
description 'Fishing Minigame'

client_scripts {
	"client/config.lua",
	"client/client.lua",
	"client/escrow.lua",
}

ui_page "html/index.html"

files {
	"html/index.html",
	"html/style.css",
	"html/index.js",
	"html/reset.css",
	"html/imgs/*.png"
}

escrow_ignore {
	'client/config.lua',
	'client/client.lua',
	'README.txt',
}
dependency '/assetpacks'