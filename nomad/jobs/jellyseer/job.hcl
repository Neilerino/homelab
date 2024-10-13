job "jellyseer" {
    datacenters = ["dc1"]
    type       = "service"

    group "jellyseer-group" {
        count = 1

        volume "config" {
            type = "host"
            read_only = false
            source = "jellyseer-config"
        }

        network {
            port "http" {
                static = 8080
            }
        }

        task "jellyseer" {
            driver = "docker"

            volume_mount {
                volume = "config"
                read_only = false
                destination = "/config"
            }

            config {
                image = "jellyfin/jellyseer:latest"
                ports = ["http"]
            }

            resources {
                cpu    = 500
                memory = 512
            }
        }
    }
}