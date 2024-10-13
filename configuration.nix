{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./nomad/startup.nix
    ];
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    nomad-driver-podman
    damon
    pkgs.nomad
  ];
  environment.variables.EDITOR = "vim";

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.hostName = "zapdos";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  home-manager.users.neil = import ./home-manager/home.nix;  

  services.nomad = import ./nomad/service.nix { inherit pkgs; };

  networking.firewall.allowedTCPPorts = [ 4646 8096 8080 7878 5055 8989 ];
  networking.firewall.allowedUDPPorts = [ 8096 ];

  systemd.tmpfiles.rules = [
    # Create and set ownership/permissions for Sonarr directories
    "d /home/neil/radarr/config 0755 1000 1000 -"
    "d /home/neil/media/tv 0755 1000 1000 -"
    "d /path/to/downloads 0755 1000 1000 -"
    
    # Create and set ownership/permissions for Radarr directories
    "d /home/neil/sonarr/config 0755 1000 1000 -"
    "d /home/neil/media/movies 0755 1000 1000 -"
    "d /path/to/downloads 0755 1000 1000 -"
  ];


  time.timeZone = "America/St_Johns";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.neil = {
    isNormalUser = true;
    home = "/home/neil";
    extraGroups = ["wheel" "networkmanager" "docker"];
  };

  services.openssh.enable = true;

  system.stateVersion = "24.05";
}

