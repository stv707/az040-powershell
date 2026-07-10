<#
.SYNOPSIS
Grades Exercise 03: Pipeline-Based System Report.
#>

$ErrorActionPreference = 'SilentlyContinue'
$score = 0
$total = 15
$checks = New-Object System.Collections.Generic.List[object]
function Add-Check { param([string]$Item,[bool]$Passed,[int]$Points,[string]$Details) if($Passed){$script:score += $Points}; $checks.Add([PSCustomObject]@{Item=$Item;Result=if($Passed){'PASS'}else{'FAIL'};Points=if($Passed){$Points}else{0};Details=$Details}) }

Write-Host "`n=== Grading Exercise 03: Pipeline-Based System Report ===" -ForegroundColor Cyan

$base = 'C:\AZ040Extra'
$scriptPath = Join-Path $base 'EX03-SystemReport.ps1'
$reportPath = Join-Path $base 'Reports'
$files = @(
    'RunningServices.csv',
    'TopProcesses.csv',
    'InstalledHotfixes.csv',
    'NetworkAdapters.csv',
    'EnabledFirewallRules.csv'
)

Add-Check 'Student script exists' (Test-Path $scriptPath) 2 $scriptPath
Add-Check 'Reports folder exists' (Test-Path $reportPath) 1 $reportPath

foreach ($file in $files) {
    $path = Join-Path $reportPath $file
    $exists = Test-Path $path
    Add-Check "$file exists" $exists 1 $path
    if ($exists) {
        $rows = Import-Csv $path
        Add-Check "$file has rows" (($rows | Measure-Object).Count -gt 0) 1 "Rows found: $(($rows | Measure-Object).Count)"
    } else {
        Add-Check "$file has rows" $false 1 'File missing.'
    }
}

if (Test-Path $scriptPath) {
    $text = Get-Content $scriptPath -Raw
    Add-Check 'Script uses pipeline cmdlets' ($text -match 'Where-Object' -and $text -match 'Select-Object' -and $text -match 'Sort-Object' -and $text -match 'Export-Csv') 2 'Expected Where, Select, Sort, Export-Csv.'
} else {
    Add-Check 'Script uses pipeline cmdlets' $false 2 'Student script missing.'
}

$checks | Format-Table -AutoSize
Write-Host "Score: $score / $total" -ForegroundColor Yellow
if ($score -ge 12) { Write-Host 'Overall: PASS' -ForegroundColor Green }
elseif ($score -ge 9) { Write-Host 'Overall: PARTIAL - inspect student script manually' -ForegroundColor Yellow }
else { Write-Host 'Overall: FAIL / INCOMPLETE' -ForegroundColor Red }
