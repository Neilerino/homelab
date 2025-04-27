{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./nomad/startup.nix
      ./pod-stack.nix
    ];
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    nomad-driver-podman
    damon
    pkgs.nomad
    # pkgs.tailscale
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

  systemd.tmpfiles.rules = [
    "mkdir -p /srv/caddy/data"
    "mkdir -p /srv/caddy/config"
    "yes | cp -f /etc/nixos/nomad/jobs/caddy/Caddyfile /srv/caddy/Caddyfile"

    # Create and set ownership/permissions for tailscale dirs
    # "d /var/lib/tailscale 0755 1000 1000 -"
  ];

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  boot.supportedFilesystems = [ "ntfs" ];

  # services.tailscale = {
  #   enable = true;
  #   openFirewall = true;
  #   authKeyFile = /etc/nixos/secrets/tailscale;
  #   extraUpFlags = [
  #     "--accept-dns=false"
  #   ];
  # };

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
