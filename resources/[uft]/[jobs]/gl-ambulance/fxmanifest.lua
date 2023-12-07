fx_version 'cerulean'
game 'gta5'

author 'Kallock - The Goodlife RP Server, edited manifest to APPEASE OVERLORD KAKAROT'
version '1.0.0'
lua54 'yes'

escrow_ignore {
    'client.lua',
    'server.lua',
    'shared.lua',
}


client_script 'client.lua'

server_script 'server.lua'

shared_scripts {
	'shared.lua'
}

dependencies {
	"qb-target",
	"qb-ambulancejob"
}


dependency '/assetpacks'