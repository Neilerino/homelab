{ pkgs, ... }:

{
  "caddy-data" = {
    path = "/srv/caddy/data";
    read_only = false;
  };
  "caddy-config" = {
    path = "/srv/caddy/config";
    read_only = false;
  };
  "caddy-file" = {
    path = "/srv/caddy/Caddyfile";
    read_only = false;
  };
}
