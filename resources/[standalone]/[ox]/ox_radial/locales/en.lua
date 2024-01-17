local Translations = {
    error = {
        no_people_nearby = "No Players Nearby",
        no_vehicle_found = "No Vehicle Found",
        extra_deactivated = "Extra %{extra} Has Been Deactivated",
        extra_not_present = "Extra %{extra} Is Not Present on This Vehicle",
        not_driver = "You Are Not the Driver of the Vehicle",
        vehicle_driving_fast = "This Vehicle Is Moving Too Fast",
        race_harness_on = "You Have a Race Harness On; You Can't Switch",
        obj_not_found = "Could Not Create the Requested Object",
        not_near_ambulance = "You Are Not Near an Ambulance",
        far_away = "You Are Too Far Away",
        not_kidnapped = "You Did Not Kidnap This Person",
        trunk_closed = "The Trunk Is Closed",
        cant_enter_trunk = "You Can't Get In This Trunk",
        already_in_trunk = "You Are Already In The Trunk",
        cancel_task = "Task Cancelled",
        someone_in_trunk = "Someone Is Already In The Trunk",
        no_vehicle_nearby = "No Vehicle Nearby For Flipping."
    },
    progress = {
        flipping_car = "Flipping Vehicle..."
    },
    success = {
        extra_activated = "Extra %{extra} Has Been Activated",
        entered_trunk = "You're In The Trunk",
        flipped_car = "Vehicle Flipped Successfully!"
    },
    info = {
        no_variants = "There Don't Seem to Be Any Variants for This",
        wrong_ped = "This Ped Model Does Not Allow for This Option",
        nothing_to_remove = "You Don't Appear to Have Anything to Remove",
        already_wearing = "You Are Already Wearing That",
    },
    general = {
        command_description = "Open Radial Menu",
        get_out_trunk_button = "[E] Get Out Of The Trunk",
        close_trunk_button = "[G] Close The Trunk",
        open_trunk_button = "[G] Open The Trunk",
        getintrunk_command_desc = "Get In Trunk",
        putintrunk_command_desc = "Put Player In Trunk",
        gang_radial = "Gang",
        job_radial = "Job"
    },
    options = {
        flip = 'Flip Vehicle',
        vehicle = 'Vehicle',
        emergency_button = "Emergency Button",
        driver_seat = "Drivers Seat",
        passenger_seat = "Passenger Seat",
        other_seats = "Other Seat",
        rear_left_seat = "Rear Left Seat",
        rear_right_seat = "Rear Right Seat"
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
