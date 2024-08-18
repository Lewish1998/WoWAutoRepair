if not AutoRepairDB or AutoRepairDB.version == '1.1.0' then 
    local backupPersonalSpend = AutoRepairDB and AutoRepairDB.totalRepairSpendPersonal or 0
    local backupGuildSpend = AutoRepairDB and AutoRepairDB.totalRepairSpendGuild or 0

    AutoRepairDB = {
        version = '1.2.0',
        totalRepairSpendPersonal = backupPersonalSpend,
        totalRepairSpendGuild = backupGuildSpend,
        enabled = true,
        costToDate = true,
        guildRepair = false,
        personalRepair = true
    }
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("MERCHANT_SHOW")

print("AutoRepair v1.2.0 loaded")
print("If you find AutoRepair useful, or want to see additional features, please leave a comment on Curse Forge!")

local function guildRepairFunc(repairCost)
    RepairAllItems(true)
    AutoRepairDB.totalRepairSpendGuild = AutoRepairDB.totalRepairSpendGuild + repairCost
    print("All items repaired for " .. C_CurrencyInfo.GetCoinTextureString(repairCost) .. "(guild)")
end

local function personalRepairFunc(repairCost)
    if repairCost > 0 and GetMoney() >= repairCost then
        RepairAllItems()
        AutoRepairDB.totalRepairSpendPersonal = AutoRepairDB.totalRepairSpendPersonal + repairCost
        print("All items repaired for " .. C_CurrencyInfo.GetCoinTextureString(repairCost) .. "(personal)")
    elseif repairCost > 0 then
        print("Not enough money to repair items")
    end
end

local function printCostToDate()
    local TotalSpend = C_CurrencyInfo.GetCoinTextureString(AutoRepairDB.totalRepairSpendGuild + AutoRepairDB.totalRepairSpendPersonal) or C_CurrencyInfo.GetCoinTextureString(0)
    print(string.format("Repair cost to date: %s", TotalSpend))
end

local function OnEvent(self, event, ...)
    local repairCost = GetRepairAllCost()
    if event == "MERCHANT_SHOW" and CanMerchantRepair() and AutoRepairDB.enabled and repairCost > 0 then
        local totalRepair = AutoRepairDB.totalRepairSpendGuild + AutoRepairDB.totalRepairSpendPersonal

        if AutoRepairDB.guildRepair then
            guildRepairFunc(repairCost)
        elseif AutoRepairDB.personalRepair then
            personalRepairFunc(repairCost)
        end

        if AutoRepairDB.costToDate then
            printCostToDate()
        end
    end
end

frame:SetScript("OnEvent", OnEvent)

local function enableAutoRepair()
    if AutoRepairDB.enabled == false then
        AutoRepairDB.enabled = true
        print("AutoRepair enabled")
    elseif AutoRepairDB.enabled then
        print("AutoRepair is already enabled")
    end
end

local function disableAutoRepair()
    if AutoRepairDB.enabled then
        AutoRepairDB.enabled = false
        print("AutoRepair disabled")
    elseif AutoRepairDB.enabled == false then
        print("AutoRepair is already disabled")
    end
end

local function enableCostToDate()
    if AutoRepairDB.costToDate == false then
        AutoRepairDB.costToDate = true
        print("Cost-to-date enabled")
    elseif AutoRepairDB.costToDate then
        print("Cost-to-date already enabled")
    end
end

local function disableCostToDate()
    if AutoRepairDB.costToDate then
        AutoRepairDB.costToDate = false
        print("Cost-to-date disabled")
    elseif AutoRepairDB.costToDate == false then
        print("Cost-to-date already disabled")
    end
end

local function enableGuildRepair()
    if AutoRepairDB.guildRepair == false then
        AutoRepairDB.guildRepair = true
        print("Guild repair enabled")
    elseif AutoRepairDB.guildRepair then
        print("Guild repair already enabled")
    end
end

local function disableGuildRepair()
    if AutoRepairDB.guildRepair then
        AutoRepairDB.guildRepair = false
        print("Guild repair disabled")
    elseif AutoRepairDB.guildRepair == false then
        print("Guild repair already disabled")
    end
end

-- FIX
local function enablePersonalRepair()
    print("Debug: Current personalRepair state: ", AutoRepairDB.personalRepair)
    print("Debug: Current ctd state: ", AutoRepairDB.costToDate)
    print("Debug: Current guildRepair state: ", AutoRepairDB.guildRepair)
    if AutoRepairDB.personalRepair == false then
        AutoRepairDB.personalRepair = true
        print("Personal repair enabled")
    elseif AutoRepairDB.personalRepair then
        print("Personal repair already enabled")
    end
end

local function disablePersonalRepair()
    print("Debug: Current personalRepair state: ", AutoRepairDB.personalRepair)
    if AutoRepairDB.personalRepair then
        AutoRepairDB.personalRepair = false
        print("Personal repair disabled")
    elseif AutoRepairDB.personalRepair == false then
        print("Personal repair already disabled")
    end
end

local function showHelp()
    print("Commands:\nEnable AutoRepair: /autorepair enable\nDisable AutoRepair: /autorepair disable\nEnable cost-to-date: /autorepair ctd enable\nDisable cost-to-date: /autorepair ctd disable\nPrint cost-to-date: /autorepair ctd\nEnable guild repair: /autorepair guild enable\nDisable guild repair: /autorepair guild disable\nEnable personal repair: /autorepair personal enable\nDisable personal repair: /autorepair personal disable")
end

local function showDetail()
    print(string.format("Auto Repair Details\nVersion: %s\nAddon enabled: %s\nCost to date enabled: %s\nGuild repair enabled: %s\nPersonal repair enabled: %s", AutoRepairDB.version, tostring(AutoRepairDB.enabled), tostring(AutoRepairDB.costToDate), tostring(AutoRepairDB.guildRepair), tostring(AutoRepairDB.personalRepair)))
end

local commands = {
    ["enable"] = enableAutoRepair,
    ["disable"] = disableAutoRepair,
    ["ctd"] = printCostToDate,
    ["ctd enable"] = enableCostToDate,
    ["ctd disable"] = disableCostToDate,
    ["guild enable"] = enableGuildRepair,
    ["guild disable"] = disableGuildRepair,
    ["personal enable"] = enablePersonalRepair,
    ["personal disable"] = disablePersonalRepair,
    ["help"] = showHelp,
    ["detail"] = showDetail
}

local function HandleSlashCommand(input)
    local command = commands[string.lower(input)]
    if command then
        command()
    else
        print("Invalid command. Hint: type /autorepair enable | disable to toggle AutoRepair.")
        print("Type /autorepair help to view all commands")
    end
end

SLASH_AUTOREPAIR1 = "/autorepair"
SlashCmdList["AUTOREPAIR"] = HandleSlashCommand
