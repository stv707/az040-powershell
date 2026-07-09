# Exercise 04: PSDrive ScriptShare and Registry Configuration

## Main Topic

Using PSProviders and PSDrives with the file system and registry.

## VMs to Use

Run the script from **LON-CL1**. The file share target is **LON-SVR1**.

## Estimated Time

30-40 minutes

## Points

15 points

## Scenario

The server team wants a standard location on `LON-SVR1` for storing administration scripts. They also want a registry value on `LON-CL1` that records the location of the shared script path.

## Your Task

Create a script named:

```powershell
C:\AZ040Extra\EX04-ScriptShareRegistry.ps1
```

The script must:

1. Create a folder on `LON-SVR1`:

```text
\\LON-SVR1\C$\ScriptShare
```

2. Create a temporary PSDrive named `ScriptShare` that maps to:

```text
\\LON-SVR1\C$\ScriptShare
```

3. Create three empty script files on the PSDrive:

```text
DailyCheck.ps1
UserAudit.ps1
ServerReport.ps1
```

4. Create this registry key on `LON-CL1`:

```text
HKCU:\Software\AZ040Extra
```

5. Create or update this registry value:

```text
ScriptSharePath = \\LON-SVR1\C$\ScriptShare
```

6. Export proof of the files and registry value to:

```text
C:\AZ040Extra\EX04-PSDriveRegistryProof.txt
```

## Required Script Features

Your script should include:

- `New-PSDrive`
- `Remove-PSDrive`
- File provider usage
- Registry provider usage
- `New-Item`
- `Set-ItemProperty` or `New-ItemProperty`
- Basic validation output

## Tips

Useful commands:

```powershell
New-PSDrive
Get-PSDrive
Remove-PSDrive
New-Item
Set-Location
Set-ItemProperty
Get-ItemProperty
Out-File
```

Create a PSDrive:

```powershell
New-PSDrive -Name ScriptShare -PSProvider FileSystem -Root '\\LON-SVR1\C$\ScriptShare'
```

Access a PSDrive:

```powershell
Set-Location ScriptShare:
```

Create a registry key:

```powershell
New-Item -Path 'HKCU:\Software\AZ040Extra' -Force
```

Create or update a registry value:

```powershell
Set-ItemProperty -Path 'HKCU:\Software\AZ040Extra' -Name ScriptSharePath -Value '\\LON-SVR1\C$\ScriptShare'
```

## Expected Result

You should be able to run:

```powershell
Get-ChildItem '\\LON-SVR1\C$\ScriptShare'
Get-ItemProperty 'HKCU:\Software\AZ040Extra'
```

and see the created script files plus the registry value.

## Validation

Run:

```powershell
Test-Path '\\LON-SVR1\C$\ScriptShare\DailyCheck.ps1'
Get-ItemProperty 'HKCU:\Software\AZ040Extra' | Select-Object ScriptSharePath
Get-Content C:\AZ040Extra\EX04-PSDriveRegistryProof.txt
```

## Bonus Challenge

Modify the script to create the same registry value under `HKLM:\Software\AZ040Extra`. This requires running PowerShell as Administrator.
