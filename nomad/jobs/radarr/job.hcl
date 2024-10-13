job "radarr" {
    datacenters = ["dc1"]
    type        = "service"

    group "radarr-group" {
        count = 1

        volume "downloads" {
            type = "host"
            read_only = false
            source = "media-downloads"
        }

        volume "movies" {
            type = "host"
            read_only = false
            source = "media-movies"
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
                volume = "downloads"
                read_only = false
                destination = "/downloads"
            }

            volume_mount {
                volume = "movies"
                read_only = false
                destination = "/movies"
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

            resources {
                cpu    = 1000
                memory = 1024
            }
        }
    }
}