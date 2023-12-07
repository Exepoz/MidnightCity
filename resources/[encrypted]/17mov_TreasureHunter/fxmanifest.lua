fx_version "adamant"
game "gta5"
author "Malizniak - 17Movement"
version "2.5.2"
lua54 "yes"

files {
    "web/**/*.**",
    "web/*.**",
    "stream/*.**",
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

data_file 'HANDLING_FILE'            'stream/handling.meta'
data_file 'VEHICLE_METADATA_FILE'    'stream/vehicles.meta'
data_file 'VEHICLE_VARIATION_FILE'   'stream/carvariations.meta'
data_file 'DLC_ITYP_REQUEST' 'stream/17mov_diving_props.ytyp'

dependency '/assetpacks'