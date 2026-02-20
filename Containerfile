# Build tinyproxy from vendored source as a static binary
# Builder: project-hummingbird core-runtime builder (no git needed)
# Runtime: project-hummingbird core-runtime (distroless)

FROM quay.io/hummingbird/core-runtime:2-builder AS build

USER root
RUN dnf install -y autoconf automake gcc gawk make glibc-static && dnf clean all

COPY tinyproxy/ /tinyproxy/

RUN set -x \
    && cd /tinyproxy \
    && ./autogen.sh \
    && ./configure CFLAGS="-Os -s -static" \
        --disable-manpage_support \
        --disable-transparent \
        --disable-xtinyproxy \
        --prefix=/ \
    && make -j$(nproc)

FROM quay.io/hummingbird/curl:8

COPY --from=build /tinyproxy/src/tinyproxy /usr/bin/tinyproxy

USER 65532

EXPOSE 8888/tcp
ENTRYPOINT ["/usr/bin/tinyproxy", "-d", "-c", "/etc/tinyproxy/tinyproxy.conf"]
