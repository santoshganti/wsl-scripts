#!/usr/bin/env bash
# https://cockpit-project.org/running#ubuntu
. /etc/os-release
sudo apt install -t ${VERSION_CODENAME}-backports cockpit -y