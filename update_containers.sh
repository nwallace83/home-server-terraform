#!/bin/bash -x

echo "Start time: `date`"

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

docker pull linuxserver/sickchill:latest
docker pull linuxserver/radarr:latest
docker pull nginx:latest
docker pull linuxserver/prowlarr:latest
docker pull plexinc/pms-docker:latest
docker pull binhex/arch-delugevpn:latest
docker pull jlesage/handbrake:latest

git checkout .terraform.lock.hcl
git pull

terraform init --upgrade -force-copy
terraform destroy -auto-approve
terraform plan
terraform apply -auto-approve

docker image prune -f

echo "End time: `date`"