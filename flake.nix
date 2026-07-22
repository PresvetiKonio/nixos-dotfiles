{
  description = "NixOS on the shitbox";


  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #lazyvim.url = "github:pfassina/lazyvim-nix";
    lazyvim.url = "github:pfassina/lazyvim-nix/v15.13.0";
  };

  outputs = { lazyvim, nixpkgs, home-manager, ... }: {
    nixosConfigurations.shitbox = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.vladko = import ./home.nix;
            backupFileExtension = "backup";
          extraSpecialArgs = { inherit lazyvim; };
          };
        }
      ];
    };
  };
}
