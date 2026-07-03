{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    nvim = "nvim";
    rofi = "rofi";
    waybar = "waybar";
    kitty = "kitty";
    zsh = "zsh";
    wallpapers = "wallpapers";
  };
in
{
  home.username = "vladko";
  home.homeDirectory = "/home/vladko";
  home.sessionPath = [ "$HOME/.local/bin" ];
  programs.git = {
    enable = true;
    userName = "PresvetiKonio";
    userEmail = "vladimirfilipov1234@gmail.com";
  };
  home.stateVersion = "26.05";

  # shells
  programs.bash = {
    enable = true;
    shellAliases = {
      vim = "nvim";
    };
  };

  programs.zsh.enable = false;

  # config files loop
  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
    })
    configs;


  home.file.".config/sway".source = config/sway; # sway is stubborn
  home.file.".zshenv".source = config/.zshenv;
  home.file.".local/bin".source = local/bin;

  fonts.fontconfig.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    xwayland = true;
    package = pkgs.swayfx;
    checkConfig = false;
    config = null;
  };

  home.packages = with pkgs; [
    neovim
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    gcc

    kitty

    waybar
    rofi
    pavucontrol
    pywal
    networkmanagerapplet
    slurp
    wayneko
    wl-clipboard
    nerd-fonts.jetbrains-mono
    pamixer
    brillo
    mako

    zsh
    oh-my-zsh
    zsh-powerlevel10k
    fzf

    fastfetch

    librewolf-bin
  ];
}
