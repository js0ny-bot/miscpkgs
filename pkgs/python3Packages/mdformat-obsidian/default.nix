{
  python3Packages,
  lib,
  fetchFromGitHub,
  pins ? builtins.fromJSON (builtins.readFile ./pins.json),
}:
python3Packages.buildPythonPackage (finalAttrs: {
  pname = "mdformat-obsidian";
  inherit (pins) version;
  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = "mdformat-obsidian";
    inherit (pins) rev hash;
  };

  pyproject = true;
  build-system = with python3Packages; [
    uv-build
  ];
  dependencies = with python3Packages; [
    mdformat
    mdformat-gfm
    mdit-py-plugins
  ];

  doCheck = false;
  pythonImportsCheck = [ "mdformat_obsidian" ];

  meta = {
    description = "Format Markdown for Obsidian including callouts";
    homepage = "https://github.com/KyleKing/mdformat-obsidian";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
