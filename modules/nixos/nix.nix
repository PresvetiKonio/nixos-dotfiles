{
  nix.settings = {
    cores = 0;
    max-jobs = "auto";
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config.allowUnfree = true;
}
