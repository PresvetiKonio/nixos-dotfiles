{
  config,
  pkgs,
  ...
}:

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
    mako = "mako";
    vis = "vis";
  };
in
{

  imports = [
    ./modules/pywalfox.nix
  ];

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

  programs.neovim = {
  enable = true;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;
  sideloadInitLua = true;
  extraPackages = with pkgs; [
    gcc            # treesitter parser compilation
    gnumake
    tree-sitter
    ripgrep
    fd
    lazygit
    nodejs         # some LSPs/plugins expect it
    unzip
    # LSPs/formatters (instead of Mason):
    lua-language-server
    stylua
    nixd           # or nil
    nixfmt
  ];
};


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
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita";
      icon-theme = "Papirus-Dark";
    };
  };

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "librewolf.desktop";
        "x-scheme-handler/http" = "librewolf.desktop";
        "x-scheme-handler/https" = "librewolf.desktop";
        "x-scheme-handler/about" = "librewolf.desktop";
        "x-scheme-handler/unknown" = "librewolf.desktop";
      };
    };
    terminal-exec = {
      enable = true;
      settings = {
        default = [ "kitty.desktop" ];
      };
    };
  };

  home.file."scripts/taildrop-poll.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      DEST="$HOME/Taildrop"
      mkdir -p "$DEST"

      before=$(ls -1 "$DEST" 2>/dev/null | wc -l)
      ${pkgs.tailscale}/bin/tailscale file get --wait=false "$DEST/" || true
      after=$(ls -1 "$DEST" 2>/dev/null | wc -l)

      if [ "$after" -gt "$before" ]; then
        new_files=$(ls -1t "$DEST" | head -n $((after - before)))
        ${pkgs.libnotify}/bin/notify-send "Taildrop" "Received: $new_files"
      fi
    '';
  };

  systemd.user.services.taildrop-poll = {
    Unit.Description = "Poll Taildrop for incoming files";
    Service = {
      Type = "oneshot";
      ExecStart = "${config.home.homeDirectory}/scripts/taildrop-poll.sh";
    };
  };

  systemd.user.timers.taildrop-poll = {
    Unit.Description = "Timer for Taildrop polling";
    Timer = {
      OnBootSec = "30s";
      OnUnitActiveSec = "30s";
    };
    Install.WantedBy = [ "timers.target" ];
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 10d --keep 10";
    flake = "/home/vladko/nixos-dotfiles";
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
    extraConfig = builtins.readFile ./config/sway/config;
  };

  home.packages = with pkgs; [
    #neovim
    vim
    ripgrep
    nil
    nodejs
    gcc
    python3
    libnotify

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

    qbittorrent

    fastfetch

    librewolf-bin
    firefox
    qutebrowser

    pywalfox-native

    spotify
    playerctl

    jellyfin-desktop

    moonlight-qt

    vesktop

    sideband

    onlyoffice-desktopeditors

    vis
    racket

    rustup

    (writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [
        fzf
        nix-search-tv
      ];
      text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
    })

    lunar-client
  ];
}
