# jx-boot-helmfile

Experimentle repo looking at getting [helmfile](https://github.com/roboll/helmfile) working with a jx boot config repo.

## prerequisits

- helmfile `brew install helmfile` - note this also installs a helm 3 binary on your `$PATH`
- helm plugins
```bash
helm plugin install https://github.com/aslafy-z/helm-git.git
helm plugin install https://github.com/databus23/helm-diff
```
- clean Jenkins X cluster created with `jx create cluster gke --skip-installation`

## running the helmfile installer

There's lots of info on the [helmfile](https://github.com/roboll/helmfile) github repo, take a look to see how things fit together.

```
git clone git@github.com:jenkins-x-labs/boot-helmfile-poc.git
cd boot-helmfile-poc
```

* modify the `jx-requirements.yml` to modify the `cluster` fields to point to your cluster: 

* `clusterName`
* `project`
* `zone`

auto generate jx requirements and helm values files
```
export JX_HELMFILE=true
jx step verify preinstall -b --namespace jx --disable-verify-helm --disable-verify-packages
jx upgrade crd
sed -i "" -e "s#domain:.*#domain: {{ exec \"bash\" (list \"./scripts/getDomain.sh\" ) | indent 4 }} #" jx-requirements.values.yaml.gotmpl
```
temporarily apply some templates that we will move into charts soon
```
kubectl apply -f templates/
```
write some installation secrets to a file using the template below, this is a temporary solution
```
vi vi $HOME/.jx/localSecrets/{{ add your cluster name }}/secrets.yaml
```
```yaml
secrets:
  token: 
  password: 
  hmacToken: 
  pipelineUser:
    username: 
    email: 
    token: 
```
```
export JX_SECRETS_DIR=$HOME/.jx/localSecrets/{{ add your cluster name }}/
helmfile sync
```

This will install an nginx ingress controller, lighthouse and tekton.

## untinstall

```
helmfile destroy
```


