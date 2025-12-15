# tests/Smoke.Tests.ps1
param (
    [int]$Port = 5000
)

Describe "Smoke Tests" {
    Context "Health Endpoint" {
        It "Should respond with 200 OK" {
            $response = Invoke-RestMethod -Uri "http://localhost:$Port/health" -Method Get -ResponseHeadersVariable headers -SkipHttpErrorCheck
            # In PowerShell 7, Invoke-RestMethod returns the body. To check status code we might need -ResponseHeadersVariable or try/catch or Use Invoke-WebRequest
            
            # Using Invoke-WebRequest is safer for status code checks
            $req = Invoke-WebRequest -Uri "http://localhost:$Port/health" -Method Get
            $req.StatusCode | Should -Be 200
        }
    }

    Context "Logging" {
        It "Should create a log file and contain health check entry" {
            # Give it a moment to flush logs
            Start-Sleep -Seconds 2

            $logDir = Join-Path $PSScriptRoot "../logs"
            # The app writes to logs/appYYYYMMDD.log because of RollingInterval.Day
            $logFiles = Get-ChildItem -Path $logDir -Filter "app*.log"
            
            $logFiles.Count | Should -BeGreaterThan 0
            
            # Check content of the latest log file
            $latestLog = $logFiles | Sort-Object LastWriteTime -Descending | Select-Object -First 1
            $content = Get-Content $latestLog.FullName
            ($content -join "`n") | Should -Match "Health endpoint hit"
        }
    }
}
