{ config, pkgs, lib, ... }:

let
  serviceNomadJobs = [
    { name = "jellyfin"; path = "/etc/nixos/nomad/jobs/jellyfin/job.hcl"; }
    { name = "radarr"; path = "/etc/nixos/nomad/jobs/radarr/job.hcl"; }
    { name = "jellyseer"; path = "/etc/nixos/nomad/jobs/jellyseer/job.hcl"; }
    { name = "sabnzbd"; path = "/etc/nixos/nomad/jobs/sabnzbd/job.hcl"; }
    { name = "sonarr"; path = "/etc/nixos/nomad/jobs/sonarr/job.hcl"; }
    { name = "heimdall"; path = "/etc/nixos/nomad/jobs/heimdall/job.hcl"; }
  ];

  batchNomadJobs = [
    { name = "recyclarr"; path = "/etc/nixos/nomad/jobs/recyclarr/job.hcl"; }
  ];

  nomadJobs = serviceNomadJobs ++ batchNomadJobs;

  nomadJobsCommands = lib.concatStringsSep "\n" (map
    (job: ''
      ${pkgs.nomad}/bin/nomad job run ${job.path}
    '')
    nomadJobs);

  nomadRestartCommands = lib.concatStringsSep "\n" (map
    (job: ''
      ${pkgs.nomad}/bin/nomad job restart -yes -on-error=fail -batch-size=1 ${job.name}
    '')
    serviceNomadJobs);

  nomadJobsScript = pkgs.writeShellScript "nomad-jobs" ''
    set -euo pipefail
    ${nomadJobsCommands}
  '';

  nomadRestartScript = pkgs.writeShellScript "nomad-jobs-daily-restart" ''
    set -euo pipefail
    ${nomadRestartCommands}
  '';
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
      ExecStart = "${nomadJobsScript}";
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.nomad-jobs-daily-restart = {
    description = "Daily rolling restart of Nomad service jobs";
    wants = [ "nomad.service" ];
    after = [ "nomad.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${nomadRestartScript}";
      TimeoutStartSec = "30m";
    };
  };

  systemd.timers.nomad-jobs-daily-restart = {
    description = "Daily rolling restart of Nomad service jobs";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 04:00:00";
      Persistent = true;
      Unit = "nomad-jobs-daily-restart.service";
    };
  };
}
