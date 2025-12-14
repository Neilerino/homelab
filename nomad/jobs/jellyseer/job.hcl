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
            mode = "host"
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
                network_mode = "host"
                image = "fallenbagel/jellyseerr:latest"
                hostname = "jellyseer"
                ports = ["http"]
            }

            service {
                name = "jellyseer"
                port = "http"

                check {
                    type     = "http"
                    path     = "/api/v1/status"
                    interval = "30s"
                    timeout  = "5s"
                }
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
                cpu    = 500
                memory = 512
            }
            env {
                PORT = "5055"
            }
        }
    }
}