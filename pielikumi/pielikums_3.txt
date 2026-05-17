#!/usr/bin/env bash
set -e

mkdir -p /opt/secret-thesis/app
mkdir -p /opt/secret-thesis/infra/docker
mkdir -p /opt/secret-thesis/scripts
chown -R vagrant:vagrant /opt/secret-thesis

echo "Lietojumprgrammatūras resurdators gatavs"