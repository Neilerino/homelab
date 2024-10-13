{ lib, config, pkgs, ... }:

{
  # Ensure Nomad is enabled (optional if already set elsewhere)
  services.nomad.enable = true;

  # Define the activation script to start Nomad jobs
  system.activationScripts.nomadJobs = lib.mkAfter ''
    echo "Starting Nomad jobs..."

    # Submit and start each Nomad job
    nomad job run /etc/nixos/nomad/jobs/jellyfin/job.hcl
    nomad job run /etc/nixos/nomad/jobs/radarr/job.hcl
    nomad job run /etc/nixos/nomad/jobs/jellyseerr/job.hcl
    nomad job run /etc/nixos/nomad/jobs/sabnzbd/job.hcl

    echo "All Nomad jobs started."
  '';
}