/*
Resident Evil HD Remaster Autosplitter Version 3.0
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

Beta testers:
Pessimism, LileyaCelestie, GrowthKasei, Bawkbasoup, ZerothGames.

Donators that supported this script's development:
Pessimism

Thank you to all the above people for helping me make this possible.
-CursedToast/Nate

Update to Version 4.0.1
-Skhowl
*/

state("bhd")
{
	float time : "bhd.exe", 0x97C9C0, 0xE474C;
	int character : "bhd.exe", 0x97C9C0, 0x5118;
	int slot1 : "bhd.exe", 0x97C9C0, 0x38;
	int slot2 : "bhd.exe", 0x97C9C0, 0x40;
	int slot3 : "bhd.exe", 0x97C9C0, 0x48;
	int slot4 : "bhd.exe", 0x97C9C0, 0x50;
	int slot5 : "bhd.exe", 0x97C9C0, 0x58;
	int slot6 : "bhd.exe", 0x97C9C0, 0x60;
	int slot7 : "bhd.exe", 0x97C9C0, 0x68;
	int slot8 : "bhd.exe", 0x97C9C0, 0x70;
	int slot9 : "bhd.exe", 0x97C9C0, 0x78;
	int dslot1 : "bhd.exe", 0x97C9C0, 0x5088;
	int dslot2 : "bhd.exe", 0x97C9C0, 0x508C;
	int area : "bhd.exe", 0x97C9C0, 0xE4750;
	int roomid : "bhd.exe", 0x97C9C0, 0xE4754;
	int camera : "bhd.exe", 0x97C9C0, 0xE48B0;
	int playing : "bhd.exe", 0x98A0B0, 0x04; /* For start, reset and final split */
	int vidplaying : "bhd.exe", 0x9E4464, 0x5CBAC; /* For final split accuracy */
}

