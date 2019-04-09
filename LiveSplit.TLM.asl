state("emuhawk") {}

startup
{
    refreshRate = 0.5;

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
            var target = new SigScanTarget(0, "C6 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ?? 01 C6");
            var scanOffset = vars.SigScan(proc, target);
            if (scanOffset != 0)
            {
                wramOffset = scanOffset - 0x83;
            }

            if (proc.ReadValue<int>((IntPtr)wramOffset) != 0)
            {
                print("[Autosplitter] WRAM Pointer: " + wramOffset + " 0x" + wramOffset.ToString("X8"));
                vars.watchers = vars.GetWatcherList(wramOffset);

                return true;
            }
        }

        return false;
    });

    vars.SigScan = (Func<Process, SigScanTarget, long>)((proc, target) =>
    {
        print("[Autosplitter] Scanning memory");

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
            new MemoryWatcher<byte>((IntPtr)wramOffset + 0x03FC) { Name = "FinalFormHP" },
            new MemoryWatcher<ushort>((IntPtr)wramOffset + 0x0052) { Name = "BossRoom" },
        };
    });
}

init
{
    vars.watchers = new MemoryWatcherList();

    if (!vars.TryFindOffsets(game, modules.First().ModuleMemorySize, (long)modules.First().BaseAddress))
        throw new Exception("Emulated memory not yet initialized.");
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
    var fanfare = vars.watchers["BossRoom"].Current == 0x0800 && vars.watchers["GameMode"].Changed && vars.watchers["GameMode"].Current == 0x07;
    var end = vars.watchers["GameMode"].Current == 0x09 && vars.watchers["FinalFormHP"].Current == 0;

    return fanfare || end;
}

exit
{
    refreshRate = 0.5;
}