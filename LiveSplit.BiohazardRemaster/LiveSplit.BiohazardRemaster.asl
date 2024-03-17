/*
Resident Evil HD Remaster Autosplitter Version 4.3.0
Supports room-room splits for every category, in addition to key-item and key-event splits.
Split files may be obtained from: 
by CursedToast 2/22/2016 (1.0 initial release) to 5/18/2018 (3.0 release)

Special thanks to:
Fatalis - original game time
Dchaps - initial scripting/data mining support
Pessimism - split order support, recorded runs with CE running for room ID data so I didn't have to.
LileyaCelestie - recorded runs with CE running for room ID data so I didn't have to.
wooferzfg - LiveSplit coding support and for developing LiveSplit so this script could happen
ZerothGames - item and inventory values
GrowthKasei - split order support.
Skhowl - splitter upkeep and rework
TheDementedSalad - load remover

Beta testers:
Pessimism, LileyaCelestie, GrowthKasei, Bawkbasoup, ZerothGames.

Donators that supported this script's development:
Pessimism

Thank you to all the above people for helping me make this possible.
-CursedToast/Nate
*/

state("bhd")
{
	float time:			0x97C9C0, 0xE474C;
	int character:		0x97C9C0, 0x5118;
	int slot1:			0x97C9C0, 0x38;
	int slot2:			0x97C9C0, 0x40;
	int slot3:			0x97C9C0, 0x48;
	int slot4:			0x97C9C0, 0x50;
	int slot5:			0x97C9C0, 0x58;
	int slot6:			0x97C9C0, 0x60;
	int slot7:			0x97C9C0, 0x68;
	int slot8:			0x97C9C0, 0x70;
	int slot9:			0x97C9C0, 0x78;
	int dslot1:			0x97C9C0, 0x5088;
	int dslot2:			0x97C9C0, 0x508C;
	int area:			0x97C9C0, 0xE4750;
	int room:			0x97C9C0, 0xE4754;
	int camera:			0x97C9C0, 0xE48B0;
	int playing:		0x98A0B0, 0x04;
	int vidplaying: 	0x9E4464, 0x5CBAC;
	
	byte load:			0x9E4270, 0x4F0;
	byte cutscene:		0x97C398, 0x1658;
}

startup
{
	/* Debug messages for DebugView (https://docs.microsoft.com/en-us/sysinternals/downloads/debugview) */
	vars.DebugMessage = (Action<string>)((message) => { print("[Debug] " + message); });
	
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	vars.Helper.Settings.CreateFromXml("Components/RE1make.Settings.xml");
}

init
{
	vars.Items = new HashSet<string>();
	vars.Events = new HashSet<string>();

	vars.ItemSplit = (Func<int, bool>)((id) =>
	{
		if (id == 44) /* Old Key */
		{
			return settings["item44"];
		}
		if (!vars.Items.Contains("item"+id))
		{
			vars.Items.Add("item"+id);
			return settings.ContainsKey("item"+id) && settings["item"+id];
		}
		return false;
	});

	refreshRate = 120.0;
}

/* update { } */

start
{
	if (current.playing == 0x0550 && current.time < 0.05)
	{
		vars.Items.Clear();
		vars.Events.Clear();
		for (int i = 1; i < 4; i++)
		{
			if (settings["outfit"+i])
			{
				game.WriteValue<int>(game.ReadPointer((IntPtr)modules.First().BaseAddress+0x97C9C0) + 0x5114, i);
				break;
			}
		}
		return true;
	}
	return false;
}

isLoading
{
	return current.load == 1 || current.cutscene == 2;
}

reset
{
	return current.playing == 0x0140 && old.playing == 0x0550;
}

