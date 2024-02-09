DeferralCards = exports['fivem-deferralCards']:DeferralCards()
local password = 'Chumash'
local passwordEntered = {}
GlobalState.passwordEntered = passwordEntered
function CheckPassword()
    return passwordCorrect
end exports('CheckPassword', CheckPassword)

AddEventHandler('playerConnecting', function(name, skr, d)
    local src = source
    d.defer()
    Wait(50)
    Citizen.CreateThread(function()
        local breakloop = false
        while true do
            local cardOne = DeferralCards.Card:Create({
                body = {
                    DeferralCards.CardElement:TextBlock({
                        size = 'ExtraLarge',
                        weight = 'Bolder',
                        text = 'Password Required to access the server'
                    }),
                    DeferralCards.CardElement:TextBlock({
                        text = "You can find the password in the server rules. Visit our discord at discord.gg/m-g-n to find our rules page.",
                        wrap = true
                    }),
                    DeferralCards.Input:Password({
                        id = 'password',
                        title = '',
                        placeholder = 'Password found in the rules.'
                    }),
                    DeferralCards.Container:ActionSet({
                        actions = {
                            DeferralCards.Action:Submit({
                                title = 'Submit Password'
                            }),
                        }
                    }),
                    DeferralCards.CardElement:Image({
                        url = 'https://cdn.discordapp.com/attachments/1089566581694140446/1190471562093142066/200x_centered.png?ex=65d0108a&is=65bd9b8a&hm=e02415feed807a46fa1de11fd425aeb7e7fc19057227c4075a4441ddad135bc2&',
                        altText = '',
                        horizontalAlignment = 'center,'
                    }),
                }
            })
            d.presentCard(cardOne, function(data, rawData)
                if data.password == password then
                    passwordEntered[src] = true
                    GlobalState.passwordEntered = passwordEntered
                    d.update('✅ Connecting to server...')
                    Wait(1000)
                    d.done()
                    print(('%s is joining the queue'):format(name))
                    breakloop = true
                end
            end)
            if breakloop then break end
            Wait(60000) break
        end
    end)
end)

-- AddEventHandler('playerConnecting', function(pName, pKickReason, pDeferrals)
--     local src = source

--     pDeferrals.defer()

--     Wait(1000)

--     CreateThread(function()
--         local breakLoop = false
--         while true do
--             local card = DeferralCards.Card:Create({
--                 body = {
--                     DeferralCards.Container:Create({
--                         items = {
--                             DeferralCards.CardElement:Image({
--                                 url = 'https://logos-world.net/wp-content/uploads/2021/03/FiveM-Logo.png',
--                                 size = 'large',
--                                 horizontalAlignment = 'center'
--                             }),
--                             DeferralCards.CardElement:TextBlock({
--                                 text = ('Welcome, %s'):format(pName),
--                                 weight = 'Light',
--                                 size = 'large',
--                                 horizontalAlignment = 'center'
--                             }),
--                             DeferralCards.Container:ActionSet({
--                                 actions = {
--                                     DeferralCards.Action:Submit({
--                                         id = 'submit_join',
--                                         title = 'Join'
--                                     })
--                                 }
--                             })
--                         },
--                         isVisible = true
--                     })
--                 }
--             })

--             pDeferrals.presentCard(card, function(pData, pRawData)
--                 if pData.submitId == 'submit_join' then
--                     pDeferrals.update('✅ Connecting to server...')
--                     Wait(1000)
--                     pDeferrals.done()
--                     print(('%s is connecting to the server'):format(pName))
--                     breakLoop = true
--                 end
--             end)

--             if breakLoop then break end

--             Wait(1000)
--         end
--     end)
-- end)