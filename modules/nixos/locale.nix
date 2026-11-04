{
  time.timeZone = "Europe/Sofia";

  services.xserver.xkb.layout = "us"; # caps -> esc is handled by keyd below

  # Remap at the input-device level so every app sees a real Escape.
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings.main.capslock = "esc";
    };
  };
}
