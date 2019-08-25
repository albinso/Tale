-- ********************************************************
-- **                      Tale                       **
-- **            <http://www.cosmocanyon.de>             **
-- ********************************************************
--
-- This addon is written and copyrighted by:
--    * Mîzukichan @ EU-Antonidas (2010-2019)
--
--
--    This file is part of Tale.
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

    Tale_Options.achievements = TaleOptions_NewAchievementCB:GetChecked()
    Tale_Options.levelUp = TaleOptions_LevelUpCB:GetChecked()
    Tale_Options.levelUpShowPlayed = TaleOptions_LevelUpCB_ShowPlayedCB:GetChecked()
    Tale_Options.resizeChat = TaleOptions_LevelUpCB_ShowPlayedCB_ResizeChatCB:GetChecked()
    Tale_Options.reputationChange = TaleOptions_ReputationChangeCB:GetChecked()
    Tale_Options.reputationChangeOnlyExalted = TaleOptions_ReputationChangeCB_ExaltedOnlyCB:GetChecked()
    Tale_Options.arenaEnding = TaleOptions_ArenaEndingCB:GetChecked()
    Tale_Options.arenaEndingOnlyWins = TaleOptions_ArenaEndingCB_WinsOnlyCB:GetChecked()
    Tale_Options.battlegroundEnding = TaleOptions_BattlegroundEndingCB:GetChecked()
    Tale_Options.battlegroundEndingOnlyWins = TaleOptions_BattlegroundEndingCB_WinsOnlyCB:GetChecked()
    Tale_Options.bosskills = TaleOptions_BosskillsCB:GetChecked()
    Tale_Options.bosskillsFirstkill = TaleOptions_BosskillsCB_FirstkillsCB:GetChecked()
    Tale_Options.challengeDone = TaleOptions_ChallengeDoneCB:GetChecked()
    Tale_Options.levelUpLog = TaleOptions_LevelUpLogCB:GetChecked()
    Tale_Options.bosskillsLog = TaleOptions_BosskillsLogCB:GetChecked()
    Tale_Options.deathLog = TaleOptions_DeathLogCB:GetChecked()
    Tale_Options.death = TaleOptions_DeathCB:GetChecked()
    Tale_Options.battlegroundEndingLog = TaleOptions_BattlegroundEndingLogCB:GetChecked()
    Tale_Options.pvpKillLog = TaleOptions_PvPKillLogCB:GetChecked()
    Tale_Options.pvpKill = TaleOptions_PvPKillCB:GetChecked()
    Tale_Options.logInterval = math.floor(TaleOptions_LogIntervalSlider:GetValue())
    Tale_Options.questTurnInLog = TaleOptions_QuestTurnInLogCB:GetChecked()
    Tale_Options.killsLog = TaleOptions_KillsLogCB:GetChecked()

    Tale:RegisterEvents(TaleFrame)
end

function Tale:OptionsRestore()
    local IsRetail = tonumber(string.sub(GetBuildInfo(), 1, 1)) > 1
    if (not IsRetail) then
        TaleOptions_NewAchievementCB:Disable()
        TaleOptions_ArenaEndingCB:Disable()
        TaleOptions_ChallengeDoneCB:Disable()
    end
    TaleOptions_NewAchievementCB:SetChecked(Tale_Options.achievements)
    Tale:OptionsEnableDisable(TaleOptions_NewAchievementCB)
    TaleOptions_LevelUpCB:SetChecked(Tale_Options.levelUp)
    TaleOptions_LevelUpCB_ShowPlayedCB:SetChecked(Tale_Options.levelUpShowPlayed)
    TaleOptions_LevelUpCB_ShowPlayedCB_ResizeChatCB:SetChecked(Tale_Options.resizeChat)
    Tale:OptionsEnableDisable(TaleOptions_LevelUpCB)
    TaleOptions_ReputationChangeCB:SetChecked(Tale_Options.reputationChange)
    TaleOptions_ReputationChangeCB_ExaltedOnlyCB:SetChecked(Tale_Options.reputationChangeOnlyExalted)
    Tale:OptionsEnableDisable(TaleOptions_ReputationChangeCB)
    TaleOptions_ArenaEndingCB:SetChecked(Tale_Options.arenaEnding)
    TaleOptions_ArenaEndingCB_WinsOnlyCB:SetChecked(Tale_Options.arenaEndingOnlyWins)
    Tale:OptionsEnableDisable(TaleOptions_ArenaEndingCB)
    TaleOptions_BattlegroundEndingCB:SetChecked(Tale_Options.battlegroundEnding)
    TaleOptions_BattlegroundEndingCB_WinsOnlyCB:SetChecked(Tale_Options.battlegroundEndingOnlyWins)
    Tale:OptionsEnableDisable(TaleOptions_BattlegroundEndingCB)
    TaleOptions_BosskillsCB:SetChecked(Tale_Options.bosskills)
    TaleOptions_BosskillsCB_FirstkillsCB:SetChecked(Tale_Options.bosskillsFirstkill)
    Tale:OptionsEnableDisable(TaleOptions_BosskillsCB)
    TaleOptions_ChallengeDoneCB:SetChecked(Tale_Options.challengeDone)
    Tale:OptionsEnableDisable(TaleOptions_ChallengeDoneCB)
    
    TaleOptions_LevelUpLogCB:SetChecked(Tale_Options.levelUpLog)
    Tale:OptionsEnableDisable(TaleOptions_LevelUpLogCB)

    TaleOptions_BosskillsLogCB:SetChecked(Tale_Options.bosskillsLog)
    Tale:OptionsEnableDisable(TaleOptions_BosskillsLogCB)

    TaleOptions_DeathLogCB:SetChecked(Tale_Options.deathLog)
    Tale:OptionsEnableDisable(TaleOptions_DeathLogCB)
    
    TaleOptions_DeathCB:SetChecked(Tale_Options.death)
    Tale:OptionsEnableDisable(TaleOptions_DeathCB)

    TaleOptions_BattlegroundEndingLogCB:SetChecked(Tale_Options.battlegroundEndingLog)
    Tale:OptionsEnableDisable(TaleOptions_BattlegroundEndingLogCB)

    TaleOptions_PvPKillCB:SetChecked(Tale_Options.pvpKill)
    Tale:OptionsEnableDisable(TaleOptions_PvPKillCB)

    TaleOptions_PvPKillLogCB:SetChecked(Tale_Options.pvpKillLog)
    Tale:OptionsEnableDisable(TaleOptions_PvPKillLogCB)

    TaleOptions_LogIntervalSlider_Text:SetText(Tale_Options.logInterval)
    TaleOptions_LogIntervalSlider:SetValue(Tale_Options.logInterval)

    TaleOptions_QuestTurnInLogCB:SetChecked(Tale_Options.questTurnInLog)
    Tale:OptionsEnableDisable(TaleOptions_QuestTurnInLogCB)

    TaleOptions_KillsLogCB:SetChecked(Tale_Options.killsLog)
    Tale:OptionsEnableDisable(TaleOptions_KillsLogCB)
