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

      resources {
        cpu    = 3000
        memory = 5120
      }

      env {
        DOCKER_MODS = "linuxserver/mods:jellyfin-amd"
        PUID = "1004"
        PGID = "1000"
        UMASK = "002"
      }
    }
  }
}

