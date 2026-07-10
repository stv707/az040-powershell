# AZ-040 Extra Exercise Grading Scripts

This folder contains trainer-side PowerShell grading scripts for the 10 extra-time exercises.

## How to Use

Run the checker for the matching exercise from **LON-CL1** after the student has completed the exercise.

Example:

```powershell
cd C:\Path\To\Repo\grading
.\Grade-EX01.ps1
```

Each script prints a clear pass/fail style report and a final score.

## Important Notes

- These scripts are validation tools, not answer-key scripts.
- They check expected files, exported data, object existence, and basic output quality.
- They do not guarantee the student's script is perfect.
- A student can pass the output checks but still have messy code. Review the `.ps1` file separately if code quality matters.
- Run PowerShell as Administrator unless the exercise says otherwise.
- Exercises 02 and 07 require the Active Directory PowerShell module.
- Exercise 08 requires PowerShell remoting to be available.
- Exercise 10 is optional and depends on Azure or Microsoft 365 access.

## Grading Script List

| Exercise | Grading Script | Main Validation |
|---:|---|---|
| 01 | `Grade-EX01.ps1` | Transcript, command CSV, student script |
| 02 | `Grade-EX02.ps1` | AD OU, group, user, computer, CSV export |
| 03 | `Grade-EX03.ps1` | Report folder and five CSV reports |
| 04 | `Grade-EX04.ps1` | ScriptShare files, registry value, proof file |
| 05 | `Grade-EX05.ps1` | CIM inventory CSV and expected computer rows |
| 06 | `Grade-EX06.ps1` | Hashtable-driven service role report CSV |
| 07 | `Grade-EX07.ps1` | CSV onboarding input, AD users, result log |
| 08 | `Grade-EX08.ps1` | Remoting maintenance CSV and failed-computer log |
| 09 | `Grade-EX09.ps1` | Background job result file and cleanup expectation |
| 10 | `Grade-EX10.ps1` | Optional Azure/M365 CSV output checks |

## Suggested Grading Policy

Use the automatic score as a fast first pass:

- 80% and above: likely successful.
- 60% to 79%: partially successful; inspect student script.
- Below 60%: likely incomplete or wrong.

For serious assessment, combine this checker output with manual review of the student's script logic.
