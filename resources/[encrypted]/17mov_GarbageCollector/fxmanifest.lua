fx_version "adamant"
game "gta5"
author "Malizniak - 17Movement"
lua54 "yes"
version "2.5.5"

files {
    "web/**/*.**",
    "web/*.**",
}

ui_page "web/driver.html"

server_scripts {
    "server/functions.lua",
    "server/server.lua",
} 

client_scripts {
    "client/target.lua",
    "client/functions.lua",
    "client/client.lua",
}

shared_script "Config.lua"

escrow_ignore {
    "Config.lua",
    "client/target.lua",
    "client/functions.lua",
    "server/functions.lua",
    "stream/*.**",
}
dependency '/assetpacks'