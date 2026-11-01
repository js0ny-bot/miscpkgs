#!/usr/bin/env python3
import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from update_utils import read_url_json, require_hash, run, write_pins

PACKAGE_DIR = Path(__file__).resolve().parent
API = "https://dawn.wine/api/v1/repos/dawn-winery/dwproton/releases/latest"


def main():
    parser = argparse.ArgumentParser(description="Update dwproton release pins")
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()
    release = read_url_json(API)
    tag = release["tag_name"]
    if not isinstance(tag, str) or not tag.startswith("dwproton-"):
        raise ValueError("Unexpected dwproton release tag")
    version = tag.removeprefix("dwproton-")
    name = f"{tag}-x86_64.tar.xz"
    assets = [asset["browser_download_url"] for asset in release["assets"] if asset["name"] == name]
    if len(assets) != 1:
        raise ValueError(f"Expected one release asset named {name}")
    url = assets[0]
    pins_file = PACKAGE_DIR / "pins.json"
    current = json.loads(pins_file.read_text())
    if current["version"] == version and current["url"] == url and not args.force:
        print(f"dwproton is up to date at {version}")
        return
    result = json.loads(run("nix", "store", "prefetch-file", "--unpack", "--name", "source", "--json", url))
    pins = {"version": version, "url": url, "hash": require_hash(result["hash"])}
    write_pins(pins_file, pins)
    print(f"Updated dwproton {version}")


if __name__ == "__main__":
    main()
