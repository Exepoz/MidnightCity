fx_version 'bodacious'
game 'gta5'
this_is_a_map 'yes'

author 'Map4All Interiors'
description 'Pillbox Hill Medical Center MLO'
version '1.0.1'
-- Fixed morque rm detail file colliding w/ world

files {
    'hedwig_pillbox_tc.xml'
}

data_file 'TIMECYCLEMOD_FILE' 'hedwig_pillbox_tc.xml'

escrow_ignore {
    'stream/basemap/meta/*.ymap',
    'stream/basemap/ybn/*.ybn',
    'stream/basemap/ydr/*.ydr',
    'stream/basemap/ydr/*.ydd',
    'stream/basemap/ymf/*.ymt',
    'stream/basemap/ynv/*.ynv',
    
    'stream/custom/ytd/*.ytd'
}
dependency '/assetpacks'