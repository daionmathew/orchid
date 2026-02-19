import zipfile
import os

def zip_directory(path, zip_filename, excludes):
    with zipfile.ZipFile(zip_filename, 'w', zipfile.ZIP_DEFLATED) as zipf:
        for root, dirs, files in os.walk(path):
            # Prune excluded directories
            dirs[:] = [d for d in dirs if d not in excludes]
            for file in files:
                if file.endswith('.pyc') or file in ['.env', 'server_log.txt', 'dashboard_deploy.zip']:
                    continue
                file_path = os.path.join(root, file)
                arcname = os.path.relpath(file_path, os.path.dirname(path)).replace('\\', '/')
                zipf.write(file_path, arcname)

if __name__ == "__main__":
    zip_directory('ResortApp', 'resortapp_deploy.zip', ['venv', '.git', '__pycache__', 'node_modules'])
    print("Created resortapp_deploy.zip")
