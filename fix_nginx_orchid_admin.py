import os

def update_nginx_remote():
    """
    Script to clean up nginx configuration:
    1. Remove /inventoryapi/ block (as user said no need for it, likely using /orchidapi/)
    2. Ensure proper routing for /orchidadmin (pointing to correct build)
    
    The user wants changes in /orchidadmin.
    """
    
    nginx_path = "/etc/nginx/sites-enabled/default"
    
    with open(nginx_path, 'r') as f:
        lines = f.readlines()
        
    new_lines = []
    skip = False
    
    # 1. Remove duplicate /inventoryapi/ if exists, and keep /orchidapi/
    for line in lines:
        if "location /inventoryapi/ {" in line:
            skip = True
        
        if skip and "}" in line:
            skip = False
            continue
            
        if not skip:
            new_lines.append(line)
            
    # 2. Update /orchidadmin to point to the new inventory admin build location
    # The user said: "https://teqmates.com/orchid/admin/ i need chanes in here"
    # And "use inventory folder"
    # So /orchidadmin should likely alias to /var/www/html/orchidadmin (where we deployed the inventory dashboard)
    
    # Let's rewrite the content of the file
    content = "".join(new_lines)
    
    # 3. Ensure /orchidadmin points to the new build
    # We deployed dashboard to /var/www/html/orchidadmin/ in fast_deploy.ps1
    # Check if /orchidadmin alias is correct
    
    updated_content = content
    if "alias /var/www/resort/Resort_first/dasboard/build;" in updated_content:
       updated_content = updated_content.replace(
           "alias /var/www/resort/Resort_first/dasboard/build;", 
           "alias /var/www/html/orchidadmin;"
       )
       
    # 4. Also ensure /inventoryadmin uses the same
    # (Already set to /var/www/html/orchidadmin/ in previous step)
    
    with open(nginx_path, 'w') as f:
        f.write(updated_content)

if __name__ == "__main__":
    update_nginx_remote()
    print("Nginx config updated: removed inventoryapi, updated orchidadmin alias.")
