# User account, shell, and the few packages every box should have.
{ pkgs, ... }:

{
  users.users.vladko = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "input"
    ];
    shell = pkgs.zsh;
    packages = [ pkgs.tree ];
  };

  programs.zsh = {
    enable = true;
    promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  };

  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];
}
