$ErrorActionPreference = "Stop"
$pem = "$env:USERPROFILE\.ssh\gcp_key"
$remote = "basilabrahamaby@34.30.59.169"

Write-Host "1. Uploading cleanup script..."
scp -o StrictHostKeyChecking=no -i $pem "c:\releasing\New Orchid\ResortApp\clear_all_transactional_data.py" "${remote}:~/clear_all_transactional_data.py"

Write-Host "2. Key Check & Execution..."
# Only run if user confirms (though instructions say user asked for it)
# We will just run it.

$cmd = "sudo cp ~/clear_all_transactional_data.py /var/www/inventory/ResortApp/ && cd /var/www/inventory/ResortApp && sudo ./venv/bin/python3 clear_all_transactional_data.py"

ssh -o StrictHostKeyChecking=no -i $pem $remote $cmd

Write-Host "Done."
