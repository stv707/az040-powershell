# Exercise 02: Active Directory Branch Provisioning Script

## Main Topic

Local system administration with PowerShell: Active Directory organizational units, users, groups, and object movement.

## VM to Use

Run this exercise from **LON-CL1**. The script will manage Active Directory on **LON-DC1**.

## Estimated Time

30-40 minutes

## Points

15 points

## Scenario

Adatum is opening a small branch office. Instead of creating Active Directory objects manually, you need to write a repeatable provisioning script.

## Your Task

Create a script named:

```powershell
C:\AZ040Extra\EX02-BranchProvisioning.ps1
```

The script must create the following Active Directory structure:

```text
OU=ExtraLab-London,DC=Adatum,DC=com
Group: ExtraLab-London-Admins
User: ExtraLab-User01
Computer Account: ExtraLab-CL99
```

## Required Tasks

Your script must:

1. Import the Active Directory module.
2. Check whether the OU `ExtraLab-London` already exists.
3. Create the OU only if it does not already exist.
4. Create the security group `ExtraLab-London-Admins` inside the OU.
5. Create the user `ExtraLab-User01` inside the OU.
6. Create the computer account `ExtraLab-CL99` inside the OU.
7. Add the user to the group.
8. Display the final OU contents.
9. Export the OU contents to:

```powershell
C:\AZ040Extra\EX02-ADObjects.csv
```

## Required Script Features

Your script should include:

- Variables for the OU name, group name, user name, and computer name.
- `if` statements to prevent duplicate object creation.
- At least one `Get-ADObject`, `Get-ADUser`, or `Get-ADGroup` validation step.
- Final output exported to CSV.

## Tips

Useful commands:

```powershell
Import-Module ActiveDirectory
Get-ADOrganizationalUnit
New-ADOrganizationalUnit
New-ADGroup
New-ADUser
New-ADComputer
Add-ADGroupMember
Get-ADObject
Export-Csv
```

Example OU path:

```powershell
$domainDN = 'DC=Adatum,DC=com'
$ouDN = "OU=ExtraLab-London,$domainDN"
```

To check whether an OU exists:

```powershell
Get-ADOrganizationalUnit -Filter "Name -eq 'ExtraLab-London'"
```

To avoid stopping the whole script when an object does not exist, you can use:

```powershell
-ErrorAction SilentlyContinue
```

## Expected Result

The script should be safe to run more than once. Running it a second time should not create duplicate objects or crash because the objects already exist.

## Validation

Run these commands:

```powershell
Get-ADOrganizationalUnit -Filter "Name -eq 'ExtraLab-London'"
Get-ADGroup -Identity 'ExtraLab-London-Admins'
Get-ADUser -Identity 'ExtraLab-User01'
Get-ADGroupMember -Identity 'ExtraLab-London-Admins'
Import-Csv C:\AZ040Extra\EX02-ADObjects.csv
```

## Cleanup Optional

Do not delete the objects unless your trainer tells you to. They may be used by later extra exercises.

## Bonus Challenge

Add a parameter named `$BranchName` so the same script can create a branch OU for another city, such as `ExtraLab-Penang` or `ExtraLab-Johor`.
