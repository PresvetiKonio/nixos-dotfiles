{
  config,
  pkgs,
  lazyvim,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    #    nvim = "nvim";
    rofi = "rofi";
    waybar = "waybar";
    kitty = "kitty";
    zsh = "zsh";
    wallpapers = "wallpapers";
    mako = "mako";
  };
in
{

  imports = [
    ./modules/pywalfox.nix
    lazyvim.homeManagerModules.default
  ];

  programs.lazyvim = {
    enable = true;

    extras = {
      lang.nix.enable = true;
      lang.python = {
        enable = true;
        installDependencies = true; # Install ruff
        installRuntimeDependencies = true; # Install python3
      };
      lang.go = {
        enable = true;
        installDependencies = true; # Install gopls, gofumpt, etc.
        installRuntimeDependencies = true; # Install go compiler
      };
    };

    # Additional packages (optional)
    extraPackages = with pkgs; [
      nixd # Nix LSP
      alejandra # Nix formatter
      statix
      tree-sitter
    ];

    # Only needed for languages not covered by LazyVim extras
    treesitterParsers = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      wgsl # WebGPU Shading Language
      templ # Go templ files
    ];

    plugins = {
      extra-lazy-opts = ''
        return {
          "folke/lazy.nvim",
          opts = {
            readme = { enabled = false },
          },
        }
      '';
    };
  };

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
  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
  }) configs;

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
  programs.pywalfox = {
    enable = true;
    browsers = [
      "firefox"
      "librewolf"
    ]; # default, drop what you don't use
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
    #neovim
    vim
    ripgrep
    nil
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

    pywalfox-native

    spotify

    (writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [
        fzf
        nix-search-tv
      ];
      text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
    })

  ];
}
