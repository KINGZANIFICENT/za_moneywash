

local QBCore = exports['qb-core']:GetCoreObject()
local debugMode = true  -- Set to false when done debugging

RegisterNetEvent("za_moneywash:attemptWash", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local inventory = Player.PlayerData.items
    local totalMarked = 0
    local removalItems = {}  

    if debugMode then
        print("---- Player Inventory Start ----")
        for slot, item in ipairs(inventory) do
            if item then
                print(string.format("Slot: %d | Name: %s | Amount: %d | Info: %s", slot, item.name, item.amount, json.encode(item.info)))
            end
        end
        print("---- Player Inventory End ----")
    end

for slot, item in pairs(inventory) do
    if item and item.name == "markedbills" and item.amount > 0 then
        local billValue = 0
        if item.info then
            if item.info.worth then
                billValue = tonumber(item.info.worth) or 0
            elseif item.info.value then
                billValue = tonumber(item.info.value) or 0
            end
        end

        if billValue == 0 then
            billValue = Config.DefaultBillValue or 300
            if debugMode then
                print(string.format("Slot %s: No valid worth/value found, using default value: %d", slot, billValue))
            end
        end

        if debugMode then
            print(string.format("Slot %s: Found markedbills - Value: %d", slot, billValue))
        end

        totalMarked = totalMarked + billValue
        table.insert(removalItems, {slot = slot, count = item.amount})
    end
end


    if totalMarked > 0 then
        
        local taxRate = Config.TaxRate or 10
        local taxAmount = math.floor(totalMarked * (taxRate / 100))
        local cleanedMoney = math.floor(totalMarked - taxAmount)
        
        
        for _, removal in ipairs(removalItems) do
            Player.Functions.RemoveItem("markedbills", removal.count, removal.slot)
        end
        
        
        Player.Functions.AddMoney("cash", cleanedMoney, "moneywashed")
        
        TriggerClientEvent("QBCore:Notify", src, 
            string.format("You washed your money! Total Value: %d, Tax Deducted: %d, Received: %d", 
                math.floor(totalMarked), 
                math.floor(taxAmount), 
                math.floor(cleanedMoney)
            ), 
            "success"
        )
    else
        TriggerClientEvent("QBCore:Notify", src, "You have no marked bills to wash.", "error")
    end
end)