startup
{
	/* Debug messages for DebugView (https://docs.microsoft.com/en-us/sysinternals/downloads/debugview) */
	vars.DebugMessage = (Action<string>)((message) => { print("[Debug] " + message); });

	/* MENU */
	settings.Add("DoorSplit", false, "Auto-split on all doors?");
	settings.SetToolTip("DoorSplit", "Make sure you grab the right splits file either way!");

	settings.Add("ItemSplit", true, "Auto-split on picking up items. (sort by item id)");
	settings.CurrentDefaultParent = "ItemSplit";
	settings.Add("item1", false, "1: Survival Knife (Jill)");
	settings.Add("item2", false, "2: Survival Knife (Chris)");
	settings.Add("item3", false, "3: Handgun");
	settings.Add("item4", false, "4: Self Defense Gun");
	settings.Add("item5", false, "5: Samurai Edge");
	settings.Add("item6", false, "6: Shotgun");
	settings.Add("item7", false, "7: Grenade Launcher (Grenade)");
	settings.Add("item8", false, "8: Grenade Launcher (Acid)");
	settings.Add("item9", false, "9: Grenade Launcher (Incendiary)");
	settings.Add("item10", false, "10: Rocket Launcher");
	settings.Add("item11", false, "11: Magnum Revolver");
	settings.Add("item12", false, "12: Flamethrower");
	settings.Add("item13", false, "13: Assault Shotgun");
	settings.Add("item14", false, "14: Rocket Launcher (Single Barrel)");
	settings.Add("item15", false, "15: Barry's 44 Magnum");
	// settings.Add("item16", false, "16: Grenade Shells");
	// settings.Add("item17", false, "17: Handgun Magazine");
	// settings.Add("item18", false, "18: Shotgun Shells");
	// settings.Add("item19", false, "19: Acid Shells");
	// settings.Add("item20", false, "20: Incendiary Shells");
	settings.Add("item21", false, "21: Golden Arrow");
	settings.Add("item22", false, "22: Book of Curses");
	settings.Add("item23", false, "23: Coin");
	settings.Add("item24", false, "24: Collar");
	// settings.Add("item25", false, "25: Magnum Rounds");
	settings.Add("item26", false, "26: Broach");
	settings.Add("item27", false, "27: Fuel Canteen");
	settings.Add("item28", false, "28: Arrowhead");
	settings.Add("item29", false, "29: Imitation of a key");
	settings.Add("item30", false, "30: Gallery Key");
	settings.Add("item31", false, "31: Fuel Supply Capsule (Full)");
	settings.Add("item32", false, "32: Musical Score (Missing Music)");
	// settings.Add("item33", false, "33: First Aid Spray");
	// settings.Add("item34", false, "34: Green Herb");
	// settings.Add("item35", false, "35: Red Herb");
	// settings.Add("item36", false, "36: Blue Herb");
	// settings.Add("item37", false, "37: Mixed Herbs (G+G)");
	// settings.Add("item38", false, "38: Mixed Herbs (G+G+G)");
	// settings.Add("item39", false, "39: Mixed Herbs (G+R)");
	// settings.Add("item40", false, "40: Mixed Herbs (G+R+B)");
	// settings.Add("item41", false, "41: Mixed Herbs (G+B)");
	// settings.Add("item42", false, "42: Mixed Herbs (G+G+B)");
	settings.Add("item43", false, "43: Lock Pick (Jill)");
	settings.Add("item44", false, "44: Old Key (5 Times)");
	settings.Add("item45", false, "45: Sword Key");
	settings.Add("item46", false, "46: Armor Key");
	settings.Add("item47", false, "47: Shield Key");
	settings.Add("item48", false, "48: Helmet Key");
	settings.Add("item49", false, "49: Key for Room 001");
	settings.Add("item50", false, "50: Key for Room 003");
	settings.Add("item51", false, "51: Medal of Eagle");
	settings.Add("item52", false, "52: Medal of Wolf");
	settings.Add("item53", false, "53: Stone & Metal Object");
	settings.Add("item54", false, "54: Key for the Power Area");
	settings.Add("item55", false, "55: Master Key");
	settings.Add("item56", false, "56: Star Crest");
	settings.Add("item57", false, "57: Wind Crest");
	settings.Add("item58", false, "58: Sun Crest");
	settings.Add("item59", false, "59: Moon Crest");
	settings.Add("item60", false, "60: Square Crank");
	settings.Add("item61", false, "61: Hexagon Crank");
	// settings.Add("item62", false, "62: Closet Key");
	settings.Add("item63", false, "63: Emblem Key");
	settings.Add("item64", false, "64: Stone Ring");
	settings.Add("item65", false, "65: Metal Object");
	settings.Add("item66", false, "66: Survival Knife (Black Tiger)");
	settings.Add("item67", false, "67: Battery");
	// settings.Add("item68", false, "68: Ink Ribbon");
	settings.Add("item69", false, "69: Wooden Emblem");
	settings.Add("item70", false, "70: Gold Emblem");
	settings.Add("item71", false, "71: Sheet Music (Moonlight Sonata)");
	settings.Add("item72", false, "72: Red Gemstone");
	settings.Add("item73", false, "73: Blue Gemstone");
	settings.Add("item74", false, "74: Yellow Gemstone");
	settings.Add("item75", false, "75: Broken Shotgun");
	settings.Add("item76", false, "76: Herbicide (Chemical)");
	settings.Add("item77", false, "77: Lighter");
	settings.Add("item78", false, "78: Serum");
	// settings.Add("item79", false, "79: Transceiver");
	// settings.Add("item80", false, "80: Empty Bottle");
	// settings.Add("item81", false, "81: Water");
	// settings.Add("item82", false, "82: UMB No. 3");
	// settings.Add("item83", false, "83: NP-004");
	// settings.Add("item84", false, "84: Yellow-6");
	// settings.Add("item85", false, "85: UMB No. 7");
	// settings.Add("item86", false, "86: UMB No. 10");
	// settings.Add("item87", false, "87: VP-017");
	settings.Add("item88", false, "88: V-JOLT");
	// settings.Add("item89", false, "89: It Hasnt Been Used!!!");
	settings.Add("item90", false, "90: Unprinted Book");
	settings.Add("item91", false, "91: Last Book Vol. 1 (Red)");
	settings.Add("item92", false, "92: Last Book Vol. 2 (Blue)");
	settings.Add("item93", false, "93: MO Disc 1 (Tiger Statue Room)");
	settings.Add("item94", false, "94: MO Disc 2 (Laboratory Stairway)");
	settings.Add("item95", false, "95: MO Disc 3 (Visual Data Room)");
	settings.Add("item96", false, "96: Dog Whistle");
	settings.Add("item97", false, "97: Fuse Unit");
	// settings.Add("item98", false, "98: Capsule (Animation)");
	settings.Add("item99", false, "99: Jewellery Box (Lisa's Room, Stone Ring)");
	settings.Add("item100", false, "100: Insecticide Spray");
	// settings.Add("item101", false, "101: First Aid Box (First Aid Spray)");
	settings.Add("item102", false, "102: Jewellery Box (Mirror Room, Broach)");
	settings.Add("item103", false, "103: Jewellery Box (Armor Room, Mask)");
	// settings.Add("item104", false, "104: First Aid Box 2 (Green Herb)");
	// settings.Add("item105", false, "105: First Aid Box 3 (Blue Herb)");
	settings.Add("item106", false, "106: Signal Rockets");
	settings.Add("item107", false, "107: Broken Flamethrower");
	settings.Add("item108", false, "108: Wooden Mount");
	settings.Add("item109", false, "109: Slide Filter");
	settings.Add("item110", false, "110: Control Room Key");
	settings.Add("item111", false, "111: Fuel Supply Capsule (Empty)");
	// settings.Add("item112", false, "112: Dagger");
	// settings.Add("item113", false, "113: Flash Grenade");
	// settings.Add("item114", false, "114: Stun Gun");
	settings.Add("item115", false, "115: Bee Specimen");
	settings.Add("item116", false, "116: Lure without a hook");
	settings.Add("item117", false, "117: Fishhook");
	settings.Add("item118", false, "118: Lure of a Bee");
	// settings.Add("item119", false, "119: X-Ray of CLARK");
	// settings.Add("item120", false, "120: X-Ray of GAIL");
	// settings.Add("item121", false, "121: Battery Pack");
	settings.Add("item122", false, "122: Shaft");
	settings.Add("item123", false, "123: Cylinder");
	settings.Add("item124", false, "124: Cylinder Shaft");
	settings.Add("item125", false, "125: Mask without eyes, nose, or mouth");
	settings.Add("item126", false, "126: Mask without eyes");
	settings.Add("item127", false, "127: Mask without a nose");
	settings.Add("item128", false, "128: Mask without a mouth");
	settings.Add("item129", false, "129: Musical Score (Music, mid-pages)");
	// settings.Add("item130", false, "130: Map (Animation)");
	// settings.Add("item131", false, "131: First Aid Box 4 (Mixed Herbs (G+B))");
	// settings.Add("item132", false, "132: First Aid Box 5 (Mixed Herbs (G+G))");
	settings.CurrentDefaultParent = null;

	settings.Add("DefenceSplit", true, "Auto-split on picking up defensives items.");
	settings.CurrentDefaultParent = "DefenceSplit";
	settings.Add("defence1", true, "Dagger");
	settings.Add("d1_2_2", false, "Dining Room 2F (Mansion 2F)", "defence1");
	settings.SetToolTip("d1_2_2", "On the shelf along the north side of the room.");
	settings.Add("d1_1_7", false, "Art Room (Mansion 1F)", "defence1");
	settings.SetToolTip("d1_1_7", "On the shelf at end of the small storage area.");
	settings.Add("d1_1_8", false, "'L' Corridor (Mansion 1F)", "defence1");
	settings.SetToolTip("d1_1_8", "Underneath the first wooden cabinet, push it aside to reveal.");
	settings.Add("d1_1_9", false, "Bathroom (Jill, Mansion 1F)", "defence1");
	settings.SetToolTip("d1_1_9", "Inside the bathtub once it's been emptied.");
	settings.Add("d1_1_22", false, "Living Room (Mansion 1F)", "defence1");
	settings.SetToolTip("d1_1_22", "On the coffee table in the middle of the room.");
	settings.Add("d1_2_18", false, "Outside Patio (Mansion 2F)", "defence1");
	settings.SetToolTip("d1_2_18", "On the bench next to Forest.");
	settings.Add("d1_2_28", false, "Kitchen (Mansion B1)", "defence1");
	settings.SetToolTip("d1_2_28", "On the edge of the main bench.");
	settings.Add("d1_1_3", false, "Northern Corridor (Mansion 1F)", "defence1");
	settings.SetToolTip("d1_1_3", "On the small shelf next to the door to the Tiger Statue Room.");
	settings.Add("d1_4_11", false, "Room 003 Bathroom (Residence 1F)", "defence1");
	settings.SetToolTip("d1_4_11", "Inside the bathtub once it has been emptied.");
	settings.Add("d1_2_21", false, "Trophy Room (Mansion 2F)", "defence1");
	settings.SetToolTip("d1_2_21", "On the cabinet in the north west corner of the room.");
	settings.Add("d1_1_17", false, "Mirror Room (Mansion 1F)", "defence1");
	settings.SetToolTip("d1_1_17", "On the floor next to the southern wall.");
	settings.Add("d1_2_27", false, "Concrete Passage 2 (Mansion B1)", "defence1");
	settings.SetToolTip("d1_2_27", "On the floor next to the wire fence.");
	settings.Add("d1_3_25", false, "Lisa's Room (Courtyard B2)", "defence1");
	settings.SetToolTip("d1_3_25", "On the bed.");
	settings.Add("d1_5_5", false, "'O' Room (Laboratory B3)", "defence1");
	settings.SetToolTip("d1_5_5", "On the shelves opposite the giant ventilation fan.");
	settings.Add("defence2", true, "Flash Grenade or Battery Pack");
	settings.Add("d2_1_2", false, "Small Storeroom (Mansion 1F)", "defence2");
	settings.SetToolTip("d2_1_2", "On the cabinet next to the entrance.");
	settings.Add("d2_1_3", false, "Northern Corridor (Mansion 1F)", "defence2");
	settings.SetToolTip("d2_1_3", "On the cabinet next to the western entrance.");
	settings.Add("d2_2_14", false, "Attic Entry (Mansion 2F)", "defence2");
	settings.SetToolTip("d2_2_14", "On the floor next to the entrance to the Small Dining Room.");
	settings.Add("d2_1_27", false, "Garden Shed (2 Times, Mansion 1F)", "defence2");
	settings.SetToolTip("d2_1_27", "1. On the shelf beside the small stone steps.\n2. On the floor, left to you by Barry/Wesker when you return from exploring the Guardhouse Residence.");
	settings.Add("d2_4_3", false, "Residence Storeroom (Residence 1F)", "defence2");
	settings.SetToolTip("d2_4_3", "On the shelf next to the table with the typewriter.");
	settings.Add("d2_2_12", false, "Sliding Trap Room (Mansion 2F)", "defence2");
	settings.SetToolTip("d2_2_12", "On the small cabinet in the hidden area that gets revealed once you position the statue.");
	settings.Add("d2_2_25", false, "Materials Room (Mansion 2F)", "defence2");
	settings.SetToolTip("d2_2_25", "On the floor.");
	settings.Add("d2_1_25", false, "Courtyard Study (Mansion 1F)", "defence2");
	settings.SetToolTip("d2_1_25", "On the bookcase on the west wall.");
	settings.Add("d2_3_24", false, "Underground Storage Room (Courtyard B2)", "defence2");
	settings.SetToolTip("d2_3_24", "On the very top of the piles of boxes in the corner opposite the small cargo transporter.");
	settings.Add("d2_5_6", false, "Operating Room (Laboratory B3)", "defence2");
	settings.SetToolTip("d2_5_6", "On the shelves in the back room, opposite the body bags.");
	settings.Add("d2_5_7", false, "Morgue (Laboratory B3)", "defence2");
	settings.SetToolTip("d2_5_7", "On the desk in the south west corner, you have to travel through the air ducts to reach it.");
	settings.Add("d2_5_16", false, "Power Maze B (Laboratory B3)", "defence2");
	settings.SetToolTip("d2_5_16", "On the floor in the north west corner of the maze.");
	settings.CurrentDefaultParent = null;

	settings.Add("EventSplit", true, "Auto-split on special events. (ONLY TESTED WITH CHRIS)");
	settings.CurrentDefaultParent = "EventSplit";
	settings.Add("RebeccaA", false, "Rebecca Chambers A (Pillar Room)");
	settings.SetToolTip("RebeccaA", "She is trying to treat the wounded Richard.");
	settings.Add("RebeccaB", false, "Rebecca Chambers B (Pillar Room)");
	settings.SetToolTip("RebeccaB", "Chris arrived with the serum.");
	settings.Add("Grimson", false, "Crimson Head Prototype 1 (Crypt)");
	settings.SetToolTip("Grimson", "After you've placed all mask's into their respective places on the wall next to the entrance, it emerges from the fallen coffin.");
	settings.Add("TransceiverA", false, "Overhear Talk (Muddy Path)");
	settings.SetToolTip("TransceiverA", "Overhear unknown talk with transceiver.");
	settings.Add("CemeteryGate", false, "Cemetery Gate (Muddy Path)");
	settings.SetToolTip("CemeteryGate", "After you solved the red and blue signpost puzzle.");
	settings.Add("LisaA", false, "Lisa Trevor A (Cabin)");
	settings.SetToolTip("LisaA", "Lisa knocks you unconscious.");
	settings.Add("TransceiverB", false, "Brad Vickers A (Main Garden)");
	settings.SetToolTip("TransceiverB", "Brad tries an answer from S.T.A.R.S. Alpha or Bravo Team to get through the transceiver.");
	settings.Add("Richard", false, "Richard Aiken (Aqua Ring Walkway)");
	settings.SetToolTip("Richard", "If you saved his life in the mansion earlier on, he will be standing on the metal walkway opposite you when you enter the room.");
	settings.Add("Plant42", false, "Plant 42 (Plant 42 Room)");
	settings.SetToolTip("Plant42", "Plant 42 is attacking you.");
	settings.Add("WeskerA", false, "Albert Wesker (Central Corridor)");
	settings.SetToolTip("WeskerA", "Meeting with Wesker after acquiring the Helmet Key.");
	settings.Add("TransceiverC", false, "Brad Vickers B (Zigzag Path)");
	settings.SetToolTip("TransceiverC", "Brad tries a second answer from S.T.A.R.S. Team to get through the transceiver.");
	settings.Add("ElevatorA", false, "Mansion Elevator (Kitchen, Elevator Corridor)");
	settings.SetToolTip("ElevatorA", "If you take the elevator.");
	settings.Add("Yawn", false, "Yawn (Library)");
	settings.SetToolTip("Yawn", "Yawn shows up and is ready to fight.");
	settings.Add("YawnKilled", false, "Yawn Killed (Library)");
	settings.SetToolTip("YawnKilled", "Yawn get's killed in Library for Last Book Vol. 2.");
	settings.Add("BatteryPlaced", false, "Battery Placed (Falls Area)");
	settings.SetToolTip("BatteryPlaced", "Used to power the elevator in the Falls Area of the Courtyard, enabling you to access the area under the waterfall once the water flow has been stopped.");
	settings.Add("WaterPool", false, "Replenish Water (Water Pool)");
	settings.SetToolTip("WaterPool", "After you have used Square Crank to fill the water pool.");
	settings.Add("Enrico", false, "Enrico Marini (Enrico Room)");
	settings.SetToolTip("Enrico", "Sitting on the floor at the end of the passage.");
	settings.Add("BlackTiger", false, "Black Tiger (Spider Room)");
	settings.SetToolTip("BlackTiger", "Black Tiger is showing up.");
	settings.Add("Boulder", false, "Boulder (Boulder Passage 2)");
	settings.SetToolTip("Boulder", "Hexagon Crank was used 3 Times in a row.");
	settings.Add("Create", false, "Wooden Box (Underground Storage Room)");
	settings.SetToolTip("Create", "Wooden Box goes on the cable car");
	settings.Add("RebeccaC", false, "Rebecca Chambers C (Courtyard Study)");
	settings.SetToolTip("RebeccaC", "If while exploring the Courtyard Study you hear her scream, you will find her in Small Library.");
	settings.Add("WeskerB", false, "Wesker attack Lisa (Altar B2)");
	settings.SetToolTip("WeskerB", "Wesker attacking Lisa.");
	settings.Add("LisaB", false, "Lisa Trevor B (Altar B2)");
	settings.SetToolTip("LisaB", "After Lisa is jumping down the pit and you entering the hall way.");
	settings.Add("Terminal", false, "Terminal (Operating Room)");
	settings.SetToolTip("Terminal", "When you access Terminal.");
	settings.Add("PowerA", false, "Fuel Supply Capsule placed (Power Maze A)");
	settings.SetToolTip("PowerA", "When you placed the full Fuel Supply Capsule and the light is turning green.");
	settings.Add("PowerB", false, "Power On (Power Control Room)");
	settings.SetToolTip("PowerB", "When the power has turned on.");
	settings.Add("Tyrant", false, "Tyrant attacks Wesker (Main Laboratory)");
	settings.SetToolTip("Tyrant", "Tyrant attacks Wesker.");
	settings.Add("End", true, "GAME IS DONE! (Landing Point)");
	settings.SetToolTip("End", "FINAL SPLIT");
}

