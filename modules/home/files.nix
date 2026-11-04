# Dotfiles that are symlinked straight into the repo (editable without a rebuild),
# plus the few that are copied into the store instead.
{ config, lib, ... }:

let
  repo = "${config.home.homeDirectory}/nixos-dotfiles";

  # Out-of-store symlink: edits in the repo show up immediately.
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/config/${name}";
in
{
  # ~/.config/<name> -> <repo>/config/<name>
  xdg.configFile = lib.genAttrs [
    "nvim"
    "rustfmt"
    "rofi"
    "waybar"
    "kitty"
    "zsh"
    "wallpapers"
    "mako"
    "vis"
  ] (name: {
    source = link name;
  });

  home.file = {
    ".zshenv".source = ../../config/.zshenv;
    ".local/bin".source = ../../local/bin;
    ".local/share/fonts".source = ../../local/fonts;
  };
}
