local Translations = {
    houses = {
        ["title"]                  = 'Bee House',
        ["capturing"]              = 'Capturing Bees',
        ["queens"]                 = 'Queens (%{currentQueens} / %{maxQueens})',
        ["workers"]                = 'Workers (%{currentWorkers} / %{maxWorkers})',
        ["destroy"]                = 'Destroy Bee House',
        ["refresh"]                = 'Refresh',
        ["withdraw_queens"]        = 'Withdraw Queens',
        ["withdraw_workers"]       = 'Withdraw Workers',
        ["confirm_destroy"]        = 'Are you sure you want to delete this Bee House?',
    },
    hives = {
        ["title"]                  = 'Bee Hive',
        ["producing"]              = 'Producing Honey...',
        ["insert_queens"]          = 'Insert %{needed} Queen(s)',
        ["insert_workers"]         = 'Insert %{needed} Worker(s)',
        ["honey_level"]            = 'Honey Level [%{currentHoney} / %{maxHoney}]',
        ["wax_level"]              = 'Wax Level [%{currentWax} / %{maxWax}]',
        ["destroy"]                = 'Destroy Bee Hive',
        ["refresh"]                = 'Refresh',
        ["withdraw_honey"]         = 'Withdraw Honey',
        ["withdraw_wax"]           = 'Withdraw Wax',
        ["confirm_destroy"]        = 'Are you sure you want to delete this Bee Hive?',
    },
    target = {
        ["open_bee_house"]         = 'Bee House',
        ["open_bee_hive"]          = 'Bee Hive',
    },
    notifications = {
        ["title"]                  = 'Beekeeping',
        ["incorrect_ground"]       = 'You cannot place it here. The ground is incorrect.',
        ["already_placing"]        = 'You are already placing an object.',
        ["not_enough_bees"]        = 'There are not enough bees in the house.',
        ["not_enough_product"]     = 'There is not enough product in the hive.',
        ["house_error"]            = 'Error with the Bee House, please contact an admin.',
        ["hive_error"]             = 'Error with the Bee Hive, please contact an admin.',
        ["owner_error"]            = 'This bee hive/house does not have an owner, please contact an admin.',
        ["inventory_full_bees"]    = 'You do not have enough space in your inventory to gather the bees!',
        ["inventory_full_products"] = 'You do not have enough space in your inventory to gather the products!',
        ["not_enough_queens"]      = 'You do not have %{needed} queen(s) on you.',
        ["not_enough_workers"]     = 'You do not have %{needed} worker(s) on you.',
        ["no_access"]              = 'You are not the owner.',
        ["max_limit_reached"]      = 'You have reached the maximum number of hives/houses you can place.',
    },
    scaleforms = {
        ["cancel_button"]          = 'Cancel',
        ["place_button"]           = 'Place Object',
        ["rotate_button"]          = 'Rotate Object',
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})