{
  fetchFromGitHub,
  pins ? builtins.fromJSON (builtins.readFile ./pins.json),
  buildGoModule,
  lib,
}:
let
  repo = "github.com/haierkeys/fast-note-sync-service";
in
buildGoModule (finalAttrs: {
  pname = "fast-note-sync-service";
  inherit (pins) version;

  src = fetchFromGitHub {
    owner = "haierkeys";
    repo = "fast-note-sync-service";
    inherit (pins) rev hash;
  };
  env.CGO_ENABLED = 0;
  subPackages = [ "." ];

  preCheck = ''
    export CGO_ENABLED=1
    unset subPackages
  '';
  inherit (pins) vendorHash;
  ldflags = [
    "-s"
    "-w"
    "-X ${repo}/internal/app.Version=${finalAttrs.version}"
    "-X ${repo}/internal/app.GitTag=v${finalAttrs.version}"
    "-X ${repo}/internal/app.BuildTime=1970-01-01T00:00:00Z"
  ];
  meta = {
    description = "High-performance, low-latency note synchronization, online management, and remote REST API service platform.";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "fast-note-sync-service";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceProvenance.fromSource ];
  };
})
