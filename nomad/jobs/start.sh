#!/usr/bin/env bash

# Check if the --restart flag is provided
RESTART=false
if [ "$1" == "--restart" ]; then
  RESTART=true
fi

# Get the list of currently running Nomad jobs
running_jobs=$(nomad job status -short | awk '{print $1}')

for folder in $(ls -d */); do
  folderName=$(basename "$folder" /)

  # Skip the 'shared' folder
  if [ "$folderName" == "shared" ]; then
    continue
  fi

  # Get the job name from the folder name (assuming job name matches folder name)
  job_name="$folderName"

  # Check if the job is already running
  if [[ "$running_jobs" =~ $job_name ]]; then
    echo "Job $job_name is already running."

    # Only restart the job if the --restart flag is provided
    if [ "$RESTART" == true ]; then
      echo "Restarting $job_name..."
      nomad job run "./$folderName/job.hcl"
    else
      echo "Skipping $job_name..."
    fi
  else
    # If the job is not running, submit it
    echo "Starting $job_name..."
    nomad job run "./$folderName/job.hcl"
  fi
done
