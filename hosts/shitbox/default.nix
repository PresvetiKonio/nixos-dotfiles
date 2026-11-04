# Machine-specific bits only. Everything reusable lives in ../../modules/nixos.
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  networking.hostName = "shitbox";

  # Never change after install; it is not a "version of NixOS to run".
  system.stateVersion = "26.05";
}
