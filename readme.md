# readme

### git links
- https://github.com/DarthBlair/CICD-Demo-Infrastructure
- https://github.com/DarthBlair/CICD-Demo-App
- https://github.com/DarthBlair/CICD-Demo-Deployment

# base installations

## install rancher desktop
- download rancher desktop for windows arch amd64
- execute exe - install and follow the instructions
- install wsl (windows subsystem for linux)
- configure rancher desktop:
  - when not fresh installed then do a factory reset
    - and do not keep cached data / images
  - config:
    - k8s version `1.24.xx`
    - `containerd` engine
    - wsl integration `ubuntu`
    - `enable traefik`
- check installation:
  - open wsl client cli
  - ```sh
    echo "alias ll='ls -la'" >> ~/.bashrc
    echo "alias k='kubectl'" >> ~/.bashrc
    source ~/.bashrc
    k get nodes
    ```

## install chocolatey
- download chocolatey for windows arch amd64
- execute exe - install and follow the instructions

## install terraform
- install terraform with chocolatey
- open a windows cmd as administrator
- type `chocolatey install terraform`

## final checks for base installations
- open a local git bash terminal
- ```sh
  echo "alias ll='ls -la'" >> ~/.bashrc
  echo "alias k='kubectl'" >> ~/.bashrc
  source ~/.bashrc
  k get nodes
  which terraform
  terraform --version

  # test local tool for containerd and images
  which nerdctl
  nerdctl pull registry:2
  nerdctl images
  ```

# deploy infra

```sh
# this is just a note for internal - ignore it
openssl req -new -newkey rsa:2048 -nodes -sha256 -x509 -days 365 \
-keyout key.pem -out crt.pem \
-addext "subjectAltName = DNS:registry.rd.localhost,DNS:image-reg.image-reg.svc.cluster.local"
```

## pre: set image registry cert as trusted
- open windows cmd as admin
- `wsl -d rancher-desktop -e /bin/sh`
- ```sh
  # just simply mark and copy the following complete block command
  echo "-----BEGIN CERTIFICATE-----
  MIIDtjCCAp6gAwIBAgIUYjLhj7NQ0y1DlbfiDJg+K+M/mDcwDQYJKoZIhvcNAQEL
  BQAwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUxITAfBgNVBAoM
  GEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDAeFw0yMzA5MDUxMjU2MDJaFw0yNDA5
  MDQxMjU2MDJaMEUxCzAJBgNVBAYTAkFVMRMwEQYDVQQIDApTb21lLVN0YXRlMSEw
  HwYDVQQKDBhJbnRlcm5ldCBXaWRnaXRzIFB0eSBMdGQwggEiMA0GCSqGSIb3DQEB
  AQUAA4IBDwAwggEKAoIBAQDSwuWhhxlrtinkAxh5cVuioaI+ISVwFLtLCVYh0mE1
  p/OSy1+nPS56MofG40GX+Y2v5rQMkwVL80a11CXR3EV7gf8/xN1yrHAxtjxWWOA8
  zNcIk3Wyrb7SYYc/WKdhPoQghmtCBJpp+b3F870iwi/x0UBvrY8upB/ryY/u2UVq
  kfjAfCF++FrQCXTLmbLJ3kDbx6trtxIbiEL2aqyLl4Jiy0SW68/0RlzObDVaBtFK
  cJY+Mz2ALzqC2djEe5D8QEd7O4+b90DMs2oFC+QEFb+8VZJz+GBFizcx2/MFa+yM
  Cg2lslbH2j5A7ijvw1ctI9jtBktvujwPSbqd45dwNSAjAgMBAAGjgZ0wgZowHQYD
  VR0OBBYEFP7QdguIo0M0orYWmAmRVlq3QWWUMB8GA1UdIwQYMBaAFP7QdguIo0M0
  orYWmAmRVlq3QWWUMA8GA1UdEwEB/wQFMAMBAf8wRwYDVR0RBEAwPoIVcmVnaXN0
  cnkucmQubG9jYWxob3N0giVpbWFnZS1yZWcuaW1hZ2UtcmVnLnN2Yy5jbHVzdGVy
  LmxvY2FsMA0GCSqGSIb3DQEBCwUAA4IBAQCcICdNPm0GhRTspupcBDEUb9P76zey
  xPze+B0zHHh0ex/6uur6HbSFxyYc202DTQ3YRxBkMpFyuA3LZTG7CyYCo6J5ea2Q
  9AnzrvWDmb6tY7NUDwCCZ0Mjdc1jSi8a+wSytxrJvormKij7a010KgFygJTmTW1l
  zDK8VZlEUhGwJvWNeE3jwVBfyxjfBmQbfMXsas+aDmc7ZytjuDkMT3VOi9u/g1Kx
  UAmQ8BJllPiSeSl7kFxuIQc9NPHGvmAsXlcA5/xV/tEmWjTN/3O5o91e3gudjBLA
  gR4Be38YXWaJze3/0VvNo+h2W3XqpyPL3lJwYODrLC8OWhgWoOIDUuur
  -----END CERTIFICATE-----" > /usr/local/share/ca-certificates/image-registry.crt
  update-ca-certificates
  ```
