{
  rustPlatform,
  lib,
  fetchFromGitHub,
  pins ? builtins.fromJSON (builtins.readFile ./pins.json),
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oroot";
  inherit (pins) version;

  src = fetchFromGitHub {
    owner = "js0ny";
    repo = "oroot";
    inherit (pins) rev hash;
  };

  inherit (pins) cargoHash;

  meta = {
    description = "Command-line tool to manipulate impermanence old roots in btrfs";
    homepage = "https://github.com/js0ny/oroot";
    license = lib.licenses.mit;
    mainProgram = "oroot";
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
