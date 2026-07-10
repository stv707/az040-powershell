<#
.SYNOPSIS
Grades Exercise 05: CIM and WMI Hardware Inventory.
#>

$ErrorActionPreference = 'SilentlyContinue'
$score = 0
$total = 15
$checks = New-Object System.Collections.Generic.List[object]
function Add-Check { param([string]$Item,[bool]$Passed,[int]$Points,[string]$Details) if($Passed){$script:score += $Points}; $checks.Add([PSCustomObject]@{Item=$Item;Result=if($Passed){'PASS'}else{'FAIL'};Points=if($Passed){$Points}else{0};Details=$Details}) }

Write-Host "`n=== Grading Exercise 05: CIM and WMI Hardware Inventory ===" -ForegroundColor Cyan

$base = 'C:\AZ040Extra'
$scriptPath = Join-Path $base 'EX05-CimInventory.ps1'
$csvPath = Join-Path $base 'EX05-CimInventory.csv'
$diskCsvPath = Join-Path $base 'EX05-DiskInventory.csv'
$expectedComputers = @('LON-CL1','LON-DC1','LON-SVR1')

Add-Check 'Student script exists' (Test-Path $scriptPath) 2 $scriptPath
Add-Check 'CIM inventory CSV exists' (Test-Path $csvPath) 3 $csvPath

if (Test-Path $csvPath) {
    $rows = Import-Csv $csvPath
    Add-Check 'CSV has at least three rows' (($rows | Measure-Object).Count -ge 3) 2 "Rows found: $(($rows | Measure-Object).Count)"
    foreach ($computer in $expectedComputers) {
        $found = $rows | Where-Object { $_.ComputerName -eq $computer -or $_.PSComputerName -eq $computer }
        Add-Check "CSV contains $computer" ($null -ne $found) 1 'Expected one row per target computer.'
    }
    $columns = ($rows | Select-Object -First 1).PSObject.Properties.Name
    Add-Check 'CSV contains OS or hardware fields' (($columns -join ',') -match 'Manufacturer|Model|Operating|Build|Memory|BIOS|Serial') 2 "Columns: $($columns -join ', ')"
} else {
    Add-Check 'CSV has at least three rows' $false 2 'CSV missing.'
    foreach ($computer in $expectedComputers) { Add-Check "CSV contains $computer" $false 1 'CSV missing.' }
    Add-Check 'CSV contains OS or hardware fields' $false 2 'CSV missing.'
}

if (Test-Path $scriptPath) {
    $text = Get-Content $scriptPath -Raw
    Add-Check 'Script uses Get-CimInstance and custom objects' ($text -match 'Get-CimInstance' -and $text -match 'PSCustomObject') 2 'Expected modern CIM and object output.'
} else {
    Add-Check 'Script uses Get-CimInstance and custom objects' $false 2 'Student script missing.'
}

Add-Check 'Bonus disk inventory exists' (Test-Path $diskCsvPath) 1 'Bonus point for disk inventory CSV.'

$checks | Format-Table -AutoSize
Write-Host "Score: $score / $total" -ForegroundColor Yellow
if ($score -ge 12) { Write-Host 'Overall: PASS' -ForegroundColor Green }
elseif ($score -ge 9) { Write-Host 'Overall: PARTIAL - inspect student script manually' -ForegroundColor Yellow }
else { Write-Host 'Overall: FAIL / INCOMPLETE' -ForegroundColor Red }
