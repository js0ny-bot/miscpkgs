{
  lib,
  rustPlatform,
  stdenv,
  fetchFromGitHub,

  # build tools
  pkg-config,

  # dependencies
  alsa-lib,
  dbus,
  openssl,

  pins ? builtins.fromJSON (builtins.readFile ./pins.json),
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ratune";
  inherit (pins) version;

  src = fetchFromGitHub {
    owner = "acmagn";
    repo = "ratune";
    inherit (pins) rev hash;
  };

  inherit (pins) cargoHash;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    dbus
    openssl
  ];

  meta = {
    description = "Terminal music player for Subsonic-compatible servers";
    homepage = "https://github.com/acmagn/ratune";
    license = lib.licenses.mit;
    mainProgram = "ratune";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
