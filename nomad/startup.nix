{ config, pkgs, lib, ... }:

let
  # List of Nomad job files
  nomadJobs = [
    "/etc/nixos/nomad/jobs/jellyfin/job.hcl"
    "/etc/nixos/nomad/jobs/radarr/job.hcl"
    "/etc/nixos/nomad/jobs/jellyseerr/job.hcl"
    "/etc/nixos/nomad/jobs/sabnzbd/job.hcl"
  ];

  # Generate the ExecStart commands
  nomadJobsCommands = lib.concatStringsSep "\n" (map (jobPath: ''
    ${pkgs.nomad}/bin/nomad job run ${jobPath}
  '') nomadJobs);
in
{
  # Ensure Nomad is enabled
  services.nomad.enable = true;

  # Define the systemd service
  systemd.services.nomad-jobs = {
    description = "Start Nomad jobs";
    wants = [ "nomad.service" ];
    after = [ "nomad.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c '${nomadJobsCommands}'";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
