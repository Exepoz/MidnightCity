if Config.EnableWebhooks then
    local Webhooks = {
        ['WebhookURL'] = Config.Webhooks.WebhookURL,
    }

    local Colors = { -- https://www.spycolor.com/
        ['default'] = 14423100,
        ['blue'] = 255,
        ['red'] = 16711680,
        ['green'] = 65280,
        ['white'] = 16777215,
        ['black'] = 0,
        ['orange'] = 16744192,
        ['yellow'] = 16776960,
        ['pink'] = 16761035,
        ["lightgreen"] = 65309,
        -- ADD MORE HERE
    }

    RegisterNetEvent('qb-wheelstance:server:CreateLog', function(name, title, color, message, tagEveryone)
        local tag = tagEveryone or false
        local webHook = Webhooks[name] or Webhooks['default']
        local defaultImageURL =
        "https://www.freepnglogos.com/uploads/discord-logo-png/discord-logo-logodownload-download-logotipos-1.png"
        local headerImageURL = Config.Webhooks.HeaderImageURL

        -- Check if HeaderImageURL is not defined, empty, or contains uppercase letters, numbers, special characters, or underscores
        if not headerImageURL or headerImageURL == "" or string.match(headerImageURL, "[%u%d%W_]") then
            headerImageURL = defaultImageURL
        end

        local embedData = {
            {
                ['title'] = title,
                ['color'] = Colors[color] or Colors['default'],
                ['footer'] = {
                    ['text'] = os.date('%c'),
                },
                ['description'] = message,
                ['author'] = {
                    ['name'] = Config.Webhooks.LogHeader,
                    ['icon_url'] = headerImageURL,
                },
            }
        }

        PerformHttpRequest(webHook, function() end, 'POST',
            json.encode({ username = Config.Webhooks.LogHeader, embeds = embedData }),
            { ['Content-Type'] = 'application/json' })

        Citizen.Wait(100)

        if tag then
            PerformHttpRequest(webHook, function() end, 'POST',
                json.encode({ username = Config.Webhooks.LogHeader, content = '@everyone' }),
                { ['Content-Type'] = 'application/json' })
        end
    end)
end
