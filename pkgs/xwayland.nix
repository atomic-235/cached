{ xwayland }:

xwayland.override {
  # programs.xwayland defaults to the system font dir whenever
  # fonts.fontDir.enable is set, and Hydra only caches the plain build.
  defaultFontPath = "/run/current-system/sw/share/X11/fonts";
}
