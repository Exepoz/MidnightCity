DeleteTableList = {}

--[[

    List of SQL tables that you want to delete the character's records when the character is deleted by admin or user
    If you don't have some tables here, don't worry, you don't need to delete them, it won't give an error, you can add your own
    to see tables that are not there, you can see them in the server console if you set Config.Debug to true

--]]

-- Default QBCore Tables
DeleteTableList.Tables = {
    {table = 'players'},
    {table = 'apartments'},
    {table = 'bank_accounts'},
    {table = 'crypto_transactions'},
    {table = 'phone_invoices'},
    {table = 'phone_messages'},
    {table = 'playerskins'},
    {table = 'player_contacts'},
    {table = 'player_houses'},
    {table = 'player_mails'},
    {table = 'player_outfits'},
    {table = 'player_vehicles'}
}