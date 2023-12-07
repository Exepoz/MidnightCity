Config = Config or {}
Config.ArmWrestle = {
    language = 'en', --change with 'en' for english, 'fr' for french, 'cz' for czech, 'de' for german
                                                      -- 'prop_arm_wrestle_01' --
                                                -- 'bkr_prop_clubhouse_arm_wrestle_01a' --
                                                -- 'bkr_prop_clubhouse_arm_wrestle_02a' --

    props = {
      {coords = vector4(1980.82, 3058.48, 46.67, 0.0), model = 'prop_arm_wrestle_01'},
      {coords = vector4(-268.97, -982.77, 31.21, 244.7), model = 'prop_arm_wrestle_01'},
      {coords = vector4(1450.21, -2615.94, 48.63, 170.56), model = 'bkr_prop_clubhouse_arm_wrestle_01a'},
      {coords = vector4(342.61, -1988.79, 23.96, 228.23), model = 'prop_arm_wrestle_01'},
      {coords = vector4(-688.96, -880.53, 24.5, 245.9), model = 'prop_arm_wrestle_01'},
      {coords = vector4(-1539.6, -259.51, 48.27, 104.74), model = 'prop_arm_wrestle_01'},
    },

    showBlipOnMap = false, -- Set to true to show blip for each table

    blip = { --Blip info

      title="Arm wrestle",
      colour=0, --
      id=1

    }

}

text = {
    ['en'] = {
      ['win'] = "You win !",
      ['lose'] = "You lost",
      ['full'] = "A wrestling match is already in progress",
      ['tuto'] = "To win, quickly press ",
      ['wait'] = "Waiting for an opponent",
    },
}