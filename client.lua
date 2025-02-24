-- client.lua
local QBCore = exports['qb-core']:GetCoreObject()
local notifyShown = false  -- Prevent spamming the notification prompt

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        for _, loc in ipairs(Config.WashLocations) do
            local distance = #(playerCoords - loc)
            
            -- Draw marker when within draw distance
            if distance < Config.MarkerDrawDistance then
                DrawMarker(1, loc.x, loc.y, loc.z - 1.0, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 0, 255, 0, 100, false, true, 2, false, false, false, false)
            end
            
            if distance < Config.InteractionDistance then
                -- Show the prompt using za_notify if not already shown
                if not notifyShown then
                    exports['za_notify']:ShowSubtitle("Press [ E ] to wash your money", 3000)
                    notifyShown = true
                end

                -- When player presses E (INPUT_CONTEXT, code 38)
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
                    Citizen.Wait(2000) -- Prevent spamming
                end
            else
                notifyShown = false
            end
        end
    end
end)


