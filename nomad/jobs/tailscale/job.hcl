job "tailscale" {
    datacenters = ["dc1"]
    type        = "service"

    group "tailscale-group" {
        count = 1

        network {
            mode = "host"
            port "http" {
                static = 9002
            }
        }

        task "tailscale" {
            driver = "docker"

            config {
                network_mode = "host"
                image = "tailscale/tailscale:latest"
                ports = ["http"]
            }

            env {
                TS_AUTHKEY = env "NOMAD_VAR_TS_AUTHKEY"
            }

            resources {
                cpu    = 500
                memory = 512
            }
        }
    }
}