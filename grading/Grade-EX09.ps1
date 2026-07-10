<#
.SYNOPSIS
Grades Exercise 09: Background Job Health Checks.
#>

$ErrorActionPreference = 'SilentlyContinue'
$score = 0
$total = 15
$checks = New-Object System.Collections.Generic.List[object]
function Add-Check { param([string]$Item,[bool]$Passed,[int]$Points,[string]$Details) if($Passed){$script:score += $Points}; $checks.Add([PSCustomObject]@{Item=$Item;Result=if($Passed){'PASS'}else{'FAIL'};Points=if($Passed){$Points}else{0};Details=$Details}) }

Write-Host "`n=== Grading Exercise 09: Background Job Health Checks ===" -ForegroundColor Cyan

$base = 'C:\AZ040Extra'
$scriptPath = Join-Path $base 'EX09-BackgroundHealthJobs.ps1'
$jobFolder = Join-Path $base 'Jobs'
$resultPath = Join-Path $jobFolder 'EX09-JobResults.txt'

Add-Check 'Student script exists' (Test-Path $scriptPath) 2 $scriptPath
Add-Check 'Jobs folder exists' (Test-Path $jobFolder) 2 $jobFolder
Add-Check 'Job results text file exists' (Test-Path $resultPath) 3 $resultPath

if (Test-Path $resultPath) {
    $content = Get-Content $resultPath -Raw
    Add-Check 'Job result file is not empty' ($content.Length -gt 100) 2 "Length: $($content.Length) characters"
    Add-Check 'Job output appears to include service/event data' ($content -match 'Service|Status|Event|Provider|LogName|DisplayName') 2 'Expected output from service or event checks.'
} else {
    Add-Check 'Job result file is not empty' $false 2 'Result file missing.'
    Add-Check 'Job output appears to include service/event data' $false 2 'Result file missing.'
}

if (Test-Path $scriptPath) {
    $text = Get-Content $scriptPath -Raw
    Add-Check 'Script uses background job cmdlets' ($text -match 'Start-Job' -and $text -match 'Get-Job' -and $text -match 'Wait-Job' -and $text -match 'Receive-Job') 4 'Expected Start/Get/Wait/Receive job workflow.'
    Add-Check 'Script includes job cleanup' ($text -match 'Remove-Job') 1 'Expected Remove-Job cleanup.'
} else {
    Add-Check 'Script uses background job cmdlets' $false 4 'Student script missing.'
    Add-Check 'Script includes job cleanup' $false 1 'Student script missing.'
}

$checks | Format-Table -AutoSize
Write-Host "Score: $score / $total" -ForegroundColor Yellow
if ($score -ge 12) { Write-Host 'Overall: PASS' -ForegroundColor Green }
elseif ($score -ge 9) { Write-Host 'Overall: PARTIAL - inspect student script manually' -ForegroundColor Yellow }
else { Write-Host 'Overall: FAIL / INCOMPLETE' -ForegroundColor Red }
