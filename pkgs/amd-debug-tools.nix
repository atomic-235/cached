{
  amd-debug-tools,
  lib,
  acpica-tools,
  ethtool,
  libdisplay-info,
}:

# amd-debug-tools puts the whole "--prefix PATH : ..." in one makeWrapperArgs
# entry; the current make-shell-wrapper-hook does not word-split it and the
# fixup phase fails. Split it into separate arguments.
amd-debug-tools.overrideAttrs (_: {
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      acpica-tools
      ethtool
      libdisplay-info
    ])
  ];
})
