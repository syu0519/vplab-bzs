"""
run.py - 自動重啟啟動器
存檔 server.py 或 static/index.html 後，伺服器自動重啟

執行：python run.py
"""

import sys
import os
import time
import subprocess
import threading
from pathlib import Path

BASE     = Path(__file__).parent
WATCH    = [BASE / "server.py", BASE / "static" / "index.html"]
PORT     = 8899

def get_mtimes():
    return {str(f): f.stat().st_mtime for f in WATCH if f.exists()}

def start_server():
    return subprocess.Popen(
        [sys.executable, str(BASE / "server.py")],
        cwd=str(BASE),
    )

def main():
    print("+------------------------------------------+")
    print("|  Auto-reload server                      |")
    print(f"|  http://localhost:{PORT}                  |")
    print("|  Save any file to restart automatically  |")
    print("|  Press Ctrl+C to stop                    |")
    print("+------------------------------------------+")
    print()

    proc = start_server()
    mtimes = get_mtimes()

    try:
        while True:
            time.sleep(1)

            # 檢查有沒有檔案變動
            new_mtimes = get_mtimes()
            changed = [f for f in new_mtimes if new_mtimes[f] != mtimes.get(f)]

            if changed:
                for f in changed:
                    print(f"[changed] {Path(f).name}")

                print("[restarting...]")
                proc.terminate()
                proc.wait()
                time.sleep(0.5)

                proc = start_server()
                mtimes = new_mtimes
                print("[OK] server restarted")
                print()

    except KeyboardInterrupt:
        print("\n[stopped]")
        proc.terminate()
        proc.wait()

if __name__ == "__main__":
    main()