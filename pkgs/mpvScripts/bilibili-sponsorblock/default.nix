{
  fetchFromGitHub,
  pins ? builtins.fromJSON (builtins.readFile ./pins.json),
  stdenv,
  rustPlatform,
  mpv,
  pkg-config,
  lib,
  ...
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bilibili-sponsorblock";
  inherit (pins) version cargoHash;
  src = fetchFromGitHub {
    owner = "test482";
    repo = "mpv-bilibili-sponsorblock";
    inherit (pins) rev hash;
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [ mpv ];

  doCheck = false;

  passthru.scriptName = "${finalAttrs.pname}/bilibili_sponsorblock.so";

  installPhase = ''
    runHook preInstall

    install -Dm755 target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/libmpv_bilibili_sponsorblock.so \
      $out/share/mpv/scripts/${finalAttrs.pname}/bilibili_sponsorblock.so
    install -Dm644 bilibili-sponsorblock.toml \
      $out/share/mpv/scripts/${finalAttrs.pname}/bilibili_sponsorblock.toml

    runHook postInstall
  '';

  meta = {
    description = "MPV plugin that allows skipping sponsor segments while watching Bilibili videos";
    homepage = "https://github.com/test482/mpv-bilibili-sponsorblock";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceProvenance.fromSource ];
  };
})
