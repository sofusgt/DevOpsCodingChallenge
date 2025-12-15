# scripts/00-bootstrap.ps1
Write-Host "Bootstrapping environment..."

# Check .NET SDK
$dotnetVersion = dotnet --version
if ($LASTEXITCODE -ne 0) {
    Write-Error ".NET SDK not found."
    exit 1
}
Write-Host "Found .NET SDK version: $dotnetVersion"

# Install Pester if not present or old
$pester = Get-Module -ListAvailable -Name Pester | Sort-Object Version -Descending | Select-Object -First 1
if ($null -eq $pester -or $pester.Version.Major -lt 5) {
    Write-Host "Installing Pester module (latest)..."
    Install-Module -Name Pester -Force -SkipPublisherCheck -Scope CurrentUser -AllowClobber
} else {
    Write-Host "Pester module (v$($pester.Version)) already installed."
}

Write-Host "Bootstrap complete."
