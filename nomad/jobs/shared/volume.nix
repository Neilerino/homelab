{ pkgs, ... }:

{
  "media-base" = {
    path = "/home/neil/media";
    read_only = false;
  };
  "media-movies" = {
    path = "/home/neil/media/movies";
    read_only = false;
  };
  "media-tv" = {
    path = "/home/neil/media/tv";
    read_only = false;
  };
  "media-downloads" = {
    path = "/home/neil/media-temp/downloads";
    read_only = false;
  };
}