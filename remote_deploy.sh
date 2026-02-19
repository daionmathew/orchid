#!/bin/bash
set -e

echo '[Backend] Extracting backend_deploy_orchid.zip...'
rm -rf ~/ResortApp_Orchid
mkdir -p ~/ResortApp_Orchid
# unzip might return exit code 1 if there are warnings (like backslashes)
unzip -o ~/backend_deploy_orchid.zip -d ~/ResortApp_Orchid || { 
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 1 ]; then 
        echo "Unzip failed with exit code $EXIT_CODE"
        exit $EXIT_CODE
    fi
    echo "Unzip finished with warnings (Exit code 1)"
}

echo "Source: /home/basilabrahamaby/ResortApp_Orchid/app/api/reports.py"
ls -l /home/basilabrahamaby/ResortApp_Orchid/app/api/reports.py

echo "Destination BEFORE copy: /var/www/inventory/ResortApp/app/api/reports.py"
ls -l /var/www/inventory/ResortApp/app/api/reports.py

echo '[Service] Stopping inventory-resort.service...'
sudo systemctl stop inventory-resort.service

echo '[Backend] Force Copying files...'
# Use -f to force and -r for recursive. 
# Delete existing app folder to ensure no stale files
sudo rm -rf /var/www/inventory/ResortApp/app
sudo cp -rf ~/ResortApp_Orchid/app /var/www/inventory/ResortApp/
sudo cp -f ~/ResortApp_Orchid/*.py /var/www/inventory/ResortApp/ 2>/dev/null || true

echo '[Backend] Running migrations...'
echo '[Backend] Running migrations...'
cd /var/www/inventory/ResortApp && sudo ./venv/bin/python3 server_migrate_orchid.py

echo "Destination AFTER copy: /var/www/inventory/ResortApp/app/api/reports.py"
ls -l /var/www/inventory/ResortApp/app/api/reports.py

echo '[Service] Restarting inventory-resort.service...'
sudo systemctl restart inventory-resort.service

echo 'Orchid Backend Deployment Complete (Target: inventory-resort) - Force Copy.'
