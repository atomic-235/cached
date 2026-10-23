{ wl-kbptr }:

wl-kbptr.overrideAttrs (old: {
  patches = (old.patches or [ ]) ++ [
    ./wl-kbptr-ignore-layout-group.patch
  ];
})
