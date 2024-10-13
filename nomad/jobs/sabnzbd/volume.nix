{ pkgs, ...}:

{
  host_volume.sabnzbd-config = {
    path = "/home/neil/sabnzbd/config";
    read_only = false;
  };
  host_volume.sabnzbd-downloads = {
    path = "/home/neil/sabnzbd/downloads";
    read_only = false;
  };
  host_volume.sabnzbd-incomplete = {
    path = "/home/neil/sabnzbd/incomplete";
    read_only = false;
  };
}