# cached

Patched nixpkgs packages, built against the nixpkgs pin **this repo owns**, and
pushed to the `atomic-235` Cachix.

Consumers set `nixpkgs.follows = "cached/nixpkgs"`, so the derivations they ask
for are byte-identical to the ones CI built — which is the only way a cache
actually hits. The daily job advances the pin, builds, pushes, then commits the
new `flake.lock`.

## Packages

| Attribute | Patch |
|---|---|
| `waybar` | `waybar-lua-dispatch.patch` |
| `wl-kbptr` | `wl-kbptr-ignore-layout-group.patch` |
| `xdg-desktop-portal` | `xdg-desktop-portal-fix-dead-pid-detection.patch` |
| `xdg-desktop-portal-gtk` | built against the patched core portal |
| `xdg-desktop-portal-termfilechooser` | built against the patched core portal |
| `amd-debug-tools` | splits `makeWrapperArgs` so the fixup phase works |

The portal backends are included because they have the core portal in
`buildInputs`; patching the core changes their derivations too, and without them
in the cache every consumer rebuilds them locally.

## Usage

```nix
{
  inputs.cached.url = "github:atomic-235/cached";
  nixpkgs.follows = "cached/nixpkgs";   # important: same pin, same derivations
}
```

```nix
nixpkgs.overlays = [ inputs.cached.overlays.default ];
```

and enable the cache:

```nix
nix.settings = {
  substituters = [ "https://atomic-235.cachix.org" ];
  trusted-public-keys = [ "atomic-235.cachix.org-1:Gx6jhRRmR4tCQBVde7371zs1muq2n1YHQduaPGe/yFE=" ];
};
```

## Why the overlay passes `prev`

Each patched package is built with `prev.callPackage … { inherit (prev) pkg; }`.
Plain `callPackage` resolves arguments from the *final* set, which would recurse
into the overlay's own definition.

## Daily job

`.github/workflows/build.yml` runs at 05:00 UTC: advance the nixpkgs pin (unless
`bump=false`), build every package, `cachix push` each path explicitly, and
commit `flake.lock` only when it changed.