init
{
	bool[] items = new bool[133];
	bool[] events = new bool[27];

	vars.GetItem = (Func<int, bool>)((id) => { return items[id]; });
	vars.SetEvent = (Action<int>)((id) => { events[id] = true; });
	vars.GetEvent = (Func<int, bool>)((id) => { return events[id]; });

	vars.ItemSplit = (Func<int, bool>)((id) =>
	{
		if (id == 44) /* Old Key */
		{
			return settings["item44"];
		}
		if (items[id] == false)
		{
			items[id] = true;
			return settings.ContainsKey("item"+id) && settings["item"+id];
		}
		return false;
	});

	vars.ResetAllTo = (Action<bool>)((value) =>
	{
		for (int i = 0; i < 133; i++)
		{
			items[i] = value;
		}
		for (int i = 0; i < 27; i++)
		{
			events[i] = value;
		}
	});

	refreshRate = 120.0;
}

start
{
	return current.playing == 0x0550 && current.time < 0.05;
}

reset
{
	return current.playing == 0x0140 && old.playing == 0x0550;
}

gameTime
{
	return TimeSpan.FromSeconds(current.time);
}

isLoading
{
	return true;
}

update
{
	if (timer.CurrentPhase == TimerPhase.NotRunning)
	{
		vars.ResetAllTo(false);
	}
}

