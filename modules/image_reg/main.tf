resource "kubectl_manifest" "image_reg_ns" {
  yaml_body = <<EOT
apiVersion: v1
kind: Namespace
metadata:
  name: image-reg
EOT
}

# it is okay that the secret is within this public git
# the server cert for the registry is just used locally and nothing elsewhere
# the trusted part injection is also only within a temporary client which will be deleted after demonstration
resource "kubectl_manifest" "image_reg_tls" {
  yaml_body = <<EOT
apiVersion: v1
kind: Secret
type: kubernetes.io/tls
metadata:
  name: reg-tls
  namespace: image-reg
data:
  tls.crt: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tDQpNSUlEdGpDQ0FwNmdBd0lCQWdJVVlqTGhqN05RMHkxRGxiZmlESmcrSytNL21EY3dEUVlKS29aSWh2Y05BUUVMDQpCUUF3UlRFTE1Ba0dBMVVFQmhNQ1FWVXhFekFSQmdOVkJBZ01DbE52YldVdFUzUmhkR1V4SVRBZkJnTlZCQW9NDQpHRWx1ZEdWeWJtVjBJRmRwWkdkcGRITWdVSFI1SUV4MFpEQWVGdzB5TXpBNU1EVXhNalUyTURKYUZ3MHlOREE1DQpNRFF4TWpVMk1ESmFNRVV4Q3pBSkJnTlZCQVlUQWtGVk1STXdFUVlEVlFRSURBcFRiMjFsTFZOMFlYUmxNU0V3DQpId1lEVlFRS0RCaEpiblJsY201bGRDQlhhV1JuYVhSeklGQjBlU0JNZEdRd2dnRWlNQTBHQ1NxR1NJYjNEUUVCDQpBUVVBQTRJQkR3QXdnZ0VLQW9JQkFRRFN3dVdoaHhscnRpbmtBeGg1Y1Z1aW9hSStJU1Z3Rkx0TENWWWgwbUUxDQpwL09TeTErblBTNTZNb2ZHNDBHWCtZMnY1clFNa3dWTDgwYTExQ1hSM0VWN2dmOC94TjF5ckhBeHRqeFdXT0E4DQp6TmNJazNXeXJiN1NZWWMvV0tkaFBvUWdobXRDQkpwcCtiM0Y4NzBpd2kveDBVQnZyWTh1cEIvcnlZL3UyVVZxDQprZmpBZkNGKytGclFDWFRMbWJMSjNrRGJ4NnRydHhJYmlFTDJhcXlMbDRKaXkwU1c2OC8wUmx6T2JEVmFCdEZLDQpjSlkrTXoyQUx6cUMyZGpFZTVEOFFFZDdPNCtiOTBETXMyb0ZDK1FFRmIrOFZaSnorR0JGaXpjeDIvTUZhK3lNDQpDZzJsc2xiSDJqNUE3aWp2dzFjdEk5anRCa3R2dWp3UFNicWQ0NWR3TlNBakFnTUJBQUdqZ1owd2dab3dIUVlEDQpWUjBPQkJZRUZQN1FkZ3VJbzBNMG9yWVdtQW1SVmxxM1FXV1VNQjhHQTFVZEl3UVlNQmFBRlA3UWRndUlvME0wDQpvcllXbUFtUlZscTNRV1dVTUE4R0ExVWRFd0VCL3dRRk1BTUJBZjh3UndZRFZSMFJCRUF3UG9JVmNtVm5hWE4wDQpjbmt1Y21RdWJHOWpZV3hvYjNOMGdpVnBiV0ZuWlMxeVpXY3VhVzFoWjJVdGNtVm5Mbk4yWXk1amJIVnpkR1Z5DQpMbXh2WTJGc01BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ2NJQ2ROUG0wR2hSVHNwdXBjQkRFVWI5UDc2emV5DQp4UHplK0IwekhIaDBleC82dXVyNkhiU0Z4eVljMjAyRFRRM1lSeEJrTXBGeXVBM0xaVEc3Q3lZQ282SjVlYTJRDQo5QW56cnZXRG1iNnRZN05VRHdDQ1owTWpkYzFqU2k4YSt3U3l0eHJKdm9ybUtpajdhMDEwS2dGeWdKVG1UVzFsDQp6REs4VlpsRVVoR3dKdldOZUUzandWQmZ5eGpmQm1RYmZNWHNhcythRG1jN1p5dGp1RGtNVDNWT2k5dS9nMUt4DQpVQW1ROEJKbGxQaVNlU2w3a0Z4dUlRYzlOUEhHdm1Bc1hsY0E1L3hWL3RFbVdqVE4vM081bzkxZTNndWRqQkxBDQpnUjRCZTM4WVhXYUp6ZTMvMFZ2Tm8raDJXM1hxcHlQTDNsSndZT0RyTEM4T1doZ1dvT0lEVXV1cg0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQ0K
  tls.key: LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tDQpNSUlFdmdJQkFEQU5CZ2txaGtpRzl3MEJBUUVGQUFTQ0JLZ3dnZ1NrQWdFQUFvSUJBUURTd3VXaGh4bHJ0aW5rDQpBeGg1Y1Z1aW9hSStJU1Z3Rkx0TENWWWgwbUUxcC9PU3kxK25QUzU2TW9mRzQwR1grWTJ2NXJRTWt3Vkw4MGExDQoxQ1hSM0VWN2dmOC94TjF5ckhBeHRqeFdXT0E4ek5jSWszV3lyYjdTWVljL1dLZGhQb1FnaG10Q0JKcHArYjNGDQo4NzBpd2kveDBVQnZyWTh1cEIvcnlZL3UyVVZxa2ZqQWZDRisrRnJRQ1hUTG1iTEoza0RieDZ0cnR4SWJpRUwyDQphcXlMbDRKaXkwU1c2OC8wUmx6T2JEVmFCdEZLY0pZK016MkFMenFDMmRqRWU1RDhRRWQ3TzQrYjkwRE1zMm9GDQpDK1FFRmIrOFZaSnorR0JGaXpjeDIvTUZhK3lNQ2cybHNsYkgyajVBN2lqdncxY3RJOWp0Qmt0dnVqd1BTYnFkDQo0NWR3TlNBakFnTUJBQUVDZ2dFQkFNajNOSFQ0V0lIL2VpUkQyMk41ZHRJMVkzbndxejBiVjVmdU9DWVo3NzEwDQovMm1hNlFPVDhDeHU0RThDUlhwL1o5NHhrcjltdFNjOXV0QUlrV054c1FOYTZxUEl1UXZ1WnpEUHZ1cnE1aTZ6DQpkOXRpbUZrZkdSU01FS1dUaUU3T2lMaG0xQUZvV0VEeTlVUzY3RDhuZ1FZSTdITlF3SFhONCs0MkRUdklDMHZZDQpWM3MwYUxLcEZYVGo5TVM3SUxBVnltQzBnekRVc3UrZUg4eUFpOHc3MU1GbVI1VTF3cFo1M2lCWjk1SDFqTFMvDQpKekQrbnBVcFFpbGtQSWZHUTdQQ3prY1I1NWlyZS9jN3IxTnhTU3ZiQXk1RzlseUZsb0FMc01zTVpOanF0OTB1DQpBbE1ocDVzN2dIcXFhNmFyVlBHRy91Z3RGaVgwOU9IaXdZN04wbGEvY21FQ2dZRUE3d2p4YnRZNjFObTRpZkJwDQpBcGVxMjJ5dkpOV3BVZTZQWUZnZW5UK0VKQ3M3QmhGUEs1ZTI0VlFrOHRBN1I0bjZzemdoZCtqcG9hci9jWnBrDQpudERVUnY3OEZZdWVWamt3eWFBd2FUdDY1VVp0N2VmaUJ6NWJtV2VtZko1T3RhdUlDbEo2WnN2UjNqbkl5emE4DQpDbFRxQUwwUy9WRkJuWmY4SGllYjBYUUlxL01DZ1lFQTRiZy9NYXh5MmFTd21VZzNualAzOGRKemFzMDZIeTYzDQpsR3lXY2NTTzBaMzJNQnk1dVh5WkdVSEZCWDIrRHI0R0NyNWZKbVBmWXNQNWo5MHVYREYveDdMc3BTZE41ZUgzDQpLZjVxWHNsMHk3K2ZWZGg4SEc3TTNtVG9XRG5kYm0xYWJmN2Z0K3hTWkxyb3FWcUlWUUZ3R2g4SUVjYXRQWWg5DQpabkk2THpVdHR4RUNnWUJvdXJoZFlZdUJPcXM1OUpWdHgxbmFyYkhISjczNTRkWDcxbUFEY1pMSjdnNzhSNVV5DQplbFJzUVZ1Mjd6a3B6UENFbVhGQWdsSHF2V3NTTVIwbzRFSkJvUEo5MWlCWGt0TW5aQUlSK1RlTlFPQmxQaFd3DQpLc2dqWEdCN2RUanpLK1o4NzBvbHcrTjl4RCtQbWJtbHBUS3BoQzNQdzB4R2FoTFNlM1F2dnZFVnRRS0JnUURKDQpNYUdpZFVRcUcxSU9Ud0RFVXk0K3JvZVNPendEYjNEVEs3Y3QwVFk4UWNDZlFmdUtDaldzL2FMUU1qU21qMXB6DQpXUjBXNnc3Q3lrdzRuNzRqRHp3R2xNVzZzRDRQR2t0bGN4RDlURFIvS0Y2dDlqa3FYdGpkb3JRM2I5eWdBWGtKDQpjcFdYSzE2Rnl0UjNuK3JGV25MQjFjY3JrUnY2TFI4Wm9kZWJISnVUQVFLQmdCN2JLMDg5UWtQcG15SzE4RW8yDQptWXJDdTFMd2txMWh0eFJhMjJ3YTM2SHNpVVdYT25hSnJDNms0VHQzakxmc0JRQU5CVm1uWUhvR2ZoY3BDeS95DQpNN3duMDBhTVdtdG1SUXo0VjlGR0pQazA1M3pqZTB1OG1DamhoSGVRbHV3WVRKSXlRbUloZ01JSnJpSkVLR1ZDDQowRlRhNzRMNTNqdEdhWDBlUmFrd2hLN1YNCi0tLS0tRU5EIFBSSVZBVEUgS0VZLS0tLS0NCg==
EOT

  depends_on = [
    kubectl_manifest.image_reg_ns
  ]
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
        env:
        - name: REGISTRY_HTTP_TLS_CERTIFICATE
          value: /certs/tls.crt
        - name: REGISTRY_HTTP_TLS_KEY
          value: /certs/tls.key
        volumeMounts:
        - mountPath: /certs
          name: image-reg-certs
      volumes:
      - name: image-reg-certs
        secret:
          secretName: reg-tls
EOT

  depends_on = [
    kubectl_manifest.image_reg_tls
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
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRouteTCP
metadata:
  name: image-reg
  namespace: image-reg
spec:
  entryPoints:
  - websecure
  - web
  routes:
  - match: HostSNI(`registry.rd.localhost`)
    services:
    - name: image-reg
      port: 5000
  # passthrough tls to service and use self signed cert from deployment above
  tls:
    passthrough: true
EOT

  depends_on = [
    kubectl_manifest.image_reg_svc
  ]
}
