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
  tls.crt: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUR0akNDQXA2Z0F3SUJBZ0lVYWV5Tko1Z1RKdXE5Rno0VWFxa1pLMDBKTW1Jd0RRWUpLb1pJaHZjTkFRRUwKQlFBd1JURUxNQWtHQTFVRUJoTUNRVlV4RXpBUkJnTlZCQWdNQ2xOdmJXVXRVM1JoZEdVeElUQWZCZ05WQkFvTQpHRWx1ZEdWeWJtVjBJRmRwWkdkcGRITWdVSFI1SUV4MFpEQWVGdzB5TkRFeU1qa3hNekkyTkRoYUZ3MHlOVEV5Ck1qa3hNekkyTkRoYU1FVXhDekFKQmdOVkJBWVRBa0ZWTVJNd0VRWURWUVFJREFwVGIyMWxMVk4wWVhSbE1TRXcKSHdZRFZRUUtEQmhKYm5SbGNtNWxkQ0JYYVdSbmFYUnpJRkIwZVNCTWRHUXdnZ0VpTUEwR0NTcUdTSWIzRFFFQgpBUVVBQTRJQkR3QXdnZ0VLQW9JQkFRRFJNdzBvUElaU2kvcU5YZ3FaWVFpTHZNSkpFTDVrZVBmY3B1eDFoMzErCmIrMnVUZkFFdmZ1c1lvS2doZHl3dlhBQ0xaYmo5YTZDQjd0YlhWcDNGRTRuclRScDVKYm9KMnRLbEdSMHlBYlYKNVk5U0JzVDNyOXorTnFNd3REdnRZQ2RVSXMwdjAwakFqd25uSFovZHhLVlNOeHFweXB4aUI0UXpxcldZRGVZaQozSTF6SEFLVG5wT09jQTVQSy9kMGUraEJhVGIvQkFha0duellVYTNETEE2cFU0b1BaekdQNStpbXpPdUdkd05yCjM3WjhZR0FSSHN0cklkazZJa25HMkJldVVjREpaa215bVR3ZWR5THJpSWY0U3QyenVQM0ppaTlzNkE2S0NNRjMKQ05sV1d5c1hpdXJYZTZ6ckRIdmhoYzBuVFM4SmxIejcyNk9VUENwbWh2OVhBZ01CQUFHamdaMHdnWm93SFFZRApWUjBPQkJZRUZIUmhsZHE4VkNKbWEzdHlxYUVLS2NsUGhLRzJNQjhHQTFVZEl3UVlNQmFBRkhSaGxkcThWQ0ptCmEzdHlxYUVLS2NsUGhLRzJNQThHQTFVZEV3RUIvd1FGTUFNQkFmOHdSd1lEVlIwUkJFQXdQb0lWY21WbmFYTjAKY25rdWNtUXViRzlqWVd4b2IzTjBnaVZwYldGblpTMXlaV2N1YVcxaFoyVXRjbVZuTG5OMll5NWpiSFZ6ZEdWeQpMbXh2WTJGc01BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQitFc2RPdmpISE9uREoyYzNWajZWRzVVMlA4cWwwClM0eHkyeXhJbFhWb25QK0IwMHJxcFo0b1FjYlQ0QnFBVzg5cGJPcVduMmtFVThyQnViTlVkREY0dVlWRVJrc3AKS0prUjNGSGZlUVZCMGZBeFhxSzZHTkIrVWhjSCtYMnAwYU0xL2w3N0t3N0k5TmgzUEJQTTV3QmlUVVZHRnJIVgpRN2RFYzB4NTFGd0VRaFd0REtyYW5Fb2pCMm1CaHU0VkE2alRpOEcvUTQzK2ZHR3RyeTZFRWVJbHhqckowa0ZHCmV2ZFNDWWMvY1IrMS96R0l6UFlqbC8vdmdxNWkzREp6WENLK1dla3RWRDZzRGNxdlVlNEVjbC9FaU5Jek1IUVIKZEtITVM3WkdhSklQaE5vU2hrd0MxOHZOcERPdlFTYVkramhjL1NxUXhhL1lKTkVtRkVqVStmYjcKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
  tls.key: LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tCk1JSUV2UUlCQURBTkJna3Foa2lHOXcwQkFRRUZBQVNDQktjd2dnU2pBZ0VBQW9JQkFRRFJNdzBvUElaU2kvcU4KWGdxWllRaUx2TUpKRUw1a2VQZmNwdXgxaDMxK2IrMnVUZkFFdmZ1c1lvS2doZHl3dlhBQ0xaYmo5YTZDQjd0YgpYVnAzRkU0bnJUUnA1SmJvSjJ0S2xHUjB5QWJWNVk5U0JzVDNyOXorTnFNd3REdnRZQ2RVSXMwdjAwakFqd25uCkhaL2R4S1ZTTnhxcHlweGlCNFF6cXJXWURlWWkzSTF6SEFLVG5wT09jQTVQSy9kMGUraEJhVGIvQkFha0duelkKVWEzRExBNnBVNG9QWnpHUDUraW16T3VHZHdOcjM3WjhZR0FSSHN0cklkazZJa25HMkJldVVjREpaa215bVR3ZQpkeUxyaUlmNFN0Mnp1UDNKaWk5czZBNktDTUYzQ05sV1d5c1hpdXJYZTZ6ckRIdmhoYzBuVFM4SmxIejcyNk9VClBDcG1odjlYQWdNQkFBRUNnZ0VBRCtZc2tkQ3VLeUY3aDdsWkswVnBiMEloU0ZYbGJ6b3ZLUlJOQjRHbU9aZGUKaERXWUtkMnpTdXQ0SHRmYWFTZDhsdnFXYTVNNGVBeWhsVzV1RTBoY2xRcVRSZjluNVhtLzMxWmVPTzYwYitPWApTT01LMGdIVzFRNW9Za00yMFNVNDEvZFRpbkNQanV5RFJjSXNPUWFOdzVOdnZvZkN0Nm9xazVYZHgwVnRqUFZpCjhhQU9KSG43Y1JUOHUzK0JnYlN0dmlEL2tOc2dSMjRSZjRVQStzYjQ5bmw3cUZRTnFudjBWOUttdmtLb2MwUnIKcHkvYkxPSE0yVytGSU12ajE5VUR6K3I4ZCs0T216SDBaS0I3elRpNjE2bHBFbndqcks3QWp6eUdwMkRHR1dSQgpoaU13OHZ1YkU4bzlWazNDM0RwTmplNDNGRlVubDJCSzRFd1UyU1BBd1FLQmdRRHpwMFl2UVlrNmdLL2ZYNldwClJvSFZJOHhOczdKZit3RUt1Z05MVVZKeExjWmhGS0xiMWhYNUVIY3ZhSjh0cUwzSmNhb09HQkxTM1BkUnhTcWkKeEtaY2VTR3ZtNVJTTGJNU1FKWmlGNUg1NUJVUnRSVVZuVWliMEdsTmZBTWR6MERIZHlQWVAzQjl6TnE1bVNINQpFbW1iS3FiQW5UQXBTd3dJQjgza1gwaG5Rd0tCZ1FEYnpOVVk1K2tiOWFJeWgzRm9MNkh5UGRUek8wOGdKK2poCkE1TUdtVDVUaFBjTmEzSGZpOFJZVTNKWUp6cHJkSzBLeWs1QXROMUJGZUNYT3R0S0RpZ1dQR2R1M0RIWXgrUjEKTDNPdndqYkhJV1ZmcDRnS2xtRk1BVTB4TUMzbVp0dlNMai9DTS9ralRweHpxWUNkR3IrV29hc0dsOWRyZUh4RQo3SWtsbXhMVVhRS0JnUURpeWhzbzF6NXRSdVRzN0xGYzYzVGp1Q3R0VThxL1RmbzlTc0RRTlVTZ2RqUUZudGlyCitReUF4Tk83UEEyVnlVL0dGbGRzUVBvY2JYS0RHUnZEWDNsZDc1M3NQOHNCNXVtY0hxUWJiOGIvSzA1MUtmRVQKS2xBd1FBQVVFRTh5U3Z3SDdaeGVwMFlFd2s0QW5VbWk5WUY0M1cxVE1ieG5ZeVF5d1ZqaXJkSE4wd0tCZ0VEUgp6RG8zRWlERHRKeVFJdHFseVcyRjNJb0tnSkFzRk5wZTBub01zVHV5SjZWV2ZWTitoVjNDNWlLbkZ1eGZrVFJ3CmF0bGNQUytYZ3c4Mk5UdEdwMzIvUElXTi9FbEEwZGZaTVpXd2diVUIzVUp6Um9SUXlzcStTNFJvLy9CRmZ5Z2gKcVgzZEUramNvdmpkRU9mRDNxSk9kUUJSd1I2WmZwUlk2UzBrNlUybEFvR0FVTUFIUlZqWDlmQXc3R0JVYUE5YgpKczRDQVVsdllrZENVU2VPT2lHMEtIbGJ2TEJYNHdaMzUzZXBIeUVOcE5RcGRBSHlDTlpqK0ZqK2w3bnlFVnR5CkE4NTdWUXpQaTErcFVyRTdmcW5tTDlQbVZ5WXk4dGh3cXpsc3pPbjhEelA3NnF3eFM3YW9QamQyQkc4NU54MUsKdW15UUo3Mmxya0wwWDBQRFBTQlErUnc9Ci0tLS0tRU5EIFBSSVZBVEUgS0VZLS0tLS0K
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
