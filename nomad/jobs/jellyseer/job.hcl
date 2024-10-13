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
                static = 5055
            }
        }

        task "jellyseer" {
            driver = "docker"

            volume_mount {
                volume = "config"
                read_only = false
                destination = "/app/config"
            }

            config {
                image = "fallenbagel/jellyseerr"
                hostname = "jellyseer"
                ports = ["http"]
            }

            resources {
                cpu    = 500
                memory = 512
            }
            env {
                PORT = "5055"
            }
        }
    }
}