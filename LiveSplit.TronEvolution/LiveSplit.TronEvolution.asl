/*
    This is a LiveSplit ASL script for Tron: Evolution on Steam.

    - Twitch: https://www.twitch.tv/gehsalzen
    - GitHub: https://github.com/Skhowl/AutoSplitters
    - Discord: https://www.discord.gg/3D4ckwX
    - Youtube: https://www.youtube.com/channel/UCY-pqgCPPUCqQ7R3RbQI-uQ
*/

// GridGame 1.01
state("gridgame")
{
    // Static
    byte iNoBink    : 0x1D99188;
    byte iBGLevel   : 0x1EBA634;
    short iLastBink : "binkw32.dll", 0x27221;
    byte iBinkInfo  : "binkw32.dll", 0x27245;
    // Pointer
    byte iNoSkip : 0x1E7E63C, 0xD7;
    byte iTutCut : 0x1E89C18, 0, 0x908, 0xC, 0x382;
}

startup
{
    refreshRate = 0.5;

    // Debug messages for DebugView (https://docs.microsoft.com/en-us/sysinternals/downloads/debugview)
    vars.doDebug = true;
    vars.DebugMessage = (Action<string>)((message) =>
    {
        if (vars.doDebug)
        {
            print("[Debug] " + message);
        }
    });

    // Load remover:
    settings.Add("remover", true, "Load Remover use Game Time!");

    // Timer:
    settings.Add("timer", true, "Timer:");
    settings.CurrentDefaultParent = "timer";
    settings.Add("start", true, "Start after Introduction (enable to move)");
    settings.Add("finish", true, "Finish after Final Hit (screen goes black)");
    settings.CurrentDefaultParent = null;

    // Split:
    settings.Add("bink_split", false, "Split: Bink movie finished/skipped");
    settings.CurrentDefaultParent = "bink_split";
    // Chapter 1:
    settings.Add("bik_2188", false, "Ch.1: Quorra's Introduction");
    settings.SetToolTip("bik_2188", "Tron Evolution\\GridGame\\Movies\\Sc1_01_03.bik");
    settings.Add("bik_2764", true, "Ch.1: Radia's Installation Ceremony");
    settings.SetToolTip("bik_2764", "Tron Evolution\\GridGame\\Movies\\Sc1_01_03.bik");
    settings.Add("bik_3020", false, "Ch.1: Abraxas Disease Taunt");
    settings.SetToolTip("bik_3020", "Tron Evolution\\GridGame\\Movies\\101AbraxDiseaseTaunt.bik");
    settings.Add("bik_3604", false, "Ch.1: Abraxas jump down");
    settings.SetToolTip("bik_3604", "Tron Evolution\\GridGame\\Movies\\101AbraxasJumpDown.bik");
    settings.Add("bik_2980", false, "Ch.1: Abraxas jump up");
    settings.SetToolTip("bik_2980", "Tron Evolution\\GridGame\\Movies\\101AbraxasJumpUp.bik");
    settings.Add("bik_2852", false, "Ch.1: Abraxas Insignificance Taunt");
    settings.SetToolTip("bik_2852", "Tron Evolution\\GridGame\\Movies\\101AbraxInsigTaunt.bik");
    settings.Add("bik_3156", true, "Ch.1: Viral Attack");
    settings.SetToolTip("bik_3156", "Tron Evolution\\GridGame\\Movies\\Sc1_01_07.bik");
    settings.Add("bik_3120", true, "Ch.1: The Perfect System");
    settings.SetToolTip("bik_3120", "Tron Evolution\\GridGame\\Movies\\Sc1_03_01.bik");
    settings.Add("bik_1880", true, "Ch.1: Quorra's Gift");
    settings.SetToolTip("bik_1880", "Tron Evolution\\GridGame\\Movies\\Sc1_03_03.bik");
    settings.Add("bik_1532", true, "Ch.1: Quorra talk finding Zuse");
    settings.SetToolTip("bik_1532", "Tron Evolution\\GridGame\\Movies\\Sc1_03_04.bik");
    settings.Add("bik_1928", true, "Ch.1: Zuse's Help");
    settings.SetToolTip("bik_1928", "Tron Evolution\\GridGame\\Movies\\Sc1_03_05.bik");
    // Chapter 2:
    settings.Add("bik_1828", true, "Ch.2: Declaration of War");
    settings.SetToolTip("bik_1828", "Tron Evolution\\GridGame\\Movies\\Sc1_04_01.bik");
    settings.Add("bik_2216", true, "Ch.2: Solar Sailer Ride");
    settings.SetToolTip("bik_2216", "Tron Evolution\\GridGame\\Movies\\Sc2_01_01.bik");
    // Chapter 3:
    settings.Add("bik_2436", false, "Ch.3: New Course");
    settings.SetToolTip("bik_2436", "Tron Evolution\\GridGame\\Movies\\Sc2_01_02.bik");
    settings.Add("bik_2432", true, "Ch.3: Meeting with Radia");
    settings.SetToolTip("bik_2432", "Tron Evolution\\GridGame\\Movies\\Sc2_01_03.bik");
    settings.Add("bik_1696", true, "Ch.3: Threat Detected");
    settings.SetToolTip("bik_1696", "Tron Evolution\\GridGame\\Movies\\Sc2_02_02.bik");
    // Chapter 4:
    settings.Add("bik_2132", true, "Ch.4: Meeting Gibson at Game Grid");
    settings.SetToolTip("bik_2132", "Tron Evolution\\GridGame\\Movies\\Sc2_04_01.bik");
    settings.Add("bik_1608", false, "Ch.4: Clu Speech 1");
    settings.SetToolTip("bik_1608", "Tron Evolution\\GridGame\\Movies\\204CluSpeech1.bik");
    settings.Add("bik_1724", false, "Ch.4: Clu Speech 2");
    settings.SetToolTip("bik_1724", "Tron Evolution\\GridGame\\Movies\\204CluSpeech2.bik");
    settings.Add("bik_1784", false, "Ch.4: Clu Speech 3");
    settings.SetToolTip("bik_1784", "Tron Evolution\\GridGame\\Movies\\204CluSpeech3.bik");
    settings.Add("bik_1668", false, "Ch.4: Clu Speech 4");
    settings.SetToolTip("bik_1668", "Tron Evolution\\GridGame\\Movies\\204CluSpeech4.bik");
    settings.Add("bik_1512", false, "Ch.4: Clu Speech 5");
    settings.SetToolTip("bik_1512", "Tron Evolution\\GridGame\\Movies\\204CluSpeech5.bik");
    settings.Add("bik_1924", true, "Ch.4: Escape Game Grid with Gibson");
    settings.SetToolTip("bik_1924", "Tron Evolution\\GridGame\\Movies\\Sc2_04_05.bik");
    // Chapter 5:
    settings.Add("bik_2184", false, "Ch.5: Gibson lost his friends");
    settings.SetToolTip("bik_2184", "Tron Evolution\\GridGame\\Movies\\Sc2_05_01.bik");
    settings.Add("bik_2456", true, "Ch.5: Abraxas visit at Bostrom colony");
    settings.SetToolTip("bik_2456", "Tron Evolution\\GridGame\\Movies\\Sc2_05_02.bik");
    settings.Add("bik_3840", false, "Ch.5: Reactor elevator escape");
    settings.SetToolTip("bik_3840", "Tron Evolution\\GridGame\\Movies\\206CoreWinSeq.bik");
    settings.Add("bik_1760", true, "Ch.5: Leaving the Bostrom colony");
    settings.SetToolTip("bik_1760", "Tron Evolution\\GridGame\\Movies\\Sc2_06_01.bik");
    settings.Add("bik_2820", true, "Ch.5: Gibson's infection");
    settings.SetToolTip("bik_2820", "Tron Evolution\\GridGame\\Movies\\Sc2_06_02.bik");
    settings.Add("bik_3540", true, "Ch.5: Gibson's death (Press F to pay respect)");
    settings.SetToolTip("bik_3540", "Tron Evolution\\GridGame\\Movies\\207GibsonDeath.bik");
    settings.Add("bik_2576", true, "Ch.5: Bike jump into Arjia City");
    settings.SetToolTip("bik_2576", "Tron Evolution\\GridGame\\Movies\\208BikeJump.bik");
    // Chapter 6:
    settings.Add("bik_2620", true, "Ch.6: Radia's death");
    settings.SetToolTip("bik_2620", "Tron Evolution\\GridGame\\Movies\\Sc2_10_01.bik");
    settings.Add("bik_3404", true, "Ch.6: Abraxas buried");
    settings.SetToolTip("bik_3404", "Tron Evolution\\GridGame\\Movies\\Sc2_10_02.bik");
    // Chapter 7:
    settings.Add("bik_2336", false, "Ch.7: Meeting with Kevin Flynn");
    settings.SetToolTip("bik_2336", "Tron Evolution\\GridGame\\Movies\\Sc3_01_01.bik");
    settings.Add("bik_2580", true, "Ch.7: Enter Regulator");
    settings.SetToolTip("bik_2580", "Tron Evolution\\GridGame\\Movies\\301EnterRegulator.bik");
    settings.Add("bik_1020", true, "Ch.7: Quorra's confrontation with Clu");
    settings.SetToolTip("bik_1020", "Tron Evolution\\GridGame\\Movies\\Sc3_02_01.bik");
    settings.Add("bik_3144", true, "Ch.7: Plucky Spirit");
    settings.SetToolTip("bik_3144", "Tron Evolution\\GridGame\\Movies\\Sc3_02_02a.bik");
    settings.Add("bik_3428", false, "Ch.7: You'll overload the Drive");
    settings.SetToolTip("bik_3428", "Tron Evolution\\GridGame\\Movies\\Sc3_02_02b.bik");

    // Extras
    vars.BinkID = 0;
    vars.LastBink = 0;
}

