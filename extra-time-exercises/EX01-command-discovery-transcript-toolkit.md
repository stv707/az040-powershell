# Exercise 01: Command Discovery and Transcript Toolkit

## Main Topic

Getting started with Windows PowerShell, command discovery, Help, and transcripts.

## VM to Use

Run this exercise on **LON-CL1**.

## Estimated Time

20-30 minutes

## Points

10 points

## Scenario

You are preparing a reusable PowerShell discovery toolkit for junior administrators. The toolkit must help them discover useful commands, view Help, and save proof of what they ran.

## Your Task

Create a script named:

```powershell
C:\AZ040Extra\EX01-DiscoveryToolkit.ps1
```

The script must perform the following:

1. Create the folder `C:\AZ040Extra` if it does not exist.
2. Start a transcript and save it as `C:\AZ040Extra\EX01-Transcript.txt`.
3. Display the current PowerShell version.
4. Find commands related to these keywords:
   - `service`
   - `process`
   - `event`
   - `net`
5. Save the command-discovery result to `C:\AZ040Extra\EX01-Commands.csv`.
6. Display Help examples for one command of your choice.
7. Stop the transcript.

## Required Script Features

Your script should include:

- At least one variable.
- At least one array.
- At least one `foreach` loop.
- At least one exported CSV file.
- Clear comments explaining each section.

## Tips

Useful commands:

```powershell
Get-Command
Get-Help
Start-Transcript
Stop-Transcript
New-Item
Test-Path
Export-Csv
$PSVersionTable
```

To search commands by keyword:

```powershell
Get-Command -Name *service*
```

To loop through multiple keywords:

```powershell
$keywords = 'service','process','event','net'
foreach ($keyword in $keywords) {
    Get-Command -Name "*$keyword*"
}
```

To avoid errors when creating a folder that already exists, test first:

```powershell
if (-not (Test-Path 'C:\AZ040Extra')) {
    New-Item -Path 'C:\AZ040Extra' -ItemType Directory
}
```

## Expected Result

At the end of the exercise, the folder `C:\AZ040Extra` should contain:

```text
EX01-DiscoveryToolkit.ps1
EX01-Transcript.txt
EX01-Commands.csv
```

## Validation

Run these commands to verify your work:

```powershell
Test-Path C:\AZ040Extra\EX01-Transcript.txt
Test-Path C:\AZ040Extra\EX01-Commands.csv
Import-Csv C:\AZ040Extra\EX01-Commands.csv | Select-Object -First 10
```

## Bonus Challenge

Add a script parameter named `$Keyword` so the user can search for one extra keyword when running the script.
