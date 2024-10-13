job "sonarr" {
    datacenters = ["dc1"]
    type        = "service"

    group "sonarr-group" {
        count = 1

        volume "downloads" {
            type = "host"
            read_only = false
            source = "media-downloads"
        }

        volume "tv" {
            type = "host"
            read_only = false
            source = "media-tv"
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
                volume = "downloads"
                read_only = false
                destination = "/downloads"
            }

            volume_mount {
                volume = "tv"
                read_only = false
                destination = "/tv"
            }

            volume_mount {
                volume = "config"
                read_only = false
                destination = "/config"
            }

            config {
                image = "lscr.io/linuxserver/sonarr:latest"
                ports = ["http"]
            }

            resources {
                cpu    = 1000
                memory = 1024
            }
        }
    }
}