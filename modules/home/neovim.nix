{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    sideloadInitLua = true;

    # Available to nvim only (instead of Mason).
    extraPackages = with pkgs; [
      # build tooling
      gcc # treesitter parser compilation
      gnumake
      tree-sitter
      nodejs # some LSPs/plugins expect it
      unzip

      # search / git
      ripgrep
      fd
      lazygit

      # LSPs and formatters
      lua-language-server
      stylua
      nixd # or nil
      nixfmt
      rustfmt
      rust-analyzer
      asmfmt
      asm-lsp
      prettier
      prettierd
    ];
  };
}
