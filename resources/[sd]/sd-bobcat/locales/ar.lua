local Translations = {
    error = {
        ["canceled"]                 = "أُلغي..",
        ["no_c4"]                    = "ليس لديك C4!",
        ["you_failed"]               = "لقد فشلت!",
        ["how_you_get_here"]         = "كيف وصلت إلى هنا؟",
        ["missing_something"]        = "تفتقد إلى الثرمايت.",
        ["missing_something2"]       = "ليست لديك البطاقة المطلوبة.",
        ["no_cops"]                  = "لا يوجد ما يكفي من الشرطة!",
        ["recently_robbed"]          = "تم سرقة هذا المكان مؤخرا!",
        ["cannot_use_here"]          = "لا يمكنك استخدام هذا العنصر هنا..",
        ["timer_too_high"] = "الحد الأقصى للوقت الممكن أن يكون هو:",
    },
    success = {
        ["planted_bomb"]             = "تم زرع العبوة الناسفة! ابتعد لمسافة آمنة!",
    },
    target = {
        ["place_bomb"]               = "زرع العبوات الناسفة",
        ["take_weapon"]              = "أخذ الأسلحة",
        ["take_ammo"]                = "أخذ الذخيرة",
        ["plant_thermite"]           = "زرع الثرمايت",
        ["swipe_card"]               = "اسحب البطاقة",
    },
    prints = {
        ["cooldown_started"]         = "BOBCAT: بدأت فترة التهدئة",
        ["cooldown_finished"]        = "BOBCAT: انتهت فترة التهدئة",
    },
    menu = {
        ["submit_text"] = "إرسال",
        ["enter_timer"] = "أدخل المؤقت (بالثواني):",
        ["bomb_timer"] = "مؤقت القنبلة",
        ["seconds"] = "ثواني",
    },
    progress = {
        ["looting_crate"]            = "سرقة الصندوق..",
    },   
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})