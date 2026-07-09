# Exercise 07: CSV-Based AD User Onboarding

## Main Topic

PowerShell scripting, CSV input, loops, conditions, Active Directory automation, and repeatable administration.

## VMs to Use

Run this exercise from **LON-CL1**. The script will create users in Active Directory on **LON-DC1**.

## Estimated Time

45-60 minutes

## Points

20 points

## Scenario

HR sends a CSV file with new starter information. You need to write a PowerShell script that reads the CSV and creates user accounts in Active Directory.

## Your Task

Create this CSV file:

```powershell
C:\AZ040Extra\NewUsers.csv
```

With this content:

```csv
FirstName,LastName,Department,City
Asha,Raman,IT,London
Daniel,Lee,Finance,London
Mira,Patel,HR,London
```

Then create a script named:

```powershell
C:\AZ040Extra\EX07-CreateUsersFromCSV.ps1
```

The script must:

1. Import the CSV file.
2. Create an OU named `ExtraLab-NewUsers` if it does not already exist.
3. For each CSV row, build:
   - Display name: `FirstName LastName`
   - SamAccountName: first initial + last name, for example `araman`
   - UserPrincipalName: `samAccountName@adatum.com`
4. Check if the user already exists.
5. Create only missing users.
6. Set the department and city attributes.
7. Export a result log to:

```powershell
C:\AZ040Extra\EX07-OnboardingResult.csv
```

## Required Script Features

Your script should include:

- `Import-Csv`.
- `foreach` loop.
- String building.
- `if` statement.
- `New-ADUser`.
- `[PSCustomObject]` result logging.
- `Export-Csv`.

## Tips

Useful commands:

```powershell
Import-Csv
New-ADOrganizationalUnit
Get-ADUser
New-ADUser
Set-ADUser
Export-Csv
```

Build a username:

```powershell
$sam = ($user.FirstName.Substring(0,1) + $user.LastName).ToLower()
```

Build a display name:

```powershell
$displayName = "$($user.FirstName) $($user.LastName)"
```

Check whether a user exists:

```powershell
Get-ADUser -Filter "SamAccountName -eq '$sam'" -ErrorAction SilentlyContinue
```

Create a secure default password:

```powershell
$password = ConvertTo-SecureString 'Pa55w.rd123!' -AsPlainText -Force
```

Example `New-ADUser` properties:

```powershell
New-ADUser -Name $displayName `
    -GivenName $user.FirstName `
    -Surname $user.LastName `
    -SamAccountName $sam `
    -UserPrincipalName "$sam@adatum.com" `
    -Department $user.Department `
    -City $user.City `
    -Path $ouDN `
    -AccountPassword $password `
    -Enabled $true
```

## Expected Result

Three users should exist in the `ExtraLab-NewUsers` OU. Running the script a second time should not duplicate them.

## Validation

Run:

```powershell
Get-ADUser -Filter * -SearchBase 'OU=ExtraLab-NewUsers,DC=Adatum,DC=com' -Properties Department,City |
    Select-Object Name,SamAccountName,Department,City

Import-Csv C:\AZ040Extra\EX07-OnboardingResult.csv | Format-Table -AutoSize
```

## Bonus Challenge

Create one department-based group per department, then add each user to the correct group.

Example group names:

```text
ExtraLab-IT
ExtraLab-Finance
ExtraLab-HR
```
