job "recyclarr" {
    datacenters = ["dc1"]
    type        = "batch"

    periodic {
        cron             = "@daily"
        prohibit_overlap = true
        time_zone        = "UTC"
    }

    group "recyclarr-group" {
        count = 1

        volume "config" {
            type = "host"
            read_only = false
            source = "recyclarr-config"
        }

        task "recyclarr" {
            driver = "docker"

            volume_mount {
                volume = "config"
                read_only = false
                destination = "/config"
            }

            config {
                image = "recyclarr/recyclarr:latest"
                hostname = "recyclarr"
                args = ["sync"]
            }

            restart {
                attempts = 2
                delay    = "15s"
                interval = "30m"
                mode     = "fail"
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
                PUID = "1001"
                PGID = "1000"
                UMASK = "002"
            }
        }
    }
}