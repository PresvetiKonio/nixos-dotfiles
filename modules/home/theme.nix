{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-theme = "Adwaita";
    icon-theme = "Papirus-Dark";
  };

  # Browser theming from pywal colours
  programs.pywalfox = {
    enable = true;
    browsers = [
      "firefox"
      "librewolf"
    ];
  };
  home.packages = [
    pkgs.pywal
    pkgs.pywalfox-native
  ];
}
