{
  description = "Patched nixpkgs packages, built against the pin this repo owns";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          waybar = pkgs.callPackage ./pkgs/waybar.nix { };
          wl-kbptr = pkgs.callPackage ./pkgs/wl-kbptr.nix { };
          xdg-desktop-portal = pkgs.callPackage ./pkgs/xdg-desktop-portal.nix { };
          default = self.packages.${system}.waybar;
        }
      );

      overlays.default =
        final: prev:
        {
          # Pass the previous package explicitly: `callPackage` resolves its
          # arguments from the final set, which would recurse here.
          waybar = prev.callPackage ./pkgs/waybar.nix { inherit (prev) waybar; };
          wl-kbptr = prev.callPackage ./pkgs/wl-kbptr.nix { inherit (prev) wl-kbptr; };
          xdg-desktop-portal = prev.callPackage ./pkgs/xdg-desktop-portal.nix {
            inherit (prev) xdg-desktop-portal;
          };
        };
    };
}
