resource "kubernetes_namespace" "fluent" {
  metadata {
    name = "fluent"
  }
}