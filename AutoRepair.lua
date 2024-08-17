if not AutoRepairDB then 
    AutoRepairDB = {
        totalRepairSpend = 0,
        enabled = true,
        constToDate = true,
        guildRepair = false,
        normalRepair = true
    }
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("MERCHANT_SHOW")

print("AutoRepair v1.1.0 loaded")
print("If you find AutoRepair useful, or want to see additional features, please leave a comment on Curse Forge!")

local function OnEvent(self, event, ...)
    if event == "MERCHANT_SHOW" and CanMerchantRepair() and AutoRepairDB.enabled then
        local repairCost = GetRepairAllCost()
        if repairCost > 0 and GetMoney() >= repairCost then
            RepairAllItems()
            AutoRepairDB.totalRepairSpend = AutoRepairDB.totalRepairSpend + repairCost
            print("All items repaired for " .. C_CurrencyInfo.GetCoinTextureString(repairCost))
            if AutoRepairDB.constToDate then
                print(string.format("Repair cost to date: %s", C_CurrencyInfo.GetCoinTextureString(AutoRepairDB.totalRepairSpend)))
            end
        elseif repairCost > 0 then
            print("Not enough money to repair items")
        end
    end
end

frame:SetScript("OnEvent", OnEvent)

local function enableAutoRepair()
    AutoRepairDB.enabled = true
    print("AutoRepair addon enabled")
end

local function disableAutoRepair()
    AutoRepairDB.enabled = false
    print("AutoRepair addon disabled")
end

local function printCostToDate()
    local TotalSpend = C_CurrencyInfo.GetCoinTextureString(AutoRepairDB.totalRepairSpend)
    print(string.format("Repair cost to date: %s", TotalSpend))
end

local function enableCostToDate()
    AutoRepairDB.constToDate = true
    print("Cost-to-date enabled")
end

local function disableCostToDate()
    AutoRepairDB.constToDate = false
    print("Cost-to-date disabled")
end

local function showHelp()
    print("Commands:\nEnable AutoRepair: /autorepair enable\nDisable AutoRepair: /autorepair disable\nEnable cost-to-date: /autorepair ctd enable\nDisable cost-to-date: /autorepair ctd disable\nPrint cost-to-date: /autorepair ctd")
end

local commands = {
    ["enable"] = enableAutoRepair,
    ["disable"] = disableAutoRepair,
    ["ctd"] = printCostToDate,
    ["ctd enable"] = enableCostToDate,
    ["ctd disable"] = disableCostToDate,
    ["help"] = showHelp
}

local function HandleSlashCommand(input)
    local command = commands[input]
    if command then
        command()
    else
        print("Invalid command. Hint: type /autorepair enable | disable to toggle AutoRepair.")
        print("Type /autorepair help to view all commands")
    end
end

SLASH_AUTOREPAIR1 = "/autorepair"
SlashCmdList["AUTOREPAIR"] = HandleSlashCommand
