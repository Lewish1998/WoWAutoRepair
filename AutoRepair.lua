if not AutoRepairDB or AutoRepairDB.version ~= '1.1.0' then 
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

print('AutoRepair v1.2.0 loaded\nNote: Guild Repair is disabled by default\nType "/ar" to open the settings')

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
    -- print("Debug: Current personalRepair state: ", AutoRepairDB.personalRepair)
    -- print("Debug: Current ctd state: ", AutoRepairDB.costToDate)
    -- print("Debug: Current guildRepair state: ", AutoRepairDB.guildRepair)
    if AutoRepairDB.personalRepair == false then
        AutoRepairDB.personalRepair = true
        print("Personal repair enabled")
    elseif AutoRepairDB.personalRepair then
        print("Personal repair already enabled")
    end
end

local function disablePersonalRepair()
    -- print("Debug: Current personalRepair state: ", AutoRepairDB.personalRepair)
    if AutoRepairDB.personalRepair then
        AutoRepairDB.personalRepair = false
        print("Personal repair disabled")
    elseif AutoRepairDB.personalRepair == false then
        print("Personal repair already disabled")
    end
end

local function showHelp()
    print("Commands:\nEnable AutoRepair: /ar enable\nDisable AutoRepair: /ar disable\nEnable cost-to-date: /ar ctd enable\nDisable cost-to-date: /ar ctd disable\nPrint cost-to-date: /ar ctd\nEnable guild repair: /ar guild enable\nDisable guild repair: /ar guild disable\nEnable personal repair: /ar personal enable\nDisable personal repair: /ar personal disable")
end

-- Create the main frame
local uiFrame = CreateFrame("Frame", "AutoRepairUIFrame", UIParent, "BasicFrameTemplateWithInset")
uiFrame:SetSize(350, 500)
uiFrame:SetPoint("CENTER")

-- Enable mouse interaction for moving the frame
uiFrame:SetMovable(true)
uiFrame:EnableMouse(true)
uiFrame:RegisterForDrag("LeftButton")
uiFrame:SetScript("OnDragStart", uiFrame.StartMoving)
uiFrame:SetScript("OnDragStop", uiFrame.StopMovingOrSizing)

-- Title
uiFrame.title = uiFrame:CreateFontString(nil, "OVERLAY")
uiFrame.title:SetFontObject("GameFontHighlightLarge")
uiFrame.title:SetPoint("CENTER", uiFrame.TitleBg, "CENTER", 5, 0)
uiFrame.title:SetText("AutoRepair Settings")

-- Enable AutoRepair Button
local enableButton = CreateFrame("Button", nil, uiFrame, "GameMenuButtonTemplate")
enableButton:SetPoint("TOP", uiFrame, "TOP", 0, -40)
enableButton:SetSize(200, 40)
enableButton:SetText("Enable AutoRepair")
enableButton:SetNormalFontObject("GameFontNormalLarge")
enableButton:SetHighlightFontObject("GameFontHighlightLarge")
enableButton:SetScript("OnClick", function()
    enableAutoRepair()
end)

-- Disable AutoRepair Button
local disableButton = CreateFrame("Button", nil, uiFrame, "GameMenuButtonTemplate")
disableButton:SetPoint("TOP", enableButton, "BOTTOM", 0, -10)
disableButton:SetSize(200, 40)
disableButton:SetText("Disable AutoRepair")
disableButton:SetNormalFontObject("GameFontNormalLarge")
disableButton:SetHighlightFontObject("GameFontHighlightLarge")
disableButton:SetScript("OnClick", function()
    disableAutoRepair()
end)

-- Enable Cost-to-Date Button
local enableCTDButton = CreateFrame("Button", nil, uiFrame, "GameMenuButtonTemplate")
enableCTDButton:SetPoint("TOP", disableButton, "BOTTOM", 0, -10)
enableCTDButton:SetSize(200, 40)
enableCTDButton:SetText("Enable Cost-to-Date")
enableCTDButton:SetNormalFontObject("GameFontNormalLarge")
enableCTDButton:SetHighlightFontObject("GameFontHighlightLarge")
enableCTDButton:SetScript("OnClick", function()
    enableCostToDate()
end)

-- Disable Cost-to-Date Button
local disableCTDButton = CreateFrame("Button", nil, uiFrame, "GameMenuButtonTemplate")
disableCTDButton:SetPoint("TOP", enableCTDButton, "BOTTOM", 0, -10)
disableCTDButton:SetSize(200, 40)
disableCTDButton:SetText("Disable Cost-to-Date")
disableCTDButton:SetNormalFontObject("GameFontNormalLarge")
disableCTDButton:SetHighlightFontObject("GameFontHighlightLarge")
disableCTDButton:SetScript("OnClick", function()
    disableCostToDate()
end)

-- Enable Guild Repair Button
local enableGuildButton = CreateFrame("Button", nil, uiFrame, "GameMenuButtonTemplate")
enableGuildButton:SetPoint("TOP", disableCTDButton, "BOTTOM", 0, -10)
enableGuildButton:SetSize(200, 40)
enableGuildButton:SetText("Enable Guild Repair")
enableGuildButton:SetNormalFontObject("GameFontNormalLarge")
enableGuildButton:SetHighlightFontObject("GameFontHighlightLarge")
enableGuildButton:SetScript("OnClick", function()
    enableGuildRepair()
end)

