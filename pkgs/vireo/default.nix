{
  lib,
  rustPlatform,
  fetchFromGitHub,

  # build tools
  glib,
  pkg-config,
  wrapGAppsHook4,

  # dependencies
  dbus,
  gtk4,
  libadwaita,
  openssl,
  poppler-utils,
  webkitgtk_6_0,

  pins ? builtins.fromJSON (builtins.readFile ./pins.json),
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vireo";
  inherit (pins) version;

  src = fetchFromGitHub {
    owner = "hyprlab";
    repo = "vireo";
    inherit (pins) rev hash;
  };

  inherit (pins) cargoHash;

  nativeBuildInputs = [
    glib
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    openssl
    dbus
    libadwaita
    webkitgtk_6_0
    poppler-utils
  ];

  postInstall = ''
    mkdir -p $out/share/icons
    cp -r data/icons $out/share/icons
    install -Dm644 data/co.hyprlab.Vireo.desktop $out/share/applications/co.hyprlab.Vireo.desktop
  '';

  meta = {
    description = "A clean, fast, GNOME-native email client with a calm three-pane layout, unified inbox, and support for OAuth accounts. Fast to open, effortless to read, and private by default.";
    homepage = "https://github.com/hyprlab/vireo";
    license = lib.licenses.agpl3Only;
    mainProgram = "vireo";
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
