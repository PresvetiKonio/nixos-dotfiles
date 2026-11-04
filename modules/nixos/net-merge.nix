{ inputs, ... }:

{
  imports = [ inputs.net-merge.nixosModules.default ];

  programs.net-merge = {
    enable = true;
    autostart = true; # start the tray in every graphical session
  };
}
