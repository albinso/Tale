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


----------------------------
--  Variables and Locals  --
----------------------------
Memoria.ADDONNAME = "Memoria"
Memoria.ADDONVERSION = GetAddOnMetadata(Memoria.ADDONNAME, "Version");
Memoria.BattlefieldScreenshotAlreadyTaken = false
Memoria.Debug = nil
local deformat = LibStub("LibDeformat-3.0")


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
        Memoria:PLAYER_LEVEL_UP_Handler()
        
    elseif (event == "UPDATE_BATTLEFIELD_STATUS") then
        Memoria:UPDATE_BATTLEFIELD_STATUS_Handler()
    
    end
end

function Memoria:ADDON_LOADED_Handler(frame)
    Memoria:Initialize(frame)
    Memoria:RegisterEvents(frame)
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
        if (Memoria_Options.bosskillsFirstkill and Memoria_CharBossKillDB[difficulty][encounterID]) then return; end
        Memoria:AddScheduledScreenshot(1)
        Memoria:DebugMsg("Encounter successful - Added screenshot to queue")
        if (not Memoria_CharBossKillDB[difficulty]) then Memoria_CharBossKillDB[difficulty] = {}; end
        Memoria_CharBossKillDB[difficulty][encounterID] = true
    end
end

function Memoria:PLAYER_LEVEL_UP_Handler()
    Memoria:DebugMsg("PLAYER_LEVEL_UP_Handler() called...")
    if (not Memoria_Options.levelUp) then return; end
    Memoria:AddScheduledScreenshot(1)
    Memoria:DebugMsg("Level up - Added screenshot to queue")
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
    local isArena = IsActiveBattlefieldArena()
    if (isArena) then
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
    Memoria:OptionsInitialize()
    Memoria:RegisterEvents(frame)
end


-------------------------------------------------
--  Set registered Event according to options  --
-------------------------------------------------
function Memoria:RegisterEvents(frame)
    frame:UnregisterAllEvents()
    if (Memoria_Options.achievements) then frame:RegisterEvent("ACHIEVEMENT_EARNED"); end
    if (Memoria_Options.challengeDone) then frame:RegisterEvent("CHALLENGE_MODE_COMPLETED"); end
    if (Memoria_Options.reputationChange) then frame:RegisterEvent("CHAT_MSG_SYSTEM"); end
    if (Memoria_Options.bosskills) then frame:RegisterEvent("ENCOUNTER_END"); end
    if (Memoria_Options.levelUp) then frame:RegisterEvent("PLAYER_LEVEL_UP"); end
    if (Memoria_Options.arenaEnding or Memoria_Options.battlegroundEnding) then frame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS"); end
end


--------------------------------------------------------
--  Create Frame for Events and ScreenshotScheduling  --
--------------------------------------------------------
MemoriaFrame = CreateFrame("Frame", "MemoriaFrame", UIParent, nil)
MemoriaFrame:SetScript("OnEvent", function(self, event, ...) Memoria:EventHandler(self, event, ...); end)
MemoriaFrame:RegisterEvent("ADDON_LOADED")
MemoriaFrame.queue = {}


-----------------------------------------
--  Functions for screenshot handling  --
-----------------------------------------
function Memoria:ScreenshotHandler(frame)
    if ( (time() - frame.lastCheck) == 0 ) then return; end
    local rmList = {}
    local now = time()
    local lastCheckInSecs = now - frame.lastCheck
    for i, delay in ipairs(frame.queue) do
        if (delay > 0) then
            frame.queue[i] = delay - lastCheckInSecs
        else
            if (now ~= frame.lastScreenshot) then
                Screenshot()
            end
            frame.lastScreenshot = now
            tinsert(rmList, i, 1)
        end
    end
    for i, index in ipairs(rmList) do
        tremove(frame.queue, index)
    end
    if (#frame.queue == 0) then
        frame:SetScript("OnUpdate", nil)
        frame.running = false
    end
    frame.lastCheck = now
end

function Memoria:AddScheduledScreenshot(delay)
    tinsert(MemoriaFrame.queue, delay);
    if (not MemoriaFrame.running) then
        MemoriaFrame.lastCheck = time()
        MemoriaFrame.lastScreenshot = time()
        MemoriaFrame.running = true
        MemoriaFrame:SetScript("OnUpdate", function(self) Memoria:ScreenshotHandler(self); end)
    end
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
