#!/usr/bin/env bash

set -euo pipefail

# Check if the --restart flag is provided
RESTART=false
if [ "${1:-}" == "--restart" ]; then
  RESTART=true
fi

# Get the list of currently running Nomad jobs
running_jobs=$(nomad job status -short | awk 'NR > 1 && $1 != "" {print $1}')

for folder in */; do
  folderName=$(basename "$folder" /)

  # Skip the 'shared' folder
  if [ "$folderName" == "shared" ]; then
    continue
  fi

  # Get the job name from the folder name (assuming job name matches folder name)
  job_name="$folderName"
  job_file="./$folderName/job.hcl"

  # Check if the job is already running
  if grep -Fxq "$job_name" <<< "$running_jobs"; then
    echo "Job $job_name is already running."

    # Only restart the job if the --restart flag is provided
    if [ "$RESTART" == true ]; then
      echo "Registering $job_name..."
      nomad job run "$job_file"

      if grep -Eq 'type[[:space:]]*=[[:space:]]*"service"' "$job_file"; then
        echo "Restarting allocations for $job_name..."
        nomad job restart -yes -on-error=fail -batch-size=1 "$job_name"
      else
        echo "Skipping allocation restart for non-service job $job_name."
      fi
    else
      echo "Skipping $job_name..."
    fi
  else
    # If the job is not running, submit it
    echo "Starting $job_name..."
    nomad job run "$job_file"
  fi
done
