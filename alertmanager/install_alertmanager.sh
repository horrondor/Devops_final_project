#!/bin/bash
ALERTMANAGER_VERSION="v0.30.0"
ALERTMANAGER_FILE="alertmanager-0.30.0.linux-amd64.tar.gz"


sudo useradd --no-create-home --shell /bin/false alertmanager
sudo mkdir /etc/alertmanager


wget https://github.com/prometheus/alertmanager/releases/download/"${ALERTMANAGER_VERSION}"/"${ALERTMANAGER_FILE}".tar.gz

tar xzf "${ALERTMANAGER_FILE}".tar.gz
cd "${ALERTMANAGER_FILE}"

sudo mv alertmanager.yml /etc/alertmanager
sudo chown -R alertmanager:alertmanager /etc/alertmanager
sudo mkdir /var/lib/alertmanager
sudo chown -R alertmanager:alertmanager /var/lib/alertmanager
sudo cp alertmanager /usr/local/bin
sudo cp amtool /usr/local/bin
sudo chown alertmanager:alertmanager /usr/local/bin/alertmanager
sudo chown alertmanager:alertmanager /usr/local/bin/amtool

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

sudo cp alertmanager.service /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl start alertmanager
sudo systemctl enable alertmanager
sudo systemctl status alertmanager