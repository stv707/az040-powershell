# Exercise 09: Background Job Health Checks

## Main Topic

Background jobs and scheduled job concepts.

## VMs to Use

Run this exercise on **LON-CL1**. Query **LON-DC1** and **LON-SVR1**.

## Estimated Time

30-40 minutes

## Points

15 points

## Scenario

You want to run multiple health checks at the same time instead of waiting for each command to finish one-by-one. You will use PowerShell background jobs to collect information asynchronously.

## Your Task

Create a script named:

```powershell
C:\AZ040Extra\EX09-BackgroundHealthJobs.ps1
```

The script must:

1. Create the folder `C:\AZ040Extra\Jobs` if it does not exist.
2. Start one background job to collect service information from `LON-DC1`.
3. Start one background job to collect service information from `LON-SVR1`.
4. Start one local background job to collect the latest 20 System event log entries from `LON-CL1`.
5. Display all job names and states.
6. Wait for all jobs to complete.
7. Receive the job results.
8. Export the combined output to:

```powershell
C:\AZ040Extra\Jobs\EX09-JobResults.txt
```

## Required Script Features

Your script should include:

- `Start-Job`.
- `Get-Job`.
- `Wait-Job`.
- `Receive-Job`.
- `Remove-Job`.
- At least three background jobs.
- Clear job names.

## Tips

Start a simple local background job:

```powershell
Start-Job -Name LocalSystemEvents -ScriptBlock {
    Get-WinEvent -LogName System -MaxEvents 20
}
```

Start a job that queries a remote computer:

```powershell
Start-Job -Name LONDC1Services -ScriptBlock {
    Get-Service -ComputerName LON-DC1 | Where-Object Status -eq 'Running'
}
```

Check job status:

```powershell
Get-Job
```

Wait for jobs:

```powershell
Get-Job | Wait-Job
```

Receive results:

```powershell
Get-Job | Receive-Job
```

Clean up jobs:

```powershell
Get-Job | Remove-Job
```

## Expected Result

The script should create multiple jobs, wait for them, collect results, and save a text file containing the output.

## Validation

Run:

```powershell
Get-Content C:\AZ040Extra\Jobs\EX09-JobResults.txt -TotalCount 30
Get-Job
```

At the end, `Get-Job` should either show no jobs or only old jobs from previous exercises.

## Important Note

The older `Get-EventLog` cmdlet is Windows PowerShell 5.1 specific. Prefer `Get-WinEvent` for this exercise because it is the newer event log cmdlet.

## Bonus Challenge

Add timing information to show how long all jobs took to complete.

Hint:

```powershell
$start = Get-Date
$end = Get-Date
$duration = $end - $start
```
