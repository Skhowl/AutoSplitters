/*
    This is a LiveSplit ASL script for Wonder Boy (UE) on emulator.
    
    - Twitch: https://www.twitch.tv/skhowl
    - GitHub: https://github.com/Skhowl/AutoSplitters
    - Discord: https://www.discord.gg/3D4ckwX
    - Youtube: https://www.youtube.com/channel/UCo3stXnGVNhoMx5a47zFXOQ
    - Scan Value: 2341871806232690692
*/

// Kega Fusion v3.64
state("fusion")
{
    // base 0x0000 address of RAM : 0x2A52D8, 0xC000;
    byte   BoyState  : 0x2A52D8, 0xC008;
    byte   GameState : 0x2A52D8, 0xC00C;
    byte   GameMode  : 0x2A52D8, 0xC115;
    byte   Level     : 0x2A52D8, 0xC128;
    ushort SubLevel  : 0x2A52D8, 0xC129;
    byte   BossHP    : 0x2A52D8, 0xC1AC;
}

// Gens+ 0.0.9.61
state("gens+")
{
    // base 0x0000 address of RAM : 0xED1698, 0;
    byte   BoyState  : 0xED1698, 0x8;
    byte   GameState : 0xED1698, 0xC;
    byte   GameMode  : 0xED1698, 0x115;
    byte   Level     : 0xED1698, 0x128;
    ushort SubLevel  : 0xED1698, 0x129;
    byte   BossHP    : 0xED1698, 0x1AC;
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
    settings.Add("support", false, "Supported Emulators:");
    settings.Add("emu1", false, "Kega Fusion v3.64", "support");
    settings.Add("emu2", false, "Gens+ 0.0.9.61", "support");
    settings.Add("start", true, "Start timer at:");
    settings.Add("title", true, "Title screen", "start");
    settings.Add("boy", false, "Boy is allow to move", "start");
    settings.Add("lasthit", true, "Split: Last Hit on Boss");
    settings.SetToolTip("lasthit", "Split on last hit when head is falling off.");
    settings.CurrentDefaultParent = "lasthit";
    settings.Add("boss3", false, "Area 1");
    settings.Add("boss7", false, "Area 2");
    settings.Add("boss11", false, "Area 3");
    settings.Add("boss15", false, "Area 4");
    settings.Add("boss19", false, "Area 5");
    settings.Add("boss23", false, "Area 6");
    settings.Add("boss27", false, "Area 7");
    settings.Add("boss31", false, "Area 8");
    settings.Add("boss35", true, "Area 9 (Boss Any%)");
    settings.Add("boss39", true, "Area 10 (Boss 100%)");
    settings.CurrentDefaultParent = null;
    settings.Add("transition", true, "Split: Level Transitions");
    settings.SetToolTip("transition", "Split when you entering a new area/round.");
    settings.Add("area1", true, "Area 1", "transition");
    settings.Add("stage1", true, "R1 >> R2", "area1");
    settings.Add("stage2", true, "R2 >> R3", "area1");
    settings.Add("stage3", true, "R3 >> R4", "area1");
    settings.Add("stage4", true, "R4 >> A2", "area1");
    settings.Add("area2", true, "Area 2", "transition");
    settings.Add("stage5", true, "R1 >> R2", "area2");
    settings.Add("stage6", true, "R2 >> R3", "area2");
    settings.Add("stage7", true, "R3 >> R4", "area2");
    settings.Add("stage8", true, "R4 >> A3", "area2");
    settings.Add("area3", true, "Area 3", "transition");
    settings.Add("stage9", true, "R1 >> R2", "area3");
    settings.Add("stage10", true, "R2 >> R3", "area3");
    settings.Add("stage11", true, "R3 >> R4", "area3");
    settings.Add("stage12", true, "R4 >> A4", "area3");
    settings.Add("area4", true, "Area 4", "transition");
    settings.Add("stage13", true, "R1 >> R2", "area4");
    settings.Add("stage14", true, "R2 >> R3", "area4");
    settings.Add("stage15", true, "R3 >> R4", "area4");
    settings.Add("stage16", true, "R4 >> A5", "area4");
    settings.Add("area5", true, "Area 5", "transition");
    settings.Add("stage17", true, "R1 >> R2", "area5");
    settings.Add("stage18", true, "R2 >> R3", "area5");
    settings.Add("stage19", true, "R3 >> R4", "area5");
    settings.Add("stage20", true, "R4 >> A6", "area5");
    settings.Add("area6", true, "Area 6", "transition");
    settings.Add("stage21", true, "R1 >> R2", "area6");
    settings.Add("stage22", true, "R2 >> R3", "area6");
    settings.Add("stage23", true, "R3 >> R4", "area6");
    settings.Add("stage24", true, "R4 >> A7", "area6");
    settings.Add("area7", true, "Area 7", "transition");
    settings.Add("stage25", true, "R1 >> R2", "area7");
    settings.Add("stage26", true, "R2 >> R3", "area7");
    settings.Add("stage27", true, "R3 >> R4", "area7");
    settings.Add("stage28", true, "R4 >> A8", "area7");
    settings.Add("area8", true, "Area 8", "transition");
    settings.Add("stage29", true, "R1 >> R2", "area8");
    settings.Add("stage30", true, "R2 >> R3", "area8");
    settings.Add("stage31", true, "R3 >> R4", "area8");
    settings.Add("stage32", true, "R4 >> A9", "area8");
    settings.Add("area9", true, "Area 9", "transition");
    settings.Add("stage33", true, "R1 >> R2", "area9");
    settings.Add("stage34", true, "R2 >> R3", "area9");
    settings.Add("stage35", true, "R3 >> R4", "area9");
    settings.Add("stage36", true, "R4 >> A10", "area9");
    settings.Add("area10", true, "Area 10", "transition");
    settings.Add("stage37", true, "R1 >> R2", "area10");
    settings.Add("stage38", true, "R2 >> R3", "area10");
    settings.Add("stage39", true, "R3 >> R4", "area10");
}

