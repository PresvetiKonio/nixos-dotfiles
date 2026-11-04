{ pkgs, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
    xwayland = true;
    checkConfig = false;
    config = null; # everything lives in config/sway/config
    extraConfig = builtins.readFile ../../config/sway/config;
  };

  # Whole directory is linked too (sway is stubborn about extra files).
  home.file.".config/sway".source = ../../config/sway;
}
