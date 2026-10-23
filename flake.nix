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
          # The overlay is applied so packages that link the patched portal
          # (the backends below) are built against it, exactly as consumers
          # evaluate them.
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        {
          inherit (pkgs)
            waybar
            wl-kbptr
            xdg-desktop-portal
            xdg-desktop-portal-gtk
            xdg-desktop-portal-termfilechooser
            amd-debug-tools
            ;
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
          amd-debug-tools = prev.callPackage ./pkgs/amd-debug-tools.nix {
            inherit (prev) amd-debug-tools;
          };
        };
    };
}
