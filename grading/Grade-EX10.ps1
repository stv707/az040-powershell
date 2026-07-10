<#
.SYNOPSIS
Grades Exercise 10: Optional Cloud Admin Audit Script.

This checker gives credit for Azure Track A, Microsoft 365 Track B, or both.
#>

$ErrorActionPreference = 'SilentlyContinue'
$score = 0
$total = 20
$checks = New-Object System.Collections.Generic.List[object]
function Add-Check { param([string]$Item,[bool]$Passed,[int]$Points,[string]$Details) if($Passed){$script:score += $Points}; $checks.Add([PSCustomObject]@{Item=$Item;Result=if($Passed){'PASS'}else{'FAIL'};Points=if($Passed){$Points}else{0};Details=$Details}) }

Write-Host "`n=== Grading Exercise 10: Optional Cloud Admin Audit Script ===" -ForegroundColor Cyan

$base = 'C:\AZ040Extra'
$azureScript = Join-Path $base 'EX10-AzureAudit.ps1'
$m365Script = Join-Path $base 'EX10-M365Audit.ps1'
$azureRgCsv = Join-Path $base 'EX10-AzureResourceGroups.csv'
$azureResCsv = Join-Path $base 'EX10-AzureResources.csv'
$m365UsersCsv = Join-Path $base 'EX10-M365Users.csv'
$m365GroupsCsv = Join-Path $base 'EX10-M365Groups.csv'

$azureTrackStarted = (Test-Path $azureScript) -or (Test-Path $azureRgCsv) -or (Test-Path $azureResCsv)
$m365TrackStarted = (Test-Path $m365Script) -or (Test-Path $m365UsersCsv) -or (Test-Path $m365GroupsCsv)

Add-Check 'At least one optional track attempted' ($azureTrackStarted -or $m365TrackStarted) 2 'Expected Azure or Microsoft 365 track output.'

# Azure Track - 9 points
Add-Check 'Azure audit script exists' (Test-Path $azureScript) 1 $azureScript
Add-Check 'Azure resource groups CSV exists' (Test-Path $azureRgCsv) 3 $azureRgCsv
Add-Check 'Azure resources CSV exists' (Test-Path $azureResCsv) 2 $azureResCsv

if (Test-Path $azureRgCsv) {
    $rgRows = Import-Csv $azureRgCsv
    Add-Check 'Azure resource group CSV is readable' ($null -ne $rgRows) 1 "Rows found: $(($rgRows | Measure-Object).Count)"
} else {
    Add-Check 'Azure resource group CSV is readable' $false 1 'CSV missing.'
}

if (Test-Path $azureScript) {
    $text = Get-Content $azureScript -Raw
    Add-Check 'Azure script uses Az cmdlets' ($text -match 'Connect-AzAccount' -and $text -match 'Get-AzResource') 2 'Expected Connect-AzAccount and Get-AzResource.'
} else {
    Add-Check 'Azure script uses Az cmdlets' $false 2 'Azure script missing.'
}

# M365 Track - 9 points
Add-Check 'Microsoft 365 audit script exists' (Test-Path $m365Script) 1 $m365Script
Add-Check 'M365 users CSV exists' (Test-Path $m365UsersCsv) 3 $m365UsersCsv
Add-Check 'M365 groups CSV exists' (Test-Path $m365GroupsCsv) 2 $m365GroupsCsv

if (Test-Path $m365UsersCsv) {
    $userRows = Import-Csv $m365UsersCsv
    Add-Check 'M365 users CSV is readable' ($null -ne $userRows) 1 "Rows found: $(($userRows | Measure-Object).Count)"
} else {
    Add-Check 'M365 users CSV is readable' $false 1 'CSV missing.'
}

if (Test-Path $m365Script) {
    $text = Get-Content $m365Script -Raw
    Add-Check 'M365 script uses Graph cmdlets' ($text -match 'Connect-MgGraph' -and $text -match 'Get-MgUser|Get-MgGroup') 2 'Expected Connect-MgGraph and Get-MgUser/Get-MgGroup.'
} else {
    Add-Check 'M365 script uses Graph cmdlets' $false 2 'M365 script missing.'
}

$checks | Format-Table -AutoSize
Write-Host "Score: $score / $total" -ForegroundColor Yellow
if ($score -ge 12) { Write-Host 'Overall: PASS for optional exercise' -ForegroundColor Green }
elseif ($score -ge 8) { Write-Host 'Overall: PARTIAL - one track may be incomplete' -ForegroundColor Yellow }
else { Write-Host 'Overall: FAIL / NOT ATTEMPTED' -ForegroundColor Red }

Write-Host "`nNote: Exercise 10 is optional. Do not penalize students if no cloud tenant/subscription was provided." -ForegroundColor Cyan
