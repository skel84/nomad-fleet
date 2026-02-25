job "fleet-hello-http" {
  datacenters = ["dc1"]
  type        = "service"

  group "app" {
    count = 1

    network {
      mode = "host"

      port "http" {
        static = 18080
        to     = 18080
      }
    }

    service {
      name = "fleet-hello-http"
      port = "http"

      check {
        name     = "tcp"
        type     = "tcp"
        port     = "http"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "app" {
      driver = "docker"

      config {
        image        = "hashicorp/http-echo:0.2.3"
        network_mode = "host"
        args = [
          "-listen",
          ":18080",
          "-text",
          "Hello from GitOps revision 1",
        ]
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
