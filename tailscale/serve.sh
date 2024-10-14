#!/usr/bin/env bash

tailscale serve -bg --http=5555 http://zapdos.lab:8096
tailscale serve -bg --http=6666 http://zapdos.lab:5055