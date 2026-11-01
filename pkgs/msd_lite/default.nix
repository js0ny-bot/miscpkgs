{
  stdenv,
  lib,
  cmake,
  fetchFromGitHub,
  ...
}:
let
  pins = builtins.fromJSON (builtins.readFile ./pins.json);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "msd_lite";
  inherit (pins) version;
  src = fetchFromGitHub {
    owner = "rozhuk-im";
    repo = "msd_lite";
    inherit (pins) rev hash;
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  cmakeBuildType = "Release";

  postInstall = ''
    install -Dm644 $src/conf/msd_lite.conf $out/etc/msd_lite/msd_lite.conf.sample
  '';

  meta = with lib; {
    description = "Multi stream daemon lite for IPTV streaming over HTTP";
    homepage = "https://github.com/rozhuk-im/msd_lite";
    license = licenses.bsd2;
    mainProgram = "msd_lite";
    platforms = platforms.linux;
  };
})
