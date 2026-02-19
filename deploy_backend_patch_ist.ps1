
$ErrorActionPreference = "Stop"
$serverIP = "34.30.59.169"
$username = "basilabrahamaby"
$sshKey = "$env:USERPROFILE\.ssh\gcp_key"

Write-Host "1. Uploading modified Python files..."
scp -i $sshKey "C:\releasing\New Orchid\ResortApp\app\utils\food_scheduler.py" "${username}@${serverIP}:~/food_scheduler.py"
scp -i $sshKey "C:\releasing\New Orchid\ResortApp\app\api\packages.py" "${username}@${serverIP}:~/packages.py"

Write-Host "2. Moving files to production and restarting service..."
$deployScript = @"
echo 'Moving files...'
sudo mv ~/food_scheduler.py /var/www/inventory/ResortApp/app/utils/food_scheduler.py
sudo mv ~/packages.py /var/www/inventory/ResortApp/app/api/packages.py
sudo chown www-data:www-data /var/www/inventory/ResortApp/app/utils/food_scheduler.py
sudo chown www-data:www-data /var/www/inventory/ResortApp/app/api/packages.py

echo 'Restarting Service...'
# Try common service names, just in case
sudo systemctl restart inventory-resort.service || echo 'inventory-resort.service not found'
sudo systemctl restart resort.service || echo 'resort.service not found'
sudo systemctl restart fastapi.service || echo 'fastapi.service not found'
sudo systemctl restart gunicorn.service || echo 'gunicorn.service not found'
"@

ssh -i $sshKey -o StrictHostKeyChecking=no "${username}@${serverIP}" $deployScript

Write-Host "Backend Patch Deployed!"
