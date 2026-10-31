{ hyprland }:

hyprland.override {
  # programs.hyprland defaults to withUWSM = false while pkgs.hyprland defaults
  # to withUWSM = withSystemd = true, and Hydra only caches the latter.
  withUWSM = false;
}
