# Exercise 03: Pipeline-Based System Report

## Main Topic

PowerShell pipeline, selecting objects, sorting, filtering, formatting, and exporting.

## VMs to Use

Run this exercise on **LON-CL1**. Collect data locally from **LON-CL1** first. If remoting is already enabled, you may extend it to **LON-DC1** and **LON-SVR1**.

## Estimated Time

30-40 minutes

## Points

15 points

## Scenario

Your manager wants a quick system report from the lab computers. You must write a script that gathers useful administrative data and exports clean CSV reports.

## Your Task

Create a script named:

```powershell
C:\AZ040Extra\EX03-SystemReport.ps1
```

The script must generate reports for:

1. Running services.
2. Top 10 processes by CPU usage.
3. Installed hotfixes.
4. Network adapters.
5. Firewall rules that are enabled.

## Required Output Files

Save the output files into `C:\AZ040Extra\Reports`:

```text
RunningServices.csv
TopProcesses.csv
InstalledHotfixes.csv
NetworkAdapters.csv
EnabledFirewallRules.csv
```

## Required Script Features

Your script should include:

- `Where-Object`
- `Select-Object`
- `Sort-Object`
- `Export-Csv`
- At least one calculated property.
- At least one folder creation check.

## Tips

Useful commands:

```powershell
Get-Service
Get-Process
Get-HotFix
Get-NetAdapter
Get-NetFirewallRule
Where-Object
Select-Object
Sort-Object
Export-Csv
```

Example: filter only running services:

```powershell
Get-Service |
    Where-Object Status -eq 'Running' |
    Select-Object Name, DisplayName, Status
```

Example: top 10 processes by CPU:

```powershell
Get-Process |
    Sort-Object CPU -Descending |
    Select-Object -First 10 Name, Id, CPU
```

Example calculated property:

```powershell
Select-Object Name, @{Name='MemoryMB';Expression={[math]::Round($_.WorkingSet64 / 1MB, 2)}}
```

## Expected Result

The `C:\AZ040Extra\Reports` folder should contain five CSV files. Each file should contain clean columns, not raw unformatted output.

## Validation

Run:

```powershell
Get-ChildItem C:\AZ040Extra\Reports
Import-Csv C:\AZ040Extra\Reports\RunningServices.csv | Select-Object -First 5
Import-Csv C:\AZ040Extra\Reports\TopProcesses.csv | Select-Object -First 5
```

## Bonus Challenge

Create a single HTML report named:

```powershell
C:\AZ040Extra\Reports\SystemReport.html
```

Hint:

```powershell
ConvertTo-Html
```
