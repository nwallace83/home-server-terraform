#!/bin/bash -x

echo "Start time: `date`"

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $SCRIPT_DIR

kubectl rollout restart deployment handbrake
kubectl rollout restart deployment sickchill
kubectl rollout restart deployment delugevpn
kubectl rollout restart deployment plex
kubectl rollout restart deployment pihole
kubectl rollout restart deployment prowlarr
kubectl rollout restart deployment radarr

echo "End time: `date`"