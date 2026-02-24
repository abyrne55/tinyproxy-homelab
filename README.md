# tinyproxy-homelab

Minimal tinyproxy container image built from source for homelab use.

## Usage

Pull the image:

```bash
podman pull ghcr.io/abyrne55/tinyproxy-homelab:main
```

Run with a config file:

```bash
podman run -d \
  -p 8888:8888 \
  -v /path/to/tinyproxy.conf:/etc/tinyproxy/tinyproxy.conf:ro \
  ghcr.io/abyrne55/tinyproxy-homelab:main
```

## Base Images

Built using [project-hummingbird](https://quay.io/organization/hummingbird) distroless base images:

- **Builder**: `quay.io/hummingbird/core-runtime:2-builder` — build environment for compiling the static binary
- **Runtime**: `quay.io/hummingbird/curl:8` — minimal distroless runtime with curl for healthchecks

Container runs as non-root user (UID 65532).

## Building Locally

```bash
# Clone with submodules
git clone --recursive https://github.com/abyrne55/tinyproxy-homelab.git

# Or if already cloned, initialize submodules
git submodule update --init --recursive

# Build
podman build -t tinyproxy-homelab:latest -f Containerfile .
```

## CI/CD

On push to `main`, GitHub Actions builds an arm64 image and pushes to GHCR, signed with Cosign.
