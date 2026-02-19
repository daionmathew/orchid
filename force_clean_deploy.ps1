# Force Clean Dashboard Deployment
$serverIP = "34.30.59.169"
$username = "basilabrahamaby"
$sshKey = "$env:USERPROFILE\.ssh\gcp_key"
$zip = "C:\releasing\New Orchid\dashboard_deploy.zip"

Write-Host "Step 1: Uploading fresh dashboard build..." -ForegroundColor Yellow
scp -i $sshKey $zip "${username}@${serverIP}:~/orchid-repo/"

Write-Host "Step 2: Cleaning server directories..." -ForegroundColor Yellow
$cleanScript = @"
echo '[Clean] Removing old dashboard completely...'
sudo rm -rf /var/www/html/orchidadmin/*
sudo rm -rf ~/orchid-repo/dashboard_build
mkdir -p ~/orchid-repo/dashboard_build

echo '[Extract] Unzipping new build...'
cd ~/orchid-repo
unzip -o dashboard_deploy.zip -d dashboard_build/

echo '[Deploy] Copying to web root...'
sudo cp -r ~/orchid-repo/dashboard_build/* /var/www/html/orchidadmin/

echo '[Permissions] Setting ownership...'
sudo chown -R www-data:www-data /var/www/html/orchidadmin/
sudo chmod -R 755 /var/www/html/orchidadmin/

echo '[Verify] Checking deployed files...'
ls -la /var/www/html/orchidadmin/
cat /var/www/html/orchidadmin/asset-manifest.json

echo '[Complete] Deployment finished!'
"@

ssh -i $sshKey "${username}@${serverIP}" $cleanScript

Write-Host "`nDeployment Complete!" -ForegroundColor Green
Write-Host "Please hard refresh your browser (Ctrl+Shift+R)" -ForegroundColor Cyan
