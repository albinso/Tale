-- ********************************************************
-- **                      Memoria                       **
-- **            <http://www.cosmocanyon.de>             **
-- ********************************************************
--
-- This addon is written and copyrighted by:
--    * Mîzukichan @ EU-Antonidas (2010-2019)
--
--
--    This file is part of Memoria.
--
--    Memoria is free software: you can redistribute it and/or 
--    modify it under the terms of the GNU General Public License as 
--    published by the Free Software Foundation, either version 3 of the 
--    License, or (at your option) any later version.
--
--    Memoria is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with Memoria.  
--    If not, see <http://www.gnu.org/licenses/>.
--

-- Check for addon table
if (not Memoria) then Memoria = {}; end
local Memoria = Memoria;


----------------------
--  Option Handler  --
----------------------
function Memoria:OptionsEnableDisable(cbFrame)
    local enable = cbFrame:GetChecked() and cbFrame:IsEnabled()
    local colorEnable = {1, 1, 1, 1}
    local colorDisable = {0.5, 0.5, 0.5, 1}
    local children = {cbFrame:GetChildren()}
    local text = getglobal(cbFrame:GetName() .. "_Text")
    if (cbFrame:IsEnabled()) then
        text:SetTextColor(unpack(colorEnable))
    else
       text:SetTextColor(unpack(colorDisable))
    end
    for i = 1, #children do
        text = getglobal(children[i]:GetName() .. "_Text")
        if (enable) then
            children[i]:Enable()
            text:SetTextColor(unpack(colorEnable))
        else
            children[i]:Disable()
            text:SetTextColor(unpack(colorDisable))
        end
        Memoria:OptionsEnableDisable(children[i])
    end
end

function Memoria:OptionsSave()
    Memoria_Options.achievements = MemoriaOptions_NewAchievementCB:GetChecked()
    Memoria_Options.levelUp = MemoriaOptions_LevelUpCB:GetChecked()
    Memoria_Options.levelUpShowPlayed = MemoriaOptions_LevelUpCB_ShowPlayedCB:GetChecked()
    Memoria_Options.resizeChat = MemoriaOptions_LevelUpCB_ShowPlayedCB_ResizeChatCB:GetChecked()
    Memoria_Options.reputationChange = MemoriaOptions_ReputationChangeCB:GetChecked()
    Memoria_Options.reputationChangeOnlyExalted = MemoriaOptions_ReputationChangeCB_ExaltedOnlyCB:GetChecked()
    Memoria_Options.arenaEnding = MemoriaOptions_ArenaEndingCB:GetChecked()
    Memoria_Options.arenaEndingOnlyWins = MemoriaOptions_ArenaEndingCB_WinsOnlyCB:GetChecked()
    Memoria_Options.battlegroundEnding = MemoriaOptions_BattlegroundEndingCB:GetChecked()
    Memoria_Options.battlegroundEndingOnlyWins = MemoriaOptions_BattlegroundEndingCB_WinsOnlyCB:GetChecked()
    Memoria_Options.bosskills = MemoriaOptions_BosskillsCB:GetChecked()
    Memoria_Options.bosskillsFirstkill = MemoriaOptions_BosskillsCB_FirstkillsCB:GetChecked()
    Memoria_Options.challengeDone = MemoriaOptions_ChallengeDoneCB:GetChecked()
    Memoria:RegisterEvents(MemoriaFrame)
end