init
{
    print(""+game.MainModule.FileVersionInfo);
    print("ModuleMemorySize: "+modules.First().ModuleMemorySize);
    refreshRate = 100.0;
}

start
{
    if (settings["start"] && old.iTutCut == 0x9E && current.iTutCut == 0x96)
    {
        vars.DebugMessage("*Timer* Start");
        vars.LastBink = 0;
        return true;
    }
    return false;
}

split
{
    vars.BinkID = (short)(current.iLastBink*3+current.iBinkInfo);
    if (settings["bink_split"] && old.iNoBink == 0 && current.iNoBink == 1)
    {
        if (vars.LastBink != vars.BinkID && settings.ContainsKey("bik_"+vars.BinkID) && settings["bik_"+vars.BinkID])
        {
            vars.DebugMessage("*Split* BinkID: "+vars.BinkID);
            vars.LastBink = vars.BinkID;
            return true;
        }
    }
    if (settings["finish"] && vars.BinkID == 0xD64 && old.iTutCut == 0x82 && current.iTutCut == 0x9E)
    {
        vars.DebugMessage("*Timer* Finish");
        return true;
    }
    return false;
}

isLoading
{
    return (current.iNoBink == 0 && current.iLastBink == 4) || current.iBGLevel == 1 || current.iNoSkip != 0;
}

exit
{
    refreshRate = 0.5;
}