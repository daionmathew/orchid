$serverIP = "34.30.59.169"
$username = "basilabrahamaby"
$sshKey = "$env:USERPROFILE\.ssh\gcp_key"
$localFile = "ResortApp\main.py"
$remoteDir = "~/orchid-repo"

Write-Host "Uploading main.py..."
scp -i $sshKey $localFile "${username}@${serverIP}:${remoteDir}/main.py"

Write-Host "Updating server..."
ssh -i $sshKey "${username}@${serverIP}" "sudo cp ~/orchid-repo/main.py /var/www/inventory/ResortApp/app/main.py && sudo cp ~/orchid-repo/main.py /var/www/inventory/ResortApp/main.py && sudo systemctl restart inventory-resort.service"

Write-Host "Done!"
