{ pkgs, ... }:
{
  networking.networkmanager.enable = true;
  services.tailscale.enable = true;

  # iphone usb tethering
  services.usbmuxd.enable = true;
  environment.systemPackages = [ pkgs.libimobiledevice ];
}
