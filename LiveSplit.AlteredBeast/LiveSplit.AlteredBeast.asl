/*
    This is a LiveSplit ASL script for Altered Beast on emulator.
    
    - Twitch: https://www.twitch.tv/gehsalzen
    - GitHub: https://github.com/Skhowl/AutoSplitters
    - Discord: https://www.discord.gg/3D4ckwX
    - Youtube: https://www.youtube.com/channel/UCY-pqgCPPUCqQ7R3RbQI-uQ
    - Scan Values:  7301730173017301    8287031239400059649
                    516450644D644C64    5864901006468598884
*/

// Kega Fusion v3.64
state("fusion")
{
    // base 0x0000 address of RAM : 0x002A52D4, 0x0000;
    byte GameState   : 0x002A52D4, 0xB104;
    byte PlayerState : 0x002A52D4, 0xD064;
    byte Stage       : 0x002A52D4, 0xFE15;
    byte PowerLevel  : 0x002A52D4, 0xD02B;
    byte BossShared  : 0x002A52D4, 0xE365; // Aggar, Crocodile Worm, Van Vader
    byte BossEyes    : 0x002A52D4, 0xE3A5; // Octeyes
    byte BossSnail   : 0x002A52D4, 0xE377; // Moldy Snail
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
    
    // Supported Emulators
    settings.Add("support", false, "Supported Emulators:");
    settings.Add("emu1", false, "Kega Fusion v3.64", "support");
    
    // Start
    settings.Add("start", true, "Start timer at:");
    settings.Add("title", false, "Title screen", "start");
    settings.Add("move", true, "Guy is allow to move (START TIMER)", "start");
    
    // Cutscene
    settings.Add("scene", true, "Split: Cutscene starts (lost control)");
    settings.CurrentDefaultParent = "scene";
    settings.Add("scene0", true, "Stage 1: Aggar");
    settings.Add("scene1", true, "Stage 2: Octeyes");
    settings.Add("scene2", true, "Stage 3: Moldy Snail");
    settings.Add("scene3", true, "Stage 4: Crocodile Worm");
    settings.Add("scene4", true, "Stage 5: Van Vader (END TIMER)");
    settings.CurrentDefaultParent = null;
    
    // Last Hit
    settings.Add("boss", false, "Split: Last Hit on Boss");
    settings.CurrentDefaultParent = "boss";
    settings.Add("boss0", false, "Stage 1: Aggar");
    settings.Add("boss1", false, "Stage 2: Octeyes");
    settings.Add("boss2", false, "Stage 3: Moldy Snail");
    settings.Add("boss3", false, "Stage 4: Crocodile Worm");
    settings.Add("boss4", false, "Stage 5: Van Vader");
    settings.CurrentDefaultParent = null;
    
    // Transitions
    settings.Add("stage", false, "Split: Stage Transitions");
    settings.SetToolTip("stage", "Split when you entering a new stage.");
    settings.CurrentDefaultParent = "stage";
    settings.Add("stage1", false, "Stage 2");
    settings.Add("stage2", false, "Stage 3");
    settings.Add("stage3", false, "Stage 4");
    settings.Add("stage4", false, "Stage 5");
    settings.CurrentDefaultParent = null;
    
    // Losing Power
    settings.Add("power", false, "Split: Neff steal your Power");
    settings.CurrentDefaultParent = "power";
    settings.Add("power0", false, "Stage 1: Aggar");
    settings.Add("power1", false, "Stage 2: Octeyes");
    settings.Add("power2", false, "Stage 3: Moldy Snail");
    settings.Add("power3", false, "Stage 4: Crocodile Worm");
    
    vars.BossNames = new string[]
    {
        "Aggar",
        "Octeyes",
        "Moldy Snail",
        "Crocodile Worm",
        "Van Vader"
    };
}

init
{
    print(""+game.MainModule.FileVersionInfo);
    refreshRate = 100.0;
}

start
{
    if (current.GameState == 0x04)
    {
        if (settings["title"])
        {
            vars.DebugMessage("*Timer* Start (title screen)");
            return true;
        }
        if (settings["move"] && old.BossSnail == 0xC0 && current.BossSnail == 0)
        {
            vars.DebugMessage("*Timer* Start (enable to move)");
            return true;
        }
    }
    return false;
}

reset
{
    if ((old.GameState != current.GameState && current.GameState == 0) || current.GameState == 0x06)
    {
        vars.DebugMessage("*Timer* Reset");
        return true;
    }
    return false;
}

split
{
    // Cutscene
    if (settings["scene" + current.Stage] && old.PlayerState == 0 && current.PlayerState == 0x19)
    {
        vars.DebugMessage("*Timer* Cutscene starts at stage " + (int)(current.Stage + 1));
        return true;
    }
    
    // Losing Power
    if (old.PowerLevel >= 0x03 && current.PowerLevel == 0 && settings["power" + current.Stage])
    {
        vars.DebugMessage("*Split* Losing power on stage " + (int)(current.Stage + 1));
        return true;
    }
    
    // Transitions
    if (current.Stage > old.Stage && settings["stage" + current.Stage])
    {
        vars.DebugMessage("*Split* Transition to stage " + current.Stage);
        return true;
    }
    
    // Last Hit
    if (settings["boss" + current.Stage])
    {
        switch ((int)current.Stage)
        {
            case 1: // Octeyes
                if (old.BossEyes > current.BossEyes && current.BossEyes == 0)
                {
                    vars.DebugMessage("*Split* Octeyes killed");
                    return true;
                }
                break;
            case 2: // Moldy Snail
                if (old.BossSnail > current.BossSnail && current.BossSnail == 0)
                {
                    vars.DebugMessage("*Split* Moldy Snail killed");
                    return true;
                }
                break;
            default: // Aggar - Octeyes - Van Vader
                if (old.BossShared > current.BossShared && current.BossShared == 0)
                {
                    vars.DebugMessage("*Split* " + vars.BossNames[current.Stage] + " killed");
                    return true;
                }
                break;
        }
    }
    
    return false;
}

exit
{
    refreshRate = 0.5;
}