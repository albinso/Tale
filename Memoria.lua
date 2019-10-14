-- ********************************************************
-- **                      Memoria                       **
-- **            <http://www.cosmocanyon.de>             **
-- ********************************************************
--
-- This addon is written and copyrighted by:
--    * Mîzukichan @ EU-Antonidas (2010-2019)
--
-- Contributors:
--    * Softea_Lethon (Show played time on screenshot, Classic support) (2019) 
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


----------------------------
--  Variables and Locals  --
----------------------------
Memoria.ADDONNAME = "Memoria"
Memoria.ADDONVERSION = GetAddOnMetadata(Memoria.ADDONNAME, "Version");
Memoria.BattlefieldScreenshotAlreadyTaken = false
Memoria.Debug = nil
Memoria.WaitForTimePlayed = false
Memoria.ChatSettings = {}
Memoria.PlayerLevel = 1
Memoria.IsRetail = tonumber(string.sub(GetBuildInfo(), 1, 1)) > 1
local deformat = LibStub("LibDeformat-3.0")


------------------------
--  Addon FSM States  --
------------------------
local STATE_IDLE           = 0
local STATE_SHOT_SCHEDULED = 1
local STATE_SHOT_DELAY     = 2
local STATE_SCREENSHOT     = 3
local STATE_RESTORE_DELAY  = 4


-----------------------
--  Default Options  --
-----------------------
Memoria.DefaultOptions = {
    achievements = true,
    arenaEnding = false,
    arenaEndingOnlyWins = false,
    battlegroundEnding = false,
    battlegroundEndingOnlyWins = false,
    bosskills = true,
    bosskillsFirstkill = false,
    reputationChange = true,
    reputationChangeOnlyExalted = false,
    levelUp = true,
    levelUpShowPlayed = false,
    resizeChat = false,
    challengeDone = false,
    version = 1,
}


----------------------------
--  Declare EventHandler  --
----------------------------
function Memoria:EventHandler(frame, event, ...)
    if (event == "ADDON_LOADED") then
        local addonName = ...
        if (addonName == Memoria.ADDONNAME) then
            Memoria:ADDON_LOADED_Handler(frame)
        end
    
    elseif (event == "ACHIEVEMENT_EARNED") then
        Memoria:ACHIEVEMENT_EARNED_Handler()
        
    elseif (event == "CHALLENGE_MODE_COMPLETED") then
        Memoria:CHALLENGE_MODE_COMPLETED_Handler()
    
    elseif (event == "CHAT_MSG_SYSTEM") then
        Memoria:DebugMsg("CHAT_MSG_SYSTEM_Handler() called...")
        Memoria:CHAT_MSG_SYSTEM_Handler(...)
        
    elseif (event == "ENCOUNTER_END") then
        Memoria:ENCOUNTER_END_Handler(...)
    
    elseif (event == "PLAYER_LEVEL_UP") then
        Memoria:PLAYER_LEVEL_UP_Handler(...)
    
    elseif (event == "TIME_PLAYED_MSG") then
        if (Memoria.WaitForTimePlayed) then
            Memoria:PLAYER_LEVEL_UP_SHOW_PLAYED_Handler(...)
        end
        
    elseif (event == "UPDATE_BATTLEFIELD_STATUS") then
        Memoria:UPDATE_BATTLEFIELD_STATUS_Handler()
    
    end
end

function Memoria:ADDON_LOADED_Handler(frame)
    Memoria:Initialize(frame)
    Memoria:RegisterEvents(frame)
    MemoriaFrame:SetScript("OnUpdate", Memoria.OnUpdate)
end

function Memoria:ACHIEVEMENT_EARNED_Handler()
    Memoria:DebugMsg("ACHIEVEMENT_EARNED_Handler() called...")
    if (not Memoria_Options.achievements) then return; end
    Memoria:AddScheduledScreenshot(1)
    Memoria:DebugMsg("Achievement - Added screenshot to queue")
end

function Memoria:CHALLENGE_MODE_COMPLETED_Handler()
    Memoria:DebugMsg("CHALLENGE_MODE_COMPLETED_Handler() called...")
    if (not Memoria_Options.challengeDone) then return; end
    Memoria:AddScheduledScreenshot(5)
    Memoria:DebugMsg("Challenge mode completed - Added screenshot to queue")
