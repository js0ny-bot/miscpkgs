{
  rustPlatform,
  lib,
  fetchFromGitHub,
  versionCheckHook,
  pins ? builtins.fromJSON (builtins.readFile ./pins.json),
  ...
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dirstat-rs";
  inherit (pins) version;

  src = fetchFromGitHub {
    owner = "scullionw";
    repo = "dirstat-rs";
    inherit (pins) rev hash;
  };

  inherit (pins) cargoHash;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    description = "Disk usage analyser similar to WinDirStat";
    homepage = "https://github.com/scullionw/dirstat-rs";
    license = lib.licenses.mit;
    mainProgram = "ds";
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
