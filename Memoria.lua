-- ********************************************************
-- **                       Memoria                      **
-- **           <http://nanaki.affenfelsen.de>           **
-- ********************************************************
--
-- This addon is written and copyrighted by:
--    * Mizukichan @ EU-Thrall (2010)
--
--
--    This file is part of Mizus RaidTracker.
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
local Memoria = Memoria


----------------------------
--  Variables and Locals  --
----------------------------
Memoria.ADDONNAME = "Memoria"
Memoria.ADDONVERSION = GetAddOnMetadata(Memoria.ADDONNAME, "Version");
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
    reputationChange = true,
    reputationChangeOnlyExalted = false,
    levelUp = true,
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
    
    elseif (event == "CHAT_MSG_COMBAT_FACTION_CHANGE") then
        Memoria:CHAT_MSG_COMBAT_FACTION_CHANGE_Handler(...)
    
    elseif (event == "PLAYER_LEVEL_UP") then
        Memoria:PLAYER_LEVEL_UP_Handler()
    
    end
end

function Memoria:ADDON_LOADED_Handler(frame)
    Memoria:Initialize(frame)
    Memoria:RegisterEvents(frame)
end

function Memoria:ACHIEVEMENT_EARNED_Handler()
    if (Memoria_Options.achievements) then
        Memoria:AddScheduledScreenshot(1)
    end
end

function Memoria:CHAT_MSG_COMBAT_FACTION_CHANGE_Handler(...)
    local chatmsg = ...
    if (Memoria_Options.reputationChange and not Memoria_Options.reputationChangeOnlyExalted) then
        Memoria:AddScheduledScreenshot(1)
    elseif (Memoria_Options.reputationChange) then
        local repLevel, faction = deformat(chatmsg, FACTION_STANDING_CHANGED)
        if (repLevel == FACTION_STANDING_LABEL8 or repLevel == FACTION_STANDING_LABEL8_FEMALE) then
            Memoria:AddScheduledScreenshot(1)
        end
    end
end

function Memoria:PLAYER_LEVEL_UP_Handler()
    if (Memoria_Options.levelUp) then
        Memoria:AddScheduledScreenshot(1)
    end
end


-----------------------------------
--  Initialize and update Addon  --
-----------------------------------
function Memoria:Initialize(frame)
    Memoria:OptionsInitialize()
    if (not Memoria_Options) then
        Memoria_Options = {}
        for key, val in pairs(Memoria.DefaultOptions) do
            Memoria_Options[key] = val
        end
    end
end


-------------------------------------------------
--  Set registered Event according to options  --
-------------------------------------------------
function Memoria:RegisterEvents(frame)
    frame:UnregisterAllEvents()
end


--------------------------------------------------------
--  Create Frame for Events and ScreenshotScheduling  --
--------------------------------------------------------
Memoria.Frame = CreateFrame("Frame", "MemoriaFrame", UIParent, nil)
Memoria.Frame:SetScript("OnEvent", function(self, event, ...) Memoria:EventHandler(self, event, ...); end)
Memoria.Frame:RegisterEvent("ADDON_LOADED")
Memoria.Frame.queue = {}


-----------------------------------------
--  Functions for screenshot handling  --
-----------------------------------------
function Memoria.Frame:ScreenshotHandler(frame)
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
        Memoria.Frame:SetScript("OnUpdate", nil)
        frame.running = false
    end
    frame.lastCheck = now
end

function Memoria:AddScheduledScreenshot(delay)
    tinsert(Memoria.Frame.queue, delay);
    if (not Memoria.Frame.running) then
        Memoria.Frame.lastCheck = time()
        Memoria.Frame.lastScreenshot = time()
        Memoria.Frame.running = true
        Memoria.Frame:SetScript("OnUpdate", Memoria.Frame:ScreenshotHandler(self))
    end
end