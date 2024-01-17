Config = {}
Config.locale = {
  --js
  ["hook"] = "HOOK!",
  ["success"] = "SUCCESS",
  ["got_away2"] = "GOT AWAY",
  ["fail"] = "FAIL",
  ["fish_on"] = "FISH ON!",
  ["too_soon"] = "TOO EARLY!",
  ["controls_reel"] = "Hook/Reel",
  ["controls_exit"] = "Exit Fishing",
}

Config.difficulty = {
  ['easy'] = {                             --*I would probably not touch these, or save the original values if you do*
    tensionIncrease = { min = 35, max = 40 }, --speed of tension increase. lower = harder
    tensionDecrease = { min = 50, max = 55 }, --speed of tension decrease. lower = easier
    progressIncrease = { min = 1, max = 8 }, --speed of percent increase. lower = easier
    progressDecrease = { min = 50, max = 55 }, --speed of percent decrease. lower = harder
  },
  ['medium'] = {
    tensionIncrease = { min = 30, max = 35 },
    tensionDecrease = { min = 55, max = 60 },
    progressIncrease = { min = 5, max = 13 },
    progressDecrease = { min = 45, max = 50 },
  },
  ['hard'] = {
    tensionIncrease = { min = 25, max = 30 },
    tensionDecrease = { min = 60, max = 65 },
    progressIncrease = { min = 8, max = 17 },
    progressDecrease = { min = 40, max = 45 },
  },
}
