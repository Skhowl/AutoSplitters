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
    byte iBGS  : 0x1E78EB4;
    byte iBGLS : 0x1EBA634;
    byte iGP   : 0x1D99188;
    long iLAG  : 0x1E8AA8C;
    // Pointer
    byte iCID : 0x9AD6B8, 0x8CC, 0xAFC, 0x4, 0xE0;
    byte iNSM : 0x1E7E63C, 0xD7;
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

    settings.Add("start", false, "Start:");
    settings.Add("after", true, "After intro movie", "start");
    settings.Add("chapter", false, "Split: Chapter finished");
    settings.CurrentDefaultParent = "chapter";
    settings.Add("chapter1", true, "Chapter 1: Reboot");
    settings.Add("chapter2", true, "Chapter 2: Shutdown");
    settings.Add("chapter3", true, "Chapter 3: Arjia");
    settings.Add("chapter4", true, "Chapter 4: The Combatant");
    settings.Add("chapter5", true, "Chapter 5: Identification Friend or Foe");
    settings.Add("chapter6", true, "Chapter 6: The Approach");
    settings.Add("chapter7", false, "Chapter 7: End of the Line");
    settings.CurrentDefaultParent = null;
    settings.Add("remover", true, "Game Time Remover");
    settings.CurrentDefaultParent = "remover";
    settings.Add("load", true, "Loading Screen");
    settings.Add("tips", true, "Loading Tips");
    settings.Add("skip", true, "Loading Bink");
    settings.Add("bink", false, "Whole Bink Video");

    vars.ChapterNames = new string[]
    {
        "1: Reboot",
        "2: Shutdown",
        "3: Arjia",
        "4: The Combatant",
        "5: Identification Friend or Foe",
        "6: The Approach",
        "7: End of the Line"
    };
}

init
{
    print(""+game.MainModule.FileVersionInfo);
    refreshRate = 200/3;
}

/*start
{
    if (settings["start"])
    {
        if (settings["after"] && current.iCID == 1 && current.iLAG == 0 && old.iGP == 0 && current.iGP == 1)
        {
            vars.DebugMessage("*Timer* Start");
            return true;
        }
    }
    return false;
}

split
{
    if (settings["chapter"] && old.iCID < current.iCID && settings["chapter" + old.iCID])
    {
        vars.DebugMessage("*Split* Chapter " + vars.ChapterNames[old.iCID]);
        return true;
    }
    return false;
}*/

isLoading
{
    if (settings["remover"])
    {
        if (settings["load"] && current.iBGS != 0 && current.iGP == 0)
        {
            return true;
        }
        if (settings["tips"] && current.iBGLS == 1)
        {
            return true;
        }
        if (settings["skip"] && current.iNSM != 0)
        {
            return true;
        }
        if (settings["bink"] && current.iGP == 0)
        {
            return true;
        }
    }
    return false;
}

exit
{
    refreshRate = 0.5;
}