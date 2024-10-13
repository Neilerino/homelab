{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    nomad-driver-podman
    damon
    pkgs.nomad
  ];
  environment.variables.EDITOR = "vim";

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.hostName = "zapdos";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  home-manager.users.neil = import ./home-manager/home.nix;  

  services.nomad = import ./nomad/service.nix { inherit pkgs; };

  networking.firewall.allowedTCPPorts = [ 4646 8096 8080 ];
  networking.firewall.allowedUDPPorts = [ 8096 ];

  time.timeZone = "America/St_Johns";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.neil = {
    isNormalUser = true;
    home = "/home/neil";
    extraGroups = ["wheel" "networkmanager" "docker"];
  };

  services.openssh.enable = true;

  system.stateVersion = "24.05";
}

