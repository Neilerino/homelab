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

  networking.firewall.allowedTCPPorts = [ 4646 8096 8080 7878 5055 8989 9696 ];
  networking.firewall.allowedUDPPorts = [ 8096 ];

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
    "d /srv/streaming/data 0755 1000 1000 -"

    # Create and set ownership/permissions for Sonarr directories
    "d /home/neil/radarr/config 0755 1001 1000 -"
    "d /srv/streaming/data/movies 0755 1001 1000 -"

    # Create and set ownership/permissions for Radarr directories
    "d /home/neil/sonarr/config 0755 1002 1000 -"
    "d /srv/streaming/data/tv 0755 1002 1000 -"

    # Create and set ownership/permissions for sabnzbd directories
    "d /home/neil/sabnzbd/config 0755 1004 1000 -"
    "d /srv/streaming/data/downloads 0755 1004 1000 -"
    "d /srv/streaming/data/incomplete 0755 1004 1000 -"
  ];

  services.tailscale = {
    enable = true;
    authKeyFile = "./secrets/tailscale";
    useRoutingFeatures = "server";
  };

  environment.variables.TAILSCALE_KEY = [ (builtins.readFile ./secrets/tailscale) ];

  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";
    after = [ "network-pre.target" "tailscale.service" "environment.variables.TAILSCALE_KEY" ];
    wants = [ "network-pre.target" "tailscale.service" "environment.variables.TAILSCALE_KEY" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up -authkey ${environment.variables.TAILSCALE_KEY}
      ${tailscale}/bin/tailscale serve -bg --http=5555 http://zapdos.lab:8096
      ${tailscale}/bin/tailscale serve -bg --http=6666 http://zapdos.lab:5055
    '';
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