end

function Memoria:CHAT_MSG_SYSTEM_Handler(...)
    if (not Memoria_Options.reputationChange) then return; end
    local chatmsg = ...
    local repLevel, faction = deformat(chatmsg, FACTION_STANDING_CHANGED)
    if (not repLevel or not faction) then return; end
    if (not Memoria_Options.reputationChangeOnlyExalted) then
        Memoria:AddScheduledScreenshot(1)
        Memoria:DebugMsg("Reputation level changed - Added screenshot to queue")
    else
        if (repLevel == FACTION_STANDING_LABEL8 or repLevel == FACTION_STANDING_LABEL8_FEMALE) then
            Memoria:AddScheduledScreenshot(1)
            Memoria:DebugMsg("Reputation level reached exalted - Added screenshot to queue")
        end
    end
end

function Memoria:ENCOUNTER_END_Handler(...)
    if (not Memoria_Options.bosskills) then return; end
    local encounterID, name, difficulty, size, success = ...
    Memoria:DebugMsg("ENCOUNTER_END fired! encounterID="..encounterID..", name="..name..", difficulty="..difficulty..", size="..size..", success="..success)
    if ((not encounterID) or (not difficulty)) then return; end
    if (success == 1) then 
        -- check if boss was a known kill, if "only after first kill" is enabled
        if (not Memoria_CharBossKillDB[difficulty]) then Memoria_CharBossKillDB[difficulty] = {}; end
        if (Memoria_Options.bosskillsFirstkill and Memoria_CharBossKillDB[difficulty][encounterID]) then return; end
        Memoria:AddScheduledScreenshot(1)
        Memoria:DebugMsg("Encounter successful - Added screenshot to queue")
        Memoria_CharBossKillDB[difficulty][encounterID] = true
    end
end

function Memoria:PLAYER_LEVEL_UP_Handler(level, ...)
    Memoria:DebugMsg("PLAYER_LEVEL_UP_Handler() called...")
    Memoria.PlayerLevel = level
    if not Memoria_CharLevelTimes[Memoria.PlayerLevel] then
        Memoria_CharLevelTimes[Memoria.PlayerLevel] = 0
    end
    if (not Memoria_Options.levelUp) then return; end
    if (Memoria_Options.levelUpShowPlayed) then
        Memoria.WaitForTimePlayed = true
        RequestTimePlayed()
        return
    end
    Memoria:AddScheduledScreenshot(1)
    Memoria:DebugMsg("Level up - Added screenshot to queue")
end

function Memoria:PLAYER_LEVEL_UP_SHOW_PLAYED_Handler(...)
    Memoria:DebugMsg("PLAYER_LEVEL_UP_SHOW_PLAYED_Handler() called...")
    if (not Memoria_Options.levelUp) then return; end
    if (not Memoria_Options.levelUpShowPlayed) then return; end
    if (not Memoria.WaitForTimePlayed) then return; end
    Memoria.WaitForTimePlayed = false
    Memoria:ShowPrevious()
    Memoria:AddScheduledScreenshot(0)
    Memoria:DebugMsg("Level up show played - Added screenshot to queue")
end

