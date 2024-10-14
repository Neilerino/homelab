job "caddy" {
    datacenters = ["dc1"]
    type = "service"

    group "caddy-group" {
        count = 1

        network {
            port "http" {
                static = 80
            }
            port "https" {
                static = 443
            }
        }

        volume "data" {
            type = "host"
            read_only = false
            source = "caddy-data"
        }

        volume "caddy-file" {
            type = "host"
            read_only = true
            source = "caddy-file"
        }

        task "caddy" {
            driver = "docker"

            volume_mount {
                volume = "caddy-data"
                read_only = false
                destination = "/data"
            }

            volume_mount {
                volume = "caddy-config"
                read_only = false
                destination = "/config"
            }

            volume_mount {
                volume = "caddy-file"
                read_only = true
                destination = "/etc/caddy/Caddyfile"
            }

            config {
                image = "caddy:latest"
                hostname = "caddy"
                ports = ["http", "https"] 
            }

            resources {
                cpu = 500
                memory = 512
            }
        }
    }
}