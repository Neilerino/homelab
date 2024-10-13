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

  users.groups.media = {
    gid = 1000;
  };

  users.users.sonarr = {
    isSystemUser = true;
    uid = 1002;                # Set the UID to 1000
    group = "media";            # Primary group
    extraGroups = [ "docker" ]; # Add to the Docker group if needed
    home = "/var/lib/sonarr";   # Define home directory
    createHome = true;          # Create the home directory if it doesn't exist
    shell = pkgs.bash;          # Optional: set the default shell
  };

  users.users.radarr = {
    isSystemUser = true;
    uid = 1001;                # Set the UID to 1000
    group = "media";            # Primary group
    extraGroups = [ "docker" ]; # Add to the Docker group if needed
    home = "/var/lib/radarr";   # Define home directory
    createHome = true;          # Create the home directory if it doesn't exist
    shell = pkgs.bash;          # Optional: set the default shell
  };

  systemd.tmpfiles.rules = [
    # Create and set ownership/permissions for Sonarr directories
    "d /home/neil/radarr/config 0755 1001 1000 -"
    "d /home/neil/media/tv 0755 1001 1000 -"
    
    # Create and set ownership/permissions for Radarr directories
    "d /home/neil/sonarr/config 0755 1002 1000 -"
    "d /home/neil/media/movies 0755 1002 1000 -"
  ];


  time.timeZone = "America/St_Johns";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.neil = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    home = "/home/neil";
    extraGroups = ["wheel" "networkmanager" "docker"];
  };

  services.openssh.enable = true;

  system.stateVersion = "24.05";
}

