<#
.SYNOPSIS
Grades Exercise 04: PSDrive ScriptShare and Registry Configuration.
#>

$ErrorActionPreference = 'SilentlyContinue'
$score = 0
$total = 15
$checks = New-Object System.Collections.Generic.List[object]
function Add-Check { param([string]$Item,[bool]$Passed,[int]$Points,[string]$Details) if($Passed){$script:score += $Points}; $checks.Add([PSCustomObject]@{Item=$Item;Result=if($Passed){'PASS'}else{'FAIL'};Points=if($Passed){$Points}else{0};Details=$Details}) }

Write-Host "`n=== Grading Exercise 04: PSDrive ScriptShare and Registry Configuration ===" -ForegroundColor Cyan

$base = 'C:\AZ040Extra'
$scriptPath = Join-Path $base 'EX04-ScriptShareRegistry.ps1'
$server = 'LON-SVR1'
$drivePart = 'C' + '$'
$sharePath = "\\$server\$drivePart\ScriptShare"
$regPath = 'HKCU:\Software\AZ040Extra'
$proofPath = Join-Path $base 'EX04-PSDriveRegistryProof.txt'
$expectedFiles = @('DailyCheck.ps1','UserAudit.ps1','ServerReport.ps1')

Add-Check 'Student script exists' (Test-Path $scriptPath) 2 $scriptPath
Add-Check 'Remote ScriptShare folder exists' (Test-Path $sharePath) 2 $sharePath

foreach ($file in $expectedFiles) {
    $path = Join-Path $sharePath $file
    Add-Check "$file exists in ScriptShare" (Test-Path $path) 1 $path
}

$regExists = Test-Path $regPath
Add-Check 'Registry key exists' $regExists 2 $regPath

if ($regExists) {
    $value = (Get-ItemProperty $regPath).ScriptSharePath
    Add-Check 'Registry value ScriptSharePath is correct' ($value -eq $sharePath) 2 "Actual: $value"
} else {
    Add-Check 'Registry value ScriptSharePath is correct' $false 2 'Registry key missing.'
}

Add-Check 'Proof text file exists' (Test-Path $proofPath) 2 $proofPath

if (Test-Path $scriptPath) {
    $text = Get-Content $scriptPath -Raw
    Add-Check 'Script uses PSDrive and registry commands' ($text -match 'New-PSDrive' -and $text -match 'Set-ItemProperty|New-ItemProperty' -and $text -match 'Remove-PSDrive') 2 'Expected PSDrive creation, registry write, PSDrive cleanup.'
} else {
    Add-Check 'Script uses PSDrive and registry commands' $false 2 'Student script missing.'
}

$checks | Format-Table -AutoSize
Write-Host "Score: $score / $total" -ForegroundColor Yellow
if ($score -ge 12) { Write-Host 'Overall: PASS' -ForegroundColor Green }
elseif ($score -ge 9) { Write-Host 'Overall: PARTIAL - inspect student script manually' -ForegroundColor Yellow }
else { Write-Host 'Overall: FAIL / INCOMPLETE' -ForegroundColor Red }
