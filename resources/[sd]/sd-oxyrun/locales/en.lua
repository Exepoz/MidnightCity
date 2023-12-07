local Translations = {
        error = {
            ["canceled"]                    = "Canceled..",
            ["done_recently"]               = "You've done this recently, come back again soon!",
            ["someone_recently_did_this"]   = "Someone recently did this..",
            ["cannot_do_this_right_now"]    = "Cannot do this right now..",
            ["does_not_speak"]              = "Bring the other package away first..",
            ["get_out_vehicle"]             = "Get out of your vehicle first..",
            ["bring_other_package"]         = "Bring the other package away first..",
            ["what_do_you_want"]            = "What do you want?",
            ["you_cannot_do_this"]          = "You cannot do this..",
            ["you_dont_have_enough_money"]  = "You dont have enough money..",
            ["no_package"]                  = "You're are not holding a package..",
            ["leave_area"]                  = "Your customers will leave, if you don't stay in the area..",
            ["occupied_routes"]             = "All Routes are currently occupied, try again later..",
            ["missing_required_item"]       = "You're missing something..",
        },
        success = {
            ["you_have_arrived"]            = "You have arrived at the marked location, wait for customers..",
            ["drive_to_location"]           = "Drive to the Location marked on your GPS..",
            ["arrived_location"]            = "You have arrived at the marked location, wait for customers..",
            ["suppliers_position"]          = "The suppliers position has been marked on your GPS..",
            ["send_email_right_now"]        = "I will send you an e-mail right now..",
            ["start_run"]                   = "You've signed in, get yourself a vehicle..",
            ["run_ended"]                   = "Your run has ended..",
        },
        prints = {
            ["global_cooldown_started"] = "OXY RUN: Global Cooldown Started",
            ["global_cooldown_finished"] = "OXY RUN: Global Cooldown Finished",
        },
        -- Locales Used in qb-phone email event if Config.SendEmail is true.
        mailstart = {
            ["sender"]                      = "Unknown",
            ["subject"]                     = "Special Delievery",
            ["message"]                     = "Thanks for helping me out, you will be awarded generously! Find yourself a vehicle so you can get to the supplier!",
        },
        mailfinish = {
            ["sender"]                      = "Unknown",
            ["subject"]                     = "Special Delievery",
            ["message"]                     = "You have done me a great favour! Come back to me when you're ready for more!",
        },
        --
        target = {
            ["oxyboss"]                     = "Sign In",
            ["oxysupplier"]                 = "Grab Package",
            ["handoff_package"]             = "Handoff Package",
        },
        progress = {
            ["talking_to_boss"]             = "Talking to Boss..",
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})