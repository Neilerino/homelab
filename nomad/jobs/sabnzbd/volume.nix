{ pkgs, ...}:

{
  "sabnzbd-config" = {
    path = "/home/neil/sabnzbd/config";
    read_only = false;
  };
  "sabnzbd-downloads" = {
    path = "/home/neil/sabnzbd/downloads";
    read_only = false;
  };
  "sabnzbd-incomplete" = {
    path = "/home/neil/sabnzbd/incomplete";
    read_only = false;
  };
}