- exit cmd, quit and restart rancher desktop

## deploy infra using terraform
- switch into main directory of this git (infra)
- ```sh
  terraform init

  # run a special plan and apply to render dynamic map keys content
  terraform plan -target=module.tekton.data.kubectl_file_documents.tekton_dashboard_manifests -out=./.tf.tfplan
  terraform apply ./.tf.tfplan

  # after that we can run all of it
  terraform plan -out=./.tf.tfplan
  terraform apply ./.tf.tfplan
  ```

## check some services from our new infra

### image registry
- ```sh
  nerdctl pull docker.io/library/registry:2 -q
  nerdctl tag docker.io/library/registry:2 registry.rd.localhost/library/registry:2
  nerdctl push --insecure-registry registry.rd.localhost/library/registry:2 -q
  ```
- check url in browser: https://registry.rd.localhost/v2/library/registry/tags/list

### argocd webapp / dashboard
- check url in browser: https://argo-cd.rd.localhost
- `admin:admin`

### sonarqube webapp
- check url in browser: https://sonar.rd.localhost
- `user:admin`
- follow instructions - change pw to e.g. `admin1` (need to differ)

### tekton CI
- check url in browser: https://tekton.rd.localhost
- no login required
- check the sections for the new ci config objects (tasks, pipelines, etc.)

### grafana dashboard
- check url in browser: https://grafana.rd.localhost
- `admin:admin`
- follow instructions - change pw to e.g. `admin1` (need to differ)

## first tekton ci-run testing
- check if all resources are deployed successfully
- run following command to start a tekton ci run
- ```sh
  k apply -f ./ci-run.yaml
  ```
- switch to the dashboard and inspect the tasks and logs
- https://tekton.rd.localhost/#/namespaces/example-tekton-ci/pipelineruns
- check the outputs like `image`, `version` and `digest`
- now we check the new image in our registry
- for this you can use:
  - the new image version tag: e.g. `:1.5.3`
  - the new hash digest: e.g. `@sha256:993fa1ae17d12...`
- ```sh
  nerdctl pull \
  registry.rd.localhost/piotr-cicd/sample-spring-kotlin:1.5.3 \
  -q --insecure-registry
  ```
- check all images of the registry now: https://registry.rd.localhost/v2/_catalog
- check the tags of the new image now: https://registry.rd.localhost/v2/piotr-cicd/sample-spring-kotlin/tags/list
- hint: if you want to rerun the ci-run you can simply click "rerun" within the tekton dashboard or <br>
  if you want to re-apply the manifest you need to delete the existing one or <br>
  change the name within `ci-run.yaml` into any new one
- https://tekton.rd.localhost/#/namespaces/example-tekton-ci/pipelineruns

## setup argocd config and trigger sync
- switch to the argocd dashboard and check the new application `example-app`
- https://argo-cd.rd.localhost/applications/argocd/example-app
- trigger the sync manually one time and simply `synchronize`
- you can enable auto sync to not always have to click `synchronize`
- demonstrate a change:
  - commit a change within the deploy git
  - e.g. change the tag version of the image to the current one
  - file: `deploy.yaml`
  - line: `image: registry.rd.localhost/piotr-cicd/sample-spring-kotlin:1.5.3`
  - switch back to the dashboard and synchronize again
  - a new revision of the deployment will be applied (blue-green)

## check and show the final microservice api
- when argocd finished syncing the resources (deployment, service and ingress)
- check the api with a simple get request through the browser
- https://example-app.rd.localhost/persons
- should return a lot of persons as json payload


## TODO
- Add auto certificate generation
- Fix setting admin password for ArgoCD
- 