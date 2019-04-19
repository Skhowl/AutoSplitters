/*
    This is a LiveSplit ASL script for Disney's The Little Mermaid and Little Mermaid - Ningyo Hime on emulator.
    
    - Twitch: https://www.twitch.tv/skhowl
    - GitHub: https://github.com/Skhowl/AutoSplitters
    - Discord: https://www.discord.gg/3D4ckwX
    - Youtube: https://www.youtube.com/channel/UCo3stXnGVNhoMx5a47zFXOQ
    - Scan Value: 1123217096621663495
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
    
    vars.TryFindOffsets = (Func<Process, int, long, bool>)((proc, memorySize, baseAddress) => 
    {
        vars.DebugMessage(proc.ProcessName + " memorySize: " + memorySize);
        
        if (memorySize == 7249920) // BizHawk 2.3.1
        {
            long wramOffset = 0;
            /* RAM Watch
                 00112233445566778899AABBCCDDEEFF
            0x80 ......C6000000000000000000000000
            0x90 ??00??01C6??????00??00??????????
            0xA0 ????????????????????000000000000
            */
            var target = new SigScanTarget(0,    "C6 00 00 00 00 00 00 00 00 00 00 00 00",
                                        "?? 00 ?? 01 C6 ?? ?? ?? 00 ?? 00 ?? ?? ?? ?? ??",
                                        "?? ?? ?? ?? ?? ?? ?? ?? ?? ?? 00 00 00 00 00 00");
            
            var scanOffset = vars.SigScan(proc, target);
            if (scanOffset != 0)
            {
                wramOffset = scanOffset - 0x83;
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
            MessageBox.Show("The autosplitter detects an unsupported emulator.", "", MessageBoxButtons.OK, MessageBoxIcon.Error);
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
            new MemoryWatcher<byte>((IntPtr)wramOffset + 0x01ED) { Name = "GameState" },
            new MemoryWatcher<byte>((IntPtr)wramOffset + 0x00D9) { Name = "GameMode" },
            new MemoryWatcher<byte>((IntPtr)wramOffset + 0x00E9) { Name = "Stage" },
            new MemoryWatcher<byte>((IntPtr)wramOffset + 0x03FC) { Name = "FinalFormHP" },
            new MemoryWatcher<byte>((IntPtr)wramOffset + 0x0053) { Name = "BossRoom" },
        };
    });
}

init
{
    vars.watchers = new MemoryWatcherList();
    
    if (!vars.TryFindOffsets(game, modules.First().ModuleMemorySize, (long)modules.First().BaseAddress))
        throw new Exception("[ERROR] Emulated memory not yet initialized.");
    else
        refreshRate = 72.0;
}

update
{
    vars.watchers.UpdateAll(game);
}

start
{
    if (vars.Changed("GameState", 0xFC))
    {
        vars.DebugMessage("*Timer* Start");
        return true;
    }
    return false;
}

reset
{
    if (vars.watchers["GameState"].Changed && vars.watchers["GameState"].Current != 0xFC)
    {
        vars.DebugMessage("*Timer* Reset");
        return true;
    }
    return false;
}

split
{
    if (settings["fanfare"] && vars.watchers["Stage"].Current <= 4 && settings["stage" + vars.watchers["Stage"].Current] && vars.Current("BossRoom", 8))
    {
        if (vars.Changed("GameMode", 7))
        {
            vars.DebugMessage("*Split* Stage: " + vars.watchers["Stage"].Current + " (Fanfare)");
            return true;
        }
    }
    else if (settings["final"] && vars.Current("GameMode", 9))
    {
        if (vars.Changed("FinalFormHP", 0))
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