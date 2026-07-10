# AZ-040 PowerShell Extra Time Exercises

This repository contains trainer-added practice exercises for **AZ-040: Automating Administration with PowerShell**.

The exercises are designed for students who have access to the standard Adatum lab virtual machines:

- `LON-DC1`
- `LON-SVR1`
- `LON-CL1`

> Note: Some lab portals may visually look like `LON-CLI1`. The official MicrosoftLearning lab naming convention uses `LON-CL1`. If your portal uses a different display name, substitute accordingly.

## Purpose

These are **extra-time exercises**, not replacements for the official Microsoft lab steps. They are intended for students who finish early or need additional scripting practice.

The exercises focus on repetitive administration tasks that students can automate with PowerShell scripts.

## Exercise Set

Go to:

[extra-time-exercises/README.md](extra-time-exercises/README.md)

## Grading Scripts

Trainer-side grading scripts are available here:

[grading/README.md](grading/README.md)

Each exercise has a matching checker script, for example:

```powershell
.\grading\Grade-EX01.ps1
.\grading\Grade-EX02.ps1
```

The grading scripts produce a clear score and PASS / PARTIAL / FAIL result. They validate expected files, CSV exports, AD objects, remoting output, job results, and optional cloud audit files.

## Source Alignment

The topics are aligned with the public MicrosoftLearning AZ-040 GitHub repository:

https://github.com/MicrosoftLearning/AZ-040T00-Automating-Administration-with-PowerShell

This repository contains original trainer-added practice material inspired by the AZ-040 lab topic areas, including command discovery, local administration, pipeline usage, PSProviders, CIM/WMI, scripting, remoting, jobs, Azure PowerShell, and Microsoft 365 PowerShell.

## Important Student Warning

Some scripts modify Active Directory objects, local server settings, files, registry keys, or cloud resources. Students must read each exercise carefully and run only in the training lab environment.

Do **not** run these exercises on production systems.
