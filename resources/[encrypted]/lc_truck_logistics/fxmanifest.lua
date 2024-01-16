fx_version 'cerulean'
game 'gta5'
author 'LixeiroCharmoso'

ui_page "nui/ui.html"

lua54 'yes'

escrow_ignore {
	'config.lua',
	'client.lua',
	'server_utils.lua',
	'lang/*.lua',
}

client_scripts {
	"client.lua",
}

server_scripts {
	"server_utils.lua",
	"server.lua"
}

shared_scripts {
	"lang/*.lua",
	"config.lua",
}

files {
	"nui/lang/*",
	"nui/ui.html",
	"nui/panel.js",
	"nui/css/*",
	"nui/img/*",
	"nui/img/avatar/*",
	"nui/img/icons/*",
}

dependency "lc_utils"
dependency '/assetpacks'