-- ********************************************************
-- **                      Memoria                       **
-- **            <http://www.cosmocanyon.de>             **
-- ********************************************************
--
-- This addon is written and copyrighted by:
--    * Mîzukichan @ EU-Antonidas (2010-2018)
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
function Memoria:OptionsSave()
    Memoria_Options.achievements = MemoriaOptions_NewAchievementCB:GetChecked()
    Memoria_Options.levelUp = MemoriaOptions_LevelUpCB:GetChecked()
    Memoria_Options.reputationChange = MemoriaOptions_ReputationChangeCB:GetChecked()
    Memoria_Options.reputationChangeOnlyExalted = MemoriaOptions_ReputationChangeExaltedOnlyCB:GetChecked()
    Memoria_Options.arenaEnding = MemoriaOptions_ArenaEndingCB:GetChecked()
    Memoria_Options.arenaEndingOnlyWins = MemoriaOptions_ArenaEndingWinsOnlyCB:GetChecked()
    Memoria_Options.battlegroundEnding = MemoriaOptions_BattlegroundEndingCB:GetChecked()
    Memoria_Options.battlegroundEndingOnlyWins = MemoriaOptions_BattlegroundEndingWinsOnlyCB:GetChecked()
    Memoria_Options.bosskills = MemoriaOptions_BosskillsCB:GetChecked()
    Memoria_Options.bosskillsFirstkill = MemoriaOptions_BosskillsFirstkillsCB:GetChecked()
    Memoria_Options.challengeDone = MemoriaOptions_ChallengeDoneCB:GetChecked()
    Memoria:RegisterEvents(MemoriaFrame)
end

function Memoria:OptionsRestore()
    MemoriaOptions_NewAchievementCB:SetChecked(Memoria_Options.achievements)
    MemoriaOptions_LevelUpCB:SetChecked(Memoria_Options.levelUp)
    MemoriaOptions_ReputationChangeCB:SetChecked(Memoria_Options.reputationChange)
    MemoriaOptions_ReputationChangeExaltedOnlyCB:SetChecked(Memoria_Options.reputationChangeOnlyExalted)
    MemoriaOptions_ArenaEndingCB:SetChecked(Memoria_Options.arenaEnding)
    MemoriaOptions_ArenaEndingWinsOnlyCB:SetChecked(Memoria_Options.arenaEndingOnlyWins)
    MemoriaOptions_BattlegroundEndingCB:SetChecked(Memoria_Options.battlegroundEnding)
    MemoriaOptions_BattlegroundEndingWinsOnlyCB:SetChecked(Memoria_Options.battlegroundEndingOnlyWins)
    MemoriaOptions_BosskillsCB:SetChecked(Memoria_Options.bosskills)
    MemoriaOptions_BosskillsFirstkillsCB:SetChecked(Memoria_Options.bosskillsFirstkill)
    MemoriaOptions_ChallengeDoneCB:SetChecked(Memoria_Options.challengeDone)
end

function Memoria:OptionsInitialize()
    -- parse localization
    MemoriaOptions_Title:SetText(Memoria.ADDONNAME.." v."..Memoria.ADDONVERSION)
    MemoriaOptions_EventsHeadline:SetText(Memoria.L["Take screenshot on"])
    MemoriaOptions_NewAchievementCB_Text:SetText(Memoria.L["new achievement"])
    MemoriaOptions_LevelUpCB_Text:SetText(Memoria.L["level up"])
    MemoriaOptions_ReputationChangeCB_Text:SetText(Memoria.L["new reputation level"])
    MemoriaOptions_ReputationChangeExaltedOnlyCB_Text:SetText(Memoria.L["exalted only"])
    MemoriaOptions_ArenaEndingCB_Text:SetText(Memoria.L["arena endings"])
    MemoriaOptions_ArenaEndingWinsOnlyCB_Text:SetText(Memoria.L["wins only"])
    MemoriaOptions_BattlegroundEndingCB_Text:SetText(Memoria.L["battleground endings"])
    MemoriaOptions_BattlegroundEndingWinsOnlyCB_Text:SetText(Memoria.L["wins only"])
    MemoriaOptions_BosskillsCB_Text:SetText(Memoria.L["bosskills"])
    MemoriaOptions_BosskillsFirstkillsCB_Text:SetText(Memoria.L["only after first kill"])
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
