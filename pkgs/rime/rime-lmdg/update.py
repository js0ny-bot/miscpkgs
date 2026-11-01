#!/usr/bin/env python3
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2]))
from update_utils import require_hash, run, write_pins

PACKAGE_DIR = Path(__file__).resolve().parent


def main():
    pins = {}
    for variant in ("hans", "hant"):
        url = f"https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-{variant}.gram"
        result = json.loads(run("nix", "store", "prefetch-file", "--refresh", "--json", url))
        pins[variant] = {"url": url, "hash": require_hash(result["hash"])}
    write_pins(PACKAGE_DIR / "pins.json", pins)
    print("Updated rime-lmdg LTS")


if __name__ == "__main__":
    main()
