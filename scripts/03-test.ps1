# scripts/03-test.ps1
param (
    [int]$Port = 5000
)

$ErrorActionPreference = "Stop"

Write-Host "Running Pester Smoke Tests..."

$testPath = "$PSScriptRoot/../tests/Smoke.Tests.ps1"

# We use Invoke-Pester
$config = New-PesterConfiguration
$config.Run.Path = $testPath
$config.Run.Container = New-PesterContainer -Path $testPath -Data @{ Port = $Port }
$config.TestResult.Enabled = $true
$config.TestResult.OutputFormat = "NUnitXml"
$config.TestResult.OutputPath = "$PSScriptRoot/../logs/pester-results.xml"
$config.Output.Verbosity = "Detailed"

Invoke-Pester -Configuration $config

if ($LASTEXITCODE -ne 0) {
    Write-Error "Smoke tests failed."
    exit 1
}

Write-Host "Smoke tests passed."
