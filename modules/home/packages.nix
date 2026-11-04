{ pkgs, inputs, ... }:

let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  home.packages = with pkgs; [
    # CLI / dev
    python3
    nil
    nodejs
    gcc
    unzip
    rustup
    racket
    ripgrep
    fastfetch
    libnotify
    (writeShellApplication {
      name = "ns";
      runtimeInputs = [
        fzf
        nix-search-tv
      ];
      text = builtins.readFile "${nix-search-tv.src}/nixpkgs.sh";
    })

    # Desktop environment pieces
    kitty
    waybar
    rofi
    mako
    slurp
    wl-clipboard
    wayneko
    autotiling-rs
    networkmanagerapplet
    pavucontrol
    pamixer
    brillo
    nerd-fonts.jetbrains-mono

    # File manager
    thunar
    thunar-volman
    thunar-archive-plugin
    libimobiledevice
    ifuse

    # Browsers
    librewolf-bin
    firefox
    qutebrowser

    # Media / chat / apps
    spotify
    playerctl
    jellyfin-desktop
    moonlight-qt
    vesktop
    #sideband
    qbittorrent
    onlyoffice-desktopeditors

    # coding
    #vis
    #vscodium
    vscode

    krita
    unstable.photocraft

    # Games
    lunar-client

    # assembly
    dosbox

  ];
}
