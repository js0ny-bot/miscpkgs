#!/usr/bin/env python3
import json
import os
import re
import subprocess
import sys
import zipfile
from pathlib import Path

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from update_utils import read_url_json, resolve_tag, write_pins

PACKAGE_DIR = Path(__file__).resolve().parent
OWNER = "js0ny"
REPO = "containerise"
ADDON_ID = "containerise-managed@js0ny.net"


def main():
    headers = {}
    if token := os.environ.get("GITHUB_TOKEN"):
        headers["Authorization"] = f"Bearer {token}"
    release = read_url_json(
        f"https://api.github.com/repos/{OWNER}/{REPO}/releases/latest", headers
    )
    tag = release["tag_name"]
    if not isinstance(tag, str) or not re.fullmatch(r"v?\d+\.\d+\.\d+", tag):
        raise ValueError(f"Unexpected release tag: {tag!r}")
    version = tag.removeprefix("v")
    rev = resolve_tag(OWNER, REPO, tag)
    assets = [asset for asset in release["assets"] if asset["name"].endswith(".xpi")]
    if len(assets) != 1:
        raise ValueError(f"Expected exactly one XPI asset, found {len(assets)}")
    url = assets[0]["browser_download_url"]
    result = json.loads(subprocess.check_output(
        ["nix", "store", "prefetch-file", "--json", url], text=True
    ))
    with zipfile.ZipFile(result["storePath"]) as archive:
        manifest = json.loads(archive.read("manifest.json"))
        addon_id = manifest["browser_specific_settings"]["gecko"]["id"]
        if manifest["version"] != version or addon_id != ADDON_ID:
            raise ValueError("XPI version or extension ID does not match the release")
        if "META-INF/mozilla.rsa" not in archive.namelist():
            raise ValueError("XPI is missing its Mozilla signature")
    pins = {"version": version, "rev": rev, "url": url, "hash": result["hash"]}
    write_pins(PACKAGE_DIR / "pins.json", pins)
    print(f"Updated {REPO} to {version} ({rev}), XPI hash {pins['hash']}")


if __name__ == "__main__":
    main()
