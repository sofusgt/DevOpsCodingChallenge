# scripts/02-run.ps1
param (
    [int]$Port = 5000,
    [string]$ProjectDir = "$PSScriptRoot/../app/src"
)

$ErrorActionPreference = "Stop"

Write-Host "Starting application on port $Port..."

$logDir = "$PSScriptRoot/../logs"
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir | Out-Null
}

# Construct arguments
$arguments = "run --project `"$ProjectDir`" --urls `"http://localhost:$Port`""

$workingDir = Resolve-Path "$PSScriptRoot/.."

# Environment variables
$logPath = Join-Path $workingDir "logs/app.log"
$envParams = @{ LOG_PATH = $logPath }

# Start background process
$process = Start-Process -FilePath "dotnet" -ArgumentList $arguments -WorkingDirectory $workingDir -Environment $envParams -PassThru -NoNewWindow -RedirectStandardOutput "$logDir/stdout.log" -RedirectStandardError "$logDir/stderr.log"

if ($process.Id) {
    Write-Host "Application started. PID: $($process.Id)"
    $process.Id | Out-File "$PSScriptRoot/../.app.pid"
    
    # Wait for service to be up
    Write-Host "Waiting for service to initialize..."
    Start-Sleep -Seconds 5
    
    # Simple check
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:$Port/health" -Method Get -ErrorAction Stop
        if ($response.StatusCode -eq 200) {
            Write-Host "Service is up and running!"
        }
    } catch {
        Write-Warning "Service might not be ready yet. Check logs."
    }

} else {
    Write-Error "Failed to start application."
    exit 1
}
