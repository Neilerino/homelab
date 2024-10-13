job "prowlarr" {
    datacenters = ["dc1"]
    type        = "service"

    group "prowlarr-group" {
        count = 1

        volume "config" {
            type = "host"
            read_only = false
            source = "prowlarr-config"
        }

        network {
            port "http" {
                static = 9696
            }
        }

        task "prowlarr" {
            driver = "docker"

            volume_mount {
                volume = "config"
                read_only = false
                destination = "/config"
            }

            config {
                image = "lscr.io/linuxserver/prowlarr:latest"
                ports = ["http"]
            }

            resources {
                cpu    = 500
                memory = 512
            }
        }
    }
}