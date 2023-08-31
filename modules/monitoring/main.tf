resource "helm_release" "prometheus" {
  repository = "oci://registry-1.docker.io/bitnamicharts"
  version = "0.1.8"
  name = "prometheus"
  chart = "prometheus"
  namespace = "monitoring"
  create_namespace = true
  timeout = 600

  set {
    name = "server.service.type"
    value = "ClusterIP"
  }
  set {
    name = "server.ingress.enabled"
    value = "true"
  }
  set {
    name = "server.ingress.hostname"
    value = "prometheus.rd.localhost"
  }
  set {
    name = "server.ingress.tls"
    value = "true"
  }
  set {
    name = "server.ingress.selfSigned"
    value = "true"
  }
  set {
    name = "alertmanager.enabled"
    value = "false"
  }
  set {
    name = "pushgateway.enabled"
    value = "false"
  }
}

resource "helm_release" "grafana" {
  repository = "oci://registry-1.docker.io/bitnamicharts"
  version = "9.0.4"
  name = "grafana"
  chart = "grafana"
  namespace = "monitoring"
  timeout = 600

  depends_on = [
    helm_release.prometheus
  ]

  set {
    name = "service.type"
    value = "ClusterIP"
  }
  set {
    name = "ingress.enabled"
    value = "true"
  }
  set {
    name = "ingress.hostname"
    value = "grafana.rd.localhost"
  }
  set {
    name = "ingress.tls"
    value = "true"
  }
  set {
    name = "ingress.selfSigned"
    value = "true"
  }
  set {
    name = "admin.password"
    value = "admin"
  }
}
