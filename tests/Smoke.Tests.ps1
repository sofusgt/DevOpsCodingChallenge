# tests/Smoke.Tests.ps1
param (
    [int]$Port = 5000
)

Describe "Smoke Tests" {
    Context "Health Endpoint" {
        It "Should respond with 200 OK" {
            # Execute GET request against the health endpoint
            $req = Invoke-WebRequest -Uri "http://localhost:$Port/health" -Method Get
            
            # Assert that the status code is 200
            $req.StatusCode | Should -Be 200
        }
    }

    Context "Logging" {
        It "Should contain health check entry in stdout logs" {
            # Give it a moment to flush logs
            Start-Sleep -Seconds 2

            $logDir = Join-Path $PSScriptRoot "../logs"
            # We are now checking the redirected stdout log
            $logFile = Join-Path $logDir "stdout.log"
            
            Test-Path $logFile | Should -Be $true
            
            # Check content of the log file
            $content = Get-Content $logFile -Raw
            $content | Should -Match "Health endpoint hit"
        }
    }
}
