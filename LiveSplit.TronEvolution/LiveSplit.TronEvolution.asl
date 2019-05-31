/*
    This is a LiveSplit ASL script for Tron: Evolution on PC.

    - Twitch: https://www.twitch.tv/skhowl
    - GitHub: https://github.com/Skhowl/AutoSplitters
    - Discord: https://www.discord.gg/3D4ckwX
    - Youtube: https://www.youtube.com/channel/UCo3stXnGVNhoMx5a47zFXOQ
*/

// GridGame 1.01
state("gridgame")
{
    // Static
    long iLoading   : 0x1E78EAD;
    byte iNoBink    : 0x1D99188;
    byte iBGLevel   : 0x1EBA634;
    short iLastBink : "binkw32.dll", 0x27221;
    byte iBinkInfo  : "binkw32.dll", 0x27245;
    // Pointer
    byte iNoSkip : 0x1E7E63C, 0xD7;
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

    // Start:
    settings.Add("start", true, "Start:");
    settings.Add("after", true, "After Grid Development Diary Entry (Intro)", "start");

    // Split:
    settings.Add("bink_split", false, "Split: Bink video finished/skipped");
    settings.CurrentDefaultParent = "bink_split";
    // Chapter 1:
    settings.Add("bik_2188", true, "Ch.1: Sc1_01_03.bik");
    settings.Add("bik_2764", true, "Ch.1: Sc1_01_06.bik");
    settings.Add("bik_3020", true, "Ch.1: 101AbraxDiseaseTaunt.bik");
    settings.Add("bik_3604", false, "Ch.1: 101AbraxasJumpDown.bik");
    settings.Add("bik_2980", false, "Ch.1: 101AbraxasJumpUp.bik");
    settings.Add("bik_2852", true, "Ch.1: 101AbraxInsigTaunt.bik");
    settings.Add("bik_3156", true, "Ch.1: Sc1_01_07.bik");
    settings.Add("bik_3120", true, "Ch.1: Sc1_03_01.bik");
    settings.Add("bik_1880", true, "Ch.1: Sc1_03_03.bik");
    settings.Add("bik_1532", true, "Ch.1: Sc1_03_04.bik");
    settings.Add("bik_1928", true, "Ch.1: Sc1_03_05.bik");
    // Chapter 2:
    settings.Add("bik_1828", true, "Ch.2: Sc1_04_01.bik");
    settings.Add("bik_2216", true, "Ch.2: Sc2_01_01.bik");
    // Chapter 3:
    settings.Add("bik_2436", true, "Ch.3: Sc2_01_02.bik");
    settings.Add("bik_2432", true, "Ch.3: Sc2_01_03.bik");
    settings.Add("bik_1696", true, "Ch.3: Sc2_02_02.bik");
    // Chapter 4:
    settings.Add("bik_2132", true, "Ch.4: Sc2_04_01.bik");
    settings.Add("bik_1608", true, "Ch.4: 204CluSpeech1.bik");
    settings.Add("bik_1724", true, "Ch.4: 204CluSpeech2.bik");
    settings.Add("bik_1784", true, "Ch.4: 204CluSpeech3.bik");
    settings.Add("bik_1668", true, "Ch.4: 204CluSpeech4.bik");
    settings.Add("bik_1512", true, "Ch.4: 204CluSpeech5.bik");
    settings.Add("bik_1924", true, "Ch.4: Sc2_04_05.bik");
    // Chapter 5:
    settings.Add("bik_2184", true, "Ch.5: Sc2_05_01.bik");
    settings.Add("bik_2456", true, "Ch.5: Sc2_05_02.bik");
    settings.Add("bik_3840", true, "Ch.5: 206CoreWinSeq.bik");
    settings.Add("bik_1760", true, "Ch.5: Sc2_06_01.bik");
    settings.Add("bik_2820", true, "Ch.5: Sc2_06_02.bik");
    settings.Add("bik_3540", true, "Ch.5: 207GibsonDeath.bik");
    settings.Add("bik_2576", true, "Ch.5: 208BikeJump.bik");
    // Chapter 6:
    settings.Add("bik_2620", true, "Ch.6: Sc2_10_01.bik");
    settings.Add("bik_3404", true, "Ch.6: Sc2_10_02.bik");
    // Chapter 7:
    settings.Add("bik_2336", true, "Ch.7: Sc3_01_01.bik");
    settings.Add("bik_2580", true, "Ch.7: 301EnterRegulator.bik");
    settings.Add("bik_1020", true, "Ch.7: Sc3_02_01.bik");
    settings.Add("bik_3144", true, "Ch.7: Sc3_02_02a.bik");
    settings.Add("bik_3428", true, "Ch.7: Sc3_02_02b.bik");
    settings.Add("bik_3564", true, "Ch.7: Sc3_03_01.bik");

    // Load remover:
    settings.CurrentDefaultParent = null;
    settings.Add("remover", true, "Load Remover");
    settings.CurrentDefaultParent = "remover";
    settings.Add("load", true, "Loading Screen");
    settings.Add("tips", true, "Loading Tips");
    settings.Add("skip", true, "Loading Bink");
    // settings.Add("bink", false, "Whole Bink Video");

    // Extras
    vars.BinkID = 0;
}

init
{
    print(""+game.MainModule.FileVersionInfo);
    print("ModuleMemorySize: "+modules.First().ModuleMemorySize);
    refreshRate = 200/3;
}

start
{
    if (settings["start"])
    {
        vars.BinkID = current.iLastBink*3+current.iBinkInfo;
        if (settings["after"] && old.iNoBink == 0 && current.iNoBink == 1 && vars.BinkID == 0xB40)
        {
            vars.DebugMessage("*Timer* Start");
            return true;
        }
    }
    return false;
}

split
{
    if (settings["bink_split"] && old.iNoBink == 0 && current.iNoBink == 1)
    {
        vars.BinkID = current.iLastBink*3+current.iBinkInfo;
        if (settings["bik_"+vars.BinkID])
        {
            vars.DebugMessage("*Split* BinkID: " + vars.BinkID);
            return true;
        }
    }
    return false;
}

isLoading
{
    if (settings["remover"])
    {
        if (settings["load"] && current.iLoading != 0 && current.iNoBink == 0)
        {
            return true;
        }
        if (settings["tips"] && current.iBGLevel == 1)
        {
            return true;
        }
        if (settings["skip"] && current.iNoSkip != 0)
        {
            return true;
        }
        /*if (settings["bink"] && current.iNoBink == 0)
        {
            return true;
        }*/
    }
    return false;
}

exit
{
    refreshRate = 0.5;
}