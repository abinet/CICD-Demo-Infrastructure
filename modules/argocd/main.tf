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

resource "kubectl_manifest" "example_app_argo_ns" {
  yaml_body = <<EOT
apiVersion: v1
kind: Namespace
metadata:
  name: example-app-argo
EOT
}

resource "kubectl_manifest" "example_app_ns" {
  yaml_body = <<EOT
apiVersion: v1
kind: Namespace
metadata:
  name: example-app
EOT
}

resource "kubectl_manifest" "argo_cd_config" {
  yaml_body = <<EOT
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: example-app
  namespace: example-app-argo
spec:
  project: example-app
  source:
    repoURL: "https://github.com/DarthBlair/CICD-Demo-Deployment.git"
    targetRevision: HEAD
    path: k8s
  destination:
    server: "https://kubernetes.default.svc"
    namespace: example-app
EOT

  depends_on = [
    helm_release.argocd,
    kubectl_manifest.example_app_argo_ns,
    kubectl_manifest.example_app_ns
  ]
}
