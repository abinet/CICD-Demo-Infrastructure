resource "kubectl_manifest" "image_reg_ns" {
  yaml_body = <<EOT
apiVersion: v1
kind: Namespace
metadata:
  name: image-reg
EOT
}

resource "kubectl_manifest" "image_reg_deploy" {
  yaml_body = <<EOT
apiVersion: apps/v1
kind: Deployment
metadata:
  name: image-reg
  namespace: image-reg
  labels:
    app: image-reg
spec:
  replicas: 1
  selector:
    matchLabels:
      app: image-reg
  template:
    metadata:
      labels:
        app: image-reg
    spec:
      containers:
      - name: image-reg
        image: docker.io/library/registry:2
        ports:
        - containerPort: 5000
EOT

  depends_on = [
    kubectl_manifest.image_reg_ns
  ]
}

resource "kubectl_manifest" "image_reg_svc" {
  yaml_body = <<EOT
apiVersion: v1
kind: Service
metadata:
  name: image-reg
  namespace: image-reg
spec:
  selector:
    app: image-reg
  ports:
    - protocol: TCP
      port: 5000
      targetPort: 5000
EOT

  depends_on = [
    kubectl_manifest.image_reg_deploy
  ]
}

resource "kubectl_manifest" "image_reg_ing" {
  yaml_body = <<EOT
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: image-reg
  namespace: image-reg
spec:
  ingressClassName: traefik
  rules:
  - host: registry.rd.localhost
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: image-reg
            port:
              number: 5000
  # use tls with default traefik cert
  tls:
  - hosts:
      - registry.rd.localhost
EOT

  depends_on = [
    kubectl_manifest.image_reg_svc
  ]
}
