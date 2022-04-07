#!/bin/bash

DOCKER_DIR=/mnt/c/wsl/shared-docker
mkdir -pm o=,ug=rwx "$DOCKER_DIR"
sudo chgrp docker "$DOCKER_DIR"
