/*
    This is a LiveSplit ASL script for Wonder Boy (UE) on emulator.
    
    - Twitch: https://www.twitch.tv/skhowl
    - GitHub: https://github.com/Skhowl/AutoSplitters
    - Discord: https://www.discord.gg/3D4ckwX
    - Youtube: https://www.youtube.com/channel/UCo3stXnGVNhoMx5a47zFXOQ
*/

state("emuhawk") {}

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
    settings.Add("info", false, "Supported Emulators: BizHawk 2.2+");
    settings.Add("LastHit", true, "Last Hit on Boss");
    settings.SetToolTip("LastHit", "Split on last hit when head is falling off.");
    settings.Add("BossAny", true, "Area 9 (Boss Any%)", "LastHit");
    settings.Add("Boss100", true, "Area 10 (Boss 100%)", "LastHit");
    settings.Add("transition", true, "Level Transitions");
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
    
    vars.TryFindOffsets = (Func<Process, int, bool>)((proc, memorySize) => 
    {
        vars.DebugMessage(proc.ProcessName + " memorySize: " + memorySize);
        
        var BizHawk = new Dictionary<int, long>
        {
            { 6578176, 0 }, //BizHawk 2.2
            { 6586368, 0 }, //BizHawk 2.2.1
            { 6627328, 0 }, //BizHawk 2.2.2
            { 7061504, 0 }, //BizHawk 2.3
            { 7249920, 0 }, //BizHawk 2.3.1
        };
        
        long wramOffset = 0;
        if (BizHawk.TryGetValue(memorySize, out wramOffset))
        {
            var target = new SigScanTarget(0,
            "26 ?? FF FF FF FF FF 00 ?? ?? 00 ?? ?? ?? ?? 01",
            "00 00 30 00 ?? ?? ?? ?? ?? ?? 00 00 00 00 ?? ??",
            "?? ?? ?? 00 00 00 00 ?? ?? ?? ?? ?? ?? ?? 00 ??",
            "?? ?? 00 ?? ?? 00 ?? ?? ?? 00 00 00 00 ?? ?? ??",
            "00 00 00 ?? 00 00 ?? ?? 00 ?? ?? 00 ?? 00 00 00"
            );
            
            var scanOffset = vars.SigScan(proc, target);
            if (scanOffset != 0)
            {
                wramOffset = scanOffset - 0x100;
            }
            
            if (proc.ReadValue<int>((IntPtr)wramOffset) != 0)
            {
                vars.DebugMessage("RAM Pointer: 0x" + wramOffset.ToString("X8"));
                vars.watchers = vars.GetWatcherList(wramOffset);
                return true;
            }
        }
        else
        {
            MessageBox.Show("Autosplitter detects an unsupported emulator.", "", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        return false;
    });
    
    vars.SigScan = (Func<Process, SigScanTarget, long>)((proc, target) =>
    {
        vars.DebugMessage("Scanning memory");
        
        long result = 0;
        foreach (var page in proc.MemoryPages())
        {
            var scanner = new SignatureScanner(proc, page.BaseAddress, (int)page.RegionSize);
            if ((result = (long)scanner.Scan(target)) != 0)
                break;
        }
        return result;
    });
    
    vars.Current = (Func<string, int, bool>)((name, value) => 
    {
        return vars.watchers[name].Current == value;
    });
    
    vars.Changed = (Func<string, int, bool>)((name, value) => 
    {
        return vars.watchers[name].Changed && vars.watchers[name].Current == value;
    });
    
    vars.GetWatcherList = (Func<long, MemoryWatcherList>)((wramOffset) =>
    {
        return new MemoryWatcherList
        {
            new MemoryWatcher<byte>(  (IntPtr)wramOffset + 0x000C) { Name = "GameState" },
            new MemoryWatcher<byte>(  (IntPtr)wramOffset + 0x0115) { Name = "GameMode" },
            new MemoryWatcher<byte>(  (IntPtr)wramOffset + 0x0128) { Name = "Level" },
            new MemoryWatcher<ushort>((IntPtr)wramOffset + 0x0129) { Name = "SubLevel" },
            new MemoryWatcher<byte>(  (IntPtr)wramOffset + 0x01AC) { Name = "BossHP" },
        };
    });
    
    vars.Level    = 0;
    vars.LevelOld = 0;
}

init
{
    vars.watchers = new MemoryWatcherList();
    
    if (!vars.TryFindOffsets(game, modules.First().ModuleMemorySize))
        throw new Exception("[ERROR] Emulated memory not yet initialized.");
    else
        refreshRate = 72.0;
}

update
{
    vars.watchers.UpdateAll(game);
    
    vars.LevelOld = vars.Level;
    vars.Level    = vars.watchers["Level"].Current;
}

start
{
    if (vars.Changed("GameMode", 0x03))
    {
        vars.DebugMessage("*Timer* Start");
        return true;
    }
    return false;
}

/*reset // Need to find a better address
{
    if (vars.Changed("GameMode", 0))
    {
        vars.DebugMessage("*Timer* Reset");
        return true;
    }
    return false;
}*/

split
{
    if (settings["transition"] && vars.Level > 0 && vars.Level <= 0x27 && settings["stage" + vars.Level])
    {
        if (vars.Level > vars.LevelOld)
        {
            vars.DebugMessage("*Split* Transition: A" + (byte)(1 + vars.LevelOld / 4) + " R" + (byte)(1 + vars.LevelOld % 4) + " >> A" + (byte)(1 + vars.Level / 4) + " R" + (byte)(1 + vars.Level % 4));
            return true;
        }
    }
    
    if (settings["BossAny"] && vars.Level == 0x23 && vars.Current("SubLevel", 0xE403))
    {
        if (vars.watchers["GameState"].Current > 0 && vars.Changed("BossHP", 0))
        {
            vars.DebugMessage("*Split* Final: Boss Any%");
            return true;
        }
    }
    else if (settings["Boss100"] && vars.Level == 0x27 && vars.Current("SubLevel", 0xE403))
    {
        if (vars.watchers["GameState"].Current > 0 && vars.Changed("BossHP", 0))
        {
            vars.DebugMessage("*Split* Final: Boss 100%");
            return true;
        }
    }
    return false;
}

exit
{
    refreshRate = 0.5;
}