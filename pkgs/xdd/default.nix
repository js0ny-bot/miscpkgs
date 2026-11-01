{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pins ? builtins.fromJSON (builtins.readFile ./pins.json),
  stdenv,
  makeDesktopItem,
  copyDesktopItems,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xdd";
  inherit (pins) version;

  src = fetchFromGitHub {
    owner = "js0ny";
    repo = "xdd";
    inherit (pins) rev hash;
  };

  inherit (pins) cargoHash;

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "xdd";
      desktopName = "xdd";
      exec = "xdd open %u";
      noDisplay = true;
      terminal = false;
      mimeTypes = [ "x-scheme-handler/xdd" ];
    })
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
  ];

  meta = {
    description = "Cross-platform directory definition URL handler";
    homepage = "https://github.com/js0ny/xdd";
    license = lib.licenses.gpl3Plus;
    mainProgram = "xdd";
    platforms = with lib.platforms; linux ++ darwin;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
