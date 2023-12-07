ChatResourceAPI = {}

-- 📛 Return the display ID for messages from a source
ChatResourceAPI.GetMessageID = function(source)
    return source
end

-- 🛂 Return the display name for messages from a source
ChatResourceAPI.GetMessageName = function(source)
    return clib.api.Character.GetCharacterNameFromSource(source)
end

-- 📨 Handle a message before it is sent to clients
---@param channel string The channel name
---@param message string The message
---@param mentions number[] The mentioned player IDs
---@return boolean . Whether the message should be sent to clients
ChatResourceAPI.HandleMessage = function(channel, message, mentions)
    return true
end

-- ❓ Return the initial suggestions for the chat
ChatResourceAPI.GetInitialSuggestions = function(source)
    if clib.config.isQBCore then
        clib.frameworks.QBCore.Commands.Refresh(source)
        return {}
    elseif clib.config.isESX then
        -- ESX.RegisteredCommands is inaccesible
        -- local _, mapped = table.mapNoKeys(clib.frameworks.ESX.RegisteredCommands, function(_, cmd)
        --     return cmd.suggestion
        -- end)

        -- return mapped
        return {}
    elseif clib.config.isCustom then
       -- 🔧 If using custom, implement your own code here
        return {}
    end
end

-- 📦 Database queries
ChatResourceAPI.Queries = {
    CheckIfChannelsTableExists = function()
        return #clib.db.Query("SHOW TABLES LIKE 'cdev_chat_channels'") > 0
    end,
    CreateChannelsTable = function()
        clib.db.Query([[
            CREATE TABLE IF NOT EXISTS `cdev_chat_channels` (
                `id` int(11) NOT NULL AUTO_INCREMENT,
                `name` varchar(50) NOT NULL DEFAULT '0',
                `icon` varchar(50) NOT NULL DEFAULT '0',
                `bgColor` varchar(50) NOT NULL DEFAULT '0',
                `allowMention` tinyint(4) NOT NULL DEFAULT 0,
                `restrictions` longtext NOT NULL,
                `range` int(11) NOT NULL DEFAULT 0,
                `enabled` tinyint(4) NOT NULL DEFAULT 0,
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
        ]])
    end,
    CreateDefaultChannels = function()
        local framework_god_permission = clib.config.isQBCore and "god" or "superadmin"
        local query = ([[
            INSERT INTO `cdev_chat_channels` (`id`, `name`, `icon`, `bgColor`, `allowMention`, `restrictions`, `range`, `enabled`) VALUES
            (1, 'OOC', 'message', '#EEC840', 1, '{"aces":{"write":[],"read":[]},"jobs":{"write":[],"read":[]},"permissions":{"write":[],"read":[]}}', -1, 1),
            (2, 'IC', 'person', '#40DEEE', 1, '{"jobs":{"read":[],"write":[]},"aces":{"read":[],"write":[]},"permissions":{"read":[],"write":[]}}', 100, 1),
            (3, 'Report', 'alert', '#EE40A4', 1, '{"permissions":{"read":["framework_god_permission"],"write":[]},"aces":{"read":[],"write":[]},"jobs":{"read":[],"write":[]}}', -1, 1),
            (4, 'Broadcast', 'megaphone', '#EE4040', 1, '{"permissions":{"write":["framework_god_permission"],"read":[]},"aces":{"write":[],"read":[]},"jobs":{"write":[],"read":[]}}', -1, 1);
        ]]):gsub("framework_god_permission", framework_god_permission)

        clib.db.Query(query)
    end,
    FetchChannels = function()
        return clib.db.Query("SELECT * FROM cdev_chat_channels")
    end,
    ---@param channel Channel
    CreateChannel = function(channel)
        return clib.db.Query("INSERT INTO cdev_chat_channels (name, icon, bgColor, allowMention, restrictions, `range`, enabled) VALUES (?, ?, ?, ?, ?, ?, ?)", {
            channel.name,
            channel.icon,
            channel.bgColor,
            channel.allowMention and 1 or 0,
            json.encode(channel.restrictions),
            channel.range,
            channel.enabled and 1 or 0,
        })
    end,
    ---@param channel Channel
    UpdateChannel = function(channel)
        return clib.db.Query("UPDATE cdev_chat_channels SET name = ?, icon = ?, bgColor = ?, allowMention = ?, restrictions = ?, `range` = ?, enabled = ? WHERE id = ?", {
            channel.name,
            channel.icon,
            channel.bgColor,
            channel.allowMention and 1 or 0,
            json.encode(channel.restrictions),
            channel.range,
            channel.enabled and 1 or 0,
            channel.id,
        })
    end,
    ---@param channelId number
    DeleteChannel = function(channelId)
        return clib.db.Query("DELETE FROM cdev_chat_channels WHERE id = ?", {
            channelId,
        })
    end,
}

if PublicSharedChatConfig.MeAndDoCommand.UseMeAndDoCommand then
    RegisterCommand('me', function(source, args)
        local playerName = ChatResourceAPI.GetMessageName(source)
        local message = table.concat(args, ' ')

        local chatMessage = {
            id = ChatResourceAPI.GetMessageID(source),
            channel = "OOC", -- You need to create a channel, and here you will put the exact name of the channel you have in the game.
            author = playerName,
            message = "* " .. playerName .. " " .. message .. " *",
            mentions = {},
        }

        TriggerClientEvent("cdev_chat:receiveMessage", -1, chatMessage)

        TriggerClientEvent("displayMeAboveHead", -1, source, message)
    end, false)

    RegisterCommand('do', function(source, args)
        local playerName = ChatResourceAPI.GetMessageName(source)
        local message = table.concat(args, ' ')

        local chatMessage = {
            id = ChatResourceAPI.GetMessageID(source),
            channel = "OOC", -- You need to create a channel, and here you will put the exact name of the channel you have in the game.
            author = playerName,
            message = "* " .. playerName .. " " .. message .. " *",
            mentions = {},
        }

        TriggerClientEvent("cdev_chat:receiveMessage", -1, chatMessage)

        TriggerClientEvent("displayDoAboveHead", -1, source, message)
    end, false)
end