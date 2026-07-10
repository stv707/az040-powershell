<#
.SYNOPSIS
Grades Exercise 06: Hashtable-Driven Server Configuration Report.
#>

$ErrorActionPreference = 'SilentlyContinue'
$score = 0
$total = 15
$checks = New-Object System.Collections.Generic.List[object]
function Add-Check { param([string]$Item,[bool]$Passed,[int]$Points,[string]$Details) if($Passed){$script:score += $Points}; $checks.Add([PSCustomObject]@{Item=$Item;Result=if($Passed){'PASS'}else{'FAIL'};Points=if($Passed){$Points}else{0};Details=$Details}) }

Write-Host "`n=== Grading Exercise 06: Hashtable-Driven Server Configuration Report ===" -ForegroundColor Cyan

$base = 'C:\AZ040Extra'
$scriptPath = Join-Path $base 'EX06-HashtableServerReport.ps1'
$csvPath = Join-Path $base 'EX06-ServiceRoleReport.csv'
$expectedServers = @('LON-DC1','LON-SVR1')

Add-Check 'Student script exists' (Test-Path $scriptPath) 2 $scriptPath
Add-Check 'Service role report CSV exists' (Test-Path $csvPath) 3 $csvPath

if (Test-Path $csvPath) {
    $rows = Import-Csv $csvPath
    Add-Check 'CSV has multiple service rows' (($rows | Measure-Object).Count -ge 4) 2 "Rows found: $(($rows | Measure-Object).Count)"
    foreach ($server in $expectedServers) {
        $found = $rows | Where-Object { $_.ComputerName -eq $server -or $_.ServerName -eq $server }
        Add-Check "CSV contains $server" ($null -ne $found) 2 'Expected rows for both target servers.'
    }
    $columns = ($rows | Select-Object -First 1).PSObject.Properties.Name -join ','
    Add-Check 'CSV contains role, service, and status columns' ($columns -match 'Role' -and $columns -match 'Service' -and $columns -match 'Status') 2 "Columns: $columns"
} else {
    Add-Check 'CSV has multiple service rows' $false 2 'CSV missing.'
    foreach ($server in $expectedServers) { Add-Check "CSV contains $server" $false 2 'CSV missing.' }
    Add-Check 'CSV contains role, service, and status columns' $false 2 'CSV missing.'
}

if (Test-Path $scriptPath) {
    $text = Get-Content $scriptPath -Raw
    Add-Check 'Script uses hashtable, loops, and service checks' ($text -match '@\{' -and $text -match 'foreach|ForEach-Object' -and $text -match 'Get-Service') 2 'Expected hashtable configuration and service validation.'
} else {
    Add-Check 'Script uses hashtable, loops, and service checks' $false 2 'Student script missing.'
}

$checks | Format-Table -AutoSize
Write-Host "Score: $score / $total" -ForegroundColor Yellow
if ($score -ge 12) { Write-Host 'Overall: PASS' -ForegroundColor Green }
elseif ($score -ge 9) { Write-Host 'Overall: PARTIAL - inspect student script manually' -ForegroundColor Yellow }
else { Write-Host 'Overall: FAIL / INCOMPLETE' -ForegroundColor Red }
