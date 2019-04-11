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
        var states = new Dictionary<int, int>
        {
            { 7061504, 0 }, //BizHawk 2.3
            { 7249920, 0 }, //BizHawk 2.3.1
        };

        int ptrOffset;
        if (states.TryGetValue(memorySize, out ptrOffset))
        {
            long wramOffset = 0;
            var target = new SigScanTarget(0, "C6 00 00 00 00 00 00 00 00 00 00 00 00 ?? 00 ?? 01 C6 ?? ?? ?? 00 ?? 00");
            var scanOffset = vars.SigScan(proc, target);
            if (scanOffset != 0)
            {
                wramOffset = scanOffset - 0x83;
            }

            if (proc.ReadValue<int>((IntPtr)wramOffset) != 0)
            {
                vars.DebugMessage("WRAM Pointer: 0x" + wramOffset.ToString("X8"));
                vars.watchers = vars.GetWatcherList(wramOffset);

                return true;
            }
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
        refreshRate = 200/3.0;
}

update
{
    vars.watchers.UpdateAll(game);
}

start
{
    return vars.watchers["GameState"].Old == 0 && vars.watchers["GameState"].Current == 0xFC;
}

reset
{
    return vars.watchers["GameState"].Old == 0xFC && vars.watchers["GameState"].Current == 0;
}

split
{
    if (settings["fanfare"] && vars.watchers["BossRoom"].Current == 0x08 && settings["stage" + vars.watchers["Stage"].Current])
    {
        return vars.watchers["GameMode"].Changed && vars.watchers["GameMode"].Current == 0x07;
    }
    else if (settings["final"] && vars.watchers["GameMode"].Current == 0x09)
    {
        return vars.watchers["FinalFormHP"].Current == 0;
    }
    return false;
}

exit
{
    refreshRate = 0.5;
}
