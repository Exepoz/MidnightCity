local Translations = {
    houses = {
        ["title"]                  = 'بيت النحل',
        ["capturing"]              = 'القبض على النحل',
        ["queens"]                 = 'الملكات (%{currentQueens} / %{maxQueens})',
        ["workers"]                = 'العاملات (%{currentWorkers} / %{maxWorkers})',
        ["destroy"]                = 'تدمير بيت النحل',
        ["refresh"]                = 'تحديث',
        ["withdraw_queens"]        = 'سحب الملكات',
        ["withdraw_workers"]       = 'سحب العاملات',
        ["confirm_destroy"]        = 'هل أنت متأكد أنك تريد حذف بيت النحل هذا؟',
    },
    hives = {
        ["title"]                  = 'خلية النحل',
        ["producing"]              = 'إنتاج العسل...',
        ["insert_queens"]          = 'إدخال %{needed} ملكة/ملكات',
        ["insert_workers"]         = 'إدخال %{needed} عامل/عاملات',
        ["honey_level"]            = 'مستوى العسل [%{currentHoney} / %{maxHoney}]',
        ["wax_level"]              = 'مستوى الشمع [%{currentWax} / %{maxWax}]',
        ["destroy"]                = 'تدمير خلية النحل',
        ["refresh"]                = 'تحديث',
        ["withdraw_honey"]         = 'سحب العسل',
        ["withdraw_wax"]           = 'سحب الشمع',
        ["confirm_destroy"]        = 'هل أنت متأكد أنك تريد حذف خلية النحل هذه؟',
    },
    target = {
        ["open_bee_house"]         = 'بيت النحل',
        ["open_bee_hive"]          = 'خلية النحل',
    },
    notifications = {
        ["title"]                  = 'تربية النحل',
        ["incorrect_ground"]       = 'لا يمكن وضعه هنا. الأرض غير صحيحة.',
        ["already_placing"]        = 'أنت بالفعل تضع شيئًا.',
        ["not_enough_bees"]        = 'لا يوجد عدد كافي من النحل في البيت.',
        ["not_enough_product"]     = 'لا يوجد منتج كافي في الخلية.',
        ["house_error"]            = 'خطأ في بيت النحل، يرجى الاتصال بمسؤول.',
        ["hive_error"]             = 'خطأ في خلية النحل، يرجى الاتصال بمسؤول.',
        ["owner_error"]            = 'ليس لهذا البيت/الخلية صاحب، يرجى الاتصال بمسؤول.',
        ["inventory_full_bees"]    = 'ليس لديك مساحة كافية في جعبتك لجمع النحل!',
        ["inventory_full_products"] = 'ليس لديك مساحة كافية في جعبتك لجمع المنتجات!',
        ["not_enough_queens"]      = 'ليس لديك %{needed} ملكة/ملكات معك.',
        ["not_enough_workers"]     = 'ليس لديك %{needed} عامل/عاملات معك.',
        ["no_access"]              = 'أنت لست المالك.',
        ["max_limit_reached"] = 'لقد وصلت إلى الحد الأقصى من الخلايا/المنازل التي يمكنك وضعها.'
    },
    scaleforms = {
        ["cancel_button"]          = 'إلغاء',
        ["place_button"]           = 'وضع الشيء',
        ["rotate_button"]          = 'تدوير الشيء',
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})