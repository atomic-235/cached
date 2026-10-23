{ waybar }:

waybar.overrideAttrs (old: {
  patches = (old.patches or [ ]) ++ [
    ./waybar-lua-dispatch.patch
  ];
})
