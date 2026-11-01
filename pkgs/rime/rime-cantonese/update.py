#!/usr/bin/env python3
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2]))
from update_utils import update_release

PACKAGE_DIR = Path(__file__).resolve().parent


def prepare(_pins, _source):
    return {}


def main():
    update_release(PACKAGE_DIR, "rime", "rime-cantonese", prepare, snapshot=True)


if __name__ == "__main__":
    main()
