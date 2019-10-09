resource "kubernetes_service_account" "fluent" {
  metadata {
    name      = "fluentd"
    namespace = "fluent"
  }
}