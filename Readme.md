# Spinnaker Local

## Introduction

This should let you run spinnaker locally for testing

WIP.. spinnaker on k8s on OS X is painful..
.. looking for spinnaker on docker-compose because it would be easiest....

## Contents

- [Usage](#usage)

## Usage

Make sure you have kubernetes running locally and `kubectl` installed, then:

```bash
./build.sh
docker-compose up -d
kubectl -n spinnaker port-forward "$(kubectl -n spinnaker get pods | grep -i deck | grep -i running | awk '{print $1}')" 9000 &
kubectl -n spinnaker port-forward "$(kubectl -n spinnaker get pods | grep -i gate | grep -i running | awk '{print $1}')" 8084 &
```

If you have to go nuclear:

```bash
kubectl -n spinnaker get all
kubectl -n spinnaker delete deployments --all --force --now --cascade=false
kubectl -n spinnaker delete statefulsets --all --force --now --cascade=false
kubectl -n spinnaker delete replicasets --all --force --now --cascade=false
kubectl -n spinnaker delete services --all --force --now --cascade=false
kubectl -n spinnaker delete pods --all --force --now --cascade=false
kubectl -n spinnaker get all
```

```bash
brew install kubernetes-helm kubernetes-cli

helm init
helm install stable/spinnaker -f values.yml

kubectl port-forward "$(kubectl get pods | grep deck | awk '{print $1}')" 9000
open http://localhost:9000
```


```bash
brew install kubernetes-cli

MINIO_ACCESS_KEY=93UD14VE2K1SHSSZE3TU MINIO_SECRET_KEY=Ak6OnEEkroAPYiUU4u73zePedB5Zz0ByNgsLfjhe docker run -itd -p 9101:9101 --name minio minio/minio server --address :9101 /data

mkdir ~/.hal
docker run -itd --rm -p 8084:8084 -p 8064:8064 -p 9000:9000 --name halyard -v ~/.hal:/home/spinnaker/.hal -v ~/.kube:/home/spinnaker/.kube gcr.io/spinnaker-marketplace/halyard:stable
docker exec -it halyard bash
hal config provider kubernetes enable --daemon-endpoint http://127.0.0.1:8064
hal config provider kubernetes account add my-k8s-v2-account --provider-version v2 --context $(kubectl config current-context) --daemon-endpoint http://127.0.0.1:8064
hal config features edit --artifacts true --daemon-endpoint http://127.0.0.1:8064
hal config deploy edit --type distributed --account-name my-k8s-v2-account --daemon-endpoint http://127.0.0.1:8064
hal config storage s3 edit --endpoint http://minio:9101 --access-key-id $MINIO_ACCESS_KEY --secret-access-key $MINIO_SECRET_KEY

hal version list --daemon-endpoint http://127.0.0.1:8064
hal config version edit --version 1.10.1 --daemon-endpoint http://127.0.0.1:8064
hal deploy apply --daemon-endpoint http://127.0.0.1:8064
```

```bash
brew install kubernetes-cli

curl -O https://raw.githubusercontent.com/spinnaker/halyard/master/install/macos/InstallHalyard.sh
chmod a+x InstallHalyard.sh
./InstallHalyard.sh

# Psych!! Not going to install java on my machine
```