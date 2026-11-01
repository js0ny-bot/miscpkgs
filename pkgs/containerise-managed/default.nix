{
  lib,
  stdenvNoCC,
  fetchurl,
  python3,
  writeShellScript,
  pins ? builtins.fromJSON (builtins.readFile ./pins.json),
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "containerise-managed";
  inherit (pins) version;

  src = fetchurl {
    inherit (pins) url hash;
  };

  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    install -Dm644 "$src" "$out/share/mozilla/extensions/containerise-managed@js0ny.net.xpi"
    runHook postInstall
  '';

  passthru = {
    addonId = "containerise-managed@js0ny.net";
    updateScript = writeShellScript "update-containerise-managed" ''
      exec ${lib.getExe python3} "$PWD/pkgs/containerise-managed/update.py" "$@"
    '';
  };

  meta = {
    description = "Automatically open websites in Firefox containers using managed rules";
    homepage = "https://github.com/js0ny/containerise";
    license = lib.licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
})
