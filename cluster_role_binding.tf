resource "kubernetes_cluster_role_binding" "fluent" {

  metadata {
    name = "fluentd"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "fluentd"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "fluentd"
    namespace = "fluent"
  }
}