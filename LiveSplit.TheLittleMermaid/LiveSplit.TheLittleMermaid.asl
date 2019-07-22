/*
    This is a LiveSplit ASL script for Disney's The Little Mermaid and Little Mermaid - Ningyo Hime on emulator.
    
    - Twitch: https://www.twitch.tv/gehsalzen
    - GitHub: https://github.com/Skhowl/AutoSplitters
    - Discord: https://www.discord.gg/3D4ckwX
    - Youtube: https://www.youtube.com/channel/UCY-pqgCPPUCqQ7R3RbQI-uQ
    - Scan Value: 1123217096621663495
*/

// FCEUX 2.2.3
state("fceux")
{
    // base 0x0000 address of RAM : 0x3B1388, 0;
    byte GameState   : 0x3B1388, 0x1ED;
    byte GameMode    : 0x3B1388, 0xD9;
    byte Stage       : 0x3B1388, 0xE9;
    byte FinalFormHP : 0x3B1388, 0x3FC;
    byte BossRoom    : 0x3B1388, 0x53;
}

// Mesen 0.9.7
state("mesen")
{
    // base 0x0000 address of RAM : 0x4311838, 0x118, 0xB8, 0x90, 0x1D8, 8, 0;
    byte GameState   : "MesenCore.dll", 0x4311838, 0x118, 0xB8, 0x90, 0x1D8, 8, 0x1ED;
    byte GameMode    : "MesenCore.dll", 0x4311838, 0x118, 0xB8, 0x90, 0x1D8, 8, 0xD9;
    byte Stage       : "MesenCore.dll", 0x4311838, 0x118, 0xB8, 0x90, 0x1D8, 8, 0xE9;
    byte FinalFormHP : "MesenCore.dll", 0x4311838, 0x118, 0xB8, 0x90, 0x1D8, 8, 0x3FC;
    byte BossRoom    : "MesenCore.dll", 0x4311838, 0x118, 0xB8, 0x90, 0x1D8, 8, 0x53;
}

// Nestopia 1.40
state("nestopia")
{
    // base 0x0000 address of RAM : 0x1B2BCC, 0, 8, 0xC, 0xC, 0x68;
    byte GameState   : 0x1B2BCC, 0, 8, 0xC, 0xC, 0x255;
    byte GameMode    : 0x1B2BCC, 0, 8, 0xC, 0xC, 0x141;
    byte Stage       : 0x1B2BCC, 0, 8, 0xC, 0xC, 0x151;
    byte FinalFormHP : 0x1B2BCC, 0, 8, 0xC, 0xC, 0x464;
    byte BossRoom    : 0x1B2BCC, 0, 8, 0xC, 0xC, 0xBB;
}

// higan v106
state("higan")
{
    // base 0x0000 address of RAM : 0x3F2800, 0x78;
    byte GameState   : 0x3F2800, 0x265;
    byte GameMode    : 0x3F2800, 0x151;
    byte Stage       : 0x3F2800, 0x161;
    byte FinalFormHP : 0x3F2800, 0x474;
    byte BossRoom    : 0x3F2800, 0xCB;
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
    settings.Add("support", true, "Supported Emulators:");
    settings.Add("emu1", true, "FCEUX 2.2.3", "support");
    settings.Add("emu2", true, "Mesen 0.9.7", "support");
    settings.Add("emu3", true, "Nestopia 1.40", "support");
    settings.Add("emu4", true, "higan v106", "support");
    settings.Add("fanfare", true, "Split: Fanfare");
    settings.SetToolTip("fanfare", "Split when you pickup the vase.");
    settings.Add("stage0", true, "Stage 1: Glut the Shark", "fanfare");
    settings.Add("stage1", true, "Stage 2: Flotsam and Jetsam", "fanfare");
    settings.Add("stage2", true, "Stage 3: Wilford Brimley", "fanfare");
    settings.Add("stage3", true, "Stage 4: Tangchaikovsky", "fanfare");
    settings.Add("stage4", true, "Stage 5: Ursula", "fanfare");
    settings.Add("final", true, "Split: Last Hit on Ursula's Final From");
    
    vars.BossNames = new string[]
    {
        "Glut the Shark",
        "Flotsam and Jetsam",
        "Wilford Brimley",
        "Tangchaikovsky",
        "Ursula"
    };
}

init
{
    print(""+game.MainModule.FileVersionInfo);
    refreshRate = 200/3;
}

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
            vars.DebugMessage("*Split* Fanfare: " + vars.BossNames[current.Stage]);
            return true;
        }
    }
    else if (settings["final"] && current.GameMode == 9)
    {
        if (old.FinalFormHP > current.FinalFormHP && current.FinalFormHP == 0)
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