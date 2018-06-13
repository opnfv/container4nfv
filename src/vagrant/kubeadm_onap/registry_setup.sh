#!/bin/bash
set -ex

sudo apt-get update -y
sudo apt install -y jq docker.io

NEXUS_REPO=nexus3.onap.org:10001
LOCAL_REPO=192.168.0.2:5000

cat << EOF | sudo tee /etc/docker/daemon.json
{
    "insecure-registries" : [ "$LOCAL_REPO" ]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

sudo docker run -d -p 5000:5000 --restart=always --name registry registry:2

dockers=$(curl -X GET https://$NEXUS_REPO/v2/_catalog | jq -r ".repositories[]")
for d in $dockers
do
    tags=$(curl -X GET https://$NEXUS_REPO/v2/$d/tags/list | jq -r ".tags[]")
    for t in $tags
    do
        sudo docker pull $NEXUS_REPO/$d:$t
        sudo docker tag $NEXUS_REPO/$d:$t $LOCAL_REPO/$d:$t
        sudo docker push $LOCAL_REPO/$d:$t
    done
done
