# Power management, lid/power-button behaviour, hibernation, backlight.
{ pkgs, ... }:

{
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "auto";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "lock";
    HandleLidSwitchDocked = "ignore";
    HandlePowerKey = "hibernate";
    HandlePowerKeyLongPress = "poweroff";
  };

  # Hibernation
  swapDevices = [ { device = "/dev/nvme0n1p2"; } ];
  boot.resumeDevice = "/dev/nvme0n1p2";
  systemd.sleep.settings.Sleep.hibernateDelaySec = "1h";

  # Let the `video` group change brightness without root.
  services.udev.extraRules = ''
    SUBSYSTEM=="backlight", ACTION=="add", RUN+="${pkgs.coreutils}/bin/chgrp video $sys$devpath/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w $sys$devpath/brightness"
  '';
  environment.systemPackages = [ pkgs.brightnessctl ];

  services.libinput.enable = true;
}
