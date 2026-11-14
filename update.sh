#!/bin/bash
# figclip-update : pulls the repo and deploys the newest figclip-server*.zip
set -e
cd /srv/figclip/repo
git pull -q
Z=$(ls figclip-server*.zip | sort -V | tail -1)
echo "Deploying $Z"
rm -rf /tmp/upd && mkdir /tmp/upd
unzip -q "$Z" -d /tmp/upd
cp -r /tmp/upd/figclip-server/figclip/. /srv/figclip/app/figclip/
chown -R figclip:figclip /srv/figclip/app/figclip
systemctl restart figclip-web figclip-worker
sleep 2
systemctl is-active figclip-web figclip-worker
