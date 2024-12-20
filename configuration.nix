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
    pkgs.tailscale
  ];
  environment.variables.EDITOR = "vim";

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "zapdos";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  home-manager.users.neil = import ./home-manager/home.nix;

  networking.firewall.allowedTCPPorts = [ 443 4646 8096 8080 7878 5055 8989 9696 ];
  networking.firewall.allowedUDPPorts = [ 8096 41641 ];

  users.groups.media = {
    gid = 1000;
  };

  users.users.radarr = {
    isSystemUser = true;
    uid = 1001;
    group = "media";
    extraGroups = [ "docker" ];
    home = "/var/lib/radarr";
    createHome = true;
    shell = pkgs.bash;
  };

  users.users.sonarr = {
    isSystemUser = true;
    uid = 1002;
    group = "media";
    extraGroups = [ "docker" ];
    home = "/var/lib/sonarr";
    createHome = true;
    shell = pkgs.bash;
  };

  users.users.jellyfin = {
    isSystemUser = true;
    uid = 1003;
    group = "media";
    extraGroups = [ "docker" ];
    home = "/var/lib/jellyfin";
    createHome = true;
    shell = pkgs.bash;
  };

  users.users.sabnzbd = {
    isSystemUser = true;
    uid = 1004;
    group = "media";
    extraGroups = [ "docker" ];
    home = "/var/lib/sabnzbd";
    createHome = true;
    shell = pkgs.bash;
  };

  systemd.tmpfiles.rules = [
    "mkdir -p /srv/caddy/data"
    "mkdir -p /srv/caddy/config"
    "yes | cp -f /etc/nixos/nomad/jobs/caddy/Caddyfile /srv/caddy/Caddyfile"

    # Create and set ownership/permissions for data directory
    "d /mnt/mediadrive/data 0755 1000 1000 -"

    # Create and set ownership/permissions for Sonarr directories
    "d /home/neil/radarr/config 0755 1001 1000 -"
    "d /mnt/mediadrive/data/movies 0755 1001 1000 -"

    # Create and set ownership/permissions for Radarr directories
    "d /home/neil/sonarr/config 0755 1002 1000 -"
    "d /mnt/mediadrive/data/tv 0755 1002 1000 -"

    # Create and set ownership/permissions for sabnzbd directories
    "d /home/neil/sabnzbd/config 0755 1004 1000 -"
    "d /mnt/mediadrive/data/downloads 0755 1004 1000 -"
    "d /mnt/mediadrive/data/incomplete 0755 1004 1000 -"
  ];

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/mnt/mediadrive" =
    {
      device = "/dev/sda1";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" ];
    };

  services.tailscale = {
    enable = true;
    openFirewall = true;
    authKeyFile = /etc/nixos/secrets/tailscale;
    extraUpFlags = [
      "--accept-dns=false"
    ];
  };

  services.nomad = import ./nomad/service.nix { inherit pkgs; };

  time.timeZone = "America/St_Johns";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.neil = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    home = "/home/neil";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  services.openssh.enable = true;

  system.stateVersion = "24.05";
}

