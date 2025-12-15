# scripts/99-cleanup.ps1
$pidFile = "$PSScriptRoot/../.app.pid"

if (Test-Path $pidFile) {
    $id = Get-Content $pidFile
    Write-Host "Stopping application (PID: $id)..."
    try {
        Stop-Process -Id $id -Force -ErrorAction Stop
        Write-Host "Application stopped."
    } catch {
        Write-Warning "Could not stop process $id. It might have already exited."
    }
    Remove-Item $pidFile
} else {
    Write-Host "No PID file found. Nothing to stop."
}