split
{
	if (current.roomid != old.roomid)
	{
		// vars.DebugMessage("Room: "+current.roomid+" - PrevRoom: "+old.roomid);
		return settings["DoorSplit"];
	}

	// if (current.playing == 0x01B0 && old.playing == 0x0550)
	if (current.playing == 0x01B0 && current.vidplaying != 0)
	{
		return settings["End"];
	}

	if (current.camera != old.camera)
	{
		ushort SceneID = (ushort)(current.area*10000+current.roomid*100+current.camera);
		// vars.DebugMessage("Area: "+current.area+", Room: "+current.roomid+", Camera: "+current.camera+", Scene: "+SceneID+" (0x"+SceneID.ToString("X4")+")");
		switch (SceneID)
		{
			case 21304: /* Without Serum */
				if (vars.GetEvent(0) == false && vars.GetItem(78) == false)
				{
					vars.SetEvent(0);
					return settings["RebeccaA"];
				}
				break;
			case 21311: /* With Serum */
				if (vars.GetEvent(1) == false && vars.GetItem(78) == true)
				{
					vars.SetEvent(1);
					return settings["RebeccaB"];
				}
				break;
			case 11121:
				if (vars.GetEvent(2) == false)
				{
					vars.SetEvent(2);
					return settings["Grimson"];
				}
				break;
			case 31714:
				if (vars.GetEvent(3) == false)
				{
					vars.SetEvent(3);
					return settings["TransceiverA"];
				}
				break;
			case 31707:
				if (vars.GetEvent(4) == false)
				{
					vars.SetEvent(4);
					return settings["CemeteryGate"];
				}
				break;
			case 32018:
				if (vars.GetEvent(5) == false)
				{
					vars.SetEvent(5);
					return settings["LisaA"];
				}
				break;
			case 30009:
				if (vars.GetEvent(6) == false)
				{
					vars.SetEvent(6);
					return settings["TransceiverB"];
				}
				break;
			case 41422:
				if (vars.GetEvent(7) == false)
				{
					vars.SetEvent(7);
					return settings["Richard"];
				}
				break;
			case 41218:
				if (vars.GetEvent(8) == false)
				{
					vars.SetEvent(8);
					return settings["Plant42"];
				}
				break;
			case 40509:
				if (vars.GetEvent(9) == false)
				{
					vars.SetEvent(9);
					return settings["WeskerA"];
				}
				break;
			case 30408:
				if (vars.GetEvent(10) == false)
				{
					vars.SetEvent(10);
					return settings["TransceiverC"];
				}
				break;
			case 20000:
				if (vars.GetEvent(11) == false)
				{
					vars.SetEvent(11);
					return settings["ElevatorA"];
				}
				break;
			case 22205:
				if (vars.GetEvent(12) == false)
				{
					vars.SetEvent(12);
					return settings["Yawn"];
				}
				break;
			case 22214:
				if (vars.GetEvent(13) == false)
				{
					vars.SetEvent(13);
					return settings["YawnKilled"];
				}
				break;
			case 30208:
				if (vars.GetEvent(14) == false && vars.GetItem(67) == true)
				{
					vars.SetEvent(14);
					return settings["BatteryPlaced"];
				}
				break;
			case 30110:
				if (vars.GetEvent(15) == false && old.camera == 7)
				{
					vars.SetEvent(15);
					return settings["WaterPool"];
				}
				break;
			case 31005:
				if (vars.GetEvent(16) == false)
				{
					vars.SetEvent(16);
					return settings["Enrico"];
				}
				break;
			case 31203:
				if (vars.GetEvent(17) == false)
				{
					vars.SetEvent(17);
					return settings["BlackTiger"];
				}
				break;
			case 31508:
				if (vars.GetEvent(18) == false)
				{
					vars.SetEvent(18);
					return settings["Boulder"];
				}
				break;
			case 32406:
				if (vars.GetEvent(19) == false)
				{
					vars.SetEvent(19);
					return settings["Create"];
				}
				break;
			case 12506:
				if (vars.GetEvent(20) == false)
				{
					vars.SetEvent(20);
					return settings["RebeccaC"];
				}
				break;
			case 32122:
				if (vars.GetEvent(21) == false)
				{
					vars.SetEvent(21);
					return settings["WeskerB"];
				}
				break;
			case 32107:
				if (vars.GetEvent(22) == false)
				{
					vars.SetEvent(22);
					return settings["LisaB"];
				}
				break;
			case 50608:
				if (vars.GetEvent(23) == false)
				{
					vars.SetEvent(23);
					return settings["Terminal"];
				}
				break;
			case 51510:
				if (vars.GetEvent(24) == false)
				{
					vars.SetEvent(24);
					return settings["PowerA"];
				}
				break;
			case 51707:
				if (vars.GetEvent(25) == false)
				{
					vars.SetEvent(25);
					return settings["PowerB"];
				}
				break;
			case 51929:
				if (vars.GetEvent(26) == false)
				{
					vars.SetEvent(26);
					return settings["Tyrant"];
				}
				break;
		}
	}

	if (current.dslot1 > old.dslot1)
	{
		// vars.DebugMessage("DSlot 1: d1_"+current.area+"_"+current.roomid);
		return settings["d1_"+current.area+"_"+current.roomid];
	}
	if (current.dslot2 > old.dslot2)
	{
		// vars.DebugMessage("DSlot 2: d2_"+current.area+"_"+current.roomid);
		return settings["d2_"+current.area+"_"+current.roomid];
	}

	if (current.slot1 != old.slot1 && current.slot1 != old.slot2)
	{
		// vars.DebugMessage("Slot 1: "+current.slot1);
		return vars.ItemSplit(current.slot1);
	}
	if (current.slot2 != old.slot2 && current.slot2 != old.slot3)
	{
		// vars.DebugMessage("Slot 2: "+current.slot2);
		return vars.ItemSplit(current.slot2);
	}
	if (current.slot3 != old.slot3 && current.slot3 != old.slot4)
	{
		// vars.DebugMessage("Slot 3: "+current.slot3);
		return vars.ItemSplit(current.slot3);
	}
	if (current.slot4 != old.slot4 && current.slot4 != old.slot5)
	{
		// vars.DebugMessage("Slot 4: "+current.slot4);
		return vars.ItemSplit(current.slot4);
	}
	if (current.slot5 != old.slot5 && current.slot5 != old.slot6)
	{
		// vars.DebugMessage("Slot 5: "+current.slot5);
		return vars.ItemSplit(current.slot5);
	}
	if (current.character == 1) /* JILL */
	{
		if (current.slot6 != old.slot6 && current.slot6 != old.slot7)
		{
			// vars.DebugMessage("Slot 6: "+current.slot6);
			return vars.ItemSplit(current.slot6);
		}
		if (current.slot7 != old.slot7 && current.slot7 != old.slot8)
		{
			// vars.DebugMessage("Slot 7: "+current.slot7);
			return vars.ItemSplit(current.slot7);
		}
		if (current.slot8 != old.slot8)
		{
			// vars.DebugMessage("Slot 8: "+current.slot8);
			return vars.ItemSplit(current.slot8);
		}
		if (current.slot9 != old.slot9)
		{
			// vars.DebugMessage("Slot 9: "+current.slot9);
			return vars.ItemSplit(current.slot9);
		}
	}
	else /* CHRIS */
	{
		if (current.slot6 != old.slot6)
		{
			// vars.DebugMessage("Slot 6: "+current.slot6);
			return vars.ItemSplit(current.slot6);
		}
	}

	return false;
}
