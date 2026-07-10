<#
.SYNOPSIS
Grades Exercise 01: Command Discovery and Transcript Toolkit.

Run on LON-CL1 after the student completes Exercise 01.
#>

$ErrorActionPreference = 'SilentlyContinue'
$score = 0
$total = 10
$checks = New-Object System.Collections.Generic.List[object]

function Add-Check {
    param(
        [string]$Item,
        [bool]$Passed,
        [int]$Points,
        [string]$Details
    )
    if ($Passed) { $script:score += $Points }
    $checks.Add([PSCustomObject]@{
        Item    = $Item
        Result  = if ($Passed) { 'PASS' } else { 'FAIL' }
        Points  = if ($Passed) { $Points } else { 0 }
        Details = $Details
    })
}

Write-Host "`n=== Grading Exercise 01: Command Discovery and Transcript Toolkit ===" -ForegroundColor Cyan

$base = 'C:\AZ040Extra'
$scriptPath = Join-Path $base 'EX01-DiscoveryToolkit.ps1'
$transcriptPath = Join-Path $base 'EX01-Transcript.txt'
$csvPath = Join-Path $base 'EX01-Commands.csv'

Add-Check 'Base folder exists' (Test-Path $base) 1 $base
Add-Check 'Student script exists' (Test-Path $scriptPath) 1 $scriptPath
Add-Check 'Transcript file exists' (Test-Path $transcriptPath) 2 $transcriptPath

if (Test-Path $transcriptPath) {
    $transcript = Get-Content $transcriptPath -Raw
    Add-Check 'Transcript contains PowerShell session markers' ($transcript -match 'transcript' -and $transcript -match 'PowerShell') 1 'Transcript should show Start-Transcript output.'
} else {
    Add-Check 'Transcript contains PowerShell session markers' $false 1 'Transcript file missing.'
}

Add-Check 'Command CSV exists' (Test-Path $csvPath) 2 $csvPath

if (Test-Path $csvPath) {
    $rows = Import-Csv $csvPath
    Add-Check 'Command CSV has at least 10 rows' (($rows | Measure-Object).Count -ge 10) 1 "Rows found: $(($rows | Measure-Object).Count)"
    $names = ($rows | ForEach-Object { $_.Name }) -join ' '
    Add-Check 'CSV appears to contain command names' ($names -match 'Service|Process|Event|Net') 1 'Expected service/process/event/net related commands.'
} else {
    Add-Check 'Command CSV has at least 10 rows' $false 1 'CSV missing.'
    Add-Check 'CSV appears to contain command names' $false 1 'CSV missing.'
}

if (Test-Path $scriptPath) {
    $scriptText = Get-Content $scriptPath -Raw
    Add-Check 'Script uses loop/array style' ($scriptText -match 'foreach|ForEach-Object' -and $scriptText -match '\$') 1 'Expected variables and loop usage.'
} else {
    Add-Check 'Script uses loop/array style' $false 1 'Student script missing.'
}

$checks | Format-Table -AutoSize
Write-Host "Score: $score / $total" -ForegroundColor Yellow

if ($score -ge 8) { Write-Host 'Overall: PASS' -ForegroundColor Green }
elseif ($score -ge 6) { Write-Host 'Overall: PARTIAL - inspect student script manually' -ForegroundColor Yellow }
else { Write-Host 'Overall: FAIL / INCOMPLETE' -ForegroundColor Red }