-- Disable Guild Repair Button
local disableGuildButton = CreateFrame("Button", nil, uiFrame, "GameMenuButtonTemplate")
disableGuildButton:SetPoint("TOP", enableGuildButton, "BOTTOM", 0, -10)
disableGuildButton:SetSize(200, 40)
disableGuildButton:SetText("Disable Guild Repair")
disableGuildButton:SetNormalFontObject("GameFontNormalLarge")
disableGuildButton:SetHighlightFontObject("GameFontHighlightLarge")
disableGuildButton:SetScript("OnClick", function()
    disableGuildRepair()
end)

-- Enable Personal Repair Button
local enablePersonalButton = CreateFrame("Button", nil, uiFrame, "GameMenuButtonTemplate")
enablePersonalButton:SetPoint("TOP", disableGuildButton, "BOTTOM", 0, -10)
enablePersonalButton:SetSize(200, 40)
enablePersonalButton:SetText("Enable Personal Repair")
enablePersonalButton:SetNormalFontObject("GameFontNormalLarge")
enablePersonalButton:SetHighlightFontObject("GameFontHighlightLarge")
enablePersonalButton:SetScript("OnClick", function()
    enablePersonalRepair()
end)

-- Disable Personal Repair Button
local disablePersonalButton = CreateFrame("Button", nil, uiFrame, "GameMenuButtonTemplate")
disablePersonalButton:SetPoint("TOP", enablePersonalButton, "BOTTOM", 0, -10)
disablePersonalButton:SetSize(200, 40)
disablePersonalButton:SetText("Disable Personal Repair")
disablePersonalButton:SetNormalFontObject("GameFontNormalLarge")
disablePersonalButton:SetHighlightFontObject("GameFontHighlightLarge")
disablePersonalButton:SetScript("OnClick", function()
    disablePersonalRepair()
end)

-- Show the UI frame
uiFrame:Hide()

-- Create the help frame
local helpFrame = CreateFrame("Frame", "AutoRepairHelpFrame", UIParent, "BasicFrameTemplateWithInset")
helpFrame:SetSize(580, 500)
helpFrame:SetPoint("CENTER")
helpFrame:Hide()

-- Enable mouse interaction for moving the frame
helpFrame:SetMovable(true)
helpFrame:EnableMouse(true)
helpFrame:RegisterForDrag("LeftButton")
helpFrame:SetScript("OnDragStart", helpFrame.StartMoving)
helpFrame:SetScript("OnDragStop", helpFrame.StopMovingOrSizing)

-- Title for help frame
helpFrame.title = helpFrame:CreateFontString(nil, "OVERLAY")
helpFrame.title:SetFontObject("GameFontHighlightLarge")
helpFrame.title:SetPoint("CENTER", helpFrame.TitleBg, "CENTER", 5, 0)
helpFrame.title:SetText("AutoRepair Help")

-- Help content
local helpContent = helpFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
helpContent:SetPoint("TOPLEFT", 10, -40)
helpContent:SetPoint("BOTTOMRIGHT", -10, 10)
helpContent:SetJustifyH("LEFT")
helpContent:SetJustifyV("TOP")
helpContent:SetText([[
How to use:

* Type '/ar' in the chat window to open the settings.

* Enable / Disable AutoRepair:
  - Enable / disable the addon. No auto repairs will be actioned.

* Enable / Disable Cost-to-Date:
  - This will stop the cost-to-date messages showing in the chat box.

* Enable / Disable Guild Repair:
  - Pay for repairs using your allocated Guild repair fund.

* Enable / Disable Personal Repair:
  - Pay for repairs using your own funds.


If Guild Repair is enabled and Personal Repair is disabled, then only Guild funds will be used. If there are no Guild funds remaining then AutoRepair will not be actioned.

This works the same if Personal Repair is enabled and Guild Repair is disabled. Even if Guild funds are available, your personal funds will be used only.

If neither option is enabled, AutoRepair will not be actioned.


Thanks for using AutoRepair! :)

If you find any bugs or have any improvements or ideas, either leave a comment on Curse Forge, or feel free to fork the repo and apply your own changes!
]])

-- Help Button
local helpButton = CreateFrame("Button", nil, uiFrame, "GameMenuButtonTemplate")
helpButton:SetPoint("TOP", disablePersonalButton, "BOTTOM", 0, -10)
helpButton:SetSize(200, 40)
helpButton:SetText("Help")
helpButton:SetNormalFontObject("GameFontNormalLarge")
helpButton:SetHighlightFontObject("GameFontHighlightLarge")
helpButton:SetScript("OnClick", function()
    if helpFrame:IsShown() then
        helpFrame:Hide()
    else
        helpFrame:Show()
    end
end)

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
    ["help"] = function()
        if helpFrame:IsShown() then
            helpFrame:Hide()
        else
            helpFrame:Show()
        end
    end,
    [""] = function() uiFrame:Show() end
}

local function HandleSlashCommand(input)
    local command = commands[string.lower(input)]
    if command then
        command()
    else
        print("Invalid command. Hint: type /ar enable | disable to toggle AutoRepair.")
        print("Type /ar help to view all commands")
    end
end

SLASH_AUTOREPAIR1 = "/ar"
SlashCmdList["AUTOREPAIR"] = HandleSlashCommand