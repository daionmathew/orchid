$serverIP = "34.30.59.169"
$username = "basilabrahamaby"
$sshKey = "$env:USERPROFILE\.ssh\gcp_key"

Write-Host "1. Uploading Files..."
# scp -i $sshKey "ResortApp\app\api\inventory.py" "${username}@${serverIP}:~/inventory_api.py"
# scp -i $sshKey "ResortApp\app\curd\inventory.py" "${username}@${serverIP}:~/inventory_crud.py"

Write-Host "2. Running Remote Core Commands..."
# ssh -i $sshKey -o StrictHostKeyChecking=no "${username}@${serverIP}" "sudo mv ~/inventory_api.py /var/www/inventory/ResortApp/app/api/inventory.py && sudo mv ~/inventory_crud.py /var/www/inventory/ResortApp/app/curd/inventory.py && sudo chown www-data:www-data /var/www/inventory/ResortApp/app/api/inventory.py && sudo chown www-data:www-data /var/www/inventory/ResortApp/app/curd/inventory.py && sudo systemctl restart inventory-resort.service"

Write-Host "3. Schema Sync..."
ssh -i $sshKey -o StrictHostKeyChecking=no "${username}@${serverIP}" "sudo -u postgres psql -d orchid_resort -c 'ALTER TABLE bookings ADD COLUMN IF NOT EXISTS source VARCHAR(255) DEFAULT ''Direct'';'"

Write-Host "Done!"
