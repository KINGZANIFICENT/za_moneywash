-- client.lua
local QBCore = exports['qb-core']:GetCoreObject()
local notifyShown = false  -- Prevent spamming the notification prompt

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        -- Money Washing Section
        for _, loc in ipairs(Config.WashLocations) do
            local distance = #(playerCoords - loc)
            
            if distance < Config.MarkerDrawDistance then
                DrawMarker(1, loc.x, loc.y, loc.z - 1.0, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 0, 255, 0, 100, false, true, 2, false, false, false, false)
            end
            
            if distance < Config.InteractionDistance then
                if not notifyShown then
                    exports['za_notify']:ShowSubtitle("Press [ E ] to wash your money", 3000)
                    notifyShown = true
                end

                if IsControlJustPressed(0, 38) then
                    QBCore.Functions.Progressbar("washing_money", "Washing money...", Config.WashTime or 5000, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {}, {}, {}, 
                    function()  -- Success callback
                        TriggerServerEvent("za_moneywash:attemptWash")
                    end, 
                    function()  -- Cancel callback
                        exports['za_notify']:ShowSubtitle("Washing cancelled", 3000)
                    end)
                    Citizen.Wait(2000)
                end
            else
                notifyShown = false
            end
        end
        
        -- Teleport Points Section
        for _, teleport in ipairs(Config.TeleportPoints) do
            -- Entrance Marker and Interaction
            local entranceDistance = #(playerCoords - teleport.entrance)
            if entranceDistance < Config.MarkerDrawDistance then
                DrawMarker(1, teleport.entrance.x, teleport.entrance.y, teleport.entrance.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 0, 255, 100, false, true, 2, false, false, false, false)
            end

            if entranceDistance < Config.InteractionDistance then
                exports['za_notify']:ShowSubtitle("Press [ E ] to enter", 3000)
                if IsControlJustPressed(0, 38) then
                    SetEntityCoords(playerPed, teleport.exit.x, teleport.exit.y, teleport.exit.z)
                end
            end
            
            -- Exit Marker and Interaction
            local exitDistance = #(playerCoords - teleport.exit)
            if exitDistance < Config.MarkerDrawDistance then
                DrawMarker(1, teleport.exit.x, teleport.exit.y, teleport.exit.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
            end

            if exitDistance < Config.InteractionDistance then
                exports['za_notify']:ShowSubtitle("Press [ E ] to exit", 3000)
                if IsControlJustPressed(0, 38) then
                    SetEntityCoords(playerPed, teleport.entrance.x, teleport.entrance.y, teleport.entrance.z)
                end
            end
        end
    end
end)



