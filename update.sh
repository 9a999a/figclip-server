#!/bin/bash
# figclip-update : pulls the repo, deploys the newest figclip-serverNN.zip and figclip-siteNN.zip
set -e
cd /srv/figclip/repo
git pull -q
Z=$(ls | grep -E "^figclip-server[0-9]+\.zip$" | sort -V | tail -1)
echo "Deploying $Z"
rm -rf /tmp/upd && mkdir /tmp/upd
unzip -q "$Z" -d /tmp/upd
cp -r /tmp/upd/figclip-server/figclip/. /srv/figclip/app/figclip/
chown -R figclip:figclip /srv/figclip/app/figclip
S=$(ls | grep -E "^figclip-site[0-9]+\.zip$" | sort -V | tail -1)
if [ -n "$S" ]; then
  echo "Deploying $S"
  rm -rf /tmp/updsite && mkdir /tmp/updsite
  unzip -q "$S" -d /tmp/updsite
  cp -r /tmp/updsite/. /srv/figclip/site/
fi
systemctl restart figclip-web figclip-worker
sleep 2
systemctl is-active figclip-web figclip-worker
# keep the installed command in step with the repo copy
cp update.sh /usr/local/bin/.figclip-update.new && chmod +x /usr/local/bin/.figclip-update.new && mv /usr/local/bin/.figclip-update.new /usr/local/bin/figclip-update
