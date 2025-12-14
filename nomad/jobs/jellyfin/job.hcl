job "jellyfin" {
  datacenters = ["dc1"]
  type        = "service"

  group "jellyfin-group" {
    count = 1

    volume "data" {
       type = "host"
       read_only = false
       source = "data"
    }
    
    volume "cache" {
       type = "host"
       read_only = false
       source = "jellyfin-cache"
    }

    volume "config" {
       type = "host"
       read_only = false
       source = "jellyfin-config"
    }

    network {
      mode = "host"
      port "http" {
        static = 8096
      }
    }
    
    task "jellyfin" {
      driver = "docker"

      volume_mount {
        volume = "data"
        read_only = false
        destination = "/data"
      }

      volume_mount {
        volume = "config"
        read_only = false
        destination = "/config"
      }

      volume_mount {
        volume = "cache"
        read_only = false
        destination = "/cache"
      }

      config {
        network_mode = "host"
        image = "jellyfin/jellyfin:latest"
        hostname = "jellyfin"
        ports = ["http"]
        devices = [
          {
            "host_path" = "/dev/dri",
            "container_path" = "/dev/dri",
          }
        ]
      }

      service {
        name = "jellyfin"
        port = "http"

        check {
          type     = "http"
          path     = "/health"
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
        cpu    = 10000
        memory = 6144
      }

      env {
        DOCKER_MODS = "linuxserver/mods:jellyfin-amd"
        PUID = "1003"
        PGID = "1000"
        UMASK = "002"
      }
    }
  }
}

