<#
.SYNOPSIS
Grades Exercise 08: PowerShell Remoting Maintenance Script.
#>

$ErrorActionPreference = 'SilentlyContinue'
$score = 0
$total = 20
$checks = New-Object System.Collections.Generic.List[object]
function Add-Check { param([string]$Item,[bool]$Passed,[int]$Points,[string]$Details) if($Passed){$script:score += $Points}; $checks.Add([PSCustomObject]@{Item=$Item;Result=if($Passed){'PASS'}else{'FAIL'};Points=if($Passed){$Points}else{0};Details=$Details}) }

Write-Host "`n=== Grading Exercise 08: PowerShell Remoting Maintenance Script ===" -ForegroundColor Cyan

$base = 'C:\AZ040Extra'
$scriptPath = Join-Path $base 'EX08-RemoteMaintenance.ps1'
$csvPath = Join-Path $base 'EX08-RemoteMaintenance.csv'
$failedPath = Join-Path $base 'EX08-FailedComputers.txt'
$expectedComputers = @('LON-DC1','LON-SVR1')

Add-Check 'Student script exists' (Test-Path $scriptPath) 2 $scriptPath
Add-Check 'Remote maintenance CSV exists' (Test-Path $csvPath) 4 $csvPath
Add-Check 'Failed-computers log exists or was intentionally created' (Test-Path $failedPath) 2 'Expected EX08-FailedComputers.txt. It may be empty if all computers succeeded.'

foreach ($computer in $expectedComputers) {
    $wsmanOk = $false
    try { Test-WSMan -ComputerName $computer -ErrorAction Stop | Out-Null; $wsmanOk = $true } catch { $wsmanOk = $false }
    Add-Check "Remoting responds on $computer" $wsmanOk 2 'Validates lab remoting availability, not only student output.'
}

if (Test-Path $csvPath) {
    $rows = Import-Csv $csvPath
    Add-Check 'CSV has at least two rows' (($rows | Measure-Object).Count -ge 2) 2 "Rows found: $(($rows | Measure-Object).Count)"
    foreach ($computer in $expectedComputers) {
        $found = $rows | Where-Object { $_.ComputerName -eq $computer -or $_.PSComputerName -eq $computer }
        Add-Check "CSV contains $computer" ($null -ne $found) 2 'Expected one summary row per target.'
    }
    $columns = ($rows | Select-Object -First 1).PSObject.Properties.Name -join ','
    Add-Check 'CSV contains OS, boot, service, or disk fields' ($columns -match 'Operating|Boot|Service|Disk|Free|Computer') 2 "Columns: $columns"
} else {
    Add-Check 'CSV has at least two rows' $false 2 'CSV missing.'
    foreach ($computer in $expectedComputers) { Add-Check "CSV contains $computer" $false 2 'CSV missing.' }
    Add-Check 'CSV contains OS, boot, service, or disk fields' $false 2 'CSV missing.'
}

if (Test-Path $scriptPath) {
    $text = Get-Content $scriptPath -Raw
    Add-Check 'Script uses remoting commands' ($text -match 'Invoke-Command' -and $text -match 'Test-WSMan|New-PSSession|ComputerName') 2 'Expected remoting validation and remote command execution.'
} else {
    Add-Check 'Script uses remoting commands' $false 2 'Student script missing.'
}

$checks | Format-Table -AutoSize
Write-Host "Score: $score / $total" -ForegroundColor Yellow
if ($score -ge 16) { Write-Host 'Overall: PASS' -ForegroundColor Green }
elseif ($score -ge 12) { Write-Host 'Overall: PARTIAL - inspect student script manually' -ForegroundColor Yellow }
else { Write-Host 'Overall: FAIL / INCOMPLETE' -ForegroundColor Red }
