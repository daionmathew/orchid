# Full Deployment Script with Data Cleanup
# This script packages and deploys Backend, Dashboard, and Userend, then clears all transactions.

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Resort Management - Full Deployment & Clean" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$ErrorActionPreference = "Stop"

# Paths
$baseDir = "C:\releasing\New Orchid"
$backendDir = "$baseDir\ResortApp"
$dashboardDir = "$baseDir\dasboard"
$userendDir = "$baseDir\userend"

# Deployment files
$backendZip = "$baseDir\backend_deploy.zip"
$dashboardZip = "$baseDir\dashboard_deploy.zip"
$userendZip = "$baseDir\userend_deploy.zip"

# Server details
$serverIP = "34.30.59.169"
$username = "basilabrahamaby"
$sshKey = "$env:USERPROFILE\.ssh\gcp_key"

Write-Host "`n[1/6] Building Dashboard (React)..." -ForegroundColor Yellow
Set-Location $dashboardDir
npm run build

Write-Host "`n[2/6] Building Userend (React)..." -ForegroundColor Yellow
Set-Location $userendDir
# Check if build already exists to avoid long build times if not needed, but for "deploy" we usually want fresh
npm run build

Write-Host "`n[3/6] Creating deployment packages..." -ForegroundColor Yellow
Set-Location $baseDir

# Package Backend (Excluding venv, .env, __pycache__)
Write-Host "  - Packaging ResortApp..." -ForegroundColor Gray
if (Test-Path $backendZip) { Remove-Item $backendZip -Force }
Get-ChildItem -Path $backendDir -Exclude "venv", "__pycache__", ".git", ".env", ".idea", ".vscode", "*.log" | Compress-Archive -DestinationPath $backendZip -CompressionLevel Optimal

# Package Dashboard build
Write-Host "  - Packaging Dashboard build..." -ForegroundColor Gray
if (Test-Path $dashboardZip) { Remove-Item $dashboardZip -Force }
Compress-Archive -Path "$dashboardDir\build\*" -DestinationPath $dashboardZip -CompressionLevel Optimal

# Package Userend build
Write-Host "  - Packaging Userend build..." -ForegroundColor Gray
if (Test-Path $userendZip) { Remove-Item $userendZip -Force }
Compress-Archive -Path "$userendDir\build\*" -DestinationPath $userendZip -CompressionLevel Optimal

Write-Host "`n[4/6] Uploading to server..." -ForegroundColor Yellow
scp -i $sshKey $backendZip "${username}@${serverIP}:~/orchid-repo/"
scp -i $sshKey $dashboardZip "${username}@${serverIP}:~/orchid-repo/"
scp -i $sshKey $userendZip "${username}@${serverIP}:~/orchid-repo/"
scp -i $sshKey "$baseDir\extract_fixed.py" "${username}@${serverIP}:~/orchid-repo/"
scp -i $sshKey "$baseDir\fix_paths.py" "${username}@${serverIP}:~/orchid-repo/"

Write-Host "`n[5/6] Deploying on server..." -ForegroundColor Yellow
$deployScript = @"
# Backend deployment
echo '[Backend] Extracting and deploying...'
sudo rm -rf ~/orchid-repo/ResortApp
python3 ~/orchid-repo/extract_fixed.py ~/orchid-repo/backend_deploy.zip ~/orchid-repo/ResortApp
sudo cp -r ~/orchid-repo/ResortApp/* /var/www/inventory/ResortApp/
cd /var/www/inventory/ResortApp/ && sudo python3 ~/orchid-repo/fix_paths.py

# Data Cleanup
echo '[Cleanup] Clearing all transactional data...'
cd /var/www/inventory/ResortApp/ && sudo ./venv/bin/python3 server_cleanup.py

# Database Migrations
echo '[Backend] Running Database Migrations...'
cd /var/www/inventory/ResortApp/ && sudo ./venv/bin/python3 migrate_database.py

# Dashboard deployment
echo '[Dashboard] Extracting and deploying...'
sudo rm -rf /var/www/resort/Resort_first/dasboard/build/*
python3 ~/orchid-repo/extract_fixed.py ~/orchid-repo/dashboard_deploy.zip /var/www/resort/Resort_first/dasboard/build/

# Userend deployment
echo '[Userend] Extracting and deploying...'
sudo rm -rf /var/www/html/inventory/*
python3 ~/orchid-repo/extract_fixed.py ~/orchid-repo/userend_deploy.zip /var/www/html/inventory/

# Restart backend service
echo '[Service] Restarting backend...'
sudo systemctl restart inventory-resort.service

echo 'Deployment and cleanup complete!'
"@

# Strip all carriage returns
$deployScript = [regex]::Replace($deployScript, "\r", "")
ssh -i $sshKey -o StrictHostKeyChecking=no "${username}@${serverIP}" $deployScript

Write-Host "`n[6/6] Verifying deployment..." -ForegroundColor Yellow
$status = ssh -i $sshKey "${username}@${serverIP}" "sudo systemctl status inventory-resort.service --no-pager | head -10"
Write-Host $status

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "DEPLOYMENT & CLEANUP COMPLETED!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
