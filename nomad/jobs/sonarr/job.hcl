job "sonarr" {
    datacenters = ["dc1"]
    type        = "service"

    group "sonarr-group" {
        count = 1

        volume "data" {
            type = "host"
            read_only = false
            source = "data"
        }

        volume "config" {
            type = "host"
            read_only = false
            source = "sonarr-config"
        }

        network {
            port "http" {
                static = 8989
            }
        }

        task "sonarr" {
            driver = "docker"

            volume_mount {
                volume = "data"
                read_only = false
                destination = "/data"
            }

            volume_mount {
                volume = "config"
                read_only = false
                destination = "/config"
            }

            config {
                image = "lscr.io/linuxserver/sonarr:latest"
                hostname = "sonarr"
                ports = ["http"]
            }

            resources {
                cpu    = 1000
                memory = 1024
            }

            env {
                PUID = "1001"
                PGID = "1000"
                UMASK = "002"
            }
        }
    }
}