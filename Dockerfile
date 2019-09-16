FROM bitnami/minideb-extras:stretch
LABEL maintainer "Rashad Ansari <rashad.ansari1996@gmail.com>"

ARG TILE38_VERSION=1.17.6

RUN curl -L  https://github.com/tidwall/tile38/releases/download/${TILE38_VERSION}/tile38-${TILE38_VERSION}-linux-amd64.tar.gz -o tile38-${TILE38_VERSION}-linux-amd64.tar.gz && \
    tar xzvf tile38-${TILE38_VERSION}-linux-amd64.tar.gz && \
    mv tile38-${TILE38_VERSION}-linux-amd64 tile38 && \
    rm -rf tile38-${TILE38_VERSION}-linux-amd64.tar.gz

RUN apt-get update && \
    apt-get install wget && \
    apt-get --assume-yes install redis-tools

WORKDIR tile38

COPY run.sh run.sh

RUN addgroup -S tile38 && \
    adduser -S -G tile38 tile38 && \
    chown -R tile38:tile38 /tile38

RUN touch /.liner_example_history
RUN chown -R 1001:1001 /.liner_example_history

# VOLUME /tile38/data

EXPOSE 9851

USER tile38
CMD [ "./run.sh" ]
