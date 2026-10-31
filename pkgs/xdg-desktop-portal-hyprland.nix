{ hyprland, xdg-desktop-portal-hyprland }:

xdg-desktop-portal-hyprland.override {
  # programs.hyprland.portalPackage passes the configured Hyprland package into
  # the wrapper, so the portal built by Hydra (stock hyprland) never matches.
  inherit hyprland;
}
