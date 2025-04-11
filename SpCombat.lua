-- Default profile text content
local profiles = {
    WARRIOR = "Warrior Profile:\n- Heroic Strike\n- Bloodthirst\n- Whirlwind\n...",
    PRIEST = "Priest Profile:\n- Shadow Word: Pain\n- Mind Flay\n- Power Word: Shield\n...",
    DRUID = "Druid Profile:\n- Wrath\n- Rejuvenation\n- Bear/Cat Form\n...",
    MAGE = "Mage Profile:\n- Frostbolt\n- Fireball\n- Arcane Explosion\n...",
}

-- Current selected class
local currentClass = "WARRIOR"

-- Update profile display
local function SpCombat_UpdateProfile(class)
    currentClass = class
    local text = profiles[class] or "Profile not found."
    SpCombatText:SetText(text)
end

-- Slash command
SLASH_SPCOMBAT1 = "/spcombat"
SLASH_SPCOMBAT2 = "/spc"
SlashCmdList["SPCOMBAT"] = function(msg)
    if SpCombatFrame:IsVisible() then
        SpCombatFrame:Hide()
    else
        SpCombatFrame:Show()
        SpCombat_UpdateProfile(currentClass)
    end
end
