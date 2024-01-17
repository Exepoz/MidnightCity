local Translations = {
        error = {
            ["canceled"]                    = "ألغيت ..",
            ["done_recently"]               = "لقد فعلت ذلك مؤخرًا ، عد مرة أخرى قريبًا!",
            ["someone_recently_did_this"]   = "قام شخص ما بذلك مؤخرًا ..",
            ["cannot_do_this_right_now"]    = "لا يمكنك القيام بذلك الآن ..",
            ["does_not_speak"]              = "اجلب الطرد الآخر أولاً ..",
            ["get_out_vehicle"]             = "اخرج من سيارتك أولاً ..",
            ["bring_other_package"]         = "اجلب الطرد الآخر أولاً ..",
            ["what_do_you_want"]            = "ماذا تريد؟",
            ["you_cannot_do_this"]          = "لا يمكنك القيام بذلك ..",
            ["you_dont_have_enough_money"]  = "ليس لديك ما يكفي من المال ..",
            ["no_package"]                  = "أنت لا تحمل أي طرد ..",
            ["leave_area"]                  = "سيغادر عملاؤك إذا لم تبق في المنطقة ..",
            ["occupied_routes"]             = "جميع الطرق مشغولة حاليًا ، حاول مرة أخرى لاحقًا ..",
            ["missing_required_item"]       = "أنت تفتقد شيئًا..",
            ["you_robbed"]                  = "العميل يحاول القيادة بعيداً دون أن يعطيك أوكسي الخاص بك!",
            ["you_were_robbed"]             = "لقد غادر العميل دون أن يدفع لك بالأوكسي!",
            ["robbery_stopped"]             = "لقد نجحت في منع العميل من المغادرة دون أن يدفع لك بالأوكسي!",
        },
        success = {
            ["you_have_arrived"]            = "لقد وصلت إلى الموقع المحدد ، انتظر العملاء ..",
            ["drive_to_location"]           = "قد إلى الموقع المحدد على نظام تحديد المواقع الخاص بك ..",
            ["arrived_location"]            = "لقد وصلت إلى الموقع المحدد ، انتظر العملاء ..",
            ["suppliers_position"]          = "تم تحديد موقع المورد على نظام تحديد المواقع الخاص بك ..",
            ["send_email_right_now"]        = "سأرسل لك بريدًا إلكترونيًا الآن ..",
            ["start_run"]                   = "لقد سجلت ، احصل على سيارة ..",
            ["run_ended"]                   = "لقد انتهى العمل ..",
        },
        prints = {
            ["global_cooldown_started"] = "OXY RUN: بدأت فترة الانتظار",
            ["global_cooldown_finished"] = "OXY RUN: انتهت فترة الانتظار",
        },
        mailstart = {
            ["sender"]                      = "مجهول",
            ["subject"]                     = "توصيل خاص",
            ["message"]                     = "شكراً لمساعدتي ، ستتم مكافأتك بسخاء! ابحث عن سيارة حتى تتمكن من الوصول إلى المورد!",
        },
        mailfinish = {
            ["sender"]                      = "مجهول",
            ["subject"]                     = "توصيل خاص",
            ["message"]                     = "لقد قمت بمعروف كبير لي! عد إلي عندما تكون جاهزًا للمزيد!",
        },
        --
        target = {
            ["oxyboss"]                     = "تسجيل الدخول",
            ["oxysupplier"]                 = "الاستيلاء على الطرد",
            ["handoff_package"]             = "تسليم الطرد",
        },
        progress = {
            ["talking_to_boss"]             = "التحدث إلى الرئيس ..",
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})