import json
import os
import shutil
import subprocess
import sys


CHROME_PATHS = [
    os.path.join(os.environ.get("PROGRAMFILES", ""), "Google", "Chrome", "Application", "chrome.exe"),
    os.path.join(os.environ.get("PROGRAMFILES(X86)", ""), "Google", "Chrome", "Application", "chrome.exe"),
    os.path.join(os.environ.get("LOCALAPPDATA", ""), "Google", "Chrome", "Application", "chrome.exe"),
]


def find_chrome():
    for p in CHROME_PATHS:
        if os.path.exists(p):
            return p
    return "chrome"


def get_profile_dir():
    base = os.path.join(os.environ.get("LOCALAPPDATA", os.path.expanduser("~")), "ONTProxy", "chrome_profile")
    os.makedirs(base, exist_ok=True)
    return base


def write_proxy_preferences(profile_dir, proxy_host="127.0.0.1", proxy_port=8080):
    prefs_path = os.path.join(profile_dir, "Default")
    os.makedirs(prefs_path, exist_ok=True)
    prefs_file = os.path.join(prefs_path, "Preferences")

    prefs = {}
    if os.path.exists(prefs_file):
        with open(prefs_file, "r", encoding="utf-8") as f:
            try:
                prefs = json.load(f)
            except json.JSONDecodeError:
                prefs = {}

    prefs.setdefault("net", {})
    prefs["net"]["proxy"] = {
        "mode": "fixed_servers",
        "server": f"{proxy_host}:{proxy_port}",
    }

    with open(prefs_file, "w", encoding="utf-8") as f:
        json.dump(prefs, f, indent=2)


def launch_chrome(proxy_host="127.0.0.1", proxy_port=8080, target_url="http://192.168.100.1"):
    chrome = find_chrome()
    profile_dir = get_profile_dir()
    write_proxy_preferences(profile_dir, proxy_host, proxy_port)

    args = [
        chrome,
        f"--proxy-server={proxy_host}:{proxy_port}",
        f"--user-data-dir={profile_dir}",
        "--ignore-certificate-errors",
        "--disable-web-security",
        "--no-first-run",
        "--no-default-browser-check",
        target_url,
    ]

    print(f"[+] Launching Chrome with proxy {proxy_host}:{proxy_port}")
    print(f"    Profile: {profile_dir}")
    print(f"    Target:  {target_url}")

    try:
        subprocess.Popen(args)
    except FileNotFoundError:
        print("[-] Chrome not found. Please install Google Chrome or set its path.")
        print(f"    Searched: {CHROME_PATHS}")


def cleanup_profile():
    profile_dir = get_profile_dir()
    if os.path.exists(profile_dir):
        shutil.rmtree(profile_dir, ignore_errors=True)
        print(f"[+] Cleaned up Chrome profile: {profile_dir}")


if __name__ == "__main__":
    action = sys.argv[1] if len(sys.argv) > 1 else "launch"
    if action == "cleanup":
        cleanup_profile()
    else:
        port = int(sys.argv[2]) if len(sys.argv) > 2 else 8080
        launch_chrome(proxy_port=port)
