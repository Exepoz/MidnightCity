-- Webhook
local Webhook = Secure.Webhook

local Colors = {
    ['default'] = 14423100,
}

local logQueue = {}

RegisterNetEvent('sd_lib:CreateLog', function(name, title, color, message, tagEveryone)
    
    local tag = tagEveryone or false

    -- Check if webHook is defined
    if Webhook == nil or Webhook == "" then
        print("No webhook is defined sv_config.lua. Please define a webhook to receive logs or turn Config.EnableLogs to false to stop receiving these messages.")
        return
    end

    local embedData = {
        ['title'] = title,
        ['color'] = Colors[color] or Colors['default'],
        ['footer'] = {
            ['text'] = os.date('%c'),
        },
        ['description'] = message,
        ['author'] = {
            ['name'] = 'SD Logs',
            ['icon_url'] = 'https://cdn.discordapp.com/attachments/1002646303139958784/1137442128310567002/samueldevelopment-logo.png',
        },
    }

    if not logQueue[name] then logQueue[name] = {} end
    logQueue[name][#logQueue[name]+1] = {webhook = Webhook, data = {embedData}, content = tag}

    if #logQueue[name] >= 10 then
        sendQueue(name)
    end
end)

sendQueue = function(name)
    if #logQueue[name] > 0 then
        local postData = { username = 'SD Logs', embeds = {} }
        
        if logQueue[name][1].content then
            postData.content = '@everyone'
        end

        for i = 1, #logQueue[name] do
            postData.embeds[#postData.embeds+1] = logQueue[name][i].data[1]
        end

        PerformHttpRequest(logQueue[name][1].webhook, function(err, text, headers)
        end, 'POST', json.encode(postData), { ['Content-Type'] = 'application/json' })

        logQueue[name] = {}
    end
end

CreateThread(function()
    local timer = 0
    while true do
        Wait(1000)
        timer = timer + 1
        if timer >= Config.LogTime then -- If Config.LogTime seconds have passed, post the logs
            timer = 0
            for name, _ in pairs(logQueue) do
                sendQueue(name)
            end
        end
    end
end)