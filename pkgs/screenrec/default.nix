{
  writeShellApplication,
  coreutils,
  jq,
  libnotify,
  slurp,
  wl-clipboard,
  wl-screenrec,
}:

# The video counterpart to hyprshot: same select-and-shoot feel, but a capture
# outlives the keypress, so the script is a toggle over a single wl-screenrec
# process. wl-screenrec encodes on the GPU through VAAPI, which on a hybrid
# laptop is the iGPU driving the compositor - the dGPU stays asleep.
writeShellApplication {
  name = "screenrec";
  runtimeInputs = [
    coreutils
    jq
    libnotify
    slurp
    wl-clipboard
    wl-screenrec
  ];
  text = builtins.readFile ./screenrec.sh;
  meta = {
    description = "Toggle a hardware-encoded screen recording of a region or the focused monitor";
    mainProgram = "screenrec";
  };
}
