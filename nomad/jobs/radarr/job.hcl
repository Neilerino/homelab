job "radarr" {
    datacenters = ["dc1"]
    type        = "service"

    group "radarr-group" {
        count = 1

        volume "data" {
            type = "host"
            read_only = false
            source = "data"
        }

        volume "config" {
            type = "host"
            read_only = false
            source = "radarr-config"
        }

        network {
            port "http" {
                static = 7878
            }
        }

        task "radarr" {
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
                image = "lscr.io/linuxserver/radarr:latest"
                hostname = "radarr"
                ports = ["http"]
            }

            restart {
                attempts = 3
                delay    = "15s"
                interval = "5m"
                mode     = "delay"
            }

            logs {
                max_files     = 5
                max_file_size = 10
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