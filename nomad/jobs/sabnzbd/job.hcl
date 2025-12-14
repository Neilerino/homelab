job "sabnzbd" {
    datacenters = ["dc1"]
    type        = "service"

    group "sabnzbd-group" {
        count = 1

        volume "data" {
            type = "host"
            read_only = false
            source = "data"
        }

        volume "config" {
            type = "host"
            read_only = false
            source = "sabnzbd-config"
        }

        network {
            port "http" {
                static = 8080
            }
        }

        task "sabnzbd" {
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
                image = "linuxserver/sabnzbd:latest"
                hostname = "sabnzbd"
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
                cpu    = 5000
                memory = 3072
            }

            env {
                PUID = "1004"
                PGID = "1000"
                UMASK = "002"
            }
        }
    }
}