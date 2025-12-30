#!/bin/bash
ALERTMANAGER_VERSION="v0.30.0"
ALERTMANAGER_FILE="alertmanager-0.30.0.linux-amd64"


useradd --no-create-home --shell /bin/false alertmanager
mkdir /etc/alertmanager


wget https://github.com/prometheus/alertmanager/releases/download/"${ALERTMANAGER_VERSION}"/"${ALERTMANAGER_FILE}".tar.gz

tar xzf "${ALERTMANAGER_FILE}".tar.gz
cd "${ALERTMANAGER_FILE}"

 mv alertmanager.yml /etc/alertmanager
chown -R alertmanager:alertmanager /etc/alertmanager
mkdir /var/lib/alertmanager
chown -R alertmanager:alertmanager /var/lib/alertmanager
cp alertmanager /usr/local/bin
cp amtool /usr/local/bin
chown alertmanager:alertmanager /usr/local/bin/alertmanager
chown alertmanager:alertmanager /usr/local/bin/amtool

# the service will listen on port 9093
cd -
cat <<EOF > alertmanager.service
[Unit]
Description=Alert Manager
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=alertmanager
Group=alertmanager
ExecStart=/usr/local/bin/alertmanager \
       --config.file=/etc/alertmanager/alertmanager.yml \
       --storage.path=/var/lib/alertmanager

Restart=always

[Install]
WantedBy=multi-user.target
EOF

cp alertmanager.service /etc/systemd/system/

 systemctl daemon-reload
 systemctl start alertmanager
 systemctl enable alertmanager
#sudo systemctl status alertmanager