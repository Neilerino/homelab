{ pkgs, ...}:

{
  enable = true;
  userName = "Neilerino";
  userEmail = "naw218@mun";
  extraConfig = {
    init = {
      defaultBranch = "main";
    };
  };
}