function Memoria:UPDATE_BATTLEFIELD_STATUS_Handler()
    Memoria:DebugMsg("UPDATE_BATTLEFIELD_STATUS_Handler() called...")
    -- if not activated, return
    if (not Memoria_Options.battlegroundEnding and not Memoria_Options.arenaEnding) then return; end
    -- if not ended, return
    local winner = GetBattlefieldWinner()                                                                             -- possible values: nil (no winner yet), 0 (Horde / green Team), 1 (Alliance / gold Team)
    if (winner == nil) then 
        Memoria.BattlefieldScreenshotAlreadyTaken = false
        return
    end
    -- if screenshot of this battlefield already taken, then return
    if (Memoria.BattlefieldScreenshotAlreadyTaken) then return; end
    -- if we are here, we have a freshly finished arena or battleground
    if (Memoria.IsRetail and IsActiveBattlefieldArena()) then
        if (not Memoria_Options.arenaEnding) then return; end
        if (not Memoria_Options.arenaEndingOnlyWins) then
            Memoria:AddScheduledScreenshot(1)
            Memoria.BattlefieldScreenshotAlreadyTaken = true
            Memoria:DebugMsg("Arena ended - Added screenshot to queue")
        else
            local playerTeam = Memoria:GetPlayerTeam()
            if (winner == playerTeam) then
                Memoria:AddScheduledScreenshot(1)
                Memoria.BattlefieldScreenshotAlreadyTaken = true
                Memoria:DebugMsg("Arena won - Added screenshot to queue")
            end
        end
    else
        if (not Memoria_Options.battlegroundEnding) then return; end
        if (not Memoria_Options.battlegroundEndingOnlyWins) then
            Memoria:AddScheduledScreenshot(1)
            Memoria.BattlefieldScreenshotAlreadyTaken = true
            Memoria:DebugMsg("Battleground ended - Added screenshot to queue")
        else
            local playerFaction = UnitFactionGroup("player")                                                          -- playerFaction is either "Alliance" or "Horde"
            if ( (playerFaction == "Alliance" and winner == 1) or (playerFaction == "Horde" and winner == 0) ) then
                Memoria:AddScheduledScreenshot(1)
                Memoria.BattlefieldScreenshotAlreadyTaken = true
                Memoria:DebugMsg("Battleground won - Added screenshot to queue")
            end
        end
    end
end

function Memoria:OnUpdate(elapsed)
    Memoria_CharLevelTimes[Memoria.PlayerLevel] = Memoria_CharLevelTimes[Memoria.PlayerLevel] + elapsed
    Memoria:ScreenshotHandler(elapsed)
end


----------------------------------------------
--  Update saved data and initialize addon  --
----------------------------------------------
function Memoria:Initialize(frame)
    if (not Memoria_Options) then
        Memoria_Options = {}
        for key, val in pairs(Memoria.DefaultOptions) do
            Memoria_Options[key] = val
        end
    end
    if (not Memoria_CharBossKillDB) then
        Memoria_CharBossKillDB = {}
    end
    if (not Memoria_CharLevelTimes) then
        Memoria_CharLevelTimes = {}
    end
    Memoria.PlayerLevel = UnitLevel("PLAYER")
    if not Memoria_CharLevelTimes[Memoria.PlayerLevel] then
        Memoria_CharLevelTimes[Memoria.PlayerLevel] = 0
    end
    Memoria.queue = {}
    Memoria.state = STATE_IDLE
    Memoria:OptionsInitialize()
end


-------------------------------------------------
--  Set registered Event according to options  --
-------------------------------------------------
function Memoria:RegisterEvents(frame)
    frame:UnregisterAllEvents()
    if Memoria.IsRetail then
        if (Memoria_Options.achievements) then frame:RegisterEvent("ACHIEVEMENT_EARNED"); end
        if (Memoria_Options.challengeDone) then frame:RegisterEvent("CHALLENGE_MODE_COMPLETED"); end
    end
    if (Memoria_Options.reputationChange) then frame:RegisterEvent("CHAT_MSG_SYSTEM"); end
    if (Memoria_Options.bosskills) then frame:RegisterEvent("ENCOUNTER_END"); end
    if (Memoria_Options.levelUp) then frame:RegisterEvent("PLAYER_LEVEL_UP"); end
    if (Memoria_Options.levelUpShowPlayed) then frame:RegisterEvent("TIME_PLAYED_MSG"); end
    if (Memoria_Options.arenaEnding or Memoria_Options.battlegroundEnding) then frame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS"); end
end


--------------------------------------------------------
--  Create Frame for Events and ScreenshotScheduling  --
--------------------------------------------------------
MemoriaFrame = CreateFrame("Frame", "MemoriaFrame", UIParent, nil)
MemoriaFrame:SetScript("OnEvent", function (...) Memoria:EventHandler(...) end)
MemoriaFrame:RegisterEvent("ADDON_LOADED")


