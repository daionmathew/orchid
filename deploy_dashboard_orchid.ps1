
$ErrorActionPreference = "Stop"

$pem = "$env:USERPROFILE\.ssh\gcp_key"
$remote = "basilabrahamaby@34.30.59.169"

Write-Host "1. Uploading Dashboard build files to temp..."
# Upload to home first to avoid permission issues
ssh -o StrictHostKeyChecking=no -i $pem $remote "rm -rf ~/orchidadmin_build_temp"
scp -r -o StrictHostKeyChecking=no -i $pem "c:\releasing\New Orchid\dasboard\build" "${remote}:~/orchidadmin_build_temp"

Write-Host "2. Deploying to /var/www/html/orchidadmin/ ..."
ssh -o StrictHostKeyChecking=no -i $pem $remote "sudo mkdir -p /var/www/html/orchidadmin && sudo rm -rf /var/www/html/orchidadmin/* && sudo cp -r ~/orchidadmin_build_temp/* /var/www/html/orchidadmin/ && sudo chmod -R 755 /var/www/html/orchidadmin/"

Write-Host "3. Deploying to /var/www/resort/Resort_first/dasboard/build/ ..."
ssh -o StrictHostKeyChecking=no -i $pem $remote "sudo mkdir -p /var/www/resort/Resort_first/dasboard/build && sudo rm -rf /var/www/resort/Resort_first/dasboard/build/* && sudo cp -r ~/orchidadmin_build_temp/* /var/www/resort/Resort_first/dasboard/build/ && sudo chmod -R 755 /var/www/resort/Resort_first/dasboard/build/"

Write-Host "4. Cleaning up temp files..."
ssh -o StrictHostKeyChecking=no -i $pem $remote "rm -rf ~/orchidadmin_build_temp"

Write-Host "Dashboard successfully deployed to BOTH locations on 34.30.59.169!"
