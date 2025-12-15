# scripts/01-build.ps1
param (
    [string]$SolutionPath = "$PSScriptRoot/../app/HealthApp.slnx"
)

$ErrorActionPreference = "Stop"

Write-Host "Building solution: $SolutionPath"
dotnet build $SolutionPath

Write-Host "Running unit tests..."
dotnet test $SolutionPath --no-build --logger "trx;LogFileName=test_results.trx"

if ($LASTEXITCODE -ne 0) {
    Write-Error "Build or Tests failed."
    exit 1
}

Write-Host "Build and Unit Tests successful."
