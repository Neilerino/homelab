job "sabnzbd" {
    datacenters = ["dc1"]
    type        = "service"

    group "sabnzbd-group" {
        count = 1

        volume "downloads" {
            type = "host"
            read_only = false
            source = "sabnzbd-downloads"
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
                volume = "downloads"
                read_only = false
                destination = "/downloads"
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

            resources {
                cpu    = 1000
                memory = 1024
            }
        }
    }
}