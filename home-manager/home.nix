{ pkgs, ... }:

{
  home.packages = with pkgs; [gh];
  home.stateVersion = "24.05";

  programs.vim = {
    enable = true;
    extraConfig = ''
      syntax on
      set number
      set tabstop=4
      
    '';
    plugins = with pkgs.vimPlugins; ["vim-nix"];
  };

  programs.git = (import ./git.nix {inherit pkgs;});
}

