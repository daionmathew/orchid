#!/bin/bash
# Backend Deployment Script

TARGET_DIR="/var/www/inventory"
ZIP_PATH="$HOME/orchid-repo/resortapp_deploy.zip"

echo "Backing up old ResortApp..."
# Use sudo here
sudo cp -r "$TARGET_DIR/ResortApp" "$TARGET_DIR/ResortApp_backup_$(date +%Y%m%d_%H%M%S)"

echo "Extracting new ResortApp..."
# Overwrite except for venv and .env
sudo unzip -o "$ZIP_PATH" -d "$TARGET_DIR/"

echo "Ensuring permissions..."
sudo chown -R www-data:www-data "$TARGET_DIR/ResortApp"
sudo chmod -R 755 "$TARGET_DIR/ResortApp"

echo "Restarting service..."
sudo systemctl restart inventory-resort.service

echo "Checking status..."
sudo systemctl status inventory-resort.service | head -n 10
