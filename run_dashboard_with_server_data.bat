@echo off
echo ========================================
echo Run Dashboard Locally with Server Data
echo ========================================
echo.
echo This script will:
echo 1. Backup database from server
echo 2. Restore it to local PostgreSQL
echo 3. Start the backend API
echo 4. Start the dashboard frontend
echo.
echo Press any key to continue or Ctrl+C to cancel...
rem pause >nul

echo.
echo ========================================
echo Step 1: Restoring Database from Server
echo ========================================
cd ResortApp
powershell -ExecutionPolicy Bypass -File restore_from_server.ps1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Database restore failed!
    rem pause
    exit /b 1
)

echo.
echo ========================================
echo Step 1b: Applying Local Inventory Fixes
echo ========================================
python fix_103_counts.py
python fix_room_103.py
python check_db_inventory.py

cd ..

echo.
echo ========================================
echo Step 2: Starting Backend Server
echo ========================================
echo Backend will run on http://localhost:8011
echo.
start "Orchid Backend" cmd /k "cd ResortApp && call venv\Scripts\activate.bat && python main.py"

echo Waiting for backend to start...
timeout /t 5 /nobreak >nul

echo.
echo ========================================
echo Step 3: Starting Dashboard Frontend
echo ========================================
echo Dashboard will run on http://localhost:3000
echo.
cd dasboard
start "Orchid Dashboard" cmd /k "npm start"
cd ..

echo.
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo Backend API: http://localhost:8011
echo API Docs: http://localhost:8011/docs
echo Dashboard: http://localhost:3000
echo.
echo Press any key to exit this window...
echo (Backend and Dashboard will continue running in separate windows)
rem pause >nul
