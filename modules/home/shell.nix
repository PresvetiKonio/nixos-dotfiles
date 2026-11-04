{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases.vim = "nvim";
  };

  # zsh is enabled system-wide and configured from config/zsh + .zshenv,
  # so home-manager must not generate its own .zshrc.
  programs.zsh.enable = false;
  home.packages = with pkgs; [
    zsh
    oh-my-zsh
    zsh-powerlevel10k
    fzf
  ];

  programs.nh = {
    enable = true;
    flake = "${config.home.homeDirectory}/nixos-dotfiles";
    clean = {
      enable = true;
      extraArgs = "--keep-since 10d --keep 10";
    };
  };
}
