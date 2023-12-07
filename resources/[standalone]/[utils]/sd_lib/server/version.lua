SD = SD or {}

-- Repository configurations
local repoConfig = {
    ["sd_lib"] = "https://api.github.com/repos/sd-versions/sd_lib/releases/latest",
    ["sd-oxyrun"] = "https://api.github.com/repos/sd-versions/sd-oxyrun/releases/latest",
    ["sd-pacificbank"] = "https://api.github.com/repos/sd-versions/sd-pacificbank/releases/latest",
    ["sd-bobcat"] = "https://api.github.com/repos/sd-versions/sd-bobcat/releases/latest",
    ["sd-oilrig"] = "https://api.github.com/repos/sd-versions/sd-oilrig/releases/latest",
    ["sd-cokemission"] = "https://api.github.com/repos/sd-versions/sd-cokemission/releases/latest",
    ["sd-warehouse"] = "https://api.github.com/repos/sd-versions/sd-warehouse/releases/latest",
    ["sd-yacht"] = "https://api.github.com/repos/sd-versions/sd-yacht/releases/latest",
    ["sd-beekeeping"] = "https://api.github.com/repos/sd-versions/sd-beekeeping/releases/latest",
}

-- Function to check the latest version of a resource against its current version
SD.VersionCheck = function()
    
    -- Attempt to get the name of the resource invoking this function
    local resourceName = GetInvokingResource()

    -- Fallback to the current resource name if the invoking resource is not identified
    if not resourceName or resourceName == "" then
        resourceName = GetCurrentResourceName()
    end
    
    -- Fetch the current version from the resource metadata
    local curVersion = GetResourceMetadata(resourceName, "Version")

    -- Get the repository URL for the current resource from the repoConfig
    local repoUrl = repoConfig[resourceName]

    -- If updates are enabled in the config and the repo URL exists, proceed to check for updates
    if Config.CheckForUpdates and repoUrl then
        PerformHttpRequest(repoUrl, function(errorCode, resultData, resultHeaders)
            if errorCode == 200 then
                local releaseData = json.decode(resultData)
                
                if releaseData then
                    -- Extract the latest release version and release notes
                    local releaseVersion = releaseData.tag_name
                    local releaseNotes = releaseData.body or "No release notes available."

                    -- Compare the latest version to the current version and print the result
                    if releaseVersion ~= curVersion then
                        -- Version mismatch indicates an update is available
                        print("^5==================================================================================^7")
                        print("^1[" .. resourceName .. "] - is NOT up to date! ^3Get the latest version from Keymaster!")
                        print("^0Current Version: ^1" .. curVersion .. "^0.")
                        print("^0New Version: ^4" .. releaseVersion .. "^0.")
                        print("^0Release Notes: ^6" .. releaseNotes)
                        print("^5==================================================================================^7")
                    elseif not Config.OnlyPrintWhenNew then
                        -- Print this message if no updates are available and if the config is set to print regardless
                        print("^5==================================================================================^7")
                        print("^2[" .. resourceName .. "] - No Updates Available^0.")
                        print("^0Current Version: ^4" .. curVersion .. "^0.")
                        print("^5==================================================================================^7")
                    end
                else
                    print("Failed to parse the JSON data.")
                end
            else
                print("Failed to fetch the latest release version from GitHub.")
            end
        end, "GET", "")
    elseif not repoUrl then
        -- If the repo URL is not found in the configuration, print this error
        print("No repository URL found for resource: " .. resourceName)
    end
end

SD.VersionCheck()