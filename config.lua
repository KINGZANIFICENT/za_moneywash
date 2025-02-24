-- config.lua
Config = {}

-- Money wash locations
Config.WashLocations = {
    vector3(1122.36, -3194.44, -40.4),   -- Example Location 1
    -- Add additional locations as needed
}

Config.MarkerDrawDistance = 10.0
Config.InteractionDistance = 1.5
Config.TaxRate = 35.00  -- Example tax rate
Config.WashTime = 5000  -- Washing progress time

-- Teleport Points
Config.TeleportPoints = {
    {
        entrance = vector3(366.43, -1250.88, 32.7),  -- Teleport Entrance coordinate
        exit = vector3(1137.91, -3199.11, -39.67),             -- Teleport Exit coordinate
    },
    -- You can add more teleport pairs if needed
}
