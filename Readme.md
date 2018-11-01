# Spinnaker Local

## Introduction

This should let you run spinnaker locally for testing

## Contents

- [Usage](#usage)

## Usage

```bash
brew install kubernetes-helm kubernetes-cli

helm init
helm install stable/spinnaker

kubectl port-forward "$(kubectl get pods | grep deck | awk '{print $1}')" 9000
open http://localhost:9000
```