init
{
    print(""+game.MainModule.FileVersionInfo);
    refreshRate = 200/3;
}

start
{
    if (current.GameMode == 0x03)
    {
        if (settings["title"])
        {
            vars.DebugMessage("*Timer* Start (title screen)");
            return true;
        }
        else if (settings["boy"] && old.BoyState == 1 && current.BoyState == 4)
        {
            vars.DebugMessage("*Timer* Start (boy move)");
            return true;
        }
    }
    return false;
}

/*reset // Need to find a better address
{
    if (old.GameMode != current.GameMode && current.GameMode == 0)
    {
        vars.DebugMessage("*Timer* Reset");
        return true;
    }
    return false;
}*/

split
{
    if (settings["transition"] && current.Level <= 0x27 && current.Level > old.Level)
    {
        if (settings["stage" + current.Level])
        {
            vars.DebugMessage("*Split* Transition: Area " + (byte)(1 + old.Level / 4) + " Round " + (byte)(1 + old.Level % 4) + " >> Area " + (byte)(1 + current.Level / 4) + " Round " + (byte)(1 + current.Level % 4));
            return true;
        }
    }
    
    if ((byte)(current.Level % 4) == 3 && settings["boss" + current.Level] && current.SubLevel == 0xE403 && current.GameState > 0)
    {
        if (old.BossHP > current.BossHP && current.BossHP == 0)
        {
            if (current.Level == 0x23) // Area 9 Round 4
            {
                vars.DebugMessage("*Split* Final: Boss Any%");
            }
            else if (current.Level == 0x27) // Area 10 Round 4
            {
                vars.DebugMessage("*Split* Final: Boss 100%");
            }
            else // everything else: Area ? Round 4
            {
                vars.DebugMessage("*Split* Boss killed in Area " + (byte)(1 + current.Level / 4));
            }
            return true;
        }
    }
    return false;
}

exit
{
    refreshRate = 0.5;
}