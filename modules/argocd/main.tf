resource "helm_release" "argocd" {
  repository = "oci://registry-1.docker.io/bitnamicharts"
  version = "4.7.21"
  name = "argo-cd"
  chart = "argo-cd"
  namespace = "argocd"
  create_namespace = true
  timeout = 600

  set {
    name = "server.ingress.enabled"
    value = "true"
  }
  set {
    name = "server.ingress.hostname"
    value = "argo-cd.rd.localhost"
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
    name = "config.secret.argocdServerAdminPassword"
    value = "admin"
  }
}
