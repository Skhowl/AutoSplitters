/*
Resident Evil HD Remaster Autosplitter Version 5.0.0
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
TheDementedSalad - load remover and rework

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
	
	vars.Items = new List<int>()
    {4, 6, 7, 13, 21, 22, 23, 24, 26, 28,
     29, 30, 31, 32, 43, 45, 46, 47, 48, 49, 
	 50, 51, 52, 53, 54, 55, 60, 61, 63, 64, 
	 65, 66, 67, 69, 70, 71, 72, 74, 76, 77, 
	 80, 90, 91, 92, 93, 94, 95, 96, 97, 99, 
	 100, 102, 103, 106, 107, 110, 111,
	 112, 123, 124, 126, 127, 128, 129};
	 
	vars.Events = new List<int>()
    {11121, 31707, 22205, 22214, 30208, 30110, 31508, 32406, 32107, 50608, 51510, 51707};
	
	
}

init
{
	vars.completedSplitsInt = new List<int>();
	vars.keys = new HashSet<string>();
	current.Inventory = new int[9];

	refreshRate = 120.0;
}

update
{ 
	if(timer.CurrentPhase == TimerPhase.NotRunning)
	{
		vars.completedSplitsInt.Clear();
		vars.keys = new HashSet<string>();
	}

	//Iterate through the inventory slots to return their values
	for(int i = 0; i < 9; i++)
	{
		current.Inventory[i] = new DeepPointer(0x97C9C0, 0x38 + (i * 0x8)).Deref<int>(game);
    }
}

start
{
	if (current.playing == 0x0550 && current.time < 0.05)
	{
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
	//vars.DebugMessage("Area: "+current.area+", Room: "+current.room+", Camera: "+current.camera+", Scene: "+SceneID+" (0x"+SceneID.ToString("X4")+")");


	//Event Splits
	if(settings["EventSplit"]){
		if(vars.Events.Contains(SceneID) && !vars.completedSplitsInt.Contains(SceneID))
           {
            vars.completedSplitsInt.Add(SceneID);
            return settings[SceneID.ToString()];
        }
	}

	//Inventory Splitter
	if(settings["ItemSplit"]){
		int[] currentInventory = (current.Inventory as int[]);
		
		for(int i = 0; i < 9; i++){
			if(currentInventory[i] == 44){
				if(SceneID == 10917 && !vars.keys.Contains("K1")){
					vars.keys.Add("K1");
					return settings["K1"];
				}
				else if(SceneID == 12401 && !vars.keys.Contains("K2")){
					vars.keys.Add("K2");
					return settings["K2"];
				}
				else if(SceneID == 11404 && !vars.keys.Contains("K3")){
					vars.keys.Add("K3");
					return settings["K3"];
				}
			}
			else if(vars.Items.Contains(currentInventory[i]) && !vars.completedSplitsInt.Contains(currentInventory[i])){
            	vars.completedSplitsInt.Add(currentInventory[i]);
            	return settings[currentInventory[i].ToString()];
        	}
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
