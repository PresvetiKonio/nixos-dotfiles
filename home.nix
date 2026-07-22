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
    settings = {
      user.name = "PresvetiKonio";
      user.email = "vladimirfilipov1234@gmail.com";
    };
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
  home.file.".local/share/fonts".source = local/fonts;

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Papirus";
    };
  };


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
    python3

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
    autotiling-rs

    zsh
    oh-my-zsh
    zsh-powerlevel10k
    fzf

    thunar
    thunar-volman
    thunar-archive-plugin


    fastfetch

    librewolf-bin
    firefox
    qutebrowser

    spotify

    (writeShellApplication
      {
        name = "ns";
        runtimeInputs = with pkgs; [ fzf nix-search-tv ];
        text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
      }
    )


  ];
}
