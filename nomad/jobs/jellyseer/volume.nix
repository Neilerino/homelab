{pkgs, ...}:

{
  host_volume.jellyseer-config = {
    path = "/home/neil/jellyseer/config";
    read_only = false;
  };
}