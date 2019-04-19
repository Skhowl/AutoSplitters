/*
    This is a LiveSplit ASL script for Disney's The Little Mermaid and Little Mermaid - Ningyo Hime on emulator.
    
    - Twitch: https://www.twitch.tv/skhowl
    - GitHub: https://github.com/Skhowl/AutoSplitters
    - Discord: https://www.discord.gg/3D4ckwX
    - Youtube: https://www.youtube.com/channel/UCo3stXnGVNhoMx5a47zFXOQ
    - Scan Value: 1123217096621663495
*/
state("fceux", "2.2.3")
{
    byte GameState   : 0x003B1388, 0x01ED;
    byte GameMode    : 0x003B1388, 0x00D9;
    byte Stage       : 0x003B1388, 0x00E9;
    byte FinalFormHP : 0x003B1388, 0x03FC;
    byte BossRoom    : 0x003B1388, 0x0053;
}

/*state("retroarch")
{
    byte GameState   : 0x004B2850, 0x01ED;
    byte GameMode    : 0x004B2850, 0x00D9;
    byte Stage       : 0x004B2850, 0x00E9;
    byte FinalFormHP : 0x004B2850, 0x03FC;
    byte BossRoom    : 0x004B2850, 0x0053;
}*/

state("nestopia", "1.40")
{
    // base 0x0000 address of ROM : 0x001B1290, 0xAC, 0x68;
    byte GameState   : 0x001B1290, 0xAC, 0x0255;
    byte GameMode    : 0x001B1290, 0xAC, 0x0141;
    byte Stage       : 0x001B1290, 0xAC, 0x0151;
    byte FinalFormHP : 0x001B1290, 0xAC, 0x0464;
    byte BossRoom    : 0x001B1290, 0xAC, 0x00BB;
}

state("higan", "v106")
{
    byte GameState   : 0x00853F78, 0x01ED;
    byte GameMode    : 0x00853F78, 0x00D9;
    byte Stage       : 0x00853F78, 0x00E9;
    byte FinalFormHP : 0x00853F78, 0x03FC;
    byte BossRoom    : 0x00853F78, 0x0053;
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
    
    // Settings
    settings.Add("fanfare", true, "Fanfare");
    settings.SetToolTip("fanfare", "Split when you pickup the vase.");
    settings.CurrentDefaultParent = "fanfare";
    settings.Add("stage0", true, "Stage 1: Glut the Shark");
    settings.Add("stage1", true, "Stage 2: Flotsam and Jetsam");
    settings.Add("stage2", true, "Stage 3: Wilford Brimley");
    settings.Add("stage3", true, "Stage 4: Tangchaikovsky");
    settings.Add("stage4", true, "Stage 5: Ursula");
    settings.CurrentDefaultParent = null;
    settings.Add("final", true, "Last Hit on Ursula's Final From");
}

init
{
    refreshRate = 72.0;
}

// update
// {
// }

start
{
    if (old.GameState != current.GameState && current.GameState == 0xFC)
    {
        vars.DebugMessage("*Timer* Start");
        return true;
    }
    return false;
}

reset
{
    if (old.GameState != current.GameState && current.GameState != 0xFC)
    {
        vars.DebugMessage("*Timer* Reset");
        return true;
    }
    return false;
}

split
{
    if (settings["fanfare"] && current.Stage <= 4 && settings["stage" + current.Stage] && current.BossRoom == 8)
    {
        if (old.GameMode != current.GameMode && current.GameMode == 7)
        {
            vars.DebugMessage("*Split* Stage: " + current.Stage + " (Fanfare)");
            return true;
        }
    }
    else if (settings["final"] && current.GameMode == 9)
    {
        if (old.FinalFormHP != current.FinalFormHP && current.FinalFormHP == 0)
        {
            vars.DebugMessage("*Split* Last Hit on Ursula's Final From");
            return true;
        }
    }
    return false;
}

exit
{
    refreshRate = 0.5;
}