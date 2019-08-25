-- ********************************************************
-- **                      Tale                       **
-- ********************************************************
--
-- This addon is written and copyrighted by:
--    * Mîzukichan @ EU-Antonidas (2010-2019)
--    * Albin Johansson (2019)
--
--
--    This file is part of Tale, a fork of Memoria.
--
--    Tale is free software: you can redistribute it and/or 
--    modify it under the terms of the GNU General Public License as 
--    published by the Free Software Foundation, either version 3 of the 
--    License, or (at your option) any later version.
--
--    Tale is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with Tale.  
--    If not, see <http://www.gnu.org/licenses/>.
--

-- Check for addon table
if (not Tale) then Tale = {}; end
local Tale = Tale;


----------------------
--  Option Handler  --
----------------------
function Tale:OptionsEnableDisable(cbFrame)
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
        Tale:OptionsEnableDisable(children[i])
    end
end

function Tale:OptionsSave()

    Tale_Options.levelUp = TaleOptions_Options_LevelUpCB:GetChecked()
    Tale_Options.levelUpShowPlayed = TaleOptions_Options_LevelUpCB_ShowPlayedCB:GetChecked()
    Tale_Options.resizeChat = TaleOptions_Options_LevelUpCB_ShowPlayedCB_ResizeChatCB:GetChecked()
    Tale_Options.reputationChange = TaleOptions_Options_ReputationChangeCB:GetChecked()
    Tale_Options.reputationChangeOnlyExalted = TaleOptions_Options_ReputationChangeCB_ExaltedOnlyCB:GetChecked()
    Tale_Options.battlegroundEnding = TaleOptions_Options_BattlegroundEndingCB:GetChecked()
    Tale_Options.battlegroundEndingOnlyWins = TaleOptions_Options_BattlegroundEndingCB_WinsOnlyCB:GetChecked()
    Tale_Options.bosskills = TaleOptions_Options_BosskillsCB:GetChecked()
    Tale_Options.bosskillsFirstkill = TaleOptions_Options_BosskillsCB_FirstkillsCB:GetChecked()
    Tale_Options.levelUpLog = TaleOptions_Options_LevelUpLogCB:GetChecked()
    Tale_Options.bosskillsLog = TaleOptions_Options_BosskillsLogCB:GetChecked()
    Tale_Options.deathLog = TaleOptions_Options_DeathLogCB:GetChecked()
    Tale_Options.death = TaleOptions_Options_DeathCB:GetChecked()
    Tale_Options.battlegroundEndingLog = TaleOptions_Options_BattlegroundEndingLogCB:GetChecked()
    Tale_Options.pvpKillsLog = TaleOptions_Options_PvPKillLogCB:GetChecked()
    Tale_Options.pvpKills = TaleOptions_Options_PvPKillCB:GetChecked()
    Tale_Options.logInterval = math.floor(TaleOptions_Options_LogIntervalSlider:GetValue())
    Tale_Options.questTurnInLog = TaleOptions_Options_QuestTurnInLogCB:GetChecked()
    Tale_Options.killsLog = TaleOptions_Options_KillsLogCB:GetChecked()

    Tale:RegisterEvents(TaleFrame)
end

function Tale:OptionsRestore()
    TaleOptions_Options_LevelUpCB:SetChecked(Tale_Options.levelUp)
    TaleOptions_Options_LevelUpCB_ShowPlayedCB:SetChecked(Tale_Options.levelUpShowPlayed)
    TaleOptions_Options_LevelUpCB_ShowPlayedCB_ResizeChatCB:SetChecked(Tale_Options.resizeChat)
    Tale:OptionsEnableDisable(TaleOptions_Options_LevelUpCB)
    TaleOptions_Options_ReputationChangeCB:SetChecked(Tale_Options.reputationChange)
    TaleOptions_Options_ReputationChangeCB_ExaltedOnlyCB:SetChecked(Tale_Options.reputationChangeOnlyExalted)
    Tale:OptionsEnableDisable(TaleOptions_Options_ReputationChangeCB)
    TaleOptions_Options_BattlegroundEndingCB:SetChecked(Tale_Options.battlegroundEnding)
    TaleOptions_Options_BattlegroundEndingCB_WinsOnlyCB:SetChecked(Tale_Options.battlegroundEndingOnlyWins)
    Tale:OptionsEnableDisable(TaleOptions_Options_BattlegroundEndingCB)
    TaleOptions_Options_BosskillsCB:SetChecked(Tale_Options.bosskills)
    TaleOptions_Options_BosskillsCB_FirstkillsCB:SetChecked(Tale_Options.bosskillsFirstkill)
    Tale:OptionsEnableDisable(TaleOptions_Options_BosskillsCB)
    
    TaleOptions_Options_LevelUpLogCB:SetChecked(Tale_Options.levelUpLog)
    Tale:OptionsEnableDisable(TaleOptions_Options_LevelUpLogCB)

    TaleOptions_Options_BosskillsLogCB:SetChecked(Tale_Options.bosskillsLog)
    Tale:OptionsEnableDisable(TaleOptions_Options_BosskillsLogCB)

    TaleOptions_Options_DeathLogCB:SetChecked(Tale_Options.deathLog)
    Tale:OptionsEnableDisable(TaleOptions_Options_DeathLogCB)
    
    TaleOptions_Options_DeathCB:SetChecked(Tale_Options.death)
    Tale:OptionsEnableDisable(TaleOptions_Options_DeathCB)

    TaleOptions_Options_BattlegroundEndingLogCB:SetChecked(Tale_Options.battlegroundEndingLog)
    Tale:OptionsEnableDisable(TaleOptions_Options_BattlegroundEndingLogCB)

    TaleOptions_Options_PvPKillCB:SetChecked(Tale_Options.pvpKills)
    Tale:OptionsEnableDisable(TaleOptions_Options_PvPKillCB)

    TaleOptions_Options_PvPKillLogCB:SetChecked(Tale_Options.pvpKillsLog)
    Tale:OptionsEnableDisable(TaleOptions_Options_PvPKillLogCB)

    TaleOptions_Options_LogIntervalSlider_Text:SetText(format(Tale.L["log interval"], Tale_Options.logInterval))
    TaleOptions_Options_LogIntervalSlider:SetValue(Tale_Options.logInterval)

    TaleOptions_Options_QuestTurnInLogCB:SetChecked(Tale_Options.questTurnInLog)
    Tale:OptionsEnableDisable(TaleOptions_Options_QuestTurnInLogCB)

    TaleOptions_Options_KillsLogCB:SetChecked(Tale_Options.killsLog)
    Tale:OptionsEnableDisable(TaleOptions_Options_KillsLogCB)
