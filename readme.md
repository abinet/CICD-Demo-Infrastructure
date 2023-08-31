# readme

# base installations

## install rancher desktop
- download rancher desktop for windows arch amd64
- execute exe - install and follow the instructions
- install wsl (windows subsystem for linux)
- configure rancher desktop:
  - containerd engine
  - wsl integration ubuntu
  - enable cluster dns and traefik
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

## deploy infra using terraform
- switch into main directory of this git (infra)
- ```sh
  terraform init
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
- no login

### grafana dashboard
- check url in browser: https://grafana.rd.localhost
- `admin:admin`
- follow instructions - change pw to e.g. `admin1` (need to differ)
