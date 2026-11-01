{
  emacsPackages,
  lib,
  fetchFromGitHub,
  pins ? builtins.fromJSON (builtins.readFile ./pins.json),
}:
emacsPackages.trivialBuild (finalAttrs: {
  pname = "kitty-graphics";
  inherit (pins) version;
  src = fetchFromGitHub {
    owner = "cashmeredev";
    repo = "kitty-graphics.el";
    inherit (pins) rev hash;
  };

  meta = with lib; {
    description = "Display images, video, and scaled text directly in terminal Emacs (emacs -nw) using the Kitty graphics protocol, tmux or Sixel.";
    homepage = "https://github.com/cashmeredev/kitty-graphics.el";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
})
