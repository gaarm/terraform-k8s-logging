resource "kubernetes_config_map" "fluent" {
  metadata {
    labels = {
      "name" = "fluentd-kafka"
    }
    name      = "fluentd-config"
    namespace = "fluent"
  }

  data = {
    "fluent.conf"     = "${file("${path.module}/conf/fluent.conf")}"
    "containers.conf" = "${templatefile("${path.module}/conf/containers.conf", { stream_name = "$${tag_parts[3]}", brokers = var.logging_kafka_broker_list, kafka_topic = var.logging_kafka_topic })}"
    "systemd.conf"    = "${templatefile("${path.module}/conf/systemd.conf", { stream_name1 = "$${tag}", stream_name2 = "$${record[\"hostname\"]}", brokers = var.logging_kafka_broker_list, kafka_topic = var.logging_kafka_topic })}"
  }
}