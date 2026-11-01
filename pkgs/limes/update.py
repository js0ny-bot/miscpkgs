#!/usr/bin/env python3
import argparse
import json
import sys
import tempfile
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from update_utils import prefetch_cargo_deps, prefetch_source, run, write_pins

PACKAGE_DIR = Path(__file__).resolve().parent


def main():
    parser = argparse.ArgumentParser(
        description="Update limes source and dependency pins"
    )
    parser.add_argument(
        "--force", action="store_true", help="Refresh hashes even when unchanged"
    )
    args = parser.parse_args()
    with tempfile.TemporaryDirectory(prefix="limes-git-") as temporary:
        run(
            "git", "clone", "--quiet", "--no-checkout",
            "https://github.com/js0ny/limes.git", temporary,
        )
        rev = run("git", "-C", temporary, "rev-parse", "HEAD")
        date = run("git", "-C", temporary, "show", "-s", "--format=%cs", rev)
        tags = run("git", "-C", temporary, "tag", "--merged", rev)
        ver = (
            run("git", "-C", temporary, "describe", "--tags", "--abbrev=0", rev)
            .removeprefix("v")
            if tags
            else "0"
        )
    version = f"{ver}-unstable-{date}"
    pins_file = PACKAGE_DIR / "pins.json"
    current = json.loads(pins_file.read_text())
    if current["version"] == version and current["rev"] == rev and not args.force:
        print(f"limes is up to date at {version}")
        return
    source_hash, _source = prefetch_source("js0ny", "limes", rev)
    pins = {"version": version, "rev": rev, "hash": source_hash}
    pins["cargoHash"] = prefetch_cargo_deps(PACKAGE_DIR, pins)
    write_pins(pins_file, pins)
    print(f"Updated limes {version} at {rev}")


if __name__ == "__main__":
    main()
