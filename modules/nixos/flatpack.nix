{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  services.flatpak = {
    #    enable = true;

    # Declaring remotes replaces the default flathub remote,
    # so mkOptionDefault keeps it alongside ours.
    remotes = lib.mkOptionDefault [
      {
        name = "artcraft-oci";
        location = "https://getartcraft.com/artcraft-oci.flatpakrepo";
      }
    ];

    packages = [
      {
        appId = "ai.storyteller.artcraft-launcher";
        origin = "artcraft-oci";
      }
    ];

    update.onActivation = true; # optional: update on every rebuild
  };

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
