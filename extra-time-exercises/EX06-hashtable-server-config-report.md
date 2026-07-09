# Exercise 06: Hashtable-Driven Server Configuration Report

## Main Topic

Variables, arrays, hash tables, calculated properties, and reusable script configuration.

## VMs to Use

Run this exercise from **LON-CL1**. Query **LON-DC1** and **LON-SVR1**.

## Estimated Time

30-40 minutes

## Points

15 points

## Scenario

You want your scripts to be easier to maintain. Instead of hard-coding values everywhere, you will store server configuration details in hash tables and use them to generate a repeatable report.

## Your Task

Create a script named:

```powershell
C:\AZ040Extra\EX06-HashtableServerReport.ps1
```

The script must define a hash table that describes each server:

```powershell
$servers = @{
    'LON-DC1' = @{
        Role = 'Domain Controller'
        ServicesToCheck = @('DNS','W32Time','Spooler')
    }
    'LON-SVR1' = @{
        Role = 'Member Server'
        ServicesToCheck = @('LanmanServer','W32Time','Spooler')
    }
}
```

Your script must:

1. Loop through each server in the hash table.
2. Test whether the server responds to a basic connection test.
3. Check the status of each service listed for that server.
4. Build a result object for each service.
5. Export the result to:

```powershell
C:\AZ040Extra\EX06-ServiceRoleReport.csv
```

## Required Script Features

Your script should include:

- At least one hash table.
- At least one nested array inside the hash table.
- A loop through hash table keys.
- A loop through service names.
- `Test-Connection`.
- `Get-Service`.
- `[PSCustomObject]`.
- CSV export.

## Tips

Loop through hash table keys:

```powershell
foreach ($serverName in $servers.Keys) {
    $role = $servers[$serverName].Role
}
```

Loop through service names:

```powershell
foreach ($serviceName in $servers[$serverName].ServicesToCheck) {
    Get-Service -ComputerName $serverName -Name $serviceName
}
```

Test connection:

```powershell
Test-Connection -ComputerName LON-DC1 -Count 1 -Quiet
```

Create a result object:

```powershell
[PSCustomObject]@{
    ComputerName = $serverName
    Role = $role
    ServiceName = $serviceName
    Status = $service.Status
}
```

## Expected Result

The CSV should show each server, its expected role, each service checked, and the actual status of that service.

## Validation

Run:

```powershell
Import-Csv C:\AZ040Extra\EX06-ServiceRoleReport.csv | Format-Table -AutoSize
```

## Bonus Challenge

Add a column named `Health`:

- `Healthy` if the server is reachable and the service is running.
- `Warning` if the server is reachable but the service is stopped.
- `Offline` if the server is not reachable.
