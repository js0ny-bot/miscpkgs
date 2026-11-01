{
  lib,
  libxkbcommon,
  wayland,
  pkg-config,
  rustPlatform,
  fetchFromGitHub,
  pins ? builtins.fromJSON (builtins.readFile ./pins.json),
  stdenv,
  ...
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wdotool";
  inherit (pins) version;

  src = fetchFromGitHub {
    owner = "cushycush";
    repo = "wdotool";
    inherit (pins) rev hash;
  };

  inherit (pins) cargoHash;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  buildInputs = [
    libxkbcommon
    wayland
  ];

  doCheck = true;

  meta = {
    description = "wdotool — xdotool-compatible input automation for Wayland";
    homepage = "https://github.com/cushycush/wdotool";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "wdotool";
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
