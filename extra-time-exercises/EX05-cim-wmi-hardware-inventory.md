# Exercise 05: CIM and WMI Hardware Inventory

## Main Topic

Querying management information by using CIM and WMI.

## VMs to Use

Run this exercise from **LON-CL1**. Query **LON-CL1**, **LON-DC1**, and **LON-SVR1**.

## Estimated Time

30-45 minutes

## Points

15 points

## Scenario

You need to build a small hardware and operating system inventory report for the training environment. The report should work across multiple computers.

## Your Task

Create a script named:

```powershell
C:\AZ040Extra\EX05-CimInventory.ps1
```

The script must query these computers:

```powershell
LON-CL1
LON-DC1
LON-SVR1
```

For each computer, collect:

1. Computer name.
2. Manufacturer.
3. Model.
4. Total physical memory in GB.
5. Operating system caption.
6. Operating system build number.
7. Last boot time.
8. BIOS serial number.

Export the result to:

```powershell
C:\AZ040Extra\EX05-CimInventory.csv
```

## Required Script Features

Your script should include:

- An array of computer names.
- A loop.
- `Get-CimInstance`.
- A custom object using `[PSCustomObject]`.
- At least one calculated value, such as RAM in GB.
- Error handling for failed connections.

## Tips

Useful CIM classes:

```powershell
Win32_ComputerSystem
Win32_OperatingSystem
Win32_BIOS
```

Basic example:

```powershell
Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName LON-DC1
```

Create a custom object:

```powershell
[PSCustomObject]@{
    ComputerName = $computer
    Manufacturer = $cs.Manufacturer
    Model = $cs.Model
}
```

Convert memory bytes to GB:

```powershell
[math]::Round($cs.TotalPhysicalMemory / 1GB, 2)
```

Use `try` and `catch`:

```powershell
try {
    # CIM commands here
}
catch {
    Write-Warning "Failed to query $computer"
}
```

## Expected Result

The output CSV should have one row per computer. If one computer cannot be queried, the script should continue with the next computer instead of stopping completely.

## Validation

Run:

```powershell
Import-Csv C:\AZ040Extra\EX05-CimInventory.csv | Format-Table -AutoSize
```

## Important Note

`Get-WmiObject` exists only in Windows PowerShell 5.1. Prefer `Get-CimInstance` for this exercise because it is the modern approach and also works in PowerShell 7.

## Bonus Challenge

Add disk information using the `Win32_LogicalDisk` CIM class and export it to a second file:

```powershell
C:\AZ040Extra\EX05-DiskInventory.csv
```
