#!/usr/bin/env sh

### https://blog.while-true-do.io/podman-systemd-in-containers/

# Build image (this can take a minute or two)
#podman image build --rm -t localhost/fedora-web:latest .
buildah bud -f Containerfile -t localhost/fedora-web:latest .

# List images
podman image ls

# Run a container
podman container run -d \
  --name fedora-web01 localhost/fedora-web:latest

# Check running containers
podman container ls

# Check processes in the container
podman container top fedora-web01
