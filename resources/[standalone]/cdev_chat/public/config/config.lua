PublicSharedChatConfig = {
    -- 💬 Chat related configuration
    Chat = {
        -- 👀 How many messages can be visible in the chat history
        MessageHistoryLimit = 25,

        -- 📜 How many characters can be in a message (will be truncated if longer than this)
        MessageSizeLimit = 5000,

        -- 📷 Allow the player to pan the camera while the chatbox is open
        AllowPanCameraWhileChatboxOpen = true,

        -- ❌ Close the chatbox when the player sends a message
        CloseChatboxOnSend = false,
    },

    -- 📜 Chat Manager Menu related configuration
    ChatManager = {
        -- 👮 Permission level (see https://docs.cdev.shop/fivem/cdev-library under your framework page)
        PermissionLevel = PERMISSION_HIGH,

        -- 👮 ACE permission
        ACEPermission = "cdev_chat.manager",

        -- ⌨️ Command to open the menu
        Command = "chat",
    },

    -- 🎨 Chat theme colors, sizes, etc
    Theme = {
        PopUpBackgroundColor = "#EEC840",
        PopUpBackgroundShadow = "#EEC840",
        PopUpIconMentionBackgroundColor = "#FF2525",
        PopUpIconNewMessageBackgroundColor = "#EEC840",
        ChatboxBackgroundColor = "rgb(0 0 0 / 10%)",
        MessageIDBackgroundColor = "#EEC840",
        MessageIDTextColor = "#000",
        MessageTextColor = "#ffffff",
        MessageTextShadow = "0 0 2px black",
        InputBoxBackgroundColor = "rgba(0, 0, 0, 0.65)",
        InputBoxBorderColor = "rgba(255, 255, 255, 0.15)",
        MainContentChatWidth = "63rem",
        MessageBodyChatHeight = "23rem",
        IconTypeMessageSize = "3rem",
        IconIdMessageSize = "3rem",
        FontIdSizeMessage = "1.4rem",
        FontSizeMessage = "1.6rem",
        InputSizeMessage = "1.7rem 2rem",
        IconSendInputSize = "1.5rem",
        IconChannelSize = "3.5rem",
        MentionPeekTime = 2.5,
        MessagePeekTime = 1.5,
    },
    -- By default icons are automatically loaded from "data/icons/" folder, however if that's not working it will grab them from here
    FallbackIcons = {
        "alert.svg",
        "megaphone.svg",
        "message.svg",
        "person.svg",
    },

    MeAndDoCommand = {
        UseMeAndDoCommand = false, -- If you want to enable the /me and /do commands, set it to true.
        Offset = 1.0 -- Adjust this value as needed for the vertical position of the text
    }
}
