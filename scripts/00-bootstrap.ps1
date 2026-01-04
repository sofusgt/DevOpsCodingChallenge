# scripts/00-bootstrap.ps1
Write-Host "Bootstrapping environment..."

# Check PowerShell version
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Error "PowerShell 7 or above is required. Current version: $($PSVersionTable.PSVersion)"
    exit 1
}
Write-Host "Found PowerShell version: $($PSVersionTable.PSVersion)"

# Check .NET SDK version and install SDK 10 if needed
$dotnetVersion = dotnet --version 2>$null
$dotnetMajor = if ($dotnetVersion) { [int]($dotnetVersion.Split('.')[0]) } else { 0 }
if ($LASTEXITCODE -ne 0 -or $dotnetMajor -lt 10) {
    Write-Host "Installing .NET SDK 10 via winget..."
    winget install --id Microsoft.DotNet.SDK.10 --accept-source-agreements --accept-package-agreements
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to install .NET SDK 10."
        exit 1
    }
    $dotnetVersion = dotnet --version
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
