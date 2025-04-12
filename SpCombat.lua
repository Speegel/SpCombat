DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[SpCombat Loaded]|r")

local profiles = { "Warrior", "Priest", "Druid", "Mage", "Rogue", "Shaman" }
local function debug(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[SpCombat]|r " .. tostring(msg))
end
local profileFrames = {}
SpCombatDB = SpCombatDB or {}

local selectedProfile = SpCombatDB.lastProfile or "Warrior"

-- Create UI per profile
local function CreateProfileFrame(profile)
    local parent = SpCombatProfileContainer
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetAllPoints()
    frame:Hide()

    -- Checkboxes
    for i = 1, 4 do
        local cb = CreateFrame("CheckButton", nil, frame, "ChatConfigCheckButtonTemplate")
        cb:SetPoint("TOPLEFT", 20, -10 - ((i - 1) * 25))
        getglobal(cb:GetName() .. "Text"):SetText("Option " .. i)
    end

    -- Sliders
    for i = 1, 2 do
        local slider = CreateFrame("Slider", nil, frame, "OptionsSliderTemplate")
        slider:SetMinMaxValues(0, 100)
        slider:SetValue(50)
        slider:SetWidth(200)
        slider:SetPoint("CENTER", 0, -20 - ((i - 1) * 40))
        getglobal(slider:GetName() .. "Low"):SetText("0")
        getglobal(slider:GetName() .. "High"):SetText("100")
        getglobal(slider:GetName() .. "Text"):SetText("Slider " .. i)
    end

    profileFrames[profile] = frame
end

-- Create all profile UIs
for _, profile in ipairs(profiles) do
    CreateProfileFrame(profile)
end

-- Show selected profile
local function SetProfile(profile)
    selectedProfile = profile
    SpCombatDB.lastProfile = profile

    for _, f in pairs(profileFrames) do
        f:Hide()
    end

    if profileFrames[profile] then
        profileFrames[profile]:Show()
        debug("Switched to profile: " .. profile)
    end
end

-- Dropdown
UIDropDownMenu_Initialize(SpCombatDropdown, function()
    for _, profile in ipairs(profiles) do
        local info = {}
        info.text = profile
        info.func = function()
            UIDropDownMenu_SetSelectedName(SpCombatDropdown, profile)
            SetProfile(profile)
        end
        UIDropDownMenu_AddButton(info)
    end
end)

-- Minimap Button
do
    local btn = CreateFrame("Button", "SpCombatMinimapButton", Minimap)
    btn:SetSize(32, 32)
    btn:SetPoint("TOPLEFT", Minimap, "TOPLEFT")

    local icon = btn:CreateTexture(nil, "BACKGROUND")
    icon:SetAllPoints()
    icon:SetTexture("Interface\\Icons\\INV_Sword_27")

    btn:SetScript("OnEnter", function()
        GameTooltip:SetOwner(btn, "ANCHOR_TOP")
        GameTooltip:AddLine("SpCombat")
        GameTooltip:AddLine("Left-click: Choose Profile")
        GameTooltip:AddLine("Right-click: Toggle UI")
        GameTooltip:Show()
    end)

    btn:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    btn:SetScript("OnMouseUp", function(_, button)
        if button == "RightButton" then
            SpCombatFrame:SetShown(not SpCombatFrame:IsShown())
            debug("Toggled SpCombatFrame: " .. tostring(SpCombatFrame:IsShown()))
        else
            ToggleDropDownMenu(1, nil, SpCombatDropdown, btn, 0, 0)
            debug("Opened dropdown menu")
        end
    end)
end

-- Slash Command
SLASH_SPCOMBAT1 = "/spcombat"
SlashCmdList["SPCOMBAT"] = function()
    SpCombatFrame:SetShown(not SpCombatFrame:IsShown())
end

-- Init on login
local event = CreateFrame("SpCombatFrame")
event:RegisterEvent("PLAYER_LOGIN")
event:SetScript("OnEvent", function()
    SetProfile(selectedProfile)
    UIDropDownMenu_SetSelectedName(SpCombatDropdown, selectedProfile)
    debug("Addon loaded. Current profile: " .. selectedProfile)
end)

-- Close button functionality
SpCombatCloseButton:SetScript("OnClick", function()
    SpCombatFrame:Hide()
end)
