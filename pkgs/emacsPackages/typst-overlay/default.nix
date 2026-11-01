{
  emacsPackages,
  lib,
  fetchFromGitHub,
  pins ? builtins.fromJSON (builtins.readFile ./pins.json),
  ...
}:
emacsPackages.trivialBuild (finalAttrs: {
  pname = "typst-overlay";
  inherit (pins) version;
  src = fetchFromGitHub {
    owner = "hesampakdaman";
    repo = "typst-overlay";
    inherit (pins) rev hash;
  };

  meta = with lib; {
    description = "Render Typst math equations as inline overlays in Emacs.";
    homepage = "https://github.com/hesampakdaman/typst-overlay";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
})
