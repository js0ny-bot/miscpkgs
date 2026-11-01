#!/usr/bin/env python3
import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2]))
from update_utils import read_url_json, require_hash, run, write_pins

PACKAGE_DIR = Path(__file__).resolve().parent


def main():
    parser = argparse.ArgumentParser(description="Update Rime Wanxiang release assets")
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()
    release = read_url_json("https://api.github.com/repos/amzxyz/rime_wanxiang/releases/latest")
    tag = release["tag_name"]
    version = tag.removeprefix("v")
    pins_file = PACKAGE_DIR / "pins.json"
    current = json.loads(pins_file.read_text())
    if current["version"] == version and not args.force:
        print(f"rime-wanxiang is up to date at {version}")
        return
    pins = {"version": version}
    for variant in ("flypy", "zrm"):
        name = f"rime-wanxiang-{variant}-fuzhu.zip"
        urls = [asset["browser_download_url"] for asset in release["assets"] if asset["name"] == name]
        if len(urls) != 1:
            raise ValueError(f"Expected one release asset named {name}")
        result = json.loads(run("nix", "store", "prefetch-file", "--json", urls[0]))
        pins[variant] = {"url": urls[0], "hash": require_hash(result["hash"])}
    write_pins(pins_file, pins)
    print(f"Updated rime-wanxiang {version}")


if __name__ == "__main__":
    main()
