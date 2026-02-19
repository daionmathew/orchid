#!/bin/bash
# Server-side deployment script to be run via SSH
# This avoids line ending issues between local shell and remote bash

TARGET1="/var/www/resort/Resort_first/dasboard/build"
TARGET2="/var/www/html/orchidadmin"
ZIP_PATH="$HOME/orchid-repo/dashboard_deploy.zip"

echo "Cleaning up any corrupted ^M directories..."
# Remove directories that literally contain a carriage return
sudo find /var/www/resort/Resort_first/dasboard/build -name $'\r' -exec rm -rf {} + 2>/dev/null
sudo find /var/www/html/orchidadmin -name $'\r' -exec rm -rf {} + 2>/dev/null

echo "Deploying to Target 1: $TARGET1"
sudo mkdir -p "$TARGET1"
sudo rm -rf "$TARGET1"/*
sudo unzip -o "$ZIP_PATH" -d "$TARGET1"

echo "Deploying to Target 2: $TARGET2"
sudo mkdir -p "$TARGET2"
sudo rm -rf "$TARGET2"/*
sudo unzip -o "$ZIP_PATH" -d "$TARGET2"

echo "Setting permissions..."
sudo chown -R www-data:www-data "$TARGET1"
sudo chown -R www-data:www-data "$TARGET2"
sudo chmod -R 755 "$TARGET1"
sudo chmod -R 755 "$TARGET2"

echo "Verifying extraction..."
if [ -f "$TARGET1/index.html" ]; then
    echo "Success: Target 1 index.html found"
else
    echo "ERROR: Target 1 index.html NOT found"
fi

if [ -f "$TARGET2/index.html" ]; then
    echo "Success: Target 2 index.html found"
else
    echo "ERROR: Target 2 index.html NOT found"
fi
