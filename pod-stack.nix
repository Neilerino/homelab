# /Users/neilwadden/Programming/homelab/pod-stack.nix
# Module for media stack (radarr, sonarr, jellyfin, sabnzbd) users and related config

{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Define the media group
  users.groups.media = {
    gid = 1000; # Assuming GID 1000 is desired for this group
  };

  # Define media stack users
  users.users.radarr = {
    isSystemUser = true;
    uid = 1001;
    group = "media";
    extraGroups = [ "docker" ]; # Assuming 'docker' group exists or is defined elsewhere
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

  # Define media-related directories and permissions
  systemd.tmpfiles.rules = [
    # Create and set ownership/permissions for main data directory
    "d /mnt/mediadrive/data 0755 1000 1000 -"

    # Radarr directories (config owner: radarr(1001), group: media(1000))
    "d /home/neil/radarr/config 0755 1001 1000 -"
    "d /mnt/mediadrive/data/movies 0755 1001 1000 -"

    # Sonarr directories (config owner: sonarr(1002), group: media(1000))
    "d /home/neil/sonarr/config 0755 1002 1000 -"
    "d /mnt/mediadrive/data/tv 0755 1002 1000 -"

    # Sabnzbd directories (config owner: sabnzbd(1004), group: media(1000))
    "d /home/neil/sabnzbd/config 0755 1004 1000 -"
    "d /mnt/mediadrive/data/downloads 0755 1004 1000 -"
    "d /mnt/mediadrive/data/incomplete 0755 1004 1000 -"
  ];

  # Define the media drive filesystem mount
  # Ensure boot.supportedFilesystems = [ "ntfs" ]; is set in configuration.nix if needed
  fileSystems."/mnt/mediadrive" = {
    device = "/dev/sda1";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000" ]; # Assuming uid 1000 is the 'media' group or primary user access
  };

}
