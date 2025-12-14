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
                static = 83
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

            service {
                name = "heimdall"
                port = "http"

                check {
                    type     = "tcp"
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
                PUID = "1000"
                PGID = "1000"
                UMASK = "002"
            }
        }
    }
}