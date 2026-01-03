#!/bin/bash
set -e
apt-get update
apt-get install -y adduser libfontconfig1 musl
wget https://dl.grafana.com/enterprise/release/grafana-enterprise_12.3.1_amd64.deb
dpkg -i grafana-enterprise_12.3.1_amd64.deb

systemctl daemon-reload
systemctl enable grafana-server
systemctl start grafana-server
#systemctl status grafana-server
