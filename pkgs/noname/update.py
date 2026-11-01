#!/usr/bin/env python3
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from update_utils import prefetch_pnpm_deps, update_release

PACKAGE_DIR = Path(__file__).resolve().parent


def prepare(pins, _source):
    return {"pnpmHash": prefetch_pnpm_deps(PACKAGE_DIR, pins)}


def main():
    update_release(PACKAGE_DIR, "libnoname", "noname", prepare)


if __name__ == "__main__":
    main()
