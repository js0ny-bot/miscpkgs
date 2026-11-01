{
  fetchFromGitHub,
  pins ? builtins.fromJSON (builtins.readFile ./pins.json),
  vimUtils,
  lib,
}:
vimUtils.buildVimPlugin {
  pname = "typst-infect-nvim";
  inherit (pins) version;
  src = fetchFromGitHub {
    owner = "js0ny";
    repo = "typst-infect.nvim";
    inherit (pins) rev hash;
  };
  meta = {
    license = lib.licenses.mit;
    description = "Display Typst math in Markdown math blocks";
    homepage = "https://github.com/js0ny/typst-infect.nvim";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
