# Log Format

## General
Each log entry consists of a list of elements contained by double quotation marks ("). Elements are separated by commas and a single space (eg "5, 3, 2"). 

## Mandatory fields
There are six mandatory fields that are included in all log entries. If the addon is unable to fill some of these fields it will insert the value -1. The fields are as follows:

### X coordinate
A value ranging from 0 to 1. This represents how far along the X axis the player is on the current map (see MapID). 0 is far west with 1 being far east. 

### Y coordinate
Exactly the same as X coordinate but instead working from north to south.

### MapID
The ID for the current "best fit map". This is the map that is brought up by default when the player opens the map view. This will generally be a zone map or an instance map but may in some cases be Kalimdor, Eastern Kingdoms or the World map.

For more info see https://wow.gamepedia.com/API_C_Map.GetBestMapForUnit and https://wow.gamepedia.com/UiMapID/Classic

### Timestamp
Current real world time measured as the number of seconds passed since the epoch. What constitutes the epoch depends on the operating system so this is not a reliable measure of time. It is internally consistent so each real world second passed will always increase this by 1.

### Level
The current level of the character. For LevelUp entries this will be the new level of the character.

### EntryID
The type of entry. More entries may be added in the future but none will be removed or changed once they have been documented here. If an entry type becomes invalid due to changes to the addon API that ID will not be used for another entry type. Each entry may have several type-specific fields that are inserted after the entryID. In some cases more than one event is triggered by the same action. In those cases both events will be written to the log.

#### Standard (ID: 101)
Type used for periodic entries if no other type applies. Has no additional fields.

#### Fly (ID: 102)
Inserted at beginning of flight master travel and used for periodic entries while in flight. No additional fields.

#### Ghost (ID: 103)
Inserted when character becomes ghost (upon pressing Release Spirit) and used for periodic entries while ghost. No additional fields.

#### Death (ID: 201)
Inserted immediately upon character death.  
Additional field: the name of the source of the killing damage. This can be one of the environmental categories, a mob name or a player name.

#### Level (ID 301)
Inserted when the character levels up. Has no additional fields.

#### Quest Turn-in (ID 311)
Inserted when a quest is turned in.  
Additional field: numeric Quest ID. 

#### Kill (ID 401)
Inserted whenever a unit the player has damaged dies.  
Additional field: name of the killed unit.

#### Boss (ID 411)
Inserted on the end of a successful instanced encounter. This should only be dungeon and raid bosses but there may be exceptions I'm not aware of. Overlaps with 401.
Additional field: numeric id for the encounter.


#### PvP Kill (ID 501) 
Inserted on honorable PvP kills. May overlap with 401.
Additional field: name of the killed enemy player.

#### Battleground end (ID 511)
Inserted at end of battlegrounds.  
Additional field: string equal to "won" or "lost" depending on outcome.



