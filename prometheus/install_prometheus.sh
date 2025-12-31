#!/bin/bash
PROMETHEUS_VERSION="v3.5.0"
PROMETHEUS_FILE="prometheus-3.5.0.linux-amd64"

sudo useradd --no-create-home --shell /bin/false prometheus
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus
wget https://github.com/prometheus/prometheus/releases/download/"${PROMETHEUS_VERSION}"/"${PROMETHEUS_FILE}".tar.gz
tar xvf "${PROMETHEUS_FILE}".tar.gz
cd "${PROMETHEUS_FILE}"

sudo  prometheus /usr/local/bin/
sudo cp promtool /usr/local/bin
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool
sudo cp prometheus.yml /etc/prometheus/prometheus.yml
sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml
cat <<EOF > prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF
sudo cp prometheus.service /etc/systemd/system/prometheus.service
sudo systemctl daemon-reload

sudo systemctl start prometheus
sudo systemctl enable prometheus
sudo systemctl status prometheus