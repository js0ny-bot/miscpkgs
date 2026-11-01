{
  stdenv,
  libsecret,
  glib,
  lib,
  fetchurl,
}:
let
  pins = builtins.fromJSON (builtins.readFile ./pins.json);
  archMap = {
    "x86_64-linux" = pins.linux-x64;
    "aarch64-linux" = pins.linux-arm64;
    "aarch64-darwin" = pins.darwin-arm64;
  };

  system = stdenv.hostPlatform.system;

  p = archMap.${system} or (throw "Proton Drive CLI: Unsupported system ${system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "proton-drive-cli";
  inherit (pins) version;
  src = fetchurl p;
  dontUnpack = true;
  # when stripping, bun executable payload is after the ELF header
  dontStrip = true;

  runtimeDeps = lib.optionals (stdenv.hostPlatform.isLinux) [
    libsecret
    glib
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/proton-drive-cli
    runHook postInstall
  '';
  meta = with lib; {
    description = "Command-line interface for Proton Drive";
    homepage = "https://github.com/ProtonDriveApps/sdk/tree/main/cli";
    license = licenses.mit;
    mainProgram = "proton-drive-cli";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
