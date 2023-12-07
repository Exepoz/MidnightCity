fx_version "cerulean"
games { "gta5" }
description '[QBCore] Fivem WheelStancer | Tuff Scripts'
version 'v3.3.4'


ui_page "assets/html/index.html"

files {
  "assets/html/index.html",
  "assets/html/js/ui.js",
  "assets/html/css/menu.css",  -- Menu Style Path
  "assets/html/imgs/logo.png", -- Logo Path
}

shared_script {
  "config.lua",
  '@qb-core/shared/locale.lua',
  'locales/en.lua',
}

client_script {
  "@PolyZone/client.lua",
  '@PolyZone/BoxZone.lua',
  '@PolyZone/EntityZone.lua',
  '@PolyZone/CircleZone.lua',
  '@PolyZone/ComboZone.lua',
  "client/*.lua"
}

server_scripts {
  'server/*.lua',
  '@oxmysql/lib/MySQL.lua',
}

escrow_ignore {
  -- [Accessable Files]
  "config.lua",
  "server/sv_webhook.lua",
  'locales/*.lua',
}

lua54 'yes'

dependency '/assetpacks'