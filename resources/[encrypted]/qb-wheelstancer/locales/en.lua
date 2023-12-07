local Translations = {
    error = {
        job = 'You do not have the Required Job',
        not_enough_money = 'You do not have enough Money',
        blacklisted = 'This Vehicle is Blacklisted / Not Allowed for Stance',
    },
    success = {
        cash_removed = 'Stanced Settings Applied Successfuly, Money Detucted From your Cash ',
        bank_removed = 'Stanced Settings Applied Successfuly, Money Detucted From your Bank',
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
