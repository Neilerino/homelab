job "heimdall" {
    datacenters = ["dc1"]
    type        = "service"

    group "heimdall-group" {
        count = 1

        volume "config" {
            type = "host"
            read_only = false
            source = "heimdall-config"
        }

        network {
            port "http" {
                to = 80
                from = 83
            }
        }

        task "heimdall" {
            driver = "docker"

            volume_mount {
                volume = "config"
                read_only = false
                destination = "/config"
            }

            config {
                image = "lscr.io/linuxserver/heimdall:latest"
                hostname = "heimdall"
                ports = ["http"]
            }

            resources {
                cpu    = 500
                memory = 512
            }
        }
    }
}