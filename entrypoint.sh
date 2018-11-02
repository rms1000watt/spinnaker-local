#!/usr/bin/env bash

set -e

if [[ -z $MINIO_ACCESS_KEY ]] || [[ -z $MINIO_SECRET_KEY ]]; then
  echo "Minio keys not defined: $MINIO_ACCESS_KEY $MINIO_SECRET_KEY"
  exit 1
fi

echo "Minio keys: $MINIO_ACCESS_KEY $MINIO_SECRET_KEY"

echo "Starting halyard in background"
nohup /opt/halyard/bin/halyard > /dev/null &

daep="--daemon-endpoint http://127.0.0.1:8064"

echo "Waiting for halyard"
until hal --ready $daep &> /dev/null; do
  echo "halyard not ready, sleeping 5s.."
  sleep 5 || exit 1 ;
done

echo "############################### 1"
hal config provider kubernetes enable $daep
echo "############################### 2"
hal config provider kubernetes account add my-k8s-v2-account --provider-version v2 --context $(kubectl config current-context) $daep
echo "############################### 3"
hal config features edit --artifacts true $daep
echo "############################### 4"
hal config deploy edit --type distributed --account-name my-k8s-v2-account $daep
echo "############################### 5"
echo "$MINIO_SECRET_KEY" | hal config storage s3 edit --endpoint http://minio:9101 --access-key-id "$MINIO_ACCESS_KEY" --bucket spinnaker $daep --secret-access-key
echo "############################### 6"
hal config storage edit --type s3 $daep
echo "############################### 7"
hal version list $daep
echo "############################### 8"
hal config version edit --version 1.10.1 $daep
echo "############################### 9"
hal deploy apply $daep
echo "############################### 10"

echo "Letting halyard run in the background"
while :; do sleep 1 || exit; done