end

function Tale:OptionsInitialize()
    -- parse localization
    TaleOptions_Title:SetText(Tale.ADDONNAME.." v."..Tale.ADDONVERSION)
    TaleOptions_EventsHeadline:SetText(Tale.L["Take screenshot on"])
    TaleOptions_NewAchievementCB_Text:SetText(Tale.L["new achievement"])

    TaleOptions_LevelUpLogCB_Text:SetText(Tale.L["level up log"])

    TaleOptions_LevelUpCB_Text:SetText(Tale.L["level up"])
    TaleOptions_LevelUpCB_ShowPlayedCB_Text:SetText(Tale.L["show played"])
    TaleOptions_LevelUpCB_ShowPlayedCB_ResizeChatCB_Text:SetText(Tale.L["resize chat window"])
    TaleOptions_ReputationChangeCB_Text:SetText(Tale.L["new reputation level"])
    TaleOptions_ReputationChangeCB_ExaltedOnlyCB_Text:SetText(Tale.L["exalted only"])
    TaleOptions_ArenaEndingCB_Text:SetText(Tale.L["arena endings"])
    TaleOptions_ArenaEndingCB_WinsOnlyCB_Text:SetText(Tale.L["wins only"])

    TaleOptions_BattlegroundEndingLogCB_Text:SetText(Tale.L["battleground endings log"])

    TaleOptions_BattlegroundEndingCB_Text:SetText(Tale.L["battleground endings"])
    TaleOptions_BattlegroundEndingCB_WinsOnlyCB_Text:SetText(Tale.L["wins only"])

    TaleOptions_BosskillsLogCB_Text:SetText(Tale.L["bosskills log"])

    TaleOptions_BosskillsCB_Text:SetText(Tale.L["bosskills"])
    TaleOptions_BosskillsCB_FirstkillsCB_Text:SetText(Tale.L["only after first kill"])
    TaleOptions_ChallengeDoneCB_Text:SetText(Tale.L["challenge instance endings"])

    TaleOptions_DeathLogCB_Text:SetText(Tale.L["death log"])
    TaleOptions_DeathCB_Text:SetText(Tale.L["death"])


    TaleOptions_PvPKillLogCB_Text:SetText(Tale.L["pvp kills log"])
    TaleOptions_PvPKillCB_Text:SetText(Tale.L["pvp kills"])

    TaleOptions_QuestTurnInLogCB_Text:SetText(Tale.L["quest turn in log"])

    TaleOptions_KillsLogCB_Text:SetText(Tale.L["kills log"])

    TaleOptions_LogIntervalSlider:SetScript("OnUpdate", function (self, elapsed) TaleOptions_LogIntervalSlider_Text:SetText(math.floor(TaleOptions_LogIntervalSlider:GetValue())) end)
    -- parse current options
    Tale:OptionsRestore()
end


----------------------
--  Register panel  --
----------------------
Tale.OptionPanel = CreateFrame("Frame", "TaleOptions", UIParent, "TaleOptionsTemplate")
Tale.OptionPanel.name = "Tale"
Tale.OptionPanel.okay = function() Tale:OptionsSave() end
Tale.OptionPanel.cancel = function() Tale:OptionsRestore() end
InterfaceOptions_AddCategory(Tale.OptionPanel)
