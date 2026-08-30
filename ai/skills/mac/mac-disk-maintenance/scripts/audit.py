#!/usr/bin/env python3
import os
import subprocess
import json
import sys

def get_dir_size(path):
    if not os.path.exists(path):
        return 0
    try:
        res = subprocess.run(["du", "-sk", path], capture_output=True, text=True, timeout=60)
        if res.returncode == 0 and res.stdout.strip():
            kb = int(res.stdout.strip().split()[0])
            return kb * 1024
    except Exception:
        pass
    return 0

def format_size(bytes_val):
    if bytes_val is None or bytes_val < 0:
        return "0 B"
    for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
        if bytes_val < 1024.0 or unit == 'TB':
            return f"{bytes_val:.2f} {unit}"
        bytes_val /= 1024.0

def run_cmd(cmd, timeout=60):
    try:
        res = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=timeout)
        return res.stdout.strip()
    except Exception as e:
        return f"Error: {e}"

def audit():
    results = {}
    print("=== PHASE 1: DISK AUDIT ===")
    
    # 1. df info
    print("\n--- Filesystem Space ---")
    df_out = run_cmd("df -h / /System/Volumes/Data")
    print(df_out)
    results["df"] = df_out

    # 2. APFS purgeable & snapshots
    print("\n--- APFS & Snapshots ---")
    tmutil_out = run_cmd("tmutil listlocalsnapshots /")
    print("Local Snapshots:\n", tmutil_out if tmutil_out else "None")
    results["snapshots"] = tmutil_out

    # 3. Top-level in Home
    home = os.path.expanduser("~")
    print(f"\n--- Scanning Home Directory: {home} ---")
    du_home = run_cmd(f"du -hd 1 {home} 2>/dev/null | sort -hr | head -30")
    print(du_home)

    # 4. Top-level in System dirs
    print("\n--- Scanning /Applications, /Library, /usr/local, /opt/homebrew ---")
    du_sys = run_cmd("du -hd 1 /Applications /Library /usr/local /opt/homebrew 2>/dev/null | sort -hr | head -30")
    print(du_sys)

    # 5. Targeted Checks
    print("\n--- Checking Specific Subsystems ---")
    targets = [
        ("User Caches", f"{home}/Library/Caches"),
        ("System Developer (Xcode)", "/Library/Developer"),
        ("User Developer (Xcode/Simulators/DerivedData)", f"{home}/Library/Developer"),
        ("Xcode DerivedData", f"{home}/Library/Developer/Xcode/DerivedData"),
        ("Xcode iOS DeviceSupport", f"{home}/Library/Developer/Xcode/iOS DeviceSupport"),
        ("Xcode Archives", f"{home}/Library/Developer/Xcode/Archives"),
        ("CoreSimulator Devices", f"{home}/Library/Developer/CoreSimulator/Devices"),
        ("User Application Support", f"{home}/Library/Application Support"),
        ("User Containers", f"{home}/Library/Containers"),
        ("User Group Containers", f"{home}/Library/Group Containers"),
        ("iOS Backups (MobileSync)", f"{home}/Library/Application Support/MobileSync/Backup"),
        ("Downloads", f"{home}/Downloads"),
        ("Trash", f"{home}/.Trash"),
        ("Mail", f"{home}/Library/Mail"),
        ("Messages Attachments", f"{home}/Library/Messages/Attachments"),
        ("Messages", f"{home}/Library/Messages"),
        ("Homebrew Cache", run_cmd("brew --cache 2>/dev/null")),
        ("NPM Cache", f"{home}/.npm"),
        ("Yarn Cache", f"{home}/Library/Caches/Yarn"),
        ("PNPM Store", f"{home}/Library/pnpm/store"),
        ("Cargo/Rust Cache", f"{home}/.cargo"),
        ("Rustup", f"{home}/.rustup"),
        ("Gradle Cache", f"{home}/.gradle"),
        ("Maven Cache", f"{home}/.m2"),
        ("Pip Cache", f"{home}/Library/Caches/pip"),
        ("Conda / Miniconda / Anaconda", f"{home}/.conda"),
        ("HuggingFace Cache", f"{home}/.cache/huggingface"),
        ("Ollama Models", f"{home}/.ollama"),
        ("Docker Container Data", f"{home}/Library/Containers/com.docker.docker"),
        ("Docker Data Dir", f"{home}/.docker"),
        ("User Logs", f"{home}/Library/Logs"),
        ("System Logs", "/Library/Logs"),
        ("Var Logs", "/var/log"),
        ("Photos Library", f"{home}/Pictures/Photos Library.photoslibrary"),
        ("iMovie Library", f"{home}/Movies/iMovie Library.imovielibrary"),
        ("iCloud Drive Docs", f"{home}/Library/Mobile Documents/com~apple~CloudDocs"),
        ("Android SDK", f"{home}/Library/Android"),
        ("Google Chrome Cache", f"{home}/Library/Caches/Google/Chrome"),
        ("Spotify Cache", f"{home}/Library/Caches/com.spotify.client"),
        ("Slack Cache", f"{home}/Library/Caches/com.tinyspeck.slackmacgap"),
        ("Adobe Cache/Support", f"{home}/Library/Application Support/Adobe"),
        ("Steam", f"{home}/Library/Application Support/Steam"),
    ]

    for name, path in targets:
        if path and os.path.exists(path):
            size = get_dir_size(path)
            if size > 10 * 1024 * 1024:  # > 10 MB
                print(f"{name:45}: {format_size(size):>10} ({path})")

    # 6. Recurse into top heavy directories (> 2 GB)
    print("\n--- Drilling down into heavy directories (> 2 GB in ~/Library) ---")
    heavy_dirs_cmd = f"du -k -d 2 {home}/Library 2>/dev/null | awk '$1 > 2097152 {{printf \"%.2f GB  %s\\n\", $1/1048576, $2}}' | sort -hr"
    print(run_cmd(heavy_dirs_cmd))

    # 7. Files > 1GB in Home
    print("\n--- Files > 1 GB in ~ (excluding .Trash) ---")
    find_cmd = f'find {home} -type f -size +1G -not -path "*/.Trash/*" -exec ls -lh {{}} + 2>/dev/null | awk \'{{print $5, $9}}\''
    print(run_cmd(find_cmd, timeout=90))

    # 8. Check Docker if running
    docker_df = run_cmd("docker system df 2>/dev/null")
    if docker_df and ("CONTAINER ID" in docker_df or "TYPE" in docker_df):
        print("\n--- Docker Disk Usage ---")
        print(docker_df)

    # 9. Top node_modules / .venv / build targets
    print("\n--- Large node_modules & build directories (> 300 MB) ---")
    find_dev_dirs = f"find {home} -maxdepth 5 -type d \\( -name 'node_modules' -o -name '.venv' -o -name 'venv' -o -name 'target' -o -name 'Pods' -o -name '.build' \\) -exec du -sk {{}} + 2>/dev/null | awk '$1 > 307200 {{printf \"%.2f MB  %s\\n\", $1/1024, $2}}' | sort -hr | head -20"
    print(run_cmd(find_dev_dirs, timeout=60))

if __name__ == "__main__":
    audit()
