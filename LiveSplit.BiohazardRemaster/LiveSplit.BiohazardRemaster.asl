/*
Resident Evil HD Remaster Autosplitter Version 4.2.2
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

Update to Version 4.2.2 (4/29/2021)
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
	int room : "bhd.exe", 0x97C9C0, 0xE4754;
	int camera : "bhd.exe", 0x97C9C0, 0xE48B0;
	int playing : "bhd.exe", 0x98A0B0, 0x04;
	int vidplaying : "bhd.exe", 0x9E4464, 0x5CBAC;
}

startup
{
	/* Debug messages for DebugView (https://docs.microsoft.com/en-us/sysinternals/downloads/debugview) */
	vars.DebugMessage = (Action<string>)((message) => { print("[Debug] " + message); });

	/* MENU */
	settings.Add("DoorSplit", false, "Auto-split on all doors!");
	settings.SetToolTip("DoorSplit", "Make sure you grab the right splits file either way!");

	settings.Add("RoomSplit", true, "Auto-split on specific rooms. (Ignored when 'all doors' are enabled)");
	settings.CurrentDefaultParent = "RoomSplit";
	settings.Add("room20501", false, "Entering Armor Room");
	settings.Add("room12306", false, "Entering Large Gallery");
	settings.Add("room41300", false, "Entering Aqua Ring entrance");
	settings.Add("room41200", false, "Entering Plant 42 Room");
	settings.Add("room21203", false, "Entering Sliding Trap Room");
	settings.Add("room20000", false, "Mansion Elevator (Kitchen 🡸/🡺 Elevator Corridor)");
	settings.Add("room31200", false, "Entering Spider Room");
	settings.Add("room31301", false, "Entering Straight Passage");
	settings.Add("room30600", false, "Entering Underground Statue Room");
	settings.Add("room52100", false, "Elevator to Laboratory B3 from B4");
	settings.Add("room52101", false, "Elevator to Laboratory B4 from B3");
	settings.CurrentDefaultParent = null;

	settings.Add("ItemSplit", true, "Auto-split on picking up items. (Sort by item id)");
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
	settings.Add("item77", false, "77: Lighter (Jill)");
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
	settings.Add("item119", false, "119: X-Ray of CLARK");
	settings.Add("item120", false, "120: X-Ray of GAIL");
	// settings.Add("item121", false, "121: Battery Pack");
	settings.Add("item122", false, "122: Shaft");
	settings.Add("item123", false, "123: Cylinder");
	settings.Add("item124", false, "124: Cylinder Shaft");
	settings.Add("item125", false, "125: Mask without eyes, nose and mouth");
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

	settings.Add("EventSplit", true, "Auto-split on certain events.");
	settings.CurrentDefaultParent = "EventSplit";
	settings.Add("fmv", true, "FMV Events");
	settings.Add("fmv103", false, "Zombie eating Kenneth (Tea Room)", "fmv");
	settings.Add("fmv301", false, "Drain the water (Water Pool)", "fmv");
	settings.Add("fmv414", false, "Shark speeding (Jill, Aqua Ring Walkway)", "fmv");
	settings.Add("fmv110", false, "A Hunter is coming for you (Dark Corridor)", "fmv");
	settings.Add("fmv305", false, "Fountain releasing (Fountain)", "fmv");
	settings.Add("fmv519", false, "Tyrant shown in cryogenic tube (Main Laboratory)", "fmv");
	settings.Add("shared", true, "Shared Events");
	settings.Add("event10509", false, "Clock puzzle (Dining Room)", "shared");
	settings.Add("event21605", false, "Yawn A (Attic)", "shared");
	settings.SetToolTip("event21605", "Yawn shows up and is ready to fight.");
	settings.Add("event11116", false, "Placing Mask without eyes (Crypt)", "shared");
	settings.Add("event11117", false, "Placing Mask without eyes, nose and mouth (Crypt)", "shared");
	settings.Add("event11118", false, "Placing Mask without a nose (Crypt)", "shared");
	settings.Add("event11119", false, "Placing Mask without a mouth (Crypt)", "shared");
	settings.Add("event11121", false, "Crimson Head awakens (Crypt)", "shared");
	settings.SetToolTip("event11121", "After you've placed all mask's into their respective places on the wall next to the entrance, it emerges from the fallen coffin.");
	settings.Add("event31714", false, "Overhear transmission (Muddy Path)", "shared");
	settings.SetToolTip("event31714", "Overhear unknown transmission with transceiver.");
	settings.Add("event31707", false, "Cemetery gate (Muddy Path)", "shared");
	settings.SetToolTip("event31707", "After you solved the red and blue signpost puzzle.");
	settings.Add("event32018", false, "Lisa Trevor A (Cabin)", "shared");
	settings.SetToolTip("event32018", "Lisa knocks you unconscious.");
	settings.Add("event41729", false, "Aqua Park drained (Control Room)", "shared");
	settings.Add("event41811", false, "Neptune drops down Gallery Key (Aqua Ring Water Tank)", "shared");
	settings.Add("event40507", false, "Killing bee hive (Central Corridor)", "shared");
	settings.Add("event40509", false, "Albert Wesker (Central Corridor)", "shared");
	settings.SetToolTip("event40509", "Meeting with Wesker after acquiring the Helmet Key.");
	settings.Add("event22205", false, "Yawn B (Library)", "shared");
	settings.SetToolTip("event22205", "Yawn shows up a second time and is ready to fight.");
	settings.Add("event22214", false, "Yawn dying (Library)", "shared");
	settings.SetToolTip("event22214", "Yawn get's killed in Library for Last Book Vol. 2.");
	settings.Add("event30208", false, "Battery placed (Falls Area)", "shared");
	settings.SetToolTip("event30208", "Used to power the elevator in the Falls Area of the Courtyard, enabling you to access the area under the waterfall once the water flow has been stopped.");
	settings.Add("event30110", false, "Replenish water (Water Pool)", "shared");
	settings.SetToolTip("event30110", "After you have used Square Crank to fill the water pool.");
	settings.Add("event31508", false, "Boulder rolling (Boulder Passage 2)", "shared");
	settings.SetToolTip("event31508", "Hexagon Crank was used 3 Times in a row.");
	settings.Add("event32406", false, "Wooden box (Underground Storage Room)", "shared");
	settings.SetToolTip("event32406", "Wooden Box goes on the cable car");
	settings.Add("event32315", false, "Activating switch (Winding Underground Passage)", "shared");
	settings.Add("event32107", false, "Lisa Trevor B (Altar B2)", "shared");
	settings.SetToolTip("event32107", "After Lisa is jumping down the pit and you entering the hall way.");
	settings.Add("event50608", false, "*Terminal* (Operating Room)", "shared");
	settings.SetToolTip("event50608", "When you access Terminal.");
	settings.Add("event50712", false, "Insert Disc... A (Morgue)", "shared");
	settings.Add("event51005", false, "Insert Disc... B (X-Ray Room B)", "shared");
	settings.Add("event51510", false, "Fuel Supply Capsule placed (Power Maze A)", "shared");
	settings.SetToolTip("event51510", "When you placed the full Fuel Supply Capsule and the light is turning green.");
	settings.Add("event51606", false, "Insert Disc... C (Power Maze B)", "shared");
	settings.Add("event51707", false, "Power on (Power Control Room)", "shared");
	settings.SetToolTip("event51707", "When the power has turned on.");
	settings.Add("chris", true, "Chris Redfield");
	settings.Add("event21304", false, "Rebecca Chambers A (Pillar Room)", "chris");
	settings.SetToolTip("event21304", "She is trying to treat the wounded Richard.");
	settings.Add("event21311", false, "Rebecca Chambers B (Pillar Room)", "chris");
	settings.SetToolTip("event21311", "Chris arrived with the serum.");
	settings.Add("event30009", false, "Brad Vickers A (Main Garden)", "chris");
	settings.SetToolTip("event30009", "Brad tries an answer from S.T.A.R.S. Alpha or Bravo Team to get through the transceiver.");
	settings.Add("event41422", false, "Richard Aiken (Aqua Ring Walkway)", "chris");
	settings.SetToolTip("event41422", "If you saved his life in the mansion earlier on, he will be standing on the metal walkway opposite you when you enter the room.");
	settings.Add("event30408", false, "Brad Vickers B (Zigzag Path)", "chris");
	settings.SetToolTip("event30408", "Brad tries a second answer from S.T.A.R.S. Team to get through the transceiver.");
	settings.Add("event31005", false, "Enrico Marini (Enrico Room)", "chris");
	settings.SetToolTip("event31005", "Sitting on the floor at the end of the passage.");
	settings.Add("event31114", false, "Avoiding boulder by a side jump (Boulder Passage 1)", "chris");
	settings.Add("event12506", false, "Rebecca Chambers C (Courtyard Study)", "chris");
	settings.SetToolTip("event12506", "If while exploring the Courtyard Study you hear her scream, you will find her in Small Library.");
	settings.Add("event20607", false, "Rebecca Chambers D (Small Library)", "chris");
	settings.Add("event32122", false, "Wesker attacks Lisa (Altar B2)", "chris");
	settings.Add("event51804", false, "Rescuing Jill (Cell)", "chris");
	settings.Add("jill", true, "Jill Valentine");
	settings.Add("event21322", false, "Richard Aiken A (Pillar Room)", "jill");
	settings.Add("event21329", false, "Richard Aiken B (Pillar Room)", "jill");
	settings.Add("event30012", false, "Brad Vickers A (Main Garden)", "jill");
	settings.SetToolTip("event30012", "Brad tries an answer from S.T.A.R.S. Alpha or Bravo Team to get through the transceiver.");
	settings.Add("event40514", false, "Barry arguing (Central Corridor)", "jill");
	settings.Add("event30410", false, "Brad Vickers B (Zigzag Path)", "jill");
	settings.SetToolTip("event30410", "Brad tries a second answer from S.T.A.R.S. Team to get through the transceiver.");
	settings.Add("event31014", false, "Enrico Marini (Enrico Room)", "jill");
	settings.SetToolTip("event31014", "Sitting on the floor at the end of the passage.");
	settings.Add("event31117", false, "Avoiding boulder by a side jump (Boulder Passage 1)", "jill");
	settings.Add("event32143", false, "Barry checking Altar (Altar B2)", "jill");
	settings.Add("event51808", false, "Rescuing Chris (Cell)", "jill");
	settings.CurrentDefaultParent = null;

	settings.Add("Outfits", true, "Gimme that damn outfit! (Check one only)");
	settings.SetToolTip("Outfits", "Start with the selected outfit.");
	settings.CurrentDefaultParent = "Outfits";
	settings.Add("outfit1", false, "Chris: CVX ♦ Jill: Sarah Conner");
	settings.Add("outfit2", false, "Chris: The Mexican ♦ Jill: Casual");
	settings.Add("outfit3", false, "Both: BSAA");
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
	return true;
}

gameTime
{
	return TimeSpan.FromSeconds(current.time);
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
		case 20000: /* Mansion Elevator (Kitchen 🡸/🡺 Elevator Corridor) */
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
