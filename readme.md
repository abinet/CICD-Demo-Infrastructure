# readme

# base installations

## install rancher desktop
- download rancher desktop for windows arch amd64
- execute exe - install and follow the instructions
- install wsl (windows subsystem for linux)
- configure rancher desktop:
  - k8s version `1.25.12`
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
  - the new image version tag: e.g. `:1.5.2`
  - the new hash digest: e.g. `@sha256:993fa1ae17d12...`
- ```sh
  nerdctl pull \
  registry.rd.localhost/piotr-cicd/sample-spring-kotlin:1.5.2 \
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
- commit a change within the deploy git
  - change the tag version of the image to the current one
  - file: `deploy.yaml`
  - line: `image: image-reg.image-reg.svc.cluster.local:5000/piotr-cicd/sample-spring-kotlin:1.5.2`

TODO: continue
