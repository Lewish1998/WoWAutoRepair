if not AutoRepairDB then 
    AutoRepairDB = {totalRepairSpend = 0}
end

local AutoRepairDB

local frame = CreateFrame("Frame")

frame:RegisterEvent("MERCHANT_SHOW")

print("AutoRepair addon loaded")

local function OnEvent(self, event, ...)
    if event == "MERCHANT_SHOW" and CanMerchantRepair() then
        local repairCost = GetRepairAllCost()
        if repairCost > 0 and GetMoney() >= repairCost then
            RepairAllItems()
            print("All items repaired for " .. C_CurrencyInfo.GetCoinTextureString(repairCost))
        elseif repairCost > 0 then
            print("Not enough money to repair items")
        end
    end
end

frame:SetScript("OnEvent", OnEvent)