# Windows DevOps Coding Challenge

## Overview
This repository contains a solution for the Windows DevOps Coding Challenge.
It includes a minimal .NET web application, unit tests, and a set of PowerShell scripts to automate the lifecycle (bootstrap, build, run, test, cleanup).

## Structure
- `app/`: Source code and tests.
  - `src/`: The minimal Web API (.NET).
  - `test/`: NUnit tests.
- `scripts/`: Automation scripts.
  - `00-bootstrap.ps1`: Environment setup.
  - `01-build.ps1`: Builds and runs unit tests.
  - `02-run.ps1`: Starts the app in background on a configurable port.
  - `03-test.ps1`: Runs Pester smoke tests.
  - `99-cleanup.ps1`: Stops the application.
- `tests/`: Pester smoke tests.
- `.github/`: CI/CD workflow.

## Prerequisites
- Windows 10/11 or Windows Server.
- PowerShell 7+ (pwsh).
- .NET SDK (matches project version).

## Usage
Run the scripts in order from the `scripts` directory (or root).

```powershell
./scripts/00-bootstrap.ps1
./scripts/01-build.ps1
./scripts/02-run.ps1 -Port 5001
./scripts/03-test.ps1 -Port 5001
./scripts/99-cleanup.ps1
```

## Decisions & Assumptions
- **Framework**: Used .NET 10 (based on local environment). Can be downgraded to .NET 8/9 easily.
- **Logging**: Configured Serilog to write to `logs/app.log`.
- **Process Management**: Used `Start-Process` with output redirection to manage the background process. PID is stored in `.app.pid` for cleanup.
- **Testing**:
  - Unit tests use `WebApplicationFactory` to verify the endpoint status code.
  - Smoke tests (Pester) verify the running service via HTTP and check for log file creation.
