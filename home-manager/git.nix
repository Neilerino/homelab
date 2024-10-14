{ pkgs, ... }:

{
  enable = true;
  userName = "Neilerino";
  userEmail = "naw218@mun.ca";
  extraConfig = {
    init = {
      defaultBranch = "main";
    };
  };
}
