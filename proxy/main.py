import os
import asyncio
from pathlib import Path
import time

from proxy import APProxy
import subprocess

shutdown_event = asyncio.Event()
proxy_base = Path(__file__).parent.resolve() / "events"
hs_to_ap_proxy_file = proxy_base / "hs_to_ap_proxy.txt"
ap_to_hs_proxy_file = proxy_base / "ap_to_hs_proxy.txt"

game_executable_path = r"C:\Program Files (x86)\Steam\steamapps\common\FTL Faster Than Light\FTLGame.exe"

def setup_proxy_files():
    proxy_base.mkdir(parents=True, exist_ok=True)

    hs_to_ap_proxy_file.touch(exist_ok=True)
    ap_to_hs_proxy_file.touch(exist_ok=True)

    os.environ["HS_TO_AP_PROXY_FILE"] = hs_to_ap_proxy_file.as_posix()
    os.environ["AP_TO_HS_PROXY_FILE"] = ap_to_hs_proxy_file.as_posix()

async def main():
    # AP Proxy main loop. Run coroutines and wait indefinitely
    proxy = APProxy(os.environ["HS_TO_AP_PROXY_FILE"], os.environ["AP_TO_HS_PROXY_FILE"])
    
    print(f"Connecting to HS and AP via proxy files: {os.environ['HS_TO_AP_PROXY_FILE']} and {os.environ['AP_TO_HS_PROXY_FILE']}")
    proxy.start()

    wd = os.getcwd()
    try:
        Path("run").mkdir(exist_ok=True)
        os.chdir("run")
        process = subprocess.Popen([game_executable_path])

        while process.poll() is None:
            try:
                await asyncio.sleep(0.5)
            except asyncio.CancelledError as e:
                process.kill()
                raise e

    except FileNotFoundError:
        print(f"Executable not found at {game_executable_path}.")

    finally:
        os.chdir(wd)
    
def cleanup():
    hs_to_ap_proxy_file.unlink(missing_ok=True)
    hs_to_ap_proxy_file.unlink(missing_ok=True)
    
    os.environ.pop("HS_TO_AP_PROXY_FILE", None)
    os.environ.pop("AP_TO_HS_PROXY_FILE", None)

if __name__ == "__main__":
    setup_proxy_files()
    executable_path = input("Enter the path to FTLGame.exe (or press Enter to use default): ").strip()
    if executable_path:
        game_executable_path = executable_path
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("Shutting down AP proxy.")
    finally:
        cleanup()

    