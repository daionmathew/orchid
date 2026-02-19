
# Force deploy of dashboard only
$serverIP = "34.30.59.169"
$username = "basilabrahamaby"
$sshKey = "$env:USERPROFILE\.ssh\gcp_key"
$zip = "C:\releasing\New Orchid\dashboard_deploy.zip"

Write-Host "Uploading Dashboard..." -ForegroundColor Yellow
scp -i $sshKey $zip "${username}@${serverIP}:~/orchid-repo/"

Write-Host "Deploying on Server..." -ForegroundColor Yellow
$script = @"
echo '[Deploy] Removing old dashboard...'
sudo rm -rf ~/orchid-repo/dashboard_build
mkdir -p ~/orchid-repo/dashboard_build

echo '[Deploy] Extracting new dashboard...'
unzip -o ~/orchid-repo/dashboard_deploy.zip -d ~/orchid-repo/dashboard_build/

echo '[Deploy] Moving to web root...'
sudo rm -rf /var/www/html/orchidadmin/*
sudo cp -r ~/orchid-repo/dashboard_build/* /var/www/html/orchidadmin/

echo '[Deploy] Fixing permissions...'
sudo chown -R www-data:www-data /var/www/html/orchidadmin/
sudo chmod -R 755 /var/www/html/orchidadmin/

echo '[Deploy] Done.'
"@

ssh -i $sshKey "${username}@${serverIP}" $script
Write-Host "Dashboard Redeployed!" -ForegroundColor Green
