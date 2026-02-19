#!/bin/bash
# Add no-cache headers for orchidadmin to force fresh loads

# Backup current config
sudo cp /etc/nginx/sites-enabled/default /etc/nginx/sites-enabled/default.backup

# Check if orchidadmin location already has add_header directives
if grep -q "location /orchidadmin/" /etc/nginx/sites-enabled/default; then
    echo "Found /orchidadmin/ location block"
    
    # Add no-cache headers if not already present
    if ! grep -A 5 "location /orchidadmin/" /etc/nginx/sites-enabled/default | grep -q "no-cache"; then
        echo "Adding no-cache headers..."
        sudo sed -i '/location \/orchidadmin\//,/}/ {
            /try_files/ a\        add_header Cache-Control "no-cache, no-store, must-revalidate";\n        add_header Pragma "no-cache";\n        add_header Expires "0";
        }' /etc/nginx/sites-enabled/default
    else
        echo "No-cache headers already present"
    fi
else
    echo "No /orchidadmin/ location block found"
fi

# Test nginx config
sudo nginx -t

# Reload nginx if config is valid
if [ $? -eq 0 ]; then
    sudo systemctl reload nginx
    echo "Nginx reloaded successfully"
else
    echo "Nginx config test failed, restoring backup"
    sudo cp /etc/nginx/sites-enabled/default.backup /etc/nginx/sites-enabled/default
fi
