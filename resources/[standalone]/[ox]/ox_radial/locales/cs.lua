local Translations = {
    error = {
        no_people_nearby = "Žádní hráči v okolí",
        no_vehicle_found = "Nenalezeno žádné vozidlo",
        extra_deactivated = "Dodatek %{extra} byl deaktivován",
        extra_not_present = "Dodatek %{extra} na tomto vozidle není k dispozici",
        not_driver = "Nejste řidičem tohoto vozidla",
        vehicle_driving_fast = "Toto vozidlo jede příliš rychle",
        seat_occupied = "Tento sedadlo je obsazeno",
        race_harness_on = "Máte nasazený závodní postroj, nemůžete přepnout",
        obj_not_found = "Nepodařilo se vytvořit požadovaný objekt",
        not_near_ambulance = "Nejste poblíž sanitky",
        far_away = "Jste příliš daleko",
        not_kidnapped = "Tuto osobu jste neunesl",
        trunk_closed = "Kufr je zavřený",
        cant_enter_trunk = "Do tohoto kufru nemůžete vstoupit",
        already_in_trunk = "Již jste v kufru",
        cancel_task = "Zrušeno",
        someone_in_trunk = "V kufru je již někdo jiný"
    },
    progress = {
        flipping_car = "Převracení vozidla.."
    },
    success = {
        extra_activated = "Dodatek %{extra} byl aktivován",
        entered_trunk = "Jste v kufru"
    },
    info = {
        no_variants = "Nezdá se, že by zde byly varianty pro tento model",
        wrong_ped = "Tento model postavy neumožňuje tuto možnost",
        nothing_to_remove = "Nezdá se, že byste měli něco, co by šlo odstranit",
        already_wearing = "To již máte na sobě",
        switched_seats = "Nyní jste na sedadle %{seat}"
    },
    general = {
        command_description = "Otevřít radiální menu",
        get_out_trunk_button = "[E] Vystoupit z kufru",
        close_trunk_button = "[G] Zavřít kufr",
        open_trunk_button = "[G] Otevřít kufr",
        getintrunk_command_desc = "Nastoupit do kufru",
        putintrunk_command_desc = "Umístit hráče do kufru",
        gang_radial = "Gang",
        job_radial = "Práce"
    },
    options = {
        flip = 'Převrátit vozidlo',
        vehicle = 'Vozidlo',
        emergency_button = "Nouzové tlačítko",
        driver_seat = "Řidičovo sedadlo",
        passenger_seat = "Sedadlo spolujezdce",
        other_seats = "Ostatní sedadla",
        rear_left_seat = "Zadní levé sedadlo",
        rear_right_seat = "Zadní pravé sedadlo"
    },
}

if GetConvar('qb_locale', 'en') == 'cs' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
--translate by stepan_valic