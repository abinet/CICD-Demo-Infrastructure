resource "helm_release" "sonarqube" {
  repository = "oci://registry-1.docker.io/bitnamicharts"
  version = "3.2.8"
  name = "sonarqube"
  chart = "sonarqube"
  namespace = "sonarqube"
  create_namespace = true
  timeout = 600

  set {
    name = "ingress.enabled"
    value = "true"
  }
  set {
    name = "ingress.hostname"
    value = "sonar.rd.localhost"
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
    name = "service.type"
    value = "ClusterIP"
  }
  set {
    name = "sonarqubePassword"
    value = "admin"
  }
}
