# Docker Desktop PostgreSQL Dump Export (PowerShell)
# Usage: .\migrate_db_export.ps1

Write-Host "Docker Desktop PostgreSQL Dump Export" -ForegroundColor Blue
Write-Host "======================================" -ForegroundColor Blue
Write-Host ""

# Find Docker container
$dbContainer = docker ps --filter "name=teknik_servis_db" --format "{{.Names}}" | Select-Object -First 1

if ([string]::IsNullOrEmpty($dbContainer)) {
    Write-Host "ERROR: teknik_servis_db container not found!" -ForegroundColor Red
    Write-Host "Make sure the container is running in Docker Desktop." -ForegroundColor Yellow
    exit 1
}

Write-Host "Container found: $dbContainer" -ForegroundColor Green
Write-Host ""

# Full dump (schema + data)
Write-Host "Creating full database dump (schema + data)..." -ForegroundColor Yellow
docker exec $dbContainer pg_dump -U app -d teknik_servis --clean --if-exists | Out-File -FilePath "teknik_servis_full_dump.sql" -Encoding utf8

# Globals dump (users, roles)
Write-Host "Creating users and roles dump..." -ForegroundColor Yellow
docker exec $dbContainer pg_dumpall -U app -g | Out-File -FilePath "teknik_servis_globals.sql" -Encoding utf8

Write-Host ""
Write-Host "Dump files created:" -ForegroundColor Green
Write-Host "  - teknik_servis_full_dump.sql (schema + data)" -ForegroundColor Cyan
Write-Host "  - teknik_servis_globals.sql (users + roles)" -ForegroundColor Cyan

# Show file sizes
if (Test-Path "teknik_servis_full_dump.sql") {
    $size = (Get-Item "teknik_servis_full_dump.sql").Length / 1KB
    Write-Host "  Full dump size: $([math]::Round($size, 2)) KB" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "Now copy these files to the server:" -ForegroundColor Yellow
Write-Host "  scp teknik_servis_full_dump.sql user@server:/opt/teknik-servis/" -ForegroundColor White
Write-Host "  scp teknik_servis_globals.sql user@server:/opt/teknik-servis/" -ForegroundColor White
Write-Host ""