end

function Tale:OptionsInitialize()
    -- parse localization
    TaleOptions_Options_Title:SetText(Tale.ADDONNAME.." v."..Tale.ADDONVERSION)
    TaleOptions_Options_EventsHeadline:SetText(Tale.L["Take screenshot on"])

    TaleOptions_Options_LevelUpLogCB_Text:SetText(Tale.L["level up log"])

    TaleOptions_Options_LevelUpCB_Text:SetText(Tale.L["level up"])
    TaleOptions_Options_LevelUpCB_ShowPlayedCB_Text:SetText(Tale.L["show played"])
    TaleOptions_Options_LevelUpCB_ShowPlayedCB_ResizeChatCB_Text:SetText(Tale.L["resize chat window"])
    TaleOptions_Options_ReputationChangeCB_Text:SetText(Tale.L["new reputation level"])
    TaleOptions_Options_ReputationChangeCB_ExaltedOnlyCB_Text:SetText(Tale.L["exalted only"])

    TaleOptions_Options_BattlegroundEndingLogCB_Text:SetText(Tale.L["battleground endings log"])

    TaleOptions_Options_BattlegroundEndingCB_Text:SetText(Tale.L["battleground endings"])
    TaleOptions_Options_BattlegroundEndingCB_WinsOnlyCB_Text:SetText(Tale.L["wins only"])

    TaleOptions_Options_BosskillsLogCB_Text:SetText(Tale.L["bosskills log"])

    TaleOptions_Options_BosskillsCB_Text:SetText(Tale.L["bosskills"])
    TaleOptions_Options_BosskillsCB_FirstkillsCB_Text:SetText(Tale.L["only after first kill"])

    TaleOptions_Options_DeathLogCB_Text:SetText(Tale.L["death log"])
    TaleOptions_Options_DeathCB_Text:SetText(Tale.L["death"])


    TaleOptions_Options_PvPKillLogCB_Text:SetText(Tale.L["pvp kills log"])
    TaleOptions_Options_PvPKillCB_Text:SetText(Tale.L["pvp kills"])

    TaleOptions_Options_QuestTurnInLogCB_Text:SetText(Tale.L["quest turn in log"])

    TaleOptions_Options_KillsLogCB_Text:SetText(Tale.L["kills log"])

    TaleOptions_Options_LogIntervalSlider:SetScript("OnUpdate", function (self, elapsed) TaleOptions_Options_LogIntervalSlider_Text:SetText(format(Tale.L["log interval"], math.floor(TaleOptions_Options_LogIntervalSlider:GetValue()))) end)
    -- parse current options
    Tale:OptionsRestore()
end

function MyModScrollBar_Update()
 FauxScrollFrame_Update(TaleOptions,35,21,16);
   -- 50 is max entries, 5 is number of lines, 16 is pixel height of each line
end


----------------------
--  Register panel  --
----------------------
-- Tale.Scroll = CreateFrame('ScrollFrame', 'OptionScroll', UIParent, 'UIPanelScrollFrameTemplate')
Tale.Scroll = CreateFrame("ScrollFrame", "TaleOptions", UIParent, "TaleScrollTemplate")
Tale.Scroll:EnableMouse(true)
Tale.Scroll:SetMovable(true)
Tale.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	TaleOptions:SetHeight(offset)
end)
Tale.Scroll.name = "Tale"
Tale.Scroll.okay = function() Tale:OptionsSave() end
Tale.Scroll.cancel = function() Tale:OptionsRestore() end



InterfaceOptions_AddCategory(Tale.Scroll)

