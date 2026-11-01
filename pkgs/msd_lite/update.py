#!/usr/bin/env python3
import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from update_utils import latest_snapshot, require_hash, run, write_pins

PACKAGE_DIR = Path(__file__).resolve().parent


def main():
    parser = argparse.ArgumentParser(description="Update msd_lite source pin")
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()
    version, rev = latest_snapshot("rozhuk-im", "msd_lite")
    pins_file = PACKAGE_DIR / "pins.json"
    current = json.loads(pins_file.read_text())
    if current["rev"] == rev and current["version"] == version and not args.force:
        print(f"msd_lite is up to date at {version}")
        return
    result = json.loads(run(
        "nix", "shell", "--inputs-from", str(PACKAGE_DIR.parent.parent),
        "nixpkgs#nix-prefetch-git", "--command", "nix-prefetch-git",
        "--quiet", "--fetch-submodules", "--name", "source",
        "https://github.com/rozhuk-im/msd_lite.git", rev,
    ))
    hash_value = run("nix", "hash", "convert", "--hash-algo", "sha256", "--to", "sri", result["sha256"])
    write_pins(pins_file, {"version": version, "rev": rev, "hash": require_hash(hash_value)})
    print(f"Updated msd_lite {version} at {rev}")


if __name__ == "__main__":
    main()
