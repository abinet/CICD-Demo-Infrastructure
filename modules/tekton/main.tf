# workaround for some weird bug where tekton helm chart always creates this namespace
# but then it is not there when helm wants to use it
# we have to create it manually and add the special metadata for helm association
resource "kubectl_manifest" "tekton_ns" {
  yaml_body = <<EOT
apiVersion: v1
kind: Namespace
metadata:
  annotations:
    meta.helm.sh/release-name: "tekton"
    meta.helm.sh/release-namespace: "tekton-pipelines"
  labels:
    app.kubernetes.io/managed-by: "Helm"
  name: tekton-pipelines
EOT
}

resource "helm_release" "tekton" {
  repository = "https://cdfoundation.github.io/tekton-helm-chart"
  version = "1.0.2"
  name = "tekton"
  chart = "tekton-pipeline"
  namespace = "tekton-pipelines"
  timeout = 600

  depends_on = [
    kubectl_manifest.tekton_ns
  ]
}

data "kubectl_file_documents" "tekton_dashboard_manifests" {
  content = file("${path.module}/dashboard-rw.yaml")
}

resource "kubectl_manifest" "tekton_dashboard" {
  for_each = data.kubectl_file_documents.tekton_dashboard_manifests.manifests
  yaml_body = each.value

  depends_on = [
    helm_release.tekton
  ]
}

resource "kubectl_manifest" "tekton_ing" {
  yaml_body = <<EOT
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tekton-dashboard
  namespace: tekton-pipelines
spec:
  ingressClassName: traefik
  rules:
  - host: tekton.rd.localhost
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: tekton-dashboard
            port:
              number: 9097
  # use tls with default traefik cert
  tls:
  - hosts:
      - tekton.rd.localhost
EOT

  depends_on = [
    kubectl_manifest.tekton_dashboard
  ]
}

data "kubectl_path_documents" "tekton_ci_tasks_docs" {
  pattern = "${path.module}/ci-config/tasks/*.yaml"
}

resource "kubectl_manifest" "tekton_ci_tasks" {
  for_each = toset(data.kubectl_path_documents.tekton_ci_tasks_docs.documents)
  yaml_body = each.value

  depends_on = [
    kubectl_manifest.tekton_ing
  ]
}

resource "kubectl_manifest" "tekton_ci_config" {
  yaml_body = "${file("${path.module}/ci-config/ci.yaml")}"

  depends_on = [
    kubectl_manifest.tekton_ci_tasks
  ]
}