split
{
	/* ROOMS */
	int RoomID = current.room;
	if (RoomID != old.room)
	{
		return settings["DoorSplit"];
	}

	/* VIDEOS */
	int AreaID = current.area;
	if (current.vidplaying > 0)
	{
		if (current.playing == 0x01B0 && !vars.Events.Contains("Ended"))
		{
			vars.Events.Add("Ended");
			return true;
		}
		int FMVplace = (int)(AreaID*100+RoomID);
		if (settings.ContainsKey("fmv"+FMVplace) && !vars.Events.Contains("fmv"+FMVplace))
		{
			vars.Events.Add("fmv"+FMVplace);
			return settings["fmv"+FMVplace];
		}
	}

	/*	For a full documentary look at:
		https://docs.google.com/spreadsheets/d/1tCN-INVKPmbCZTmgJvYW3zQOAaArVHfor1OXZDsn6EU */
	ushort SceneID = (ushort)(AreaID*10000+RoomID*100+current.camera);
	// vars.DebugMessage("Area: "+current.area+", Room: "+current.room+", Camera: "+current.camera+", Scene: "+SceneID+" (0x"+SceneID.ToString("X4")+")");

	/* SHARED EVENTS */
	switch (SceneID)
	{
		case 21311: /* Rebecca Chambers B (Pillar Room) */
			if (!vars.Events.Contains("event21311") && vars.Items.Contains("item78"))
			{
				vars.Events.Add("event21311");
				return settings["event21311"];
			}
			break;
		case 21329: /* Richard Aiken B (Pillar Room) */
			if (!vars.Events.Contains("event21329") && vars.Items.Contains("item78"))
			{
				vars.Events.Add("event21329");
				return settings["event21329"];
			}
			break;
		case 30110: /* Replenish Water (Water Pool) */
			if (!vars.Events.Contains("event30110") && old.camera == 7)
			{
				vars.Events.Add("event30110");
				return settings["event30110"];
			}
			break;
		/* Room Splits */
		case 20501: /* Entering Armor Room */
		case 12306: /* Entering Large Gallery */
		case 41300: /* Entering Aqua Ring entrance */
		case 41200: /* Entering Plant 42 Room */
		case 21203: /* Entering Sliding Trap Room */
		case 20000: /* Mansion Elevator (Kitchen ??/?? Elevator Corridor) */
		case 31200: /* Entering Spider Room */
		case 31301: /* Entering Straight Passage */
		case 30600: /* Entering Underground Statue Room */
		case 52100: /* Elevator to Laboratory B3 from B4 */
		case 52101: /* Elevator to Laboratory B4 from B3 */
			if (!settings["DoorSplit"] && !vars.Events.Contains("room"+SceneID))
			{
				vars.Events.Add("room"+SceneID);
				return settings["room"+SceneID];
			}
			break;
		default:
			if (settings.ContainsKey("event"+SceneID) && !vars.Events.Contains("event"+SceneID))
			{
				vars.Events.Add("event"+SceneID);
				return settings["event"+SceneID];
			}
			break;
	}

	if (current.character == 1) /* JILL */
	{
		if (current.slot1 != old.slot1)
		{
			return vars.ItemSplit(current.slot1);
		}
		if (current.slot2 != old.slot2)
		{
			return vars.ItemSplit(current.slot2);
		}
		if (current.slot3 != old.slot3)
		{
			return vars.ItemSplit(current.slot3);
		}
		if (current.slot4 != old.slot4)
		{
			return vars.ItemSplit(current.slot4);
		}
		if (current.slot5 != old.slot5)
		{
			return vars.ItemSplit(current.slot5);
		}
		if (current.slot6 != old.slot6)
		{
			return vars.ItemSplit(current.slot6);
		}
		if (current.slot7 != old.slot7)
		{
			return vars.ItemSplit(current.slot7);
		}
		if (current.slot8 != old.slot8)
		{
			return vars.ItemSplit(current.slot8);
		}
		if (current.slot9 != old.slot9)
		{
			return vars.ItemSplit(current.slot9);
		}
	}
	else /* CHRIS */
	{
		if (current.slot1 != old.slot1 && current.slot1 != old.slot2)
		{
			return vars.ItemSplit(current.slot1);
		}
		if (current.slot2 != old.slot2 && current.slot2 != old.slot3)
		{
			return vars.ItemSplit(current.slot2);
		}
		if (current.slot3 != old.slot3 && current.slot3 != old.slot4)
		{
			return vars.ItemSplit(current.slot3);
		}
		if (current.slot4 != old.slot4 && current.slot4 != old.slot5)
		{
			return vars.ItemSplit(current.slot4);
		}
		if (current.slot5 != old.slot5 && current.slot5 != old.slot6)
		{
			return vars.ItemSplit(current.slot5);
		}
		if (current.slot6 != old.slot6)
		{
			return vars.ItemSplit(current.slot6);
		}
	}

	if (current.dslot1 > old.dslot1)
	{
		return settings["d1_"+current.area+"_"+current.room];
	}
	if (current.dslot2 > old.dslot2)
	{
		return settings["d2_"+current.area+"_"+current.room];
	}

	return false;
}
