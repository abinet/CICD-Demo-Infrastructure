resource "helm_release" "argocd" {
  repository = "https://argoproj.github.io/argo-helm"
  version = "7.7.12"
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

resource "kubectl_manifest" "argocd_appset" {
  yaml_body = <<EOT
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: example-appset
  namespace: argocd
spec:
  goTemplate: true
  #goTemplateOptions: ["missingkey=error"]
  generators:
  - git:
      repoURL: https://github.com/abinet/CICD-Demo-Deployment.git
      revision: add-config
      directories:
      - path: apps/*/envs/*   
  template:    
    metadata:
      name: '{{index .path.segments 1}}-{{index .path.segments 3}}'   
    spec:
      # The project the application belongs to.
      project: default

      # Source of the application manifests
      sources:
      - repoURL: https://github.com/abinet/CICD-Demo-Deployment.git
        targetRevision: add-config
        path: 'apps/{{index .path.segments 1}}/helm'
        helm:
          releaseName: '{{index .path.segments 1}}'
          valueFiles:
          - '$values/apps/{{index .path.segments 1}}/envs/{{index .path.segments 3}}/values.yaml'
      - repoURL: https://github.com/abinet/CICD-Demo-Deployment.git
        targetRevision: add-config
        ref: values
      syncPolicy:
        syncOptions:
        - CreateNamespace=true
      # Destination cluster and namespace to deploy the application
      destination:
        name: '{{index .path.segments 3}}-cluster'
        namespace: '{{index .path.segments 1}}'
EOT
  depends_on = [
    helm_release.argocd,
  ]
}
