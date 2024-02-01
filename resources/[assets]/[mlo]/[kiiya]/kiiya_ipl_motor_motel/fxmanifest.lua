fx_version 'bodacious'
game 'gta5'

lua54 'yes'

client_scripts {
  'NativeUI.lua',
  'config.lua',
  'iplConfig.lua',
  'client.lua',
}

server_scripts {
  'config.lua',
  'iplConfig.lua',
  'server.lua',
}

escrow_ignore {
  'script/config.lua',  -- Only ignore one file
}
dependency '/assetpacks'