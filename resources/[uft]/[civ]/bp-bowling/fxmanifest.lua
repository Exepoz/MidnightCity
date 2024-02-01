fx_version 'cerulean'
games { 'gta5' }

this_is_a_map "yes"

lua54 "yes"

client_scripts {
  '@PolyZone/client.lua', -- Remove if you don't use PolyZone
  '@PolyZone/BoxZone.lua', -- Remove if you don't use PolyZone
  '@PolyZone/ComboZone.lua', -- Remove if you don't use PolyZone
  '@PolyZone/EntityZone.lua', -- Remove if you don't use PolyZone
  'client/cl_*.lua',
}

shared_script {
  'sh_config.lua',
  '@ox_lib/init.lua',
}

server_scripts {
  'server/sv_*.lua',
}

ui_page ('ui/index.html')

files {
  'ui/*'
}

