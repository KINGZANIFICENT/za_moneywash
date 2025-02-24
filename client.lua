
local QBCore = exports['qb-core']:GetCoreObject()
local notifyShown = false  

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        for _, loc in ipairs(Config.WashLocations) do
            local distance = #(playerCoords - loc)
            
            if distance < Config.MarkerDrawDistance then
                DrawMarker(1, loc.x, loc.y, loc.z - 1.0, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 0, 255, 0, 100, false, true, 2, false, false, false, false)
            end
            
            if distance < Config.InteractionDistance then
                if not notifyShown then
                    exports['za_notify']:ShowSubtitle("Press [ E ] to wash your money", 2000)
                    notifyShown = true
                end

                if IsControlJustPressed(0, 38) then
                    QBCore.Functions.Progressbar("washing_money", "Washing money...", Config.WashTime or 5000, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {}, {}, {}, 
                    function()   
                        TriggerServerEvent("za_moneywash:attemptWash")
                    end, 
                    function()  
                        exports['za_notify']:ShowSubtitle("Washing cancelled", 3000)
                    end)
                    Citizen.Wait(2000) 
                end
            else
                notifyShown = false
            end
        end
    end
end)


Citizen.CreateThread(function()
    for i, teleport in ipairs(Config.TeleportPoints) do
        exports['qb-target']:AddCircleZone("teleport_entrance_"..i, teleport.entrance, 1.5, {
            name = "teleport_entrance_"..i,
            debugPoly = false,
            useZ = true,
        }, {
            options = {
                {
                    event = "myteleport:enter",
                    icon = "fas fa-sign-in-alt",
                    label = "Enter",
                    teleportId = i,  
                },
            },
            distance = 2.5,
        })
        
        exports['qb-target']:AddCircleZone("teleport_exit_"..i, teleport.exit, 1.5, {
            name = "teleport_exit_"..i,
            debugPoly = false,
            useZ = true,
        }, {
            options = {
                {
                    event = "myteleport:exit",
                    icon = "fas fa-sign-out-alt",
                    label = "Exit",
                    teleportId = i,
                },
            },
            distance = 2.5,
        })
    end
end)


RegisterNetEvent('myteleport:enter', function(data)
    local teleportId = data.teleportId
    if teleportId and Config.TeleportPoints[teleportId] then
         local exitCoords = Config.TeleportPoints[teleportId].exit
         local playerPed = PlayerPedId()
         SetEntityCoords(playerPed, exitCoords.x, exitCoords.y, exitCoords.z)
    end
end)

RegisterNetEvent('myteleport:exit', function(data)
    local teleportId = data.teleportId
    if teleportId and Config.TeleportPoints[teleportId] then
         local entranceCoords = Config.TeleportPoints[teleportId].entrance
         local playerPed = PlayerPedId()
         SetEntityCoords(playerPed, entranceCoords.x, entranceCoords.y, entranceCoords.z)
    end
end)



