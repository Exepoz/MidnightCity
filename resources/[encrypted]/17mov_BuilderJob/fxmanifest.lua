fx_version "adamant"
game "gta5"
author "Malizniak - 17Movement"
lua54 "yes"

files {
    "web/**/*.**",
    "web/*.**",
    'stream/**/**/vehicles.meta',
    'stream/**/**/carvariations.meta',
    'stream/**/**/carcols.meta',
}

ui_page "web/driver.html"

shared_script "Config.lua"

server_scripts {
    "server/functions.lua",
    "server/server.lua",
} 

client_scripts {
    "client/functions.lua",
    "client/target.lua",
    "client/client.lua",
} 

data_file "DLC_ITYP_REQUEST" "STREAM/17mov_pipe.ydr"
data_file "DLC_ITYP_REQUEST" "STREAM/17mov_brick_001.ydr"
data_file "DLC_ITYP_REQUEST" "STREAM/17mov_brick_002.ydr"
data_file "DLC_ITYP_REQUEST" "STREAM/17mov_brick_003.ydr"
data_file "DLC_ITYP_REQUEST" "STREAM/17mov_brick_004.ydr"
data_file "DLC_ITYP_REQUEST" "STREAM/concrete.ydr"
data_file "DLC_ITYP_REQUEST" "STREAM/concrete.ytyp"
data_file "DLC_ITYP_REQUEST" "STREAM/17mov_construction_objects.ytyp"
data_file "DLC_ITYP_REQUEST" "STREAM/17mov_wallframe_wall.ydr"

data_file 'VEHICLE_METADATA_FILE'    'stream/**/**/vehicles.meta'
data_file 'CARCOLS_FILE'             'stream/**/**/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE'   'stream/**/**/carvariations.meta'

escrow_ignore {
    "Config.lua",
    "client/target.lua",
    "client/functions.lua",
    "server/functions.lua",
}
dependency '/assetpacks'