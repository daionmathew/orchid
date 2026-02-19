# Force Clean Dashboard Deployment to CORRECT server paths
$serverIP = "34.30.59.169"
$username = "basilabrahamaby"
$sshKey = "$env:USERPROFILE\.ssh\gcp_key"
$zip = "C:\releasing\New Orchid\dashboard_deploy.zip"

Write-Host "Step 1: Uploading fresh dashboard build..." -ForegroundColor Yellow
scp -i $sshKey $zip "${username}@${serverIP}:~/orchid-repo/"

Write-Host "Step 2: Deploying to ACTIVE Nginx paths..." -ForegroundColor Yellow
$deployScript = @"
echo '[Deploy] Target 1: /var/www/resort/Resort_first/dasboard/build'
sudo mkdir -p /var/www/resort/Resort_first/dasboard/build
sudo rm -rf /var/www/resort/Resort_first/dasboard/build/*
sudo unzip -o /home/${username}/orchid-repo/dashboard_deploy.zip -d /var/www/resort/Resort_first/dasboard/build/

echo '[Deploy] Target 2: /var/www/html/orchidadmin'
sudo mkdir -p /var/www/html/orchidadmin
sudo rm -rf /var/www/html/orchidadmin/*
sudo unzip -o /home/${username}/orchid-repo/dashboard_deploy.zip -d /var/www/html/orchidadmin/

echo '[Permissions] Setting permissions...'
sudo chown -R www-data:www-data /var/www/resort/Resort_first/dasboard/build
sudo chown -R www-data:www-data /var/www/html/orchidadmin
sudo chmod -R 755 /var/www/resort/Resort_first/dasboard/build
sudo chmod -R 755 /var/www/html/orchidadmin

echo '[Verify] Checking Target 1 contents...'
cat /var/www/resort/Resort_first/dasboard/build/asset-manifest.json | grep main.js

echo '[Verify] Checking Target 2 contents...'
cat /var/www/html/orchidadmin/asset-manifest.json | grep main.js

echo '[Deploy] Done.'
"@

ssh -i $sshKey -o StrictHostKeyChecking=no "${username}@${serverIP}" $deployScript
Write-Host "Re-deployment complete to both paths!" -ForegroundColor Green
