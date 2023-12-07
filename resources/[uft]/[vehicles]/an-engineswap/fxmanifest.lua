fx_version 'cerulean'
game 'gta5'

lua54 'on'

shared_scripts {
	"config.lua"
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
	"server.lua"
}
client_scripts {
  '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
	"client.lua",
}

files {
  'audioconfig/*.dat151.rel',
  'audioconfig/*.dat54.rel',
  "audioconfig/*.dat10.rel",
  'sfx/**/*.awc',
  'sfx/**/*.awc',
}

data_file 'AUDIO_GAMEDATA' 'audioconfig/npcul_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/npcul_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_npcul'
data_file 'AUDIO_GAMEDATA' 'audioconfig/elegyx_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/elegyx_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_elegyx'
data_file 'AUDIO_GAMEDATA' 'audioconfig/majimalm_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/majimalm_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_majimagt'
data_file 'AUDIO_GAMEDATA' 'audioconfig/trumpetzrc_game.dat'
data_file 'AUDIO_GAMEDATA' 'audioconfig/trumpetzr_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/trumpetzrc_sounds.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/trumpetzr_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_trumpetzr'
data_file 'AUDIO_GAMEDATA' 'audioconfig/cw2019_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/cw2019_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_cw2019'
data_file 'AUDIO_SYNTHDATA' 'audioconfig/stratumc_amp.dat'
data_file 'AUDIO_GAMEDATA' 'audioconfig/stratumc_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/stratumc_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_zircoflow'
data_file 'AUDIO_GAMEDATA' 'audioconfig/lfasound_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/lfasound_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_lfasound'
data_file 'AUDIO_GAMEDATA' 'audioconfig/r34sound_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/r34sound_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_r34sound'
data_file 'AUDIO_GAMEDATA' 'audioconfig/s15sound_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/s15sound_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_s15sound'
data_file 'AUDIO_GAMEDATA' 'audioconfig/ftypesound_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/ftypesound_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_ftypesound'
data_file 'AUDIO_GAMEDATA' 'audioconfig/lambov10_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/lambov10_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_lambov10'
data_file 'AUDIO_GAMEDATA' 'audioconfig/f10m5_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/f10m5_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_f10m5'
data_file 'AUDIO_GAMEDATA' 'audioconfig/rb26dett_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/rb26dett_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_rb26dett'
data_file 'AUDIO_GAMEDATA' 'audioconfig/s85b50_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/s85b50_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_s85b50'
data_file 'AUDIO_GAMEDATA' 'audioconfig/f20c_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/f20c_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_f20c'
data_file 'AUDIO_GAMEDATA' 'audioconfig/npolchar_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/npolchar_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_npolchar'
data_file 'AUDIO_GAMEDATA' 'audioconfig/ecoboostv6_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/ecoboostv6_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_ecoboostv6'
data_file 'AUDIO_GAMEDATA' 'audioconfig/cvpiv8_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/cvpiv8_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_cvpiv8'
data_file 'AUDIO_GAMEDATA' 'audioconfig/subaruej20_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/subaruej20_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_subaruej20'
data_file 'AUDIO_GAMEDATA' 'audioconfig/fordvoodoo_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/fordvoodoo_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_fordvoodoo'
data_file 'AUDIO_GAMEDATA' 'audioconfig/n4g63t_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/n4g63t_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_n4g63t'
data_file 'AUDIO_GAMEDATA' 'audioconfig/ta488f154_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/ta488f154_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_ta488f154'
data_file 'AUDIO_GAMEDATA' 'audioconfig/porsche57v10_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/porsche57v10_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_porsche57v10'
data_file 'AUDIO_GAMEDATA' 'audioconfig/aq2jzgterace_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/aq2jzgterace_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_aq2jzgterace'
data_file 'AUDIO_GAMEDATA' 'audioconfig/aqtoy2jzstock_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/aqtoy2jzstock_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_aqtoy2jzstock'
data_file 'AUDIO_GAMEDATA' 'audioconfig/aqls7raceswap_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/aqls7raceswap_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_aqls7raceswap'
data_file 'AUDIO_GAMEDATA' 'audioconfig/rotary7_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/rotary7_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_rotary7'
data_file 'AUDIO_GAMEDATA' 'audioconfig/ea888_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/ea888_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_ea888'
data_file "AUDIO_SYNTHDATA" "audioconfig/lgcy04murciv12_amp.dat"
data_file "AUDIO_GAMEDATA" "audioconfig/lgcy04murciv12_game.dat"
data_file "AUDIO_SOUNDDATA" "audioconfig/lgcy04murciv12_sounds.dat"
data_file "AUDIO_WAVEPACK" "sfx/dlc_lgcy04murciv12"
data_file 'AUDIO_GAMEDATA' 'audioconfig/aq06nhonc30a_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/aq06nhonc30a_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_aq06nhonc30a'
data_file "AUDIO_SYNTHDATA" "audioconfig/gt3rstun_amp.dat"
data_file "AUDIO_GAMEDATA" "audioconfig/gt3rstun_game.dat"
data_file "AUDIO_SOUNDDATA" "audioconfig/gt3rstun_sounds.dat"
data_file "AUDIO_WAVEPACK" "sfx/dlc_gt3rstun"
data_file 'AUDIO_SYNTHDATA' 'audioconfig/p60b40_amp.dat'
data_file 'AUDIO_GAMEDATA' 'audioconfig/p60b40_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/p60b40_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_p60b40'
data_file 'AUDIO_GAMEDATA' 'audioconfig/taaud40v8_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/taaud40v8_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_taaud40v8'
data_file "AUDIO_SYNTHDATA" "audioconfig/mbnzc63eng_amp.dat"
data_file "AUDIO_GAMEDATA" "audioconfig/mbnzc63eng_game.dat"
data_file "AUDIO_SOUNDDATA" "audioconfig/mbnzc63eng_sounds.dat"
data_file "AUDIO_WAVEPACK" "sfx/dlc_mbnzc63eng"
data_file 'AUDIO_SYNTHDATA' 'audioconfig/bgw16_amp.dat'
data_file 'AUDIO_GAMEDATA' 'audioconfig/bgw16_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/bgw16_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_bgw16'
data_file 'AUDIO_GAMEDATA' 'audioconfig/m297zonda_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/m297zonda_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_m297zonda'
data_file 'AUDIO_GAMEDATA' 'audioconfig/ta028viper_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/ta028viper_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_ta028viper'
data_file 'AUDIO_GAMEDATA' 'audioconfig/suzukigsxr1k_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/suzukigsxr1k_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_suzukigsxr1k'
data_file 'AUDIO_GAMEDATA' 'audioconfig/dodgehemihellcat_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/dodgehemihellcat_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_dodgehemihellcat'
data_file 'AUDIO_GAMEDATA' 'audioconfig/tayamahar1_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/tayamahar1_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_tayamahar1'
data_file "AUDIO_SYNTHDATA" "audioconfig/bmws1krreng_amp.dat"
data_file "AUDIO_GAMEDATA" "audioconfig/bmws1krreng_game.dat"
data_file "AUDIO_SOUNDDATA" "audioconfig/bmws1krreng_sounds.dat"
data_file "AUDIO_WAVEPACK" "sfx/dlc_bmws1krreng"
data_file 'AUDIO_GAMEDATA' 'audioconfig/sultanrsv8_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/sultanrsv8_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_v8sultanrs'
data_file "AUDIO_SYNTHDATA" "audioconfig/rx7bpeng_amp.dat"
data_file "AUDIO_GAMEDATA" "audioconfig/rx7bpeng_game.dat"
data_file "AUDIO_SOUNDDATA" "audioconfig/rx7bpeng_sounds.dat"
data_file "AUDIO_WAVEPACK" "sfx/dlc_rx7bpeng"
data_file "AUDIO_GAMEDATA" "audioconfig/demonv8_game.dat"
data_file "AUDIO_SOUNDDATA" "audioconfig/demonv8_sounds.dat"
data_file "AUDIO_WAVEPACK" "sfx/dlc_demonv8"
data_file "AUDIO_GAMEDATA" "audioconfig/tagt3flat6_game.dat"
data_file "AUDIO_SOUNDDATA" "audioconfig/tagt3flat6_sounds.dat"
data_file "AUDIO_WAVEPACK" "sfx/dlc_tagt3flat6"
data_file "AUDIO_GAMEDATA" "audioconfig/aq14nisvq37vhrt_game.dat"
data_file "AUDIO_SOUNDDATA" "audioconfig/aq14nisvq37vhrt_sounds.dat"
data_file "AUDIO_WAVEPACK" "sfx/dlc_aq14nisvq37vhrt"
data_file "AUDIO_SYNTHDATA" "audioconfig/bnr34ffeng_amp.dat"
data_file "AUDIO_GAMEDATA" "audioconfig/bnr34ffeng_game.dat"
data_file "AUDIO_SOUNDDATA" "audioconfig/bnr34ffeng_sounds.dat"
data_file "AUDIO_WAVEPACK" "sfx/dlc_bnr34ffeng"
data_file "AUDIO_GAMEDATA" "audioconfig/chevroletlt4_game.dat"
data_file "AUDIO_SOUNDDATA" "audioconfig/chevroletlt4_sounds.dat"
data_file "AUDIO_WAVEPACK" "sfx/dlc_chevroletlt4"
data_file "AUDIO_GAMEDATA" "audioconfig/cummins5924v_game.dat"
data_file "AUDIO_SOUNDDATA" "audioconfig/cummins5924v_sounds.dat"
data_file "AUDIO_WAVEPACK" "sfx/dlc_cummins5924v"
data_file "AUDIO_SYNTHDATA" "audioconfig/dghmieng_amp.dat"
data_file "AUDIO_GAMEDATA" "audioconfig/dghmieng_game.dat"
data_file "AUDIO_SOUNDDATA" "audioconfig/dghmieng_sounds.dat"
data_file "AUDIO_WAVEPACK" "sfx/dlc_dghmieng"
data_file "AUDIO_SYNTHDATA" "audioconfig/m158huayra_amp.dat"
data_file "AUDIO_GAMEDATA" "audioconfig/m158huayra_game.dat"
data_file "AUDIO_SOUNDDATA" "audioconfig/m158huayra_sounds.dat"
data_file "AUDIO_WAVEPACK" "sfx/dlc_m158huayra"
data_file "AUDIO_SYNTHDATA" "audioconfig/nisgtr35_amp.dat"
data_file "AUDIO_GAMEDATA" "audioconfig/nisgtr35_game.dat"
data_file "AUDIO_SOUNDDATA" "audioconfig/nisgtr35_sounds.dat"
data_file "AUDIO_WAVEPACK" "sfx/dlc_nisgtr35"
data_file "AUDIO_SYNTHDATA" "audioconfig/nsr2teng_amp.dat"
data_file "AUDIO_GAMEDATA" "audioconfig/nsr2teng_game.dat"
data_file "AUDIO_SOUNDDATA" "audioconfig/nsr2teng_sounds.dat"
data_file "AUDIO_WAVEPACK" "sfx/dlc_nsr2teng"
data_file "AUDIO_GAMEDATA" "audioconfig/predatorv8_game.dat"
data_file "AUDIO_SOUNDDATA" "audioconfig/predatorv8_sounds.dat"
data_file "AUDIO_WAVEPACK" "sfx/dlc_predatorv8"
data_file "AUDIO_GAMEDATA" "audioconfig/musv8_game.dat"
data_file "AUDIO_SOUNDDATA" "audioconfig/musv8_sounds.dat"
data_file "AUDIO_WAVEPACK" "sfx/dlc_musv8"
data_file "AUDIO_GAMEDATA" "audioconfig/aq42chedrag427_game.dat"
data_file "AUDIO_SOUNDDATA" "audioconfig/aq42chedrag427_sounds.dat"
data_file "AUDIO_WAVEPACK" "sfx/dlc_aq42chedrag427"
data_file "AUDIO_GAMEDATA" "audioconfig/aq07powerstroke67_game.dat"
data_file "AUDIO_SOUNDDATA" "audioconfig/aq07powerstroke67_sounds.dat"
data_file "AUDIO_WAVEPACK" "sfx/dlc_aq07powerstroke67"
data_file "AUDIO_SYNTHDATA" "audioconfig/mt09eng_amp.dat"
data_file "AUDIO_GAMEDATA" "audioconfig/mt09eng_game.dat"
data_file "AUDIO_SOUNDDATA" "audioconfig/mt09eng_sounds.dat"
data_file "AUDIO_WAVEPACK" "sfx/dlc_mt09eng"
data_file "AUDIO_GAMEDATA" "audioconfig/ta103ninjah2r_game.dat"
data_file "AUDIO_SOUNDDATA" "audioconfig/ta103ninjah2r_sounds.dat"
data_file "AUDIO_WAVEPACK" "sfx/dlc_ta103ninjah2r"
data_file "AUDIO_GAMEDATA" "audioconfig/ta011mit4g63_game.dat"
data_file "AUDIO_SOUNDDATA" "audioconfig/ta011mit4g63_sounds.dat"
data_file "AUDIO_WAVEPACK" "sfx/dlc_ta011mit4g63"
data_file "AUDIO_GAMEDATA" "audioconfig/aq35ferf154cd_game.dat"
data_file "AUDIO_SOUNDDATA" "audioconfig/aq35ferf154cd_sounds.dat"
data_file "AUDIO_WAVEPACK" "sfx/dlc_aq35ferf154cd"
data_file "AUDIO_SYNTHDATA" "audioconfig/lamavgineng_amp.dat"
data_file "AUDIO_GAMEDATA" "audioconfig/lamavgineng_game.dat"
data_file "AUDIO_SOUNDDATA" "audioconfig/lamavgineng_sounds.dat"
data_file "AUDIO_WAVEPACK" "sfx/dlc_lamavgineng"
data_file "AUDIO_SYNTHDATA" "audioconfig/lg18bmwm4_amp.dat"
data_file "AUDIO_GAMEDATA" "audioconfig/lg18bmwm4_game.dat"
data_file "AUDIO_SOUNDDATA" "audioconfig/lg18bmwm4_sounds.dat"
data_file "AUDIO_WAVEPACK" "sfx/dlc_lg18bmwm4"
