# update for traefik
# disable ssl verification for self signed traefik cert
resource "kubectl_manifest" "traefik_insecure" {
  yaml_body = <<EOT
apiVersion: helm.cattle.io/v1
kind: HelmChartConfig
metadata:
  name: traefik
  namespace: kube-system
spec:
  valuesContent: |-
    additionalArguments:
      - "--serverstransport.insecureskipverify=true"
EOT
}

module "image_reg" {
  source = "./modules/image_reg"
  depends_on = [
    kubectl_manifest.traefik_insecure
  ]
}

/*
module "monitoring" {
  source = "./modules/monitoring"
  depends_on = [
    kubectl_manifest.traefik_insecure
  ]
}
*/

module "argocd" {
  source = "./modules/argocd"
  depends_on = [
    kubectl_manifest.traefik_insecure
  ]
}

/*
module "sonarqube" {
  source = "./modules/sonarqube"
  depends_on = [
    kubectl_manifest.traefik_insecure
  ]
}
*/

module "tekton" {
  source = "./modules/tekton"
  depends_on = [
    kubectl_manifest.traefik_insecure
  ]
}
