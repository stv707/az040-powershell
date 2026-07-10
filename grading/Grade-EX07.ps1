<#
.SYNOPSIS
Grades Exercise 07: CSV-Based AD User Onboarding.

Run on LON-CL1 as Adatum\Administrator.
#>

$ErrorActionPreference = 'SilentlyContinue'
$score = 0
$total = 20
$checks = New-Object System.Collections.Generic.List[object]
function Add-Check { param([string]$Item,[bool]$Passed,[int]$Points,[string]$Details) if($Passed){$script:score += $Points}; $checks.Add([PSCustomObject]@{Item=$Item;Result=if($Passed){'PASS'}else{'FAIL'};Points=if($Passed){$Points}else{0};Details=$Details}) }

Write-Host "`n=== Grading Exercise 07: CSV-Based AD User Onboarding ===" -ForegroundColor Cyan

$base = 'C:\AZ040Extra'
$scriptPath = Join-Path $base 'EX07-CreateUsersFromCSV.ps1'
$inputCsv = Join-Path $base 'NewUsers.csv'
$resultCsv = Join-Path $base 'EX07-OnboardingResult.csv'
$ouDN = 'OU=ExtraLab-NewUsers,DC=Adatum,DC=com'
$expectedUsers = @('araman','dlee','mpatel')

Add-Check 'Student script exists' (Test-Path $scriptPath) 2 $scriptPath
Add-Check 'Input CSV exists' (Test-Path $inputCsv) 2 $inputCsv

if (Test-Path $inputCsv) {
    $inputRows = Import-Csv $inputCsv
    Add-Check 'Input CSV has three user rows' (($inputRows | Measure-Object).Count -eq 3) 2 "Rows found: $(($inputRows | Measure-Object).Count)"
} else {
    Add-Check 'Input CSV has three user rows' $false 2 'Input CSV missing.'
}

Add-Check 'Onboarding result CSV exists' (Test-Path $resultCsv) 2 $resultCsv

try { Import-Module ActiveDirectory -ErrorAction Stop; $adOk = $true } catch { $adOk = $false }
Add-Check 'Active Directory module loads' $adOk 1 'Required for AD validation.'

if ($adOk) {
    $ou = Get-ADOrganizationalUnit -Identity $ouDN
    Add-Check 'OU ExtraLab-NewUsers exists' ($null -ne $ou) 2 $ouDN

    foreach ($sam in $expectedUsers) {
        $u = Get-ADUser -Identity $sam -Properties Department,City
        Add-Check "User $sam exists" ($null -ne $u) 2 'Expected CSV-created AD user.'
    }

    $usersWithAttributes = foreach ($sam in $expectedUsers) {
        Get-ADUser -Identity $sam -Properties Department,City | Where-Object { $_.Department -and $_.City }
    }
    Add-Check 'Created users have Department and City populated' (($usersWithAttributes | Measure-Object).Count -ge 3) 3 'Expected Department and City from CSV.'
} else {
    Add-Check 'OU ExtraLab-NewUsers exists' $false 2 'AD module unavailable.'
    foreach ($sam in $expectedUsers) { Add-Check "User $sam exists" $false 2 'AD module unavailable.' }
    Add-Check 'Created users have Department and City populated' $false 3 'AD module unavailable.'
}

if (Test-Path $scriptPath) {
    $text = Get-Content $scriptPath -Raw
    Add-Check 'Script uses CSV, loop, condition, and AD user creation' ($text -match 'Import-Csv' -and $text -match 'foreach|ForEach-Object' -and $text -match 'if' -and $text -match 'New-ADUser') 2 'Expected CSV-driven AD automation.'
} else {
    Add-Check 'Script uses CSV, loop, condition, and AD user creation' $false 2 'Student script missing.'
}

$checks | Format-Table -AutoSize
Write-Host "Score: $score / $total" -ForegroundColor Yellow
if ($score -ge 16) { Write-Host 'Overall: PASS' -ForegroundColor Green }
elseif ($score -ge 12) { Write-Host 'Overall: PARTIAL - inspect student script manually' -ForegroundColor Yellow }
else { Write-Host 'Overall: FAIL / INCOMPLETE' -ForegroundColor Red }
