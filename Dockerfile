FROM debian:trixie-slim
LABEL maintainer="Rashad Ansari <rashad.ansari1996@gmail.com>"

ARG TILE38_VERSION
# Set by BuildKit to the platform being built (amd64, arm64, ...).
ARG TARGETARCH

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl wget redis-tools && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://github.com/tidwall/tile38/releases/download/${TILE38_VERSION}/tile38-${TILE38_VERSION}-linux-${TARGETARCH}.tar.gz | tar xz && \
    mv tile38-${TILE38_VERSION}-linux-${TARGETARCH} /tile38

# Group 0 ownership lets the image run under an arbitrary UID (e.g. OpenShift).
RUN useradd --system --gid 0 --home-dir /tile38 tile38

WORKDIR /tile38

COPY run.sh run.sh

RUN \
    chgrp -R 0 /tile38 && \
    chmod -R g=u /tile38

RUN \
    touch /.liner_example_history && \
    chgrp -R 0 /.liner_example_history && \
    chmod -R g=u /.liner_example_history

EXPOSE 9851

USER tile38
CMD [ "./run.sh" ]
