$ErrorActionPreference = "Stop"

$pem = "$env:USERPROFILE\.ssh\gcp_key"
$remote = "basilabrahamaby@34.30.59.169"

Write-Host "1. Creating Dashboard directory on server..."
ssh -o StrictHostKeyChecking=no -i $pem $remote "sudo mkdir -p /var/www/html/orchidadmin"

Write-Host "2. Uploading Dashboard build files..."
ssh -o StrictHostKeyChecking=no -i $pem $remote "rm -rf ~/temp_build && mkdir -p ~/temp_build"
scp -r -o StrictHostKeyChecking=no -i $pem "c:\releasing\New Orchid\dasboard\build" "${remote}:~/temp_build"

Write-Host "3. Moving files to web directory..."
# The scp above creates ~/temp_build/build. We copy the contents of that directory.
ssh -o StrictHostKeyChecking=no -i $pem $remote "sudo rm -rf /var/www/html/orchidadmin/* && sudo cp -r ~/temp_build/build/* /var/www/html/orchidadmin/ && sudo chmod -R 755 /var/www/html/orchidadmin/ && rm -rf ~/temp_build"

Write-Host "4. Configuring Nginx for Dashboard..."
$nginxConfig = @'
    location /orchidadmin/ {
        alias /var/www/html/orchidadmin/;
        try_files $uri $uri/ /orchidadmin/index.html;
        add_header Cache-Control "no-cache, must-revalidate";
    }
'@

# Upload config snippet
$nginxConfig | Out-File -FilePath "c:\releasing\New Orchid\dashboard_nginx.conf" -Encoding ASCII

Write-Host "Dashboard deployed! Access at: https://teqmates.com/orchidadmin/"
Write-Host "`nNote: You'll need to manually add the Nginx location block to /etc/nginx/sites-enabled/pomma"