function Memoria:OptionsRestore()
    local IsRetail = tonumber(string.sub(GetBuildInfo(), 1, 1)) > 1
    if (not IsRetail) then
        MemoriaOptions_NewAchievementCB:Disable()
        MemoriaOptions_ArenaEndingCB:Disable()
        MemoriaOptions_ChallengeDoneCB:Disable()
    end
    MemoriaOptions_NewAchievementCB:SetChecked(Memoria_Options.achievements)
    Memoria:OptionsEnableDisable(MemoriaOptions_NewAchievementCB)
    MemoriaOptions_LevelUpCB:SetChecked(Memoria_Options.levelUp)
    MemoriaOptions_LevelUpCB_ShowPlayedCB:SetChecked(Memoria_Options.levelUpShowPlayed)
    MemoriaOptions_LevelUpCB_ShowPlayedCB_ResizeChatCB:SetChecked(Memoria_Options.resizeChat)
    Memoria:OptionsEnableDisable(MemoriaOptions_LevelUpCB)
    MemoriaOptions_ReputationChangeCB:SetChecked(Memoria_Options.reputationChange)
    MemoriaOptions_ReputationChangeCB_ExaltedOnlyCB:SetChecked(Memoria_Options.reputationChangeOnlyExalted)
    Memoria:OptionsEnableDisable(MemoriaOptions_ReputationChangeCB)
    MemoriaOptions_ArenaEndingCB:SetChecked(Memoria_Options.arenaEnding)
    MemoriaOptions_ArenaEndingCB_WinsOnlyCB:SetChecked(Memoria_Options.arenaEndingOnlyWins)
    Memoria:OptionsEnableDisable(MemoriaOptions_ArenaEndingCB)
    MemoriaOptions_BattlegroundEndingCB:SetChecked(Memoria_Options.battlegroundEnding)
    MemoriaOptions_BattlegroundEndingCB_WinsOnlyCB:SetChecked(Memoria_Options.battlegroundEndingOnlyWins)
    Memoria:OptionsEnableDisable(MemoriaOptions_BattlegroundEndingCB)
    MemoriaOptions_BosskillsCB:SetChecked(Memoria_Options.bosskills)
    MemoriaOptions_BosskillsCB_FirstkillsCB:SetChecked(Memoria_Options.bosskillsFirstkill)
    Memoria:OptionsEnableDisable(MemoriaOptions_BosskillsCB)
    MemoriaOptions_ChallengeDoneCB:SetChecked(Memoria_Options.challengeDone)
    Memoria:OptionsEnableDisable(MemoriaOptions_ChallengeDoneCB)
end

function Memoria:OptionsInitialize()
    -- parse localization
    MemoriaOptions_Title:SetText(Memoria.ADDONNAME.." v."..Memoria.ADDONVERSION)
    MemoriaOptions_EventsHeadline:SetText(Memoria.L["Take screenshot on"])
    MemoriaOptions_NewAchievementCB_Text:SetText(Memoria.L["new achievement"])
    MemoriaOptions_LevelUpCB_Text:SetText(Memoria.L["level up"])
    MemoriaOptions_LevelUpCB_ShowPlayedCB_Text:SetText(Memoria.L["show played"])
    MemoriaOptions_LevelUpCB_ShowPlayedCB_ResizeChatCB_Text:SetText(Memoria.L["resize chat window"])
    MemoriaOptions_ReputationChangeCB_Text:SetText(Memoria.L["new reputation level"])
    MemoriaOptions_ReputationChangeCB_ExaltedOnlyCB_Text:SetText(Memoria.L["exalted only"])
    MemoriaOptions_ArenaEndingCB_Text:SetText(Memoria.L["arena endings"])
    MemoriaOptions_ArenaEndingCB_WinsOnlyCB_Text:SetText(Memoria.L["wins only"])
    MemoriaOptions_BattlegroundEndingCB_Text:SetText(Memoria.L["battleground endings"])
    MemoriaOptions_BattlegroundEndingCB_WinsOnlyCB_Text:SetText(Memoria.L["wins only"])
    MemoriaOptions_BosskillsCB_Text:SetText(Memoria.L["bosskills"])
    MemoriaOptions_BosskillsCB_FirstkillsCB_Text:SetText(Memoria.L["only after first kill"])
    MemoriaOptions_ChallengeDoneCB_Text:SetText(Memoria.L["challenge instance endings"])
    -- parse current options
    Memoria:OptionsRestore()
end


----------------------
--  Register panel  --
----------------------
Memoria.OptionPanel = CreateFrame("Frame", "MemoriaOptions", UIParent, "MemoriaOptionsTemplate")
Memoria.OptionPanel.name = "Memoria"
Memoria.OptionPanel.okay = function() Memoria:OptionsSave() end
Memoria.OptionPanel.cancel = function() Memoria:OptionsRestore() end
InterfaceOptions_AddCategory(Memoria.OptionPanel)
