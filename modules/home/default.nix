{
  imports = [
    ./pywalfox.nix # custom module (programs.pywalfox)
    ./files.nix
    ./packages.nix
    ./shell.nix
    ./neovim.nix
    ./git.nix
    ./theme.nix
    ./defaults.nix
    ./sway.nix
    ./taildrop.nix
  ];

  home = {
    username = "vladko";
    homeDirectory = "/home/vladko";
    stateVersion = "26.05";
    sessionPath = [ "$HOME/.local/bin" ];
  };
}
