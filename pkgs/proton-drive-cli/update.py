#!/usr/bin/env python3
import argparse
import json
import re
import sys
from pathlib import Path
from urllib.request import Request, urlopen

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from update_utils import require_hash, run, write_pins

PACKAGE_DIR = Path(__file__).resolve().parent
INDEX = "https://proton.me/download/drive/cli/index.html"


def main():
    parser = argparse.ArgumentParser(description="Update Proton Drive CLI binaries")
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()
    with urlopen(Request(INDEX, headers={"User-Agent": "miscpkgs-updater"}), timeout=30) as response:
        page = response.read().decode("utf-8")
    versions = set(re.findall(r"https://proton\.me/download/drive/cli/([0-9.]+)/", page))
    if len(versions) != 1:
        raise ValueError("Expected one Proton Drive CLI version")
    version = versions.pop()
    pins_file = PACKAGE_DIR / "pins.json"
    current = json.loads(pins_file.read_text())
    if current["version"] == version and not args.force:
        print(f"proton-drive-cli is up to date at {version}")
        return
    pins = {"version": version}
    for platform in ("linux-x64", "linux-arm64", "darwin-arm64"):
        url = f"https://proton.me/download/drive/cli/{version}/{platform}/proton-drive"
        if url not in page:
            raise ValueError(f"Missing Proton Drive CLI download for {platform}")
        result = json.loads(run("nix", "store", "prefetch-file", "--json", url))
        pins[platform] = {"url": url, "hash": require_hash(result["hash"])}
    write_pins(pins_file, pins)
    print(f"Updated proton-drive-cli {version}")


if __name__ == "__main__":
    main()
