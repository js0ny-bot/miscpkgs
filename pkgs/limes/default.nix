{
  rustPlatform,
  lib,
  fetchFromGitHub,
  pins ? builtins.fromJSON (builtins.readFile ./pins.json),
  ...
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "limes";
  inherit (pins) version;

  src = fetchFromGitHub {
    owner = "js0ny";
    repo = "limes";
    inherit (pins) rev hash;
  };

  inherit (pins) cargoHash;

  meta = {
    description = "Linux input method switcher";
    homepage = "https://github.com/js0ny/limes";
    license = lib.licenses.mit;
    mainProgram = "limes";
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
