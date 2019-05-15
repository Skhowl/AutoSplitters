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
    byte iLoading    : 0x1E78EB4;
    byte iLoadingTip : 0x1EBA634;
    byte iGameplay   : 0x1D99188;
    long iLagging    : 0x1E8AA8C;
    // Pointer
    byte iChapterIndex : 0x15A0ABC, 0x114, 0xAFC, 0x4, 0xE0;
    byte iNotSkippable : 0x1E7E63C, 0xD7;
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
    settings.Add("load", false, "Loading (Hard Drive)");
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
        if (settings["after"] && current.iChapterIndex == 1 && current.iLagging == 0 && old.iGameplay == 0 && current.iGameplay == 1)
        {
            vars.DebugMessage("*Timer* Start");
            return true;
        }
    }
    return false;
}

split
{
    if (settings["chapter"] && old.iChapterIndex < current.iChapterIndex && settings["chapter" + old.iChapterIndex])
    {
        vars.DebugMessage("*Split* Chapter " + vars.ChapterNames[old.iChapterIndex]);
        return true;
    }
    return false;
}*/

isLoading
{
    if (settings["remover"])
    {
        if (settings["load"] && current.iLoading == 17)
        {
            return true;
        }
        if (settings["tips"] && current.iLoadingTip == 1)
        {
            return true;
        }
        if (settings["skip"] && current.iNotSkippable != 0)
        {
            return true;
        }
        if (settings["bink"] && current.iGameplay == 0)
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