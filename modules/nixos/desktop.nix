# Session, window manager, and desktop plumbing.
{ pkgs, ... }:

{
  services.displayManager.ly.enable = true;
  programs.sway.enable = true;
  security.polkit.enable = true;

  programs.dconf.enable = true;
  programs.xfconf.enable = true; # thunar settings

  # File management / removable media / thumbnails
  services = {
    udisks2.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    printing.enable = true;
  };

  fonts.packages = with pkgs; [
    font-awesome
    font-awesome_4
  ];

  environment.systemPackages = with pkgs; [
    gnome-themes-extra
    papirus-icon-theme
  ];
}
