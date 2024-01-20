fx_version 'cerulean'
game 'gta5'

files {
  '**carcols.meta',
  '**vehicles.meta',
  '**carvariations.meta',
  '**handling.meta',
}

lua54 'yes'

data_file 'CARCOLS_FILE' '**carcols.meta'
data_file 'VEHICLE_METADATA_FILE' '**vehicles.meta'
data_file 'VEHICLE_VARIATION_FILE' '**carvariations.meta'
data_file 'HANDLING_FILE' '**handling.meta'

escrow_ignore {
  'stream/modkit/polcara_liv1.yft',
  'stream/modkit/polcara_liv2.yft',
  'stream/modkit/polcara_liv3.yft'
}
dependency '/assetpacks'