{ pkgs, ...}:

{
  host_volume.jellyfin-media = {
    path = "/home/neil/jellyfin/media";
    read_only = false;
  };
  host_volume.jellyfin-cache = {
    path = "/home/neil/jellyfin/cache";
    ready_only = false;
  };
  host_volume.jellyfin-config = {
    path = "/home/neil/jellyfin/config";
    read_only = false;
  };
}