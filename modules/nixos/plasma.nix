{ pkgs, ... }:

{
  services.desktopManager.plasma6.enable = true;

  # Trim default KDE apps you don't want
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    khelpcenter
    okular
  ];

  # Only if you want KDE Connect with your phone
  programs.kdeconnect.enable = true;
}