-----------------------------------------
--  Functions for screenshot handling  --
-----------------------------------------
function Memoria:ScreenshotHandler(elapsed)
    if Memoria.state == STATE_IDLE then
        return
    elseif Memoria.state == STATE_SHOT_SCHEDULED then
        local rmList = {}
        for i, delay in ipairs(Memoria.queue) do
            if (delay > 0) then
                Memoria.queue[i] = delay - elapsed
            else
                tinsert(rmList, i, 1)
                if Memoria_Options.levelUpShowPlayed and Memoria_Options.resizeChat then
                    Memoria.state = STATE_SHOT_DELAY
                else
                    Memoria.state = STATE_SCREENSHOT
                end
            end
        end
        for i, index in ipairs(rmList) do
            tremove(Memoria.queue, index)
        end
    elseif Memoria.state == STATE_SHOT_DELAY then
        -- Ensure chat window is big enough, need 1 frame setup before screenshot
        -- No matter resolution or UI scale, max size is 608x400
        DEFAULT_CHAT_FRAME:SetHeight(608)
        DEFAULT_CHAT_FRAME:SetWidth(400)
        Memoria.state = STATE_SCREENSHOT
    elseif Memoria.state == STATE_SCREENSHOT then
        Screenshot()
        if Memoria_Options.levelUpShowPlayed and Memoria_Options.resizeChat then
            -- Wait a frame to reset the chat, screenshot happens after frame ends
            Memoria.state = STATE_RESTORE_DELAY
        else
            if (#Memoria.queue == 0) then
                Memoria.state = STATE_IDLE
            else
                Memoria.state = STATE_SHOT_SCHEDULED
            end
        end
    elseif Memoria.state == STATE_RESTORE_DELAY then
        DEFAULT_CHAT_FRAME:SetHeight(Memoria.ChatSettings["height"])
        DEFAULT_CHAT_FRAME:SetWidth(Memoria.ChatSettings["width"])
        if (#Memoria.queue == 0) then
            Memoria.state = STATE_IDLE
        else
            Memoria.state = STATE_SHOT_SCHEDULED
        end
    end
end

function Memoria:AddScheduledScreenshot(delay)
    tinsert(Memoria.queue, delay);
    Memoria.state = STATE_SHOT_SCHEDULED
    Memoria.ChatSettings["height"] = DEFAULT_CHAT_FRAME:GetHeight()
    Memoria.ChatSettings["width"] = DEFAULT_CHAT_FRAME:GetWidth()
end


-------------------------
--  Support functions  --
-------------------------
function Memoria:GetPlayerTeam()
    local numBattlefieldScores = GetNumBattlefieldScores()
    local playerName = UnitName("player")
    for i = 1, numBattlefieldScores do
        local name, _, _, _, _, team = GetBattlefieldScore(i)
        if (playerName == team) then
            return team
        end
    end
end

function Memoria:DebugMsg(text)
    if (Memoria.Debug) then
        DEFAULT_CHAT_FRAME:AddMessage("Memoria v."..Memoria.ADDONVERSION.." Debug: "..text, 1, 0.5, 0);
    end
end

function Memoria:ShowPrevious()
    local timePlayedPreviousLevel = Memoria_CharLevelTimes[Memoria.PlayerLevel - 1]
    if timePlayedPreviousLevel then
        local days, remainder  = Memoria:DivMod(timePlayedPreviousLevel, 86400)
        local hours, remainder = Memoria:DivMod(remainder, 3600)
        local minutes, seconds = Memoria:DivMod(remainder, 60)
        local systemSettings = ChatTypeInfo["SYSTEM"]
        -- \124c Color Sequence Introducer then ARGB
        -- \124r Reset
        local red = bit.lshift(systemSettings.r * 255, 16)
        local green = bit.lshift(systemSettings.g * 255, 8)
        local color = bit.bor(red, green)
        color = bit.bor(color, systemSettings.b * 255)
        color = string.format("%x", color)
        DEFAULT_CHAT_FRAME:AddMessage("\124cFF"..color..Memoria.L["time played"].." "..(Memoria.PlayerLevel - 1)..": "..days.." "..Memoria.L["days"]..", "..hours.." "..Memoria.L["hours"]..", "..minutes.." "..Memoria.L["minutes"]..", "..seconds.." "..Memoria.L["seconds"])
    end
end

function Memoria:DivMod(a, b)
    if (b == 0) then return 0, 0 end
    local div = math.floor(a / b)
    local mod = math.floor(math.fmod(a, b))
    return div, mod
end
