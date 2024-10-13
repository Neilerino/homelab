{ pkgs, ...}:

{
  "jellyfin-media" = {
    path = "/home/neil/jellyfin/media";
    read_only = false;
  };
  "jellyfin-cache" = {
    path = "/home/neil/jellyfin/cache";
    read_only = false;
  };
  "jellyfin-config" = {
    path = "/home/neil/jellyfin/config";
    read_only = false;
  };
}