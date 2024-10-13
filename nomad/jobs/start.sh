#!/usr/bin/env bash

for folder in $(ls -d */); do
  folderName=$(basename "$folder" /)
  nomad job run ./$folderName/job.hcl
done