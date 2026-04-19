$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$composeFile = Join-Path $repoRoot 'docker-compose.full.local.yml'
$dockerDesktopPath = 'C:\Program Files\Docker\Docker\Docker Desktop.exe'

function Test-DockerDaemon {
    cmd /c "docker info >nul 2>nul"
    return $LASTEXITCODE -eq 0
}

function Test-WSLAvailable {
    cmd /c "wsl --status >nul 2>nul"
    return $LASTEXITCODE -eq 0
}

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    throw 'Docker CLI is not installed. Install Docker Desktop first.'
}

if (-not (Test-Path $composeFile)) {
    throw "Compose file not found: $composeFile"
}

if (-not (Test-DockerDaemon)) {
    if (Test-Path $dockerDesktopPath) {
        Write-Host 'Starting Docker Desktop...'
        Start-Process $dockerDesktopPath | Out-Null
    }

    for ($attempt = 1; $attempt -le 12; $attempt++) {
        Start-Sleep -Seconds 5
        if (Test-DockerDaemon) {
            break
        }
    }
}

if (-not (Test-DockerDaemon)) {
    if (-not (Test-WSLAvailable)) {
        throw @'
Docker Desktop could not start because the Linux engine is unavailable and WSL is not installed.

Run this once in an elevated PowerShell window:
  wsl --install

Then reboot Windows, start Docker Desktop, and rerun this script.
'@
    }

    throw 'Docker Desktop is installed but the daemon is still unavailable. Start Docker Desktop manually, wait until it shows "Engine running", and rerun this script.'
}

Write-Host 'Building and starting the full local stack...'
docker compose -f $composeFile up -d --build
if ($LASTEXITCODE -ne 0) {
    throw 'docker compose up failed.'
}

Write-Host ''
Write-Host 'Full stack is starting with PostgreSQL.'
Write-Host 'API:      http://localhost:8000'
Write-Host 'Admin:    http://localhost:8080'
Write-Host 'Staff:    http://localhost:8081'
Write-Host 'Customer: http://localhost:8082'
Write-Host 'Driver:   http://localhost:8083'
Write-Host 'Postgres: localhost:5433'
Write-Host ''

docker compose -f $composeFile ps
