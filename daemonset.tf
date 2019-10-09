resource "kubernetes_daemonset" "fluent" {
  metadata {
    labels = {
      "name" = "fluentd-kafka"
    }
    name      = "fluentd-kafka"
    namespace = "fluent"
  }

  spec {
    min_ready_seconds      = 0
    revision_history_limit = 10

    selector {
      match_labels = {
        "name" = "fluentd-kafka"
      }
    }

    strategy {
      type = "OnDelete"
    }

    template {
      metadata {
        annotations = {}
        labels = {
          "name" = "fluentd-kafka"
        }
      }

      spec {
        automount_service_account_token  = false
        dns_policy                       = "ClusterFirst"
        host_ipc                         = false
        host_network                     = false
        host_pid                         = false
        node_selector                    = {}
        restart_policy                   = "Always"
        service_account_name             = "fluentd"
        share_process_namespace          = false
        termination_grace_period_seconds = 30

        container {
          args                     = []
          command                  = []
          image                    = "fluent/fluentd-kubernetes-daemonset:v1.7-debian-kafka-1"
          image_pull_policy        = "IfNotPresent"
          name                     = "fluentd-kafka"
          stdin                    = false
          stdin_once               = false
          termination_message_path = "/dev/termination-log"
          tty                      = false

          resources {
            limits {
              memory = "200Mi"
            }

            requests {
              cpu    = "100m"
              memory = "200Mi"
            }
          }

          volume_mount {
            mount_path = "/config-volume"
            name       = "config-volume"
            read_only  = false
          }
          volume_mount {
            mount_path = "/fluentd/etc"
            name       = "fluentdconf"
            read_only  = false
          }
          volume_mount {
            mount_path = "/var/log"
            name       = "varlog"
            read_only  = false
          }
          volume_mount {
            mount_path = "/var/lib/docker/containers"
            name       = "varlibdockercontainers"
            read_only  = true
          }
          volume_mount {
            mount_path = "/run/log/journal"
            name       = "runlogjournal"
            read_only  = true
          }
        }

        init_container {
          args = []
          command = [
            "sh",
            "-c",
            "cp /config-volume/..data/* /fluentd/etc",
          ]
          image                    = "busybox"
          image_pull_policy        = "Always"
          name                     = "copy-fluentd-config"
          stdin                    = false
          stdin_once               = false
          termination_message_path = "/dev/termination-log"
          tty                      = false

          resources {
          }

          volume_mount {
            mount_path = "/config-volume"
            name       = "config-volume"
            read_only  = false
          }
          volume_mount {
            mount_path = "/fluentd/etc"
            name       = "fluentdconf"
            read_only  = false
          }
        }

        volume {
          name = "config-volume"

          config_map {
            default_mode = "0644"
            name         = "fluentd-config"
          }
        }
        volume {
          name = "fluentdconf"

          empty_dir {}
        }
        volume {
          name = "varlog"

          host_path {
            path = "/var/log"
          }
        }
        volume {
          name = "varlibdockercontainers"

          host_path {
            path = "/var/lib/docker/containers"
          }
        }
        volume {
          name = "runlogjournal"

          host_path {
            path = "/run/log/journal"
          }
        }
      }
    }
  }

  timeouts {}
}