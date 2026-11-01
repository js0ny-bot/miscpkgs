{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pins ? builtins.fromJSON (builtins.readFile ./pins.json),
  ...
}:
buildGoModule (finalAttrs: {
  pname = "sni-fetch";
  inherit (pins) version;

  src = fetchFromGitHub {
    owner = "HelloLingC";
    repo = "SNI-Fetch";
    inherit (pins) rev hash;
  };
  inherit (pins) vendorHash;

  env.CGO_ENABLED = 0;
  subPackages = [ "." ];

  meta = {
    license = lib.licenses.gpl3Plus;
    mainProgram = "sni-fetch";
    platforms = lib.platforms.linux;
  };
})
