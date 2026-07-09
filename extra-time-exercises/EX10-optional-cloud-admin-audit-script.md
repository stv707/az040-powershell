# Exercise 10: Optional Cloud Admin Audit Script

## Main Topic

Azure PowerShell, Microsoft Graph PowerShell, cloud administration, and reporting.

## VM to Use

Run this exercise from **LON-CL1**.

## Estimated Time

45-60 minutes

## Points

20 points

## Requirement

This exercise is optional because it requires access to an Azure subscription or Microsoft 365 tenant.

Complete **Track A**, **Track B**, or both, depending on what your trainer provides.

## Track A: Azure PowerShell Resource Audit

### Scenario

You need to create a simple Azure audit script that lists resource groups and resources in the current subscription.

### Your Task

Create a script named:

```powershell
C:\AZ040Extra\EX10-AzureAudit.ps1
```

The script must:

1. Check whether the `Az.Accounts` module is available.
2. Connect to Azure using `Connect-AzAccount`.
3. Display the current subscription.
4. Export all resource groups to:

```powershell
C:\AZ040Extra\EX10-AzureResourceGroups.csv
```

5. Export all Azure resources to:

```powershell
C:\AZ040Extra\EX10-AzureResources.csv
```

### Tips

Useful commands:

```powershell
Get-Module -ListAvailable
Install-Module Az -Scope CurrentUser
Connect-AzAccount
Get-AzContext
Get-AzResourceGroup
Get-AzResource
Export-Csv
```

Check module availability:

```powershell
Get-Module -ListAvailable -Name Az.Accounts
```

Install the Az module only if your trainer allows it:

```powershell
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
```

Export resource groups:

```powershell
Get-AzResourceGroup | Select-Object ResourceGroupName, Location, ProvisioningState |
    Export-Csv C:\AZ040Extra\EX10-AzureResourceGroups.csv -NoTypeInformation
```

## Track B: Microsoft 365 / Microsoft Graph User Audit

### Scenario

You need to create a small Microsoft 365 audit script that lists users and groups from Microsoft Entra ID using Microsoft Graph PowerShell.

### Your Task

Create a script named:

```powershell
C:\AZ040Extra\EX10-M365Audit.ps1
```

The script must:

1. Check whether the `Microsoft.Graph.Authentication` module is available.
2. Connect to Microsoft Graph using delegated permissions.
3. Export users to:

```powershell
C:\AZ040Extra\EX10-M365Users.csv
```

4. Export groups to:

```powershell
C:\AZ040Extra\EX10-M365Groups.csv
```

### Tips

Useful commands:

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
Connect-MgGraph
Get-MgUser
Get-MgGroup
Disconnect-MgGraph
Export-Csv
```

Suggested scopes:

```powershell
Connect-MgGraph -Scopes 'User.Read.All','Group.Read.All'
```

Export users:

```powershell
Get-MgUser -All | Select-Object DisplayName, UserPrincipalName, Id |
    Export-Csv C:\AZ040Extra\EX10-M365Users.csv -NoTypeInformation
```

Export groups:

```powershell
Get-MgGroup -All | Select-Object DisplayName, MailEnabled, SecurityEnabled, Id |
    Export-Csv C:\AZ040Extra\EX10-M365Groups.csv -NoTypeInformation
```

## Required Script Features

For whichever track you complete, your script should include:

- Module check.
- Connection command.
- At least one exported CSV report.
- At least one `Select-Object` pipeline.
- Clear comments.
- A disconnect command where applicable.

## Expected Result

At minimum, you should produce one valid CSV report from either Azure or Microsoft 365.

## Validation

Run whichever commands apply:

```powershell
Import-Csv C:\AZ040Extra\EX10-AzureResourceGroups.csv | Select-Object -First 5
Import-Csv C:\AZ040Extra\EX10-AzureResources.csv | Select-Object -First 5
Import-Csv C:\AZ040Extra\EX10-M365Users.csv | Select-Object -First 5
Import-Csv C:\AZ040Extra\EX10-M365Groups.csv | Select-Object -First 5
```

## Important Notes

- Use only the tenant or subscription provided for training.
- Do not create paid Azure resources unless your trainer explicitly instructs you to.
- If module installation fails because of publisher/signing conflicts, remove older conflicting module versions or install with the correct trainer-approved parameters.
- Do not use a production Microsoft 365 tenant for this exercise.

## Bonus Challenge

Create a combined HTML audit report using `ConvertTo-Html`.
