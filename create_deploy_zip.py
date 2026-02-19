import zipfile
import os

def zip_directory(path, zip_filename):
    with zipfile.ZipFile(zip_filename, 'w', zipfile.ZIP_DEFLATED) as zipf:
        for root, dirs, files in os.walk(path):
            for file in files:
                file_path = os.path.join(root, file)
                # Ensure forward slashes for Linux compatibility
                arcname = os.path.relpath(file_path, path).replace('\\', '/')
                zipf.write(file_path, arcname)

if __name__ == "__main__":
    zip_directory('dasboard/build', 'dashboard_deploy.zip')
    print("Created dashboard_deploy.zip with forward slashes.")
