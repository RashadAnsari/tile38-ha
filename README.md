# Tile38 HA Docker Image

This is a docker image for making Tile38 HA with Redis Sentinel.

## Docker Tags

```
1.17.6, latest
```

## Usage

You can pull this image with following command:

```
docker pull rashadansari/tile38:tagname
```

### Notes

This image is a non-root container image that adds an extra layer of security and is generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits.
