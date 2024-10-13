{ pkgs, ...}:

let 
  jellyfinVols = import ./jobs/jellyfin/volume.nix { inherit pkgs; };
  sabnzbdVols = import ./jobs/sabnzbd/volume.nix { inherit pkgs; };
  jellyseerVols = import ./jobs/jellyseer/volume.nix { inherit pkgs; };

  volumes = jellyfinVols // sabnzbdVols // jellyseerVols;
  
in
{
  enable = true;
  package = pkgs.nomad;
  extraSettingsPlugins = [pkgs.nomad-driver-podman];
  enableDocker = true;
  dropPrivileges = false;
  settings = {
    bind_addr = "0.0.0.0";
    advertise = {
      http = "192.168.1.218:4646";
      rpc = "192.168.1.218:4647";
      serf = "192.168.1.218:4648";
    };
    client = {
      enabled = true;
      options = {
          "docker.enable_host_volumes" = true;
      };
      client_volume = volumes;
    };
    server = {
      enabled = true;
      bootstrap_expect = 1; # Adjust according to the number of servers in your cluster
    };
  };
}