<#
.SYNOPSIS
Grades Exercise 02: Active Directory Branch Provisioning Script.

Run on LON-CL1 as Adatum\Administrator.
#>

$ErrorActionPreference = 'SilentlyContinue'
$score = 0
$total = 15
$checks = New-Object System.Collections.Generic.List[object]

function Add-Check {
    param([string]$Item,[bool]$Passed,[int]$Points,[string]$Details)
    if ($Passed) { $script:score += $Points }
    $checks.Add([PSCustomObject]@{ Item=$Item; Result=if($Passed){'PASS'}else{'FAIL'}; Points=if($Passed){$Points}else{0}; Details=$Details })
}

Write-Host "`n=== Grading Exercise 02: Active Directory Branch Provisioning ===" -ForegroundColor Cyan

$base = 'C:\AZ040Extra'
$scriptPath = Join-Path $base 'EX02-BranchProvisioning.ps1'
$csvPath = Join-Path $base 'EX02-ADObjects.csv'
$ouDN = 'OU=ExtraLab-London,DC=Adatum,DC=com'

Add-Check 'Student script exists' (Test-Path $scriptPath) 2 $scriptPath
Add-Check 'Export CSV exists' (Test-Path $csvPath) 2 $csvPath

try { Import-Module ActiveDirectory -ErrorAction Stop; $adOk = $true } catch { $adOk = $false }
Add-Check 'Active Directory module loads' $adOk 1 'Required for AD validation.'

if ($adOk) {
    $ou = Get-ADOrganizationalUnit -Identity $ouDN
    Add-Check 'OU ExtraLab-London exists' ($null -ne $ou) 2 $ouDN

    $group = Get-ADGroup -Identity 'ExtraLab-London-Admins'
    Add-Check 'Group ExtraLab-London-Admins exists' ($null -ne $group) 2 'Expected AD security group.'

    $user = Get-ADUser -Identity 'ExtraLab-User01'
    Add-Check 'User ExtraLab-User01 exists' ($null -ne $user) 2 'Expected AD user.'

    $computer = Get-ADComputer -Identity 'ExtraLab-CL99'
    Add-Check 'Computer ExtraLab-CL99 exists' ($null -ne $computer) 1 'Expected AD computer account.'

    $member = if ($group -and $user) { Get-ADGroupMember -Identity $group | Where-Object SamAccountName -eq $user.SamAccountName } else { $null }
    Add-Check 'User is member of ExtraLab-London-Admins' ($null -ne $member) 2 'Expected group membership.'
} else {
    Add-Check 'OU ExtraLab-London exists' $false 2 'AD module unavailable.'
    Add-Check 'Group ExtraLab-London-Admins exists' $false 2 'AD module unavailable.'
    Add-Check 'User ExtraLab-User01 exists' $false 2 'AD module unavailable.'
    Add-Check 'Computer ExtraLab-CL99 exists' $false 1 'AD module unavailable.'
    Add-Check 'User is member of ExtraLab-London-Admins' $false 2 'AD module unavailable.'
}

if (Test-Path $csvPath) {
    $rows = Import-Csv $csvPath
    Add-Check 'CSV has AD object records' (($rows | Measure-Object).Count -ge 3) 1 "Rows found: $(($rows | Measure-Object).Count)"
} else {
    Add-Check 'CSV has AD object records' $false 1 'CSV missing.'
}

$checks | Format-Table -AutoSize
Write-Host "Score: $score / $total" -ForegroundColor Yellow
if ($score -ge 12) { Write-Host 'Overall: PASS' -ForegroundColor Green }
elseif ($score -ge 9) { Write-Host 'Overall: PARTIAL - inspect student script manually' -ForegroundColor Yellow }
else { Write-Host 'Overall: FAIL / INCOMPLETE' -ForegroundColor Red }
