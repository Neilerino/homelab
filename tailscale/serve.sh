#!/usr/bin/env bash

tailscale serve -bg --http=5555 http://localhost:8096
tailscale serve -bg --http=6666 http://localhost:5055