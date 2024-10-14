{ pkgs, ... }:

{
  "data" = {
    path = "/srv/streaming/data";
    read_only = false;
  };
  "media-downloads" = {
    path = "/home/neil/media-temp/downloads";
    read_only = false;
  };
}