# Exercise 08: PowerShell Remoting Maintenance Script

## Main Topic

PowerShell remoting, one-to-many administration, `Invoke-Command`, and PSSessions.

## VMs to Use

Run this exercise from **LON-CL1**. Target **LON-DC1** and **LON-SVR1**.

## Estimated Time

45-60 minutes

## Points

20 points

## Scenario

You need a single maintenance script that checks basic server health across multiple computers without signing in to each server manually.

## Your Task

Create a script named:

```powershell
C:\AZ040Extra\EX08-RemoteMaintenance.ps1
```

The script must:

1. Define an array of target computers:

```powershell
'LON-DC1','LON-SVR1'
```

2. Test whether PowerShell remoting is available on each target.
3. Use `Invoke-Command` to collect:
   - Computer name.
   - Operating system caption.
   - Last boot time.
   - Top 5 services that are stopped.
   - Free space on drive C.
4. Export a summary report to:

```powershell
C:\AZ040Extra\EX08-RemoteMaintenance.csv
```

5. Save any failed computer names to:

```powershell
C:\AZ040Extra\EX08-FailedComputers.txt
```

## Required Script Features

Your script should include:

- Array of target computer names.
- `Test-WSMan` or another remoting availability check.
- `Invoke-Command`.
- Script block.
- `[PSCustomObject]`.
- Error handling.
- CSV export.

## Tips

Enable remoting if required:

```powershell
Enable-PSRemoting -Force
```

Check remoting:

```powershell
Test-WSMan -ComputerName LON-DC1
```

Basic remoting structure:

```powershell
Invoke-Command -ComputerName LON-DC1 -ScriptBlock {
    hostname
}
```

Collect OS information:

```powershell
Get-CimInstance Win32_OperatingSystem
```

Collect disk information:

```powershell
Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
```

Get stopped services:

```powershell
Get-Service | Where-Object Status -eq 'Stopped' | Select-Object -First 5
```

## Expected Result

You should get one summary row per target server. If one server cannot be reached, your script should record it in `EX08-FailedComputers.txt` and continue.

## Validation

Run:

```powershell
Import-Csv C:\AZ040Extra\EX08-RemoteMaintenance.csv | Format-Table -AutoSize
Get-Content C:\AZ040Extra\EX08-FailedComputers.txt -ErrorAction SilentlyContinue
```

## Bonus Challenge

Create persistent PSSessions to both servers, run commands using the sessions, and close the sessions at the end.

Useful commands:

```powershell
New-PSSession
Invoke-Command -Session
Remove-PSSession
```
