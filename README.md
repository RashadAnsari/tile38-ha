# Tile38 HA Docker Image

A Docker image and Compose setup for running [Tile38](https://tile38.com/) with high availability. Redis Sentinel watches the Tile38 nodes and promotes a follower when the leader goes down, and HAProxy always routes clients to the current leader.

## Docker tags

```
1.38.0, latest
```

Images are built for `linux/amd64` and `linux/arm64`.

```bash
docker pull rashadansari/tile38:1.38.0
```

## How it works

[docker-compose.yml](docker-compose.yml) starts three Tile38 nodes, three Sentinels and HAProxy:

- On start, each node asks Sentinel for the current leader ([run.sh](run.sh)). If one is found it starts as a follower of it; otherwise it starts as the leader.
- The Sentinels ([sentinel.sh](sentinel.sh), official `redis` image) monitor the leader. When a quorum of 2 agrees it is down, they promote a follower and point the other nodes at it.
- HAProxy ([haproxy.cfg](haproxy.cfg)) health-checks every node with `INFO replication` and only sends traffic to the one reporting `role:master`.

## Usage

```bash
docker compose up -d
```

| Port | Service |
|---|---|
| `9851` | Tile38, through HAProxy, always the leader |
| `1986` | HAProxy stats page |

```bash
tile38-cli -p 9851 SET fleet truck1 POINT 33.5 -112.2
```

When the leader stops, Sentinel fails over after the down-after period (60 seconds by default) and writes go to the new leader. A node that comes back rejoins as a follower.

## Configuration

Tile38 nodes:

| Variable | Meaning |
|---|---|
| `TILE38_REPLICATION_ENABLED` | `true` to ask Sentinel for the leader on start; otherwise the node runs standalone |
| `REDIS_SENTINEL_HOST` / `REDIS_SENTINEL_PORT_NUMBER` | Sentinel to ask |
| `REDIS_SENTINEL_MASTER_NAME` | Name of the monitored master set |

Sentinels:

| Variable | Default | Meaning |
|---|---|---|
| `REDIS_MASTER_HOST` / `REDIS_MASTER_PORT_NUMBER` | | Initial leader to monitor |
| `REDIS_MASTER_SET` | `mymaster` | Name of the master set |
| `REDIS_SENTINEL_QUORUM` | `2` | Sentinels that must agree the leader is down |
| `REDIS_SENTINEL_DOWN_AFTER_MILLISECONDS` | `60000` | How long the leader must be unreachable |
| `REDIS_SENTINEL_FAILOVER_TIMEOUT` | `180000` | Failover timeout |

## Publishing a new version

Push a git tag named after the [Tile38 release](https://github.com/tidwall/tile38/releases) to package, for example `1.38.0`. The [Build workflow](.github/workflows/build.yml) builds both architectures and pushes `rashadansari/tile38:<tag>` and `latest` to Docker Hub. Then update the image tag in `docker-compose.yml`.

To build locally:

```bash
docker build --build-arg TILE38_VERSION=1.38.0 -t rashadansari/tile38:1.38.0 .
```

## Notes

The image runs as the non-root `tile38` user, with files owned by group 0 so it also runs under an arbitrary UID (for example on OpenShift).

## License

[MIT](LICENSE)
