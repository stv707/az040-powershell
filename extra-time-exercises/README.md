# AZ-040 Extra Time Exercises

These exercises are designed for students who finish the official lab early and need more practical scripting work.

## Environment Assumption

Use the standard AZ-040 Adatum lab VMs:

| VM | Main Use |
|---|---|
| `LON-CL1` | Main student workstation. Run most scripts from here. |
| `LON-DC1` | Domain controller, Active Directory, DNS/DHCP-style discovery, remoting target. |
| `LON-SVR1` | Member server, file share, IIS, remoting target, service/reporting target. |

Run PowerShell as Administrator unless the exercise says otherwise.

## Recommended Student Workflow

1. Read the scenario.
2. Create a new `.ps1` file on `LON-CL1`.
3. Build the script gradually.
4. Test one command at a time.
5. Add error handling only after the basic script works.
6. Capture proof of completion using screenshots, transcript files, or exported reports.

## Exercise List

| # | Exercise | Main AZ-040 Topic | Points |
|---:|---|---|---:|
| 01 | [Command Discovery and Transcript Toolkit](EX01-command-discovery-transcript-toolkit.md) | Getting started, help, command discovery | 10 |
| 02 | [Active Directory Branch Provisioning Script](EX02-active-directory-branch-provisioning.md) | Local administration, AD objects | 15 |
| 03 | [Pipeline-Based System Report](EX03-pipeline-system-report.md) | Pipeline, filtering, formatting, exporting | 15 |
| 04 | [PSDrive ScriptShare and Registry Configuration](EX04-psdrive-scriptshare-registry-config.md) | PSProviders and PSDrives | 15 |
| 05 | [CIM and WMI Hardware Inventory](EX05-cim-wmi-hardware-inventory.md) | CIM, WMI, system information | 15 |
| 06 | [Hashtable-Driven Server Configuration Report](EX06-hashtable-server-config-report.md) | Variables, arrays, hash tables | 15 |
| 07 | [CSV-Based AD User Onboarding](EX07-csv-ad-user-onboarding.md) | Scripting, CSV, loops, conditions | 20 |
| 08 | [PowerShell Remoting Maintenance Script](EX08-remoting-maintenance-script.md) | Remoting, Invoke-Command, PSSession | 20 |
| 09 | [Background Job Health Checks](EX09-background-job-health-checks.md) | Background jobs and scheduled jobs | 15 |
| 10 | [Optional Cloud Admin Audit Script](EX10-optional-cloud-admin-audit-script.md) | Azure PowerShell and Microsoft 365 PowerShell | 20 |

Total: **160 points**

## Submission Format

For each exercise, students should submit:

- The `.ps1` script they wrote.
- The generated output file, if any.
- One short paragraph explaining what the script does.
- Any errors they faced and how they fixed them.

## Trainer Note

These exercises intentionally provide tips, command hints, and structure, but not full answer-key scripts. They are meant to force students to write PowerShell, not just copy/paste.
