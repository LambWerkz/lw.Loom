# lw.Loom

**Fire and forget async PowerShell commands without melting your UI.**

Loom gives you named, persistent runspace pools that feel native to PowerShell. Dispatch commands asynchronously by pool ID, pre-load modules once, leverage full `$using:` scope injection, and keep your GUIs and TUIs from freezing while work happens in the background.

## Why Loom?

- **No More Frozen Interfaces** — Your GUI/TUI stays responsive while PowerShell does the heavy lifting
- **Named Pools** — Reference pools by ID instead of juggling thread objects
- **Pre-Loaded Modules** — Load modules once at pool creation; subsequent commands run faster
- **Full `$using:` Support** — Pass variables into async scopes like you're running local code
- **PowerShell 5.1 & 7+** — Works everywhere PowerShell runs

## Quick Start

```powershell
# Create a pool
New-LoomPool -PoolId "MyPool" -Size 4 -Modules @("Module1", "Module2")

# Dispatch async work
Invoke-LoomCommand -PoolId "MyPool" -ScriptBlock {
    param($Name)
    "Processing $Name..."
} -ArgumentList @("ItemA")

# Get results when you're ready
Receive-LoomCommand -PoolId "MyPool"

# Clean up
Remove-LoomPool -PoolId "MyPool"
```

## Commands

| Command | Purpose |
|---------|---------|
| `New-LoomPool` | Create a named runspace pool |
| `Get-LoomPool` | List active pools or get pool info |
| `Remove-LoomPool` | Shut down and remove a pool |
| `Invoke-LoomCommand` | Dispatch a command to run async |
| `Get-LoomCommand` | Query pending commands |
| `Receive-LoomCommand` | Retrieve results from completed commands |
| `Stop-LoomCommand` | Cancel a running command |

## Requirements

- PowerShell 5.1 or later (Desktop or Core)
- .NET Framework 4.5+ (built-in on modern systems)

---

Built for developers who don't want their UI hanging while PowerShell grinds. Keep it running. Keep it responsive.